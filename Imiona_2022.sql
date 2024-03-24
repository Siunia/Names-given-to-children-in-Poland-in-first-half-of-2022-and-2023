create database projekt;
use projekt;

-- ILOŚĆ URODZEŃ W PIERWSZEJ POŁOWIE 2022
SELECT 
    płeć, SUM(liczba) AS urodzenia_w_2022
FROM
    imiona_2022
GROUP BY płeć;

-- 10 NAJPOPULARNIEJSZYCH NADAWANYCH IMION MĘSKICH W PIERWSZEJ POŁOWIE 2022
SELECT DISTINCT
    '2022' as Rok, imię, MAX(liczba) AS ile_razy_nadano_imię
FROM
    imiona_2022
WHERE
    płeć = 'Mężczyzna'
GROUP BY imię
ORDER BY ile_razy_nadano_imię DESC
LIMIT 10;

-- 10 NAJPOPULARNIEJSZYCH NADAWANYCH IMION DAMSKICH W PIERWSZEJ POŁOWIE 2022
SELECT DISTINCT
    '2022' as Rok, imię, MAX(liczba) AS ile_razy_nadano_imię
FROM
    imiona_2022
WHERE
    płeć = 'Kobieta'
GROUP BY imię
ORDER BY ile_razy_nadano_imię DESC
LIMIT 10;

-- PROCENTOWA WARTOŚĆ URODZEŃ W PIERWSZEJ POŁOWIE 2022 
SELECT 
    PŁEĆ, 
    SUM(LICZBA) AS suma_urodzeń,
    (SUM(LICZBA) / (SELECT SUM(LICZBA) FROM imiona_2022)) * 100 AS procentowa_wartość
FROM 
    imiona_2022
GROUP BY 
    PŁEĆ;

-- 10 NAJMNIEJ POPULARNYCH IMION MĘSKICH I ŻEŃSKICH
SELECT DISTINCT
    IMIĘ, sum(liczba) AS najrzadsze_imię_męskie
FROM
    IMIONA_2022
WHERE
    PŁEĆ = 'MĘŻCZYZNA'
GROUP BY IMIĘ
ORDER BY najrzadsze_imię_męskie
limit 10;

sELECT DISTINCT
    IMIĘ, sum(liczba) AS najrzadsze_imię_damskie
FROM
    IMIONA_2022
WHERE
    PŁEĆ = 'Kobieta'
GROUP BY IMIĘ
ORDER BY najrzadsze_imię_damskie
LIMIT 10;

-- Imiona męskie, których liczba wystąpień przekracza 1000
SELECT 
    IMIĘ, SUM(LICZBA) LICZBA_WYSTĄPIEŃ
FROM
    IMIONA_2022
WHERE
    PŁEĆ = 'MĘŻCZYZNA'
GROUP BY IMIĘ
HAVING LICZBA_WYSTĄPIEŃ > 1000;

-- Porównanie liczby urodzeń z pierwszego półrocza 2022 oraz 2023
-- Zauważalna tendencja spadkowa
SELECT 
    '2022' AS rok, SUM(liczba) AS suma
FROM
    imiona_2022 
UNION ALL SELECT 
    '2023' AS rok, SUM(liczba) AS suma
FROM
    imiona_2023;

-- Procentowa różnica urodzeń między 2023 a 2022
SELECT 
    SUM(liczba) AS suma_2022,
    (SELECT 
            SUM(liczba)
        FROM
            imiona_2023) AS suma_2023,
    ((SELECT 
            SUM(liczba)
        FROM
            imiona_2023) - SUM(liczba)) / SUM(liczba) * 100 AS procentowa_różnica
FROM
    imiona_2022
UNION ALL
SELECT 
    (SELECT 
            SUM(liczba)
        FROM
            imiona_2022) AS suma_2022,
    SUM(liczba) AS suma_2023,
    (SUM(liczba) - (SELECT 
            SUM(liczba)
        FROM
            imiona_2022)) / (SELECT 
            SUM(liczba)
        FROM
            imiona_2022) * 100 AS procentowa_różnica
FROM
    imiona_2023;

-- Najpopularniejsze imię męskie w 2022 oraz 2023
(SELECT 
    '2022' AS rok, imię, SUM(liczba) AS liczba_wystąpień
FROM
    imiona_2022
WHERE
    płeć = 'Mężczyzna'
GROUP BY imię
ORDER BY liczba_wystąpień DESC
LIMIT 1)
union all
(SELECT 
    '2023' AS rok, imię, SUM(liczba) AS liczba_wystąpień
FROM
    imiona_2023
WHERE
    płeć = 'Mężczyzna'
GROUP BY imię
ORDER BY liczba_wystąpień DESC
LIMIT 1);

-- Najpopularniejsze imię żeńskie w 2022 oraz 2023
(SELECT 
    '2022' AS rok, imię, SUM(liczba) AS liczba_wystąpień
FROM
    imiona_2022
WHERE
    płeć = 'Kobieta'
GROUP BY imię
ORDER BY liczba_wystąpień DESC
LIMIT 1)
union all
(SELECT 
    '2023' AS rok, imię, SUM(liczba) AS liczba_wystąpień
FROM
    imiona_2023
WHERE
    płeć = 'Kobieta'
GROUP BY imię
ORDER BY liczba_wystąpień DESC
LIMIT 1);

-- Porównanie najmniej popularnych imion w 2022 oraz 2023

(SELECT 
    '2022' AS rok, imię, SUM(liczba) AS liczba_wystąpień
FROM
    imiona_2022
WHERE
    płeć = 'Kobieta'
GROUP BY imię
ORDER BY liczba_wystąpień
LIMIT 1)
union all
(SELECT 
    '2023' AS rok, imię, SUM(liczba) AS liczba_wystąpień
FROM
    imiona_2023
WHERE
    płeć = 'Kobieta'
GROUP BY imię
ORDER BY liczba_wystąpień
LIMIT 1)
union all
(SELECT 
    '2022' AS rok, imię, SUM(liczba) AS liczba_wystąpień
FROM
    imiona_2022
WHERE
    płeć = 'Mężczyzna'
GROUP BY imię
ORDER BY liczba_wystąpień
LIMIT 1)
union all
(SELECT 
    '2023' AS rok, imię, SUM(liczba) AS liczba_wystąpień
FROM
    imiona_2023
WHERE
    płeć = 'Mężczyzna'
GROUP BY imię
ORDER BY liczba_wystąpień
LIMIT 1);

-- Imiona, które pojawiły się tylko w 2022 roku
SELECT 
    *
FROM
    imiona_2022
WHERE
    imię NOT IN (SELECT 
            imię
        FROM
            imiona_2023)
            
-- Imiona, które pojawiły się tylko w 2023 roku
SELECT 
    *
FROM
    imiona_2023
WHERE
    imię NOT IN (SELECT 
            imię
        FROM
            imiona_2022);

-- Imiona, które występowały zarówno w 2022, jak i w 2023 roku, wraz z liczbą nadanych imion w obu latach

SELECT 
    '2022' AS rok,
    imiona_2022.imię,
    imiona_2022.liczba,
    '2023' AS rok,
    imiona_2023.imię,
    imiona_2023.liczba
FROM
    imiona_2022
        JOIN
    imiona_2023 ON imiona_2022.imię = imiona_2023.imię
ORDER BY imiona_2022.imię , imiona_2023.imię

