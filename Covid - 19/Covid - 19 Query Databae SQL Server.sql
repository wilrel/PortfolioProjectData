-- Memilih semua data dari tabel CovidDeaths di mana kolom continent tidak null, diurutkan berdasarkan kolom ke-3 (date) dan ke-4 (total_cases)
select *
from PortfolioProject..CovidDeaths
where continent is not null
order by 3,4

-- Query untuk melihat semua data dari tabel CovidVaccinations, diurutkan berdasarkan kolom ke-3 (date) dan ke-4 (new_vaccinations)
--select *
--from PortfolioProject..CovidVaccinations
--order by 3,4

-- Memilih data yang akan digunakan: Location, date, total_cases, new_cases, total_deaths, dan population dari tabel CovidDeaths
select Location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
order by 1,2

-- Mencari Total Cases vs Total Deaths
-- Menunjukkan kemungkinan kematian jika Anda tertular COVID di negara Anda (dalam persentase)
select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location like '%kingdom%'  -- Filter untuk lokasi yang mengandung kata 'kingdom'
and continent is not null
order by 1,2

-- Melihat Total Cases vs Population
-- Menunjukkan persentase populasi yang terkena COVID
select Location, date, Population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths
--where location like '%kingdom%'  -- Filter untuk lokasi tertentu (dikomentari)
order by 4

-- Melihat negara dengan Tingkat Infeksi Tertinggi dibandingkan dengan Populasi
select Location, population, MAX(total_cases) as HighestInfectionCount, MAX ((total_cases/population))*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths
--where location like '%kingdom%'  -- Filter untuk lokasi tertentu (dikomentari)
Group by Location, population
order by PercentPopulationInfected desc

-- Menunjukkan negara dengan Jumlah Kematian Tertinggi per Populasi
select location, MAX(cast(Total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
--where location like '%kingdom%'  -- Filter untuk lokasi tertentu (dikomentari)
where continent is not null  -- Hanya data dengan continent yang tidak null
Group by location
order by TotalDeathCount desc

-- Breakdown berdasarkan Continent
-- Menunjukkan lokasi (continent) dengan jumlah kematian tertinggi
select location, MAX(cast(Total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
--where location like '%kingdom%'  -- Filter untuk lokasi tertentu (dikomentari)
where continent is null  -- Hanya data dengan continent yang null (untuk continent-level data)
Group by location
order by TotalDeathCount desc

-- Menampilkan continent dengan jumlah kematian tertinggi per populasi
select location, MAX(cast(Total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
--where location like '%kingdom%'  -- Filter untuk lokasi tertentu (dikomentari)
where continent is null  -- Hanya data dengan continent yang null (untuk continent-level data)
Group by location
order by TotalDeathCount desc

-- GLOBAL NUMBER
-- Menghitung total kasus, total kematian, dan persentase kematian secara global
SELECT  
    SUM(new_cases) AS total_cases, 
    SUM(CAST(new_deaths AS INT)) AS total_deaths, 
    SUM(CAST(new_deaths AS INT)) / NULLIF(SUM(new_cases), 0) * 100 AS DeathPercentage
FROM 
    PortfolioProject..CovidDeaths
where continent is not null  -- Hanya data dengan continent yang tidak null
--GROUP BY 
--    date  -- Dikomentari karena tidak digunakan
ORDER BY 
    1, 2;

-- Melihat Total Population vs Vaccinations
-- Menghitung jumlah vaksinasi baru dan total vaksinasi yang dilakukan (RollingPeopleVaccinated)
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated --, (RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidDeaths vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

-- Menggunakan CTE (Common Table Expression) untuk menghitung persentase populasi yang divaksinasi
WITH PopvsVac(continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as 
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated --, (RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidDeaths vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3  -- Dikomentari karena tidak bisa digunakan di dalam CTE
)
select *, (RollingPeopleVaccinated/population)*100 as PercentPopulationVaccinated
from PopvsVac 

-- Membuat TEMP TABLE untuk menyimpan data persentase populasi yang divaksinasi
DROP TABLE if exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
continent nvarchar(255),
Location nvarchar(255),
date datetime,
population numeric,
new_vaccinated numeric,
RollingPeopleVaccinated numeric
)

-- Memasukkan data ke dalam TEMP TABLE
INSERT INTO #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated --, (RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidDeaths vac
	on dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null  -- Dikomentari karena tidak digunakan
--order by 2,3  -- Dikomentari karena tidak bisa digunakan di dalam INSERT

-- Menampilkan data dari TEMP TABLE beserta persentase populasi yang divaksinasi
select *, (RollingPeopleVaccinated/population)*100 as PercentPopulationVaccinated
from #PercentPopulationVaccinated


-- Menghapus view yang sudah ada (jika ada)
DROP VIEW IF EXISTS PercentPopulationVaccinated;
--Membuat view untuk menyimpan data untuk visualisasi

create view PercentPopulationVaccinated as 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated --, (RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidDeaths vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null  
--order by 2,3  -- Dikomentari karena tidak bisa digunakan di dalam INSERT

--MENGECEK TABLE VIEW APAKAH SUDAH DIBUAT  / BELUM 
SELECT TABLE_SCHEMA, TABLE_NAME 
FROM INFORMATION_SCHEMA.VIEWS 
WHERE TABLE_NAME = 'PercentPopulationVaccinated';

SELECT *
FROM PercentPopulationVaccinated