CREATE TABLE animals (
  id INTEGER PRIMARY KEY,
  name VARCHAR(30),
  date_of_birth DATE,
  escape_attempts INTEGER,
  neutered BOOLEAN,
  weight_kg DECIMAL(5,2)
);

ALTER TABLE vet_clinic
ADD COLUMN species VARCHAR(30);
SELECT * FROM vet_clinic;