/*
Covid 19 Data Exploration

Skills used: Joins, CTE's, Temp Tables, Window Functions, Aggregate Functions, Creating Views, Converting Data Types

*/


SELECT *
FROM PortfolioProject..CovidDeaths$
WHERE continent is not null
ORDER BY 3,4;

-- Select Data that we are going to be starting with

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths$
WHERE continent is not null
ORDER BY 1,2;

-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Deathpercentage
FROM PortfolioProject..CovidDeaths$
WHERE continent is not null
ORDER BY 1,2;

-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

SELECT location, date, total_cases, population, (total_cases/population)*100 as percentage_of_population
FROM PortfolioProject..CovidDeaths$
WHERE continent is not null
ORDER BY 1,2;

-- Countries with Highest Infection Rate compared to Population

SELECT location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentagepopulationInfected
FROM PortfolioProject..CovidDeaths$
WHERE continent is not null
GROUP BY population, location
ORDER BY PercentagepopulationInfected DESC;



-- BREAKING THINGS DOWN BY CONTINENT

-- Showing location with the highest death count per population

SELECT location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths$
WHERE continent is null
GROUP BY location
ORDER BY TotalDeathCount DESC;

-- Showing continent with highest death count per population

SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths$
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC;



--Global Numbers

SELECT SUM(new_cases) as Total_Cases, SUM(cast(new_deaths as int)) as Total_Death, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths$
WHERE continent is not null
--GROUP BY date
ORDER BY 1,2;


-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(int, vac.new_vaccinations)) OVER (partition by dea.location ORDER BY dea.location, 
  dea.date) as RollingpeopleVaccinated
 --, (RollingpeopleVaccinated/population)*100
FROM PortfolioProject..CovidDeaths$ dea
JOIN PortfolioProject..CovidVaccinations$ vac
  on dea.location = vac.location
  and dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3;


-- Using CTE to perform Calculation on Partition By in previous query

WITH Popvsvac (continent, location, date, population, new_vaccinations, RollingpeopleVaccinated)
as
(SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(int, vac.new_vaccinations)) OVER (partition by dea.location ORDER BY dea.location, 
  dea.date) as RollingpeopleVaccinated
 --, (RollingpeopleVaccinated/population)*100
FROM PortfolioProject..CovidDeaths$ dea
JOIN PortfolioProject..CovidVaccinations$ vac
  on dea.location = vac.location
  and dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2,3
)
SELECT *, (RollingpeopleVaccinated/population)*100
FROM Popvsvac



-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists #percentpopulationVaccinated
create Table #percentpopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255), 
date datetime,
population numeric,
new_vaccinations numeric,
rollingpeopleVaccinated numeric
)

INSERT INTO #percentpopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(int, vac.new_vaccinations)) OVER (partition by dea.location ORDER BY dea.location, 
  dea.date) as RollingpeopleVaccinated
 --, (RollingpeopleVaccinated/population)*100
FROM PortfolioProject..CovidDeaths$ dea
JOIN PortfolioProject..CovidVaccinations$ vac
  on dea.location = vac.location
  and dea.date = vac.date
--WHERE dea.continent is not null
--ORDER BY 2,3
SELECT *, (RollingpeopleVaccinated/population)*100
FROM #percentpopulationVaccinated;




-- Creating View to store data for later visualizations

CREATE VIEW percentpopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(int, vac.new_vaccinations)) OVER (partition by dea.location ORDER BY dea.location, 
  dea.date) as RollingpeopleVaccinated
 --, (RollingpeopleVaccinated/population)*100
FROM PortfolioProject..CovidDeaths$ dea
JOIN PortfolioProject..CovidVaccinations$ vac
  on dea.location = vac.location
  and dea.date = vac.date
WHERE dea.continent is not null