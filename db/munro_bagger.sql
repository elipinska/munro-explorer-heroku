DROP TABLE hikes;
DROP TABLE hikers;
DROP TABLE munros;

CREATE TABLE hikers
  (id SERIAL4 PRIMARY KEY,
  first_name VARCHAR(255) NOT NULL,
  last_name VARCHAR(255),
  date_of_birth DATE,
  munro_goal INT
);

CREATE TABLE munros
  (id SERIAL4 PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  region VARCHAR(255),
  altitude INT
);

CREATE TABLE hikes
  (id SERIAL4 PRIMARY KEY,
  hiker_id INT4 REFERENCES hikers(id) ON DELETE CASCADE,
  munro_id INT4 REFERENCES munros(id) ON DELETE CASCADE,
  date DATE NOT NULL
);
