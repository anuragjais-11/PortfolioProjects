SELECT location, date, total_cases, new_cases, total_deaths, population
FROM coursera-334720.Covid_Analysis.CovidDeaths
ORDER BY 1,2;

-- Looking at Total Cases vs Total Deaths (Case Fatality Rate)

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS case_fatality_rate
FROM coursera-334720.Covid_Analysis.CovidDeaths
WHERE location = 'India'
ORDER BY 1,2;

-- Looking at Total Case vs Population
-- Shows the percentage of population infected by Covid

SELECT location, date, population, total_cases, (total_deaths/population)*100 AS percent_population_infected
FROM coursera-334720.Covid_Analysis.CovidDeaths
ORDER BY 1,2;

-- Looking at Countries with Highest Infection Rate compared to Population

SELECT location, population, MAX(total_cases) AS highest_infection_count, MAX((total_cases/population))*100 AS percent_population_infected
FROM coursera-334720.Covid_Analysis.CovidDeaths
GROUP BY location, population
ORDER BY  percent_population_infected DESC;

-- Showing Countries with Highest Death Count

SELECT location, MAX(total_deaths) AS total_death_count
FROM coursera-334720.Covid_Analysis.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY  total_death_count DESC;

-- Breaking down things by Continent

SELECT continent, MAX(total_deaths) AS total_death_count,
FROM coursera-334720.Covid_Analysis.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY  total_death_count DESC;


-- Showing the Continents with the Hghest Death Count

SELECT continent, MAX(total_deaths) AS total_death_count
FROM coursera-334720.Covid_Analysis.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY  total_death_count DESC;

-- Global Numbers

SELECT SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, (SUM(new_deaths)/SUM(new_cases))*100 AS case_fatality_rate
FROM coursera-334720.Covid_Analysis.CovidDeaths
WHERE continent IS NOT NULL
--GROUP BY date
ORDER BY 1,2;

-- Looking at total Population vs Vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rolling_people_vaccinated
FROM coursera-334720.Covid_Analysis.CovidDeaths dea
JOIN coursera-334720.Covid_Analysis.CovidVaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3;

-- Use CTE

WITH pop_vs_vac AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rolling_people_vaccinated
FROM coursera-334720.Covid_Analysis.CovidDeaths dea
JOIN coursera-334720.Covid_Analysis.CovidVaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
)
SELECT *, (rolling_people_vaccinated/population)*100
FROM pop_vs_vac;