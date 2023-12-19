Select 
location,date,total_cases,new_cases,total_deaths,population
from Portfolio..coviddeaths 
Order By 1,2 


Select 
location,date,total_cases,total_deaths, (CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0))*100 as Death_Percentage 
from Portfolio..CovidDeaths 
Order By 1,2 


-- Death Percenatge of India 

Select 
location,date,total_cases,total_deaths, (CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0))*100 as Death_Percentage 
from Portfolio..CovidDeaths where location like '%India%' 
Order By 1,2 

-- Percentage of Population effected by covid in India 

Select 
location,date,total_cases,population, (CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0))*100 as	Population_Percentage 
from Portfolio..CovidDeaths where location like '%India%' 
Order By 1,2 


-- MAXIMUM INFECTED COUNTRY 

Select 
location ,population,max(cast (total_cases as int ))as Highest_Count, MAX((CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0))) *100 as	INFECTED_POPULATION
from Portfolio..CovidDeaths where continent is not null
Group By location,population
Order By INFECTED_POPULATION DESC


-- Death Count per Population

Select 
location,max(cast (total_deaths as int ))as Total_Death
from Portfolio..CovidDeaths 
where continent is Not Null 
Group By location
Order By Total_Death DESC 


-- Death Count As per Continent

Select 
continent,max(cast (total_deaths as int ))as Total_Death
from Portfolio..CovidDeaths 
where continent is not Null 
Group By continent
Order By Total_Death DESC 

-- Death Count Globally

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From Portfolio..CovidDeaths
where continent is not null 
order by 1,2

-- Vaccin taken Globally

SET ANSI_WARNINGS OFF
GO
Select Death.continent,Death.location,Death.date,Death.population,Vaccin.new_vaccinations ,
 SUM(CONVERT(float, Vaccin.new_vaccinations )) Over (Partition By Death.location Order By Death.location, Death.date ) as Total_Vaccinated_People
from portfolio..coviddeaths as Death
join portfolio..covidvaccination as Vaccin 
On Death.location =  Vaccin.location
and Death.date = Vaccin.date
where Death.continent is not null 
Order By 2,3

-- CTE EXPRESSIONS OVER THE TOTAL_VACCINATED_PEOPLE

With POPvsVACCIN (continent,location,date,population, new_vaccination,Total_Vaccinated_People)
as
(
Select Death.continent,Death.location,Death.date,Death.population,Vaccin.new_vaccinations ,
 SUM(CONVERT(float, Vaccin.new_vaccinations )) Over (Partition By Death.location Order By Death.location, Death.date ) as Total_Vaccinated_People
from portfolio..coviddeaths as Death
join portfolio..covidvaccination as Vaccin 
On Death.location =  Vaccin.location
and Death.date = Vaccin.date
where Death.continent is not null 
)
Select *, (Total_Vaccinated_People / population) *100 as percentage 
from POPvsVACCIN

--TEMP TABLE 

Drop Table if exists #PopulationVaccinatedPercentage
Create Table #PopulationVaccinatedPercentage
(
continent nvarchar(250),
location nvarchar(250),
date datetime,
population numeric,
new_vaccination float,
Total_Vaccinated_People float
)

Insert into #PopulationVaccinatedPercentage
Select Death.continent,Death.location,Death.date,Death.population,Vaccin.new_vaccinations ,
 SUM(CONVERT(float, Vaccin.new_vaccinations )) Over (Partition By Death.location Order By Death.location, Death.date ) as Total_Vaccinated_People
from portfolio..coviddeaths as Death
join portfolio..covidvaccination as Vaccin 
On Death.location =  Vaccin.location
and Death.date = Vaccin.date

Select *, (Total_Vaccinated_People / population) *100 as percentage 
from #PopulationVaccinatedPercentage


-- CREATING VIEW FOR VISUALIZATION

-- Vaccinated Population Globally 

USE Portfolio
GO
Create View PopulationVaccinatedPercentages 
As 
Select Death.continent,Death.location,Death.date,Death.population,Vaccin.new_vaccinations ,
 SUM(CONVERT(float, Vaccin.new_vaccinations )) Over (Partition By Death.location Order By Death.location, Death.date ) as Total_Vaccinated_People
from portfolio..coviddeaths as Death
join portfolio..covidvaccination as Vaccin 
On Death.location =  Vaccin.location
and Death.date = Vaccin.date
where Death.continent is not null 

Select * from PopulationVaccinatedPercentages 


-- Global Death Percentage

Use Portfolio
Go
Create View GlobalDeaths
As
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From Portfolio..CovidDeaths
where continent is not null 

Select * from GlobalDeaths

---- Deaths as Per continent
USE Portfolio
GO
Create View ContinentWiseTotalDeaths
As
Select 
continent,max(cast (total_deaths as int ))as Total_Death
from Portfolio..CovidDeaths 
where continent is not Null 
Group By continent

Select * from ContinentWiseTotalDeaths







