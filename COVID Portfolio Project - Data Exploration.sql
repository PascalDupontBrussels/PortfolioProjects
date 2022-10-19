
/*
The Data can be downloaded from  the link below:
https://ourworldindata.org/covid-deaths

Covid 19 Data Exploration 
Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/


SELECT * 
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
ORDER by 3,4 desc

-- Select Data that we are going to be using --

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2

-- Looking at total cases vs total deaths--
-- Shows likelihood of  dying if you contract covid in your country--

SELECT location, date, total_cases, total_deaths
, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2


-- Looking at Total Cases vs Population--
--Show what percentage of population got Covid--

SELECT location, date, population, total_cases
, (total_cases/population)*100 as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2

-- Looking at Countries with highest Infection Rate Compared to Population--

SELECT Location, Population
, MAX(total_cases) as HighestInfectionCount
, Max((total_cases/population))*100 as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
WHERE location not in ('Faeroe Islands')
GROUP BY Location, Population
ORDER BY PercentPopulationInfected desc


-- Showing Countries with Highest Death Count per Population --

SELECT location
, MAX(cast (Total_deaths as INT)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount desc	

-- BREAKING THINGS DOWN BY CONTINENT--

--Showing Continents with the highest death count per population--

SELECT location
, MAX(cast (Total_deaths as INT)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent IS NULL
AND location not LIKE('%income%')
GROUP BY location
ORDER BY TotalDeathCount desc

-- GLOBAL NUMBERS


SELECT location
, SUM(cast(new_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent is null 
AND location not in ('World', 'European Union', 'International')
AND location not like ('%income%')
GROUP BY location
ORDER BY TotalDeathCount desc

--GLOBAL NUMBERS--

SELECT SUM(new_cases) as total_cases
, SUM(cast(new_deaths as int)) as total_deaths
, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent is not null 
ORDER BY 1,2

--Looking at Total Population vs Vaccinations--
-- Shows Percentage of Population that has recieved at least one Covid Vaccine--

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(BIGINT,vac.new_vaccinations ))
OVER(PARTITION BY dea.location ORDER BY dea.location,dea.date )as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100  
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE DEA.continent IS NOT NULL
ORDER BY 2,3

-- Using CTE to perform Calculation on Partition By in previous query--

WITH PopvsVac 
(Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
as (
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(BIGINT,vac.new_vaccinations ))
OVER(PARTITION BY dea.location ORDER BY dea.location,dea.date )as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100  
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE DEA.continent IS NOT NULL
)

SELECT* , (RollingPeopleVaccinated/Population)*100
FROM PopvsVac


-- Using Temp Table to perform Calculation on Partition By in previous query--

DROP TABLE IF exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations))
OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date

SELECT *
, (RollingPeopleVaccinated/Population)*100
FROM #PercentPopulationVaccinated


-- Creating View to store data for later visualizations

DROP VIEW PercentPopulationVaccinated;

CREATE VIEW PercentPopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations))
OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null 

SELECT* FROM PercentPopulationVaccinated
