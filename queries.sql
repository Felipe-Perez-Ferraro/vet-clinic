SELECT * FROM vet_clinic WHERE name LIKE '%mon';
SELECT name FROM vet_clinic WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';
SELECT name FROM vet_clinic WHERE neutered = TRUE AND escape_attempts < 3; 
SELECT date_of_birth FROM vet_clinic WHERE name IN ('Agumon', 'Pikachu');
SELECT name, escape_attempts FROM vet_clinic WHERE weight_kg > 10.5;
SELECT * FROM vet_clinic WHERE neutered = TRUE;
SELECT * FROM vet_clinic WHERE name != 'Gabumon';
SELECT * FROM vet_clinic WHERE weight_kg BETWEEN 10.4 AND 17.3;


-- Added the species column
ALTER TABLE vet_clinic
ADD COLUMN species VARCHAR(30);
SELECT * FROM vet_clinic;

-- Update the animals table by setting the species column to unspecified
BEGIN;
UPDATE vet_clinic
SET species = COALESCE(species, 'unspecified')
WHERE species IS NULL;
SELECT * FROM vet_clinic;
ROLLBACK;

-- Update the animals table by setting the species column to digimon for all animals that have a name ending in mon
BEGIN;
UPDATE vet_clinic
SET species = 'digimon'
WHERE name LIKE '%mon';
-- Update the animals table by setting the species column to pokemon for all animals that don't have species already set.
UPDATE vet_clinic
SET species = 'pokemon'
WHERE species IS NULL;
COMMIT;
SELECT * FROM vet_clinic;

-- Delete all records in the animals table
BEGIN;
DELETE FROM vet_clinic;
SELECT * FROM vet_clinic;
-- Then roll back the transaction
BEGIN;
DELETE FROM vet_clinic;
ROLLBACK;
SELECT * FROM vet_clinic;

-- Inside a transaction
BEGIN;
-- Delete all animals born after Jan 1st, 2022.
DELETE FROM vet_clinic
WHERE date_of_birth > '2022-01-01';
-- Create a savepoint for the transaction
SAVEPOINT update_wheight;
-- Update all animals' weight to be their weight multiplied by -1
UPDATE vet_clinic
SET weight_kg = weight_kg * -1;
-- Rollback to the savepoint
ROLLBACK TO SAVEPOINT update_wheight;
-- Update all animals' weights that are negative to be their weight multiplied by -1
UPDATE vet_clinic
SET weight_kg = weight_kg * -1
WHERE weight_kg < 0;
-- Commit transaction
COMMIT;

SELECT * FROM vet_clinic;

-- Write queries to answer the following questions
-- How many animals are there?
SELECT COUNT(*) AS animals_count FROM vet_clinic;

-- How many animals have never tried to escape?
SELECT COUNT(*) AS animals_count FROM vet_clinic 
WHERE escape_attempts = 0;

-- What is the average weight of animals?
SELECT AVG(weight_kg) AS average_weight
FROM vet_clinic;

-- Who escapes the most, neutered or not neutered animals?
SELECT neutered, SUM(escape_attempts) AS total_escapes
FROM vet_clinic
GROUP BY neutered
ORDER BY total_escapes DESC;

-- What is the minimum and maximum weight of each type of animal?
SELECT species, MIN(weight_kg), MAX(weight_kg) FROM vet_clinic
GROUP BY species;

-- What is the average number of escape attempts per animal type of those born between 1990 and 2000?
SELECT species, AVG(escape_attempts) AS total_scapes_average FROM vet_clinic
WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31'
GROUP BY species;