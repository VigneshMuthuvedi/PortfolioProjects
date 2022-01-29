Select Location, date, total_cases, new_cases, total_deaths, population
from CovidDeaths
where Location Like '%india%'
order by 1, 2

-- Death Percentage
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
from CovidDeaths
where Location Like '%india%'
order by 1, 2

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
from CovidDeaths
where Location Like '%tates%'
order by 1, 2

Select Location, date, population, total_cases, (total_cases/population)*100 AS DeathPercentage
from CovidDeaths
where Location Like '%india%'
order by 1, 2

Select Location,population, MAX(total_cases) AS HighestInfected, MAX(total_cases/population) *100 AS PercentageofInfectedPopulation
from CovidDeaths
Group By location, population
Order By PercentageofInfectedPopulation DESC

Select Location, MAX(cast(total_deaths as int)) AS HighestDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
Group BY location
Order By HighestDeathCount DESC

Select * from CovidDeaths
where continent is not null

Select continent, MAX(cast(total_deaths as int)) AS HighestDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
Group BY continent
Order By HighestDeathCount DESC

select sum(new_cases) AS totalcases, sum(cast(new_deaths as int)) AS totaldeaths, (SUM(cast(new_deaths as int))/SUM(new_cases))*100 AS DeathPercentage
from CovidDeaths
where continent is not null
--group by date


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From PortfolioProject.dbo.CovidDeaths dea
Join PortfolioProject.dbo.CovidVaccinations vac
On dea.location = vac.location
and dea.date = dea.date
where dea.continent is not null
order by 2,3

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (partition by dea.Location order by dea.location, dea.date) AS RollingPeopleVaccinated
From PortfolioProject.dbo.CovidDeaths dea
Join PortfolioProject.dbo.CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = dea.date
where dea.continent is not null
order by 2,3

with PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (partition by dea.Location order by dea.location, dea.date) AS RollingPeopleVaccinated
From PortfolioProject.dbo.CovidDeaths dea
Join PortfolioProject.dbo.CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = dea.date
where dea.continent is not null
)
select *, (RollingPeopleVaccinated/population)*100
from PopvsVac

DROP TABLE if exists #PercentPopulationVaccinated

CREATE Table #PercentPopulationVaccinated
(continent varchar(255),
Location varchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric)

Insert Into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (partition by dea.Location order by dea.location, dea.date) AS RollingPeopleVaccinated
From PortfolioProject.dbo.CovidDeaths dea
Join PortfolioProject.dbo.CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = dea.date
where dea.continent is not null

select *, (RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated

CREATE View PercentPopulationVaccinated AS
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (partition by dea.Location order by dea.location, dea.date) AS RollingPeopleVaccinated
From PortfolioProject.dbo.CovidDeaths dea
Join PortfolioProject.dbo.CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = dea.date
where dea.continent is not null
