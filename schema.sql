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
  age INTEGER
);

CREATE TABLE species (
  id SERIAL PRIMARY KEY,
  name VARCHAR(30)
);