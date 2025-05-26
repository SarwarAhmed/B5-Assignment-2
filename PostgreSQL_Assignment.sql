-- Active: 1747990674071@@127.0.0.1@5432@ph

CREATE Table rangers
(
    ranger_id SERIAL PRIMARY KEY,
    ranger_name VARCHAR(50) NOT NULL,
    ranger_region VARCHAR(50) NOT NULL
);


CREATE Table species
(
    species_id SERIAL PRIMARY KEY,
    species_common_name VARCHAR(50) NOT NULL,
    species_scientific_name VARCHAR(100) NOT NULL,
    spacies_discovered_date DATE NOT NULL,
    spacies_conservation_status VARCHAR(50) NOT NULL
);



CREATE Table sightings
(
    sighting_id SERIAL PRIMARY KEY,
    ranger_id INT NOT NULL REFERENCES rangers(ranger_id),
    species_id INT NOT NULL REFERENCES species(species_id),
    sighting_location VARCHAR(100) NOT NULL,
    species_time TIMESTAMP NOT NULL,
    sighting_notes TEXT,
    UNIQUE (ranger_id, species_id)
);

-- Sample data for rangers
INSERT INTO rangers (ranger_name, ranger_region) VALUES
('Alice Green', 'Northern Hills'),
('Bob White', 'River Delta'),
('Alice Johnson', 'Mountain Range'),
('Bob Brown', 'West');



--  sample data for species
INSERT INTO species (species_common_name, species_scientific_name, spacies_discovered_date, spacies_conservation_status) VALUES
('Snow Leopard', 'Panthera uncia', '1775-01-01', 'Endangered'),
('Bengal Tiger', 'Panthera tigris tigris', '1758-01-01', 'Endangered'),
('Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable'),
('Asiatic Elephant', 'Elephas maximus indicus', '1758-01-01', 'Endangered');


-- Sample data for sightings
INSERT INTO sightings (ranger_id, species_id, sighting_location, species_time, sighting_notes) VALUES
(1, 1, 'Peak Ridge', '2024-05-10 07:45:00', 'Camera trap image captured'),
(2, 2, 'Bankwood Area', '2024-05-12 16:20:00', 'Juvenile seen'),
(3, 3, 'Bamboo Grove East', '2024-05-15 09:10:00', 'Feeding observed'),
(2, 1, 'Snowfall Pass', '2024-05-18 18:30:00', NULL);

-- Problem 1
INSERT INTO rangers (ranger_name, ranger_region) VALUES ('Derek Fox', 'Coastal Plains');


-- Problem 2
SELECT COUNT(DISTINCT species_id) AS unique_species_count
FROM sightings;


-- Problem 3
SELECT s.sighting_id, s.species_id, r.ranger_id, s.sighting_location, s.species_time, s.sighting_notes
FROM sightings s
JOIN rangers r ON s.ranger_id = r.ranger_id
JOIN species sp ON s.species_id = sp.species_id
WHERE s.sighting_location LIKE '%Pass%';


-- Problem 4
SELECT r.ranger_name, COUNT(s.sighting_id) AS total_sightings
FROM rangers r
LEFT JOIN sightings s ON r.ranger_id = s.ranger_id
GROUP BY r.ranger_name
HAVING COUNT(s.sighting_id) > 0;

-- Problem 5
SELECT sp.species_common_name, sp.species_scientific_name
FROM species sp
LEFT JOIN sightings s ON sp.species_id = s.species_id
WHERE s.sighting_id IS NULL;

-- Problem 6 Show the most recent 2 sightings.
SELECT sp.species_common_name, s.species_time, r.ranger_name
FROM sightings s
JOIN rangers r ON s.ranger_id = r.ranger_id
JOIN species sp ON s.species_id = sp.species_id
ORDER BY s.species_time DESC
LIMIT 2;

-- Problem 7
UPDATE species
SET spacies_conservation_status = 'Historic'
WHERE spacies_discovered_date < '1800-01-01';


-- Problem 8
SELECT s.sighting_id,
       CASE
           WHEN EXTRACT(HOUR FROM s.species_time) < 12 THEN 'Morning'
           WHEN EXTRACT(HOUR FROM s.species_time) >= 12 AND EXTRACT(HOUR FROM s.species_time) < 17 THEN 'Afternoon'
           ELSE 'Evening'
       END AS time_of_day
FROM sightings s
ORDER BY s.species_time;


-- Problem 9
DELETE FROM rangers
WHERE ranger_id NOT IN (SELECT DISTINCT ranger_id FROM sightings);
