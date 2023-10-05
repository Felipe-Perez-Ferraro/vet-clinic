CREATE TABLE animals (
  id INTEGER PRIMARY KEY,
  name VARCHAR(30),
  date_of_birth DATE,
  escape_attempts INTEGER,
  neutered BOOLEAN,
  weight_kg DECIMAL(5,2),
  owner_id INTEGER REFERENCES owners(id),
  species_id INTEGER REFERENCES species(id)
);

CREATE TABLE owners (
  id SERIAL PRIMARY KEY,
  full_name VARCHAR(30),
  age INTEGER,
  email VARCHAR(120)
);

CREATE TABLE species (
  id SERIAL PRIMARY KEY,
  name VARCHAR(30)
);

CREATE TABLE vets (
  id SERIAL PRIMARY KEY,
  name VARCHAR(30),
  age INTEGER,
  date_of_graduation DATE
);

CREATE TABLE specializations (
  PRIMARY KEY (species_id, vet_id),
  species_id INTEGER REFERENCES species(id),
  vet_id INTEGER REFERENCES vets(id)
);

CREATE TABLE visits (
  id SERIAL PRIMARY KEY,
  animal_id INTEGER REFERENCES animals(id),
  vet_id INTEGER REFERENCES vets(id),
  visit_date DATE
);

-- Week 2 performance

-- Add an email column to your owners table
ALTER TABLE owners ADD COLUMN email VARCHAR(120);

-- Create indexes to improve the speed
CREATE INDEX idx_animal_id ON visits(animal_id);
CREATE INDEX idx_vet_id ON visits(vet_id);
CREATE INDEX idx_email ON owners(email);
