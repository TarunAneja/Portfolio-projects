Select *
from [Portfolio project 1]..coviddeathrecord
where continent is not null
order by 3, 4

--Select *
--from [Portfolio project 1]..covidVaccination$
--order by 3, 4

---Data I am going to use

Select Location, date, total_cases,new_cases, total_deaths, population
from [Portfolio project 1]..coviddeathrecord
order by 1,2

----Looking at total cases vs total deaths percentage in india
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as percentagedeath
from [Portfolio project 1]..coviddeathrecord
where location like 'India'
order by 1,2


------- Looking at total cases vs population in India
Select Location, date, total_cases, population, (total_cases/population)*100 as percentageinfected
from [Portfolio project 1]..coviddeathrecord
where location like 'India' and  continent is not null
order by 1,2

----Looking at countries with highest covid cases compared to population
 

 Select location, max(cast (total_cases as int)) as covidcases, population, max((total_cases/population))*100 as percentageinfected
from [Portfolio project 1]..coviddeathrecord
where continent is not null
 group by location, population
 order by covidcases desc

----total death per country compared to population ---

Select location, max(cast (total_deaths as int )) as totaldeath, population, max((total_deaths/population))*100 as percentagedeath
from [Portfolio project 1]..coviddeathrecord
where continent is not null
 group by location, population
 order by totaldeath desc

 ----total death by continent 
 Select continent, max(cast (total_deaths as int )) as totaldeath
from [Portfolio project 1]..coviddeathrecord
where continent is not null
 group by continent
 order by totaldeath desc

 -----vaccination details

 Select *
 from [Portfolio project 1]..covidVaccination$

where continent is not null

----joining of two tables----
Select * 
from [Portfolio project 1]..coviddeathrecord dea join [Portfolio project 1]..covidVaccination$ vac
on dea.location = vac.location and dea. date = vac. date

 ----total -population y countries vs vaccination 
select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations,
sum( convert (int, vac. new_vaccinations)) over ( partition by dea.location order by dea. location, dea. date) as rollingpeoplevaccination,

from [Portfolio project 1]..coviddeathrecord dea join [Portfolio project 1]..covidVaccination$ vac
on dea.location = vac.location and dea. date = vac. date

where dea. continent is not null
order by 2,3 


--using Cte---


Select * 
from [Portfolio project 1]..coviddeathrecord dea join [Portfolio project 1]..covidVaccination$ vac
on dea.location = vac.location and dea. date = vac. date

 ----total -population y countries vs vaccination 
 with popvsvac (continent, location, date, population, new_vaccinations, rollingpeoplevaccination)

as 
(
select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations,
sum( convert (int, vac. new_vaccinations)) over ( partition by dea.location order by dea. location, dea. date) as rollingpeoplevaccination

From [Portfolio project 1]..coviddeathrecord dea join [Portfolio project 1]..covidVaccination$ vac
on dea. location = vac. location and dea. date = vac. date

where dea. continent is not null
--order by 2,3 
)

Select *, (rollingpeoplevaccination/population)*100 as totalvaccinatedpeople
from popvsvac


----using temp table--
drop table If exists #percentpopulationvaccinated

create table #percentpopulationvaccinated
(continent nvarchar(255),
location nvarchar (255),
date datetime,
population numeric,
New_vaccination numeric,
rollingpeoplevaccination numeric )

insert into #percentpopulationvaccinated
select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations,
sum( convert (int, vac. new_vaccinations)) over ( partition by dea.location order by dea. location, dea. date) as rollingpeoplevaccination

From [Portfolio project 1]..coviddeathrecord dea join [Portfolio project 1]..covidVaccination$ vac
on dea. location = vac. location and dea. date = vac. date

---where dea. continent is not null
--order by 2,3 

Select *, (rollingpeoplevaccination/population)*100 as totalvaccinatedpeople
from 

#percentpopulationvaccinated



------creating view to store data for later visualisation 

