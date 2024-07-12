select * from PortfolioProject..CovidDeaths
where continent is not null
order by 3,4


--Select data yang ingin kita gunakan 
select Location, date, total_cases, new_cases, total_deaths, population 
from PortfolioProject..CovidDeaths
order by 1,2

-- Mencari Total Kasus dan Total Kematian		

select Location, date, total_cases, total_deaths, (cast(total_deaths as float)  / cast(total_cases as float)) * 100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location like '%indonesia%'
order by DeathPercentage desc


--Mencari total kasus vs populasi
--Menunjukan persentase  populasi yang terkena covid

select location, date, population,total_cases, (total_cases/population) *100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--where location like '%states%'
order by 1,2

--Mencari Negara yang Terkena Infeksi Tertinggi dan membandingkan dengan populasi

select location, population, MAX(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths
group by population, location
order by PercentPopulationInfected desc

--Menampilkan negara dengan kematian tertinggi per populasi 

select location, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is not null
group by location
order by TotalDeathCount desc

--lets break things down by continent
select continent, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is not null
group by continent
order by TotalDeathCount desc



--Menampilkan Benua dengan kematian tertinggi perpopulasi
select continent, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is not null
group by continent
order by TotalDeathCount desc


--Global Number
SELECT 
    SUM(CAST(new_cases AS INT)) AS total_cases, 
    SUM(CAST(new_deaths AS INT)) AS total_deaths,
    CASE 
        WHEN SUM(CAST(new_cases AS INT)) = 0 THEN 0 
        ELSE (SUM(CAST(new_deaths AS INT)) / SUM(CAST(new_cases AS INT))) * 100 
    END AS DeathPercentage
FROM 
    PortfolioProject..CovidDeaths
WHERE 
    continent IS NOT NULL
--GROUP BY 
  --  date
ORDER BY 
    1,2;


-- MENCARI TOTAL POPULASI VS VAKSINASI

--Use CTE
WITH PopvsVac (Continent, Location, date, population, new_vaccinations, RollingPeopleVaccinated)
as (
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT (BIGINT,vac.new_vaccinations) )OVER (Partition by dea.Location) AS RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population) * 100
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2,3
	)
SELECT *, (RollingPeopleVaccinated/population) * 100 
FROM PopvsVac




--TEMP TABLE 
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
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT (BIGINT,vac.new_vaccinations) )OVER (Partition by dea.Location) AS RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population) * 100
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
--WHERE dea.continent is not null
--ORDER BY 2,3


SELECT *, (RollingPeopleVaccinated/population) * 100 
FROM #PercentPopulationVaccinated


--Creating View to store data for later Visualizations 

CREATE VIEW PercentPopulationVaccinated as 
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT (BIGINT,vac.new_vaccinations) )OVER (Partition by dea.Location) AS RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population) * 100
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2,3



SELECT * 
FROM PercentPopulationVaccinated