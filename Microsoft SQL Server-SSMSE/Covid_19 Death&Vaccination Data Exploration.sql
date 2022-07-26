
/*
Covid 19 Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
Data Used date: Jan 2020 - July 2022
*/
---------------------------------------------------------------------------------------------

SELECT *
FROM Covid_19_Data.dbo.CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 3, 4	-- Order by 3,4 no column of the table


SELECT *
FROM Covid_19_Data.dbo.CovidVaccinations
WHERE continent IS NOT NULL
ORDER BY 3,4



---------------------------------------------------------------------------------------------


--Select data that we are going to be using

Select location, date, total_cases, new_cases, total_deaths, population
From Covid_19_Data..CovidDeaths
where continent is not null
Order by 1,2




-- Looking at Total Cases vs Total Deaths

Select location, date, total_cases, total_deaths, round((total_deaths/total_cases)*100, 2) as Death_Percentage
From Covid_19_Data..CovidDeaths
where location like '%Bangladesh%'
and continent is not null
Order by 1,2



-- Looking at Total Cases vs Population
-- Shows what percentage of population infected with Covid

Select location, date, population, total_cases, round((total_cases/population)*100, 7) as Infected_Percentage
From Covid_19_Data..CovidDeaths
--where location like '%Bangladesh%'
Where continent is not null
Order by 1,2



---------------------------------------------------------------------------------------------

-- Countries with Highest Infection Rate compared to Population

Select location, population, MAX(total_cases) as HighInfectionCount, MAX(round((total_cases/population)*100, 7)) as Infected_Percentage
From Covid_19_Data..CovidDeaths
--where location like '%Bangladesh%'
Where continent is not null
Group by location, population
Order by Infected_Percentage desc



-- Countries with Highest Death Count per Population

Select location, population, MAX(CAST(total_deaths as int)) as TotalDeathCount
From Covid_19_Data..CovidDeaths
--where location like '%Bangladesh%'
Where continent is not null
Group by location, population
Order by  TotalDeathCount desc



---------------------------------------------------------------------------------------------

-- BREAKING THINGS DOWN BY CONTINENT
-- Showing contintents with the highest death count per population

Select continent, SUM(CAST(new_deaths as int)) as TotalDeathCount
From Covid_19_Data..CovidDeaths
Where continent is not null
Group by continent
Order by  TotalDeathCount desc



--GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(CAST(new_deaths as int)) as total_deaths, 
	round((SUM(CAST(new_deaths as int))/ SUM(new_cases))*100, 2) as DeathsPerentage
From Covid_19_Data..CovidDeaths
Where continent is not null
--Group by date
Order by 1,2



---------------------------------------------------------------------------------------------

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, Cast(vac.new_vaccinations as int) as new_vaccinations,
	SUM(CONVERT(int, vac.new_vaccinations)) OVER(Partition by dea.location order by dea.location, dea.date) as RollingPeapleVaccinated
	--,(RollingPeopleVaccinated/dea.population)*100
From Covid_19_Data..CovidDeaths as dea
Join Covid_19_Data..CovidVaccinations as vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
and vac.new_vaccinations is not null
--and dea.location = 'Bangladesh'
Order by 2,3



-- Using CTE to perform Calculation on Partition By in previous query

WITH PopuVSVacc (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as(
Select dea.continent, dea.location, dea.date, dea.population, Cast(vac.new_vaccinations as int) as new_vaccinations,
	SUM(CONVERT(int, vac.new_vaccinations)) OVER(Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
	--,(RollingPeopleVaccinated/dea.population)*100
From Covid_19_Data..CovidDeaths as dea
Join Covid_19_Data..CovidVaccinations as vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
and vac.new_vaccinations is not null
--and dea.location = 'Bangladesh'
)

Select *, Round((RollingPeopleVaccinated/population)*100, 3) as Vaccination_percentage
From PopuVSVacc



---------------------------------------------------------------------------------------------

-- Creating Temp Table

Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continet nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert Into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, Cast(vac.new_vaccinations as int) as new_vaccinations,
	SUM(CONVERT(int, vac.new_vaccinations)) OVER(Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
	--,(RollingPeopleVaccinated/dea.population)*100
From Covid_19_Data..CovidDeaths as dea
Join Covid_19_Data..CovidVaccinations as vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
and vac.new_vaccinations is not null
--and dea.location = 'Bangladesh'


Select *,Round((RollingPeopleVaccinated/population)*100, 3) as Vaccination_percentage
From #PercentPopulationVaccinated



---------------------------------------------------------------------------------------------


-- Creating View to store data for later visualizations

Drop View if exists PercentPopulationVaccinated
Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, Cast(vac.new_vaccinations as int) as new_vaccinations,
	SUM(CONVERT(int, vac.new_vaccinations)) OVER(Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
	--,(RollingPeopleVaccinated/dea.population)*100
From Covid_19_Data..CovidDeaths as dea
Join Covid_19_Data..CovidVaccinations as vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
and vac.new_vaccinations is not null
--and dea.location = 'Bangladesh'

select *,Round((RollingPeopleVaccinated/population)*100, 3) as Vaccination_percentage
from PercentPopulationVaccinated