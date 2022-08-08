SELECT *
FROM PortfolioProject..CovidDeaths$
WHERE continent is not null
ORDER BY 3,4;

--SELECT *
--FROM PortfolioProject..CovidVaccinations$
--ORDER BY 3,4;

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths$
WHERE continent is not null
ORDER BY 1,2;

--total cases vs total deaths

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Deathpercentage
FROM PortfolioProject..CovidDeaths$
WHERE continent is not null
ORDER BY 1,2;

--total cases vs population
-- Showing what percentage of population got Covid

SELECT location, date, total_cases, population, (total_cases/population)*100 as percentage_of_population
FROM PortfolioProject..CovidDeaths$
WHERE continent is not null
ORDER BY 1,2;

--countries with highest infection rate compaired to population

SELECT location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentagepopulationInfected
FROM PortfolioProject..CovidDeaths$
WHERE continent is not null
GROUP BY population, location
ORDER BY PercentagepopulationInfected DESC;

-- Showing locations with highest death count per population

SELECT location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths$
WHERE continent is null
GROUP BY location
ORDER BY TotalDeathCount DESC;

-- Showing continent with highest death count per population

SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths$
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount DESC;

--Global Numbers

SELECT SUM(new_cases) as Total_Cases, SUM(cast(new_deaths as int)) as Total_Death, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths$
WHERE continent is not null
--GROUP BY date
ORDER BY 1,2;


--Looking at Total population vs Vaccinations 

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

--CTE

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

--Temp Table

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

--Creating view to store data for later visualizations

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
--ORDER BY 2,3