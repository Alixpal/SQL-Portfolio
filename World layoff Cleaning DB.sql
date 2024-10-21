SELECT *
FROM `layoffs (1)`;

CREATE TABLE layoffs_staging
LIKE `layoffs (1)`;

SELECT *
FROM layoffs_staging;

INSERT layoffs_staging
SELECT *
FROM `layoffs (1)`;

SELECT *,
row_number() over(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage,
country, funds_raised_millions) AS row_num
FROM layoffs_staging;

WITH duplicate_cte AS
(
SELECT *,
row_number() over(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage,
country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;


SELECT *
FROM layoffs_staging
WHERE company = 'Casper';



CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

INSERT INTO layoffs_staging2
SELECT *,
row_number() over(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage,
country, funds_raised_millions) AS row_num
FROM layoffs_staging;

DELETE
FROM layoffs_staging2
WHERE row_num > 1;

SET SQL_SAFE_UPDATES = 0;

SELECT *
FROM layoffs_staging2;

-- Standardizing Data

SELECT company, trim(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = trim(company);

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT distinct country, TRIM(TRAILING "." FROM country)
FROM layoffs_staging2 ;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING "." FROM country)
WHERE country LIKE 'United States%';

-- CHANGING THE DATE TEXT TO DATE STRING 

SELECT `date`
FROM layoffs_staging2 ;

UPDATE layoffs_staging2
SET `date`= str_to_date(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;