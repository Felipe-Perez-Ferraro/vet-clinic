SELECT * FROM animals WHERE name LIKE '%mon';
SELECT name FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';
SELECT name FROM animals WHERE neutered = TRUE AND escape_attempts < 3; 
SELECT date_of_birth FROM animals WHERE name IN ('Agumon', 'Pikachu');
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered = TRUE;
SELECT * FROM animals WHERE name != 'Gabumon';
SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;


-- Added the species column
ALTER TABLE animals
ADD COLUMN species VARCHAR(30);
SELECT * FROM animals;

-- Update the animals table by setting the species column to unspecified
BEGIN;
UPDATE animals
SET species = COALESCE(species, 'unspecified')
WHERE species IS NULL;
SELECT * FROM animals;
ROLLBACK;

-- Update the animals table by setting the species column to digimon for all animals that have a name ending in mon
BEGIN;
UPDATE animals
SET species = 'digimon'
WHERE name LIKE '%mon';
-- Update the animals table by setting the species column to pokemon for all animals that don't have species already set.
UPDATE animals
SET species = 'pokemon'
WHERE species IS NULL;
COMMIT;
SELECT * FROM animals;

-- Delete all records in the animals table
BEGIN;

DELETE FROM animals;
SELECT COUNT(*) FROM animals;

ROLLBACK;
SELECT COUNT(*) FROM animals;

-- Inside a transaction
BEGIN;
-- Delete all animals born after Jan 1st, 2022.
DELETE FROM animals
WHERE date_of_birth > '2022-01-01';
-- Create a savepoint for the transaction
SAVEPOINT update_wheight;
-- Update all animals' weight to be their weight multiplied by -1
UPDATE animals
SET weight_kg = weight_kg * -1;
-- Rollback to the savepoint
ROLLBACK TO SAVEPOINT update_wheight;
-- Update all animals' weights that are negative to be their weight multiplied by -1
UPDATE animals
SET weight_kg = weight_kg * -1
WHERE weight_kg < 0;
-- Commit transaction
COMMIT;

SELECT * FROM animals;

-- Write queries to answer the following questions
-- How many animals are there?
SELECT COUNT(*) AS animals_count FROM animals;

-- How many animals have never tried to escape?
SELECT COUNT(*) AS animals_count FROM animals 
WHERE escape_attempts = 0;

-- What is the average weight of animals?
SELECT AVG(weight_kg) AS average_weight
FROM animals;

-- Who escapes the most, neutered or not neutered animals?
SELECT neutered, SUM(escape_attempts) AS total_escapes
FROM animals
GROUP BY neutered
ORDER BY total_escapes DESC;

-- What is the minimum and maximum weight of each type of animal?
SELECT species, MIN(weight_kg), MAX(weight_kg) FROM animals
GROUP BY species;

-- What is the average number of escape attempts per animal type of those born between 1990 and 2000?
SELECT species, AVG(escape_attempts) AS total_scapes_average FROM animals
WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31'
GROUP BY species;

-- Remove column species
ALTER TABLE animals
DROP COLUMN species;
-- Add column species_id which is a foreign key referencing species table
ALTER TABLE animals
ADD COLUMN species_id INTEGER REFERENCES species(id);
-- Add column owner_id which is a foreign key referencing the owners table
ALTER TABLE animals
ADD COLUMN owners_id INTEGER REFERENCES owners(id);

-- If the name ends in "mon" it will be Digimon
-- All other animals are Pokemon
UPDATE animals
SET species_id = CASE
	WHEN name LIKE '%mon' THEN (SELECT id FROM species WHERE name = 'Digimon')
	ELSE (SELECT id FROM species WHERE name = 'Pokemon')
END;

-- Modify your inserted animals to include owner information (owner_id):
-- Sam Smith owns Agumon.
-- Jennifer Orwell owns Gabumon and Pikachu.
-- Bob owns Devimon and Plantmon.
-- Melody Pond owns Charmander, Squirtle, and Blossom.
-- Dean Winchester owns Angemon and Boarmon.
UPDATE animals
SET owners_id = CASE
	WHEN name = 'Agumon' THEN (SELECT id FROM owners WHERE full_name = 'Sam Smith')
	WHEN name IN ('Gabumon', 'Pikachu') THEN (SELECT id FROM owners WHERE full_name = 'Jennifer Orwell')
	WHEN name IN ('Devimon', 'Plantmon') THEN (SELECT id FROM owners WHERE full_name = 'Bob')
	WHEN name IN ('Charmander', 'Squirtle', 'Blossom') THEN (SELECT id FROM owners WHERE full_name = 'Melody Pond')
	WHEN name IN ('Angemon', 'Boarmon') THEN (SELECT id FROM owners WHERE full_name = 'Dean Winchester')
END;

-- Write queries (using JOIN) to answer the following questions:
-- What animals belong to Melody Pond?
SELECT a.name AS animal_name
FROM animals AS a
JOIN owners AS o ON a.owners_id = o.id
WHERE o.full_name = 'Melody Pond';
-- List of all animals that are pokemon (their type is Pokemon).
SELECT a.name AS animal_type
FROM animals AS a
JOIN species AS s ON a.species_id = s.id
WHERE s.name = 'Pokemon';
-- List all owners and their animals, remember to include those that don't own any animal.
SELECT o.full_name AS owner_name, a.name AS animal_name
FROM owners AS o
LEFT JOIN animals AS a ON a.owners_id = o.id
ORDER BY o.full_name, a.name;
-- How many animals are there per species?
SELECT s.name, COUNT(*) AS species_qty
FROM species AS s
JOIN animals AS a ON s.id = a.species_id
GROUP BY s.name;
-- List all Digimon owned by Jennifer Orwell.
SELECT o.full_name AS owner_name, a.name AS digimon_name
FROM owners AS o
LEFT JOIN animals AS a ON a.owners_id = o.id
WHERE o.full_name = 'Jennifer Orwell' AND a.species_id = 2;
-- List all animals owned by Dean Winchester that haven't tried to escape.
SELECT o.full_name AS owner_name, a.name AS digimon_name
FROM owners AS o
LEFT JOIN animals AS a ON a.owners_id = o.id
WHERE o.full_name = 'Dean Winchester' AND escape_attempts = 0;
-- Who owns the most animals?
SELECT o.full_name, COUNT(*) AS animals_qty
FROM owners AS o
JOIN animals AS a ON a.owners_id = o.id
GROUP BY o.full_name
ORDER BY 2 DESC
LIMIT 1;