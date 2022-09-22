Select * from Portfolio1..CovidDeaths
where continent is not null
order by 3,4

--Select data that we are going to use

Select Location, date, total_cases, new_cases, total_deaths, population
From Portfolio1..CovidDeaths
order by 1,2

--looking at the total cases vs total deaths
-- Shows the chances of death if you have covid, in India

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_rate
From Portfolio1..CovidDeaths
where location ='india'
order by 1,2

-- Looking at total_cases Vs population
-- shows the percentage of population got covid in India

Select Location, date, total_cases, total_cases, population, (total_cases/population)*100 as covid_rate
From Portfolio1..CovidDeaths
where location ='india'
order by 1,2

--Looking at the counties with high infection rate

Select Location,max(total_cases) as Infectioncount, population, max((total_cases/population))*100 as covid_rate
From Portfolio1..CovidDeaths
where continent is not null
Group by Population, Location
order by covid_rate desc

-- Showing the countries with the highest death count 

Select Location, max(cast(total_deaths as int)) as totaldeathcount
From Portfolio1..CovidDeaths
where continent is not null
Group by Location
order by totaldeathcount desc

--shwoing the continents with the highest count

Select location, max(cast(total_deaths as int)) as totaldeathcount
From Portfolio1..CovidDeaths
where continent is null
Group by location
order by totaldeathcount desc



--daily death and covid cases accross the globe

Select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as percentagedeath
from Portfolio1..CovidDeaths
where continent is not null
group by date
order by 1,2


--with cte

with popvsvac (continent, location, population ,date ,  new_vaccination, rollover)
as
(
Select dea.continent, dea.location,dea.population, dea.date, vac.new_vaccinations
, sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as rollover
From Portfolio1..CovidDeaths dea
Join Portfolio1..CovidVaccinations$ vac
  on dea.location = vac.location 
  and dea.date = vac.date
where dea.continent is not null
--order by 2,3

)
select *, (rollover/population)*100 as percentvac
From popvsvac



-- using temp table


drop table if exists #onewithtemp
create table #onewithtemp
(
continent nvarchar(255),
location nvarchar(255),
population numeric,
date datetime,
new_vaccination numeric,
rollover numeric
)
insert into #onewithtemp

Select dea.continent, dea.location,dea.population, dea.date, vac.new_vaccinations
, sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as rollover
From Portfolio1..CovidDeaths dea
Join Portfolio1..CovidVaccinations$ vac
  on dea.location = vac.location 
  and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select *, (rollover/population)*100 as percentvac
From #onewithtemp


--creating view to store data for later visualization
   create view popvsvac as
   Select dea.continent, dea.location,dea.population, dea.date, vac.new_vaccinations
, sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as rollover
From Portfolio1..CovidDeaths dea
Join Portfolio1..CovidVaccinations$ vac
  on dea.location = vac.location 
  and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select *
from popvsvac
