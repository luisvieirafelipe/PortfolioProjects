-- Select Data 

Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths




-- Total Cases vs Total Deaths

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from Portfolio..CovidDeaths$
Where location like '%Brazil%'
order by 1,2

-- Total CAses vs Population

select location, date, total_cases, population, (total_cases/population)*100 as CasesPercentage
from Portfolio..CovidDeaths$
Where location like '%Brazil%'
order by 1,2

select location, date, total_cases, population, (total_cases/population)*100 as CasesPercentage
from Portfolio..CovidDeaths$
where continent is not null
--Where location like '%Brazil%'
order by 1,2


-- Countries with Highest Infection Rate Compared to Population

select location, max(total_cases) as HighestInfectionCount, population, Max((total_cases/population))*100 as PercentInfected
from Portfolio..CovidDeaths$
where continent is not null
Group by population, location
order by PercentInfected desc


-- Countries with Highest Death Count Compared to Population
select location, max(total_deaths) as DeathCount
from Portfolio..CovidDeaths$
where continent is not null
Group by location
order by DeathCount desc


-- Countries with Highest Death Rate Compared to Population
select location, max(total_deaths) as HighestDeathCount, population, Max((total_deaths/population))*100 as PercentDeaths
from Portfolio..CovidDeaths$
where continent is not null
Group by population, location
order by PercentDeaths desc


-- Continents with the highest death count
select location, max(cast(total_deaths as int)) as DeathCount
from Portfolio..CovidDeaths$
where continent is  null
Group by location
order by DeathCount desc

-- Global Numbers

-- Group By Date
select date, sum(new_cases) as Cases, sum(new_deaths) as Deaths, (sum(new_deaths)/sum(new_cases))*100 as DeathPercentage
from Portfolio..CovidDeaths$
Where continent is not null 
Group by date
order by 1,2

-- Total Numbers
select sum(new_cases) as Cases, sum(new_deaths) as Deaths, (sum(new_deaths)/sum(new_cases))*100 as DeathPercentage
from Portfolio..CovidDeaths$
Where continent is not null 
--Group by date
order by 1,2

-- Total Population vs Vaccinations
select Death.location, Death.continent, Death.date, cast(Death.population as bigint), Vac.new_vaccinations
,sum(convert(real, Vac.new_vaccinations)) over (Partition by Death.location order by Death.location, Death.date)
as RollingPeopleVaccnated,
from Portfolio..CovidDeaths$ Death
Join Portfolio..CovidVaccinations$ Vac
	on Death.location = Vac.location	
	and Death.date=Vac.date
where Death.continent is not null
order by 1,2,3

--CTE

With PopvsVac (Continent, Location, date, population, RollingPeopleVaccinated, new_vaccinations)
as 
(
select Death.continent, Death.location, Death.date, cast(Death.population as float), Vac.new_vaccinations
,sum(convert(real, Vac.new_vaccinations)) over (Partition by Death.location order by Death.location, Death.date)
as RollingPeopleVaccinated
from Portfolio..CovidDeaths$ Death
Join Portfolio..CovidVaccinations$ Vac
	on Death.location = Vac.location	
	and Death.date = Vac.date
where Death.continent is not null
--order by 2,3
)
select*, (RollingPeopleVaccinated/population)*100 as VaccionationPercentage
From PopvsVac

-- Temp Table

Drop Table if exists  PercentPopulationVaccinated
Create Table PercentPopulationVaccinated
(
Continent nvarchar(250) ,
Location nvarchar(250),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric,
)
Insert into PercentPopulationVaccinated
select Death.continent, Death.location, Death.date, cast(Death.population as numeric), Vac.new_vaccinations
,sum(convert(real, Vac.new_vaccinations)) over (Partition by Death.location order by Death.location, Death.date)
as RollingPeopleVaccinated
from Portfolio..CovidDeaths$ Death
Join Portfolio..CovidVaccinations$ Vac
	on Death.location = Vac.location	
	and Death.date = Vac.date
where Death.continent is not null


select*, (RollingPeopleVaccinated/population)*100 as VaccionationPercentage
From PercentPopulationVaccinated


-- Store data for later Visualizations
create view  PercentPopulationVaccinatedView1 as
select Death.continent, Death.location, Death.date, cast(Death.population as numeric) as Population, Vac.new_vaccinations
,sum(convert(real, Vac.new_vaccinations)) over (Partition by Death.location order by Death.location, Death.date)
as RollingPeopleVaccinated
from Portfolio..CovidDeaths$ Death
Join Portfolio..CovidVaccinations$ Vac
	on Death.location = Vac.location	
	and Death.date = Vac.date
where Death.continent is not null

