DROP TABLE IF EXISTS people;
CREATE TABLE IF NOT EXISTS people(
	name VARCHAR,
	gender VARCHAR,
	age INT
);

INSERT INTO people (name, gender, age)
VALUES 
	('Mia', 'F', 23),
	('Amy', 'F', 35),
	('Mark', 'M', 25),
	('Charles', 'M', 71),
	('Joe', 'M', 15);

CREATE TABLE IF NOT EXISTS audit (
	id SERIAL PRIMARY KEY,
	user_name TEXT, 
	event_time TIMESTAMPTZ,
	table_name TEXT, 
	operation TEXT,
	old_values JSON,
	new_values JSON
);

CREATE OR REPLACE FUNCTION audit_function() RETURNS TRIGGER AS
$$
DECLARE
	old_row JSON := NULL;
	new_row JSON := NULL;

BEGIN
	IF TG_OP in ('UPDATE', 'DELETE') THEN
		old_row = row_to_json(OLD);
	END IF;
	IF TG_OP in ('UPDATE', 'INSERT') THEN
		new_row = row_to_json(NEW);
	END IF;
	
	INSERT INTO audit(
		user_name,
		event_time,
		table_name,
		operation,
		old_values,
		new_values
	)
	VALUES 
		(
			session_user,
			current_timestamp AT TIME ZONE 'UTC',
			CONCAT(TG_TABLE_SCHEMA, '-', TG_TABLE_NAME),
			TG_OP,
			old_row,
			new_row
		);
	RETURN NEW;

END
$$ language 'plpgsql';

CREATE OR REPLACE TRIGGER audit_trigger
AFTER INSERT OR UPDATE OR DELETE
ON people
FOR EACH ROW
EXECUTE PROCEDURE audit_function();

INSERT INTO people (name, gender, age)
VALUES 
	('Hans', 'M', '45'); 
UPDATE people SET name = 'Billy Bob' WHERE NAME = 'Hans';
DELETE FROM people WHERE name = 'Billy Bob';
UPDATE people SET age = 14 where name = 'Joe';
UPDATE people SET age = 15 where name = 'Joe';

SELECT * FROM audit;