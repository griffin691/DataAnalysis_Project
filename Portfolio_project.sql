SELECT *
FROM Covid_Deaths
ORDER BY 2,3;


SELECT *
FROM covid_Vaccinations
ORDER BY 3,4;

-- select the data that i am going to be using
-- select the location, the date, the total cases , new cases, total deaths, population

SELECT location, date, total_cases , new_cases,total_deaths , population
FROM Covid_Deaths
ORDER BY 1,2 ;

-- Looking at the total cases vs the total deaths/Percentage of people wjo died who diagnosed with it
-- JUST TO SHOW THE LIKELIHOOD OF DYING IF YOU GOT COVID IN KENYA

SELECT location, date, total_cases ,total_deaths , population, (total_deaths/total_cases)*100 AS Death_Percentage
FROM Covid_Deaths
WHERE location like 'ken%'
ORDER BY date DESC; 

-- Total cases vs the population in Kenya (Shows what percentage of population got covid)

SELECT location, date, total_cases ,population , (total_cases/population)*100 AS Infectedpopulation_Percentage
FROM Covid_Deaths
WHERE location like 'ken%'
ORDER BY date DESC; 

-- Looking at countries with highest Infection rates compared to populations

SELECT location,population , MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS Infectedpopulation_Percentage
FROM Covid_Deaths
GROUP BY Location,Population 
-- WHERE location like 'ken%'
ORDER BY Infectedpopulation_Percentage DESC; 

-- showing countries with highest death count per population

SELECT location, MAX(total_deaths) AS TotalDeathCount
FROM Covid_Deaths
-- WHERE location like 'ken%'
GROUP BY location
ORDER BY TotalDeathCount DESC;

-- LET'S BREAK THINGS DOWN BASED ON CONTINENT
-- THIS IS ALSO SHOWING THE CONTINENTS WITH THE HIGHEST DEATH COUNTS

SELECT continent, MAX(total_deaths) AS TotalDeathCount
FROM Covid_Deaths
-- WHERE location like 'ken%'
GROUP BY continent
ORDER BY TotalDeathCount DESC;

-- GLOBAL NUMBERS
SELECT  SUM(new_cases)AS total_cases, SUM(new_deaths) AS total_deaths,(SUM(new_deaths)/SUM(new_cases))*100  AS Death_Percentage-- ,total_deaths , population, (total_deaths/total_cases)*100 AS Death_Percentage
FROM Covid_Deaths
-- GROUP BY date
ORDER BY 1,2; 

-- Looking at total population vs vaccination
SELECT dea.continent, dea.location, dea.date, vac.new_vaccinations
FROM Covid_deaths dea
JOIN Covid_Vaccinations vac
	ON dea.location = vac.location AND dea.date = vac.date
WHERE vac.new_vaccinations != ''
ORDER BY 1, 2 , 3 DESC;

-- USING CTE / TEMP TABLE TO GET VACCINATION PERCENTAGE
WITH PopvsVac AS (
    SELECT 
        dea.continent, 
        dea.location, 
        dea.date, 
        dea.population, 
        vac.new_vaccinations, 
        SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.date) AS CumulativePeople_Vaccinated
    FROM 
        Covid_deaths dea
    JOIN 
        Covid_Vaccinations vac
        ON dea.location = vac.location AND dea.date = vac.date
)
SELECT 
    continent, 
    location, 
    date, 
    population, 
    new_vaccinations, 
    CumulativePeople_Vaccinated, 
    (CumulativePeople_Vaccinated / population) * 100 AS VaccinationPercentage
FROM 
    PopvsVac;

-- CREATING VIEWS PercentagePopulationVaccinated as percentpopulationvaccinated
CREATE VIEW PercentPopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, vac.new_vaccinations
FROM Covid_deaths dea
JOIN Covid_Vaccinations vac
	ON dea.location = vac.location AND dea.date = vac.date;
-- ORDER BY 1, 2 , 3 DESC;

CREATE VIEW DeathPercentage_Kenya as
SELECT location, date, total_cases ,total_deaths , population, (total_deaths/total_cases)*100 AS Death_Percentage
FROM Covid_Deaths
WHERE location like 'ken%'
ORDER BY date DESC; 

CREATE VIEW HighestDeathCounts as
SELECT location, MAX(total_deaths) AS TotalDeathCount
FROM Covid_Deaths
-- WHERE location like 'ken%'
GROUP BY location
ORDER BY TotalDeathCount DESC;

CREATE VIEW ContinentDeathCounts as
SELECT continent, MAX(total_deaths) AS TotalDeathCount
FROM Covid_Deaths
-- WHERE location like 'ken%'
GROUP BY continent
ORDER BY TotalDeathCount DESC;