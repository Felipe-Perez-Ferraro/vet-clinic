SELECT * FROM vet_clinic WHERE name LIKE '%mon';
SELECT name FROM vet_clinic WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';
SELECT name FROM vet_clinic WHERE neutered = TRUE AND escape_attempts < 3; 
SELECT date_of_birth FROM vet_clinic WHERE name IN ('Agumon', 'Pikachu');
SELECT name, escape_attempts FROM vet_clinic WHERE weight_kg > 10.5;
SELECT * FROM vet_clinic WHERE neutered = TRUE;
SELECT * FROM vet_clinic WHERE name != 'Gabumon';
SELECT * FROM vet_clinic WHERE weight_kg BETWEEN 10.4 AND 17.3;
