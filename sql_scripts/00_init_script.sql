
CREATE TABLE patients (
  id SERIAL PRIMARY KEY,
  citizen_id_number VARCHAR(14) UNIQUE NOT NULL,
  name VARCHAR(50) NOT NULL,
  email VARCHAR(50) NOT NULL,
  birth_date DATE NOT NULL,
  street_address VARCHAR(50) NOT NULL,
  city VARCHAR(50) NOT NULL,
  state VARCHAR(20) NOT NULL
);


CREATE TABLE doctors (
  id SERIAL PRIMARY KEY,
  crm VARCHAR(10) UNIQUE NOT NULL,
  name VARCHAR(50) NOT NULL,
  email VARCHAR(50) NOT NULL,
  state VARCHAR(2) NOT NULL
);


CREATE TABLE exam_types (
  id SERIAL PRIMARY KEY,
  name VARCHAR(15) NOT NULL,
  limits VARCHAR(7) NOT NULL
);


CREATE TABLE exams (
  id SERIAL PRIMARY KEY,
  doctor_id int NOT NULL REFERENCES doctors(id),
  patient_id int NOT NULL REFERENCES patients(id),
  exam_type_id int NOT NULL REFERENCES exam_types(id),
  date DATE NOT NULL,
  result int NOT NULL,
  token_result VARCHAR(6) NOT NULL
);
