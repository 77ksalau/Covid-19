-- Global Data from Covid-19
-- Following data reps total cases, new cases and total deaths around the globe

Select * from PortfolioProject..CovidDeaths
Where continent is not null
Order by location, date

Select * from PortfolioProject..CovidVaccinations
Where continent is not null
Order by location, date

Select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

-- Death percentage in your country per total cases

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location like '%states%'
order by 1,2

-- Total Infected per population

Select location, date, population, total_cases, (total_cases/population)*100 as TotalInfected
from PortfolioProject..CovidDeaths
where location like '%states%'
order by 1,2

-- Highest infection rate compared to global population

Select location, population, Max(total_cases)as HighestInfectionCount, Max(total_cases/population)*100 as PercentagePopulationInfected
from PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is not null
Group by location, population
order by PercentagePopulationInfected desc

-- Deathcount by countries

Select location, Max(cast(total_deaths as int))as TotalDeathCount
from PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is not null
Group by location
order by TotalDeathCount desc

-- Deathcount by continent

Select continent, Max(cast(total_deaths as int))as TotalDeathCount
from PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is not null
Group by continent
order by TotalDeathCount desc

-- Joining both tables (CovidDeaths and Covidvaccinations)

Select *
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date

-- Total population vs total vaccinations globally

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(bigint, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as PeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
     on dea.location = vac.location
     and dea.date = vac.date
where dea.continent is not null
order by 2,3

-- Following queries used for tableau portfolio
-- 1

Select Sum(new_cases) as total_cases, Sum(cast(new_deaths as int)) as total_deaths, 
sum(cast(new_deaths as int))/Sum(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is not null
--Group by date
order by 1,2

-- 2
Select location, SUM(Cast(new_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is null
and location not in ('World', 'European Union', 'International', 'High income', 'Upper middle income', 'Lower middle income', 'Low income')
Group by location
Order by TotalDeathCount desc

-- 3
Select location, Population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Group by location, population
Order by PercentPopulationInfected desc

-- 4
Select location, Population, date, Max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Group by location, population, date
Order by PercentPopulationInfected desc