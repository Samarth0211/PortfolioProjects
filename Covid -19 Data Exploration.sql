--select * 
--from PortfolioProject..CovidDeaths 
--order by 3,4

--select * 
--from PortfolioProject..CovidVaccinations 
--order by 3,4

select Location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
order by 1,2

--Total Cases vs Total Deaths

select Location, date, total_cases, total_deaths, (cast(total_deaths as float)/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location = 'India'
order by 1,2

--what percent of population got Covid
select Location, date, total_cases, total_deaths, (total_cases/population)*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths
--where location = 'India'
order by 1,2

--Looking at countries with highest infection rate comapred to population
select Location,Population, MAX(cast(total_cases as int)) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths
--where location = 'India'
group by location,population
order by PercentPopulationInfected desc

--Looking at countries with highest death rate comapred to population
select Location, MAX(cast(total_deaths as int)) as TotalDeathsCount from PortfolioProject..CovidDeaths
--where location = 'India'
where continent is not null
group by location
order by TotalDeathsCount desc


-- Deaths according to continents
select continent, MAX(cast(total_deaths as int)) as TotalDeathsCount from PortfolioProject..CovidDeaths
--where location = 'India'
where continent is not null
group by continent
order by TotalDeathsCount desc

--global numbers
select date, sum(new_cases), sum(cast(new_deaths as float)), sum(CAST(new_deaths as float))/sum
(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
--where location = 'India'
where continent is not null
group by date
order by 1,2


-- Join Vaccination and Covid


-- Total Population vs Vaccination
with PopvsVac (continent,location,date,newcases,population,new_vaccinations,total_vaccinations)
as
(
select dea.continent, dea.location, dea.date, dea.new_cases, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as float)) over (Partition by dea.location order by dea.location, dea.date) as total_vaccinations
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 --order by 1,2,3
 )
 select *,(total_vaccinations/population)*100
 from PopvsVac