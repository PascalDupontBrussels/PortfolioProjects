
--WHERE date BETWEEN '2020/02/24' AND '2021/04/30'--

--SELECT * FROM PortfolioProject..CovidDeaths
--WHERE continent IS NOT NULL
--AND date BETWEEN '2020/02/24' AND '2021/04/30'
--ORDER by 3,4 

----select* from PortfolioProject..CovidDeaths
--WHERE continent IS NOT NULL
--AND date BETWEEN '2020/02/24' AND '2021/04/30'
----ORDER BY 3,4 desc

--SELECT * FROM PortfolioProject..CovidVaccinations
--ORDER by 3,4 desc

-- SELECT Data that we are going to be using --

SELECT location, date, total_cases, new_cases, total_deaths,population
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
--AND date BETWEEN '2020/02/24' AND '2021/04/30'
ORDER BY 1,2

-- Looking at total cases vs total deaths--
-- Shows likelihood of  dying if you contract covid in your country--

SELECT location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
--WHERE location like '%states%'
WHERE continent IS NOT NULL
--AND date BETWEEN '2020/02/24' AND '2021/04/30'
ORDER BY 1,2

-- Looking at Total Cases vs Population--
--Show what percentage of population got Covid--

SELECT location, date, population,total_cases, (total_cases/population)*100 as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
--WHERE location like '%states%'
WHERE continent IS NOT NULL
--AND date BETWEEN '2020/02/24' AND '2021/04/30'
ORDER BY 1,2

-- Looking at Countries with highest Infection Rate Compared to Population--

SELECT location
, population
, MAX(total_cases) as HighestInfactionCount
, MAX((total_cases/population))*100 as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
--AND date BETWEEN '2020/02/24' AND '2021/04/30'
--WHERE location like '%states%'
GROUP BY location, population
ORDER BY PercentPopulationInfected desc

-- Showing Countries with Highest Death Count per Population --

SELECT location
, MAX(cast (Total_deaths as INT)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
-- AND date BETWEEN '2020/02/24' AND '2021/04/30'
--WHERE location like '%states%'
GROUP BY location
ORDER BY TotalDeathCount desc

			--ADVANCED--

-- Lest's break things down by continent--MOI

SELECT location
, MAX(cast (Total_deaths as INT)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent IS NULL
AND location not LIKE('%income%')
--AND date BETWEEN '2020/02/24' AND '2021/04/30'
--WHERE location like '%states%'
GROUP BY location
ORDER BY TotalDeathCount desc

			----------

--Showing continents with the highest death count per population--LUI

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null 
AND date BETWEEN '2020/02/24' AND '2021/04/30'
Group by continent
order by TotalDeathCount desc

--GLOBAL NUMBERS--

Select SUM(new_cases) as total_cases,
SUM(cast(new_deaths as int)) as total_deaths,
SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%states%'
where continent is not null 
--AND date BETWEEN '2020/02/24' AND '2021/04/30'
--Group By date
order by 1,2

--Looking at Total Population vs Vaccinations--

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(INT,vac.new_vaccinations ))
OVER(PARTITION BY dea.location order by dea.location,dea.date )as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100 as 
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.date BETWEEN '2020/02/24' AND '2021/04/30'
AND DEA.continent IS NOT NULL
ORDER BY 2,3

-- Using CTE to perform Calculation on Partition By in previous query

WITH PopvsVac 
(Continent, Location, Date, Population,new_vaccinations, RollingPeopleVaccinated)
as (
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(INT,vac.new_vaccinations ))
OVER(PARTITION BY dea.location order by dea.location,dea.date )as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100 as 
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.date BETWEEN '2020/02/24' AND '2021/04/30'
AND DEA.continent IS NOT NULL)
-- ORDER BY 2,3


SELECT* , (RollingPeopleVaccinated/Population)*100
FROM PopvsVac


-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
WHERE dea.date BETWEEN '2020/02/24' AND '2021/04/30'
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


-- Creating View to store data for later visualizations

DROP View PercentPopulationVaccinated;
Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
WHERE dea.date BETWEEN '2020/02/24' AND '2021/04/30'
AND dea.continent is not null 

SELECT* FROM PercentPopulationVaccinated












