DROP TABLE IF EXISTS students cascade;
DROP TABLE IF EXISTS teachers cascade;
DROP TABLE IF EXISTS courses cascade;

CREATE TABLE IF NOT EXISTS students (
	studentid SERIAL PRIMARY KEY,
	name VARCHAR(20), 
	date_of_birth VARCHAR(10),
	address VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS teachers (
	teacherid SERIAL PRIMARY KEY CHECK(teacherid <= 10),
	teachername VARCHAR(10)
);

CREATE TABLE IF NOT EXISTS courses (
	scoreid SERIAL PRIMARY KEY,
	studentid INT REFERENCES students(studentid),
	course VARCHAR(25),
	score INT CHECK (score BETWEEN 0 AND 100),
	teacherid INT REFERENCES teachers(teacherid)
);

INSERT INTO students (name, date_of_birth, address)
VALUES
	('Harry', '03/05/1990', '4 Privet Drive Surrey'),
	('Hermoine', '04/13/1990', '8 Heathgate Hampstead Garden Suburb London'),
	('Ron', '09/10/1990', 'The Burrow Ottery St Catchpole');

INSERT INTO teachers (teachername)
VALUES 
	('Snape'),
	('Trelawney'),
	('Dumbeldore'),
	('McGonagall');

INSERT INTO courses (studentid, course, score, teacherid)
VALUES
	(1, 'Transfiguration', 98, 4),
	(1, 'Defense Dark Arts', 90, 3),
	(1, 'Potions', 70, 1),
	(2, 'Transfiguration', 98, 1),
	(2, 'Defense Dark Arts', 90, 2),
	(2, 'Potions', 70, 3),
	(3, 'Transfiguration', 98, 3),
	(3, 'Defense Dark Arts', 90, 2),
	(3, 'Potions', 70, 1);
	
UPDATE courses 
SET teacherid=4 
WHERE course = 'Transfiguration';

UPDATE courses 
SET teacherid=1 
WHERE course = 'Potions';

UPDATE courses 
SET teacherid=3 
WHERE course = 'Defense Dark Arts';

SELECT 
	students.name AS student_name,
	courses.course,
	courses.score,
	teachers.teachername AS teacher_name
FROM 
	courses INNER JOIN teachers 
		ON courses.teacherid = teachers.teacherid
	INNER JOIN students
		ON students.studentid = courses.studentid;