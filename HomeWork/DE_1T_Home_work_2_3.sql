/* 2. ��� ������� ������� ��������� ��������� ��� ������� ��� ���� ������� 
 * � ����������� �� ������� � � ������� ������ ���� ������������� 
 * ��� ������� ������, ��
 * ������ ������ (��������. ������������� ��� IT �����), 
 * ��� ������������ � ���������� �����������. f*/

CREATE TABLE IF NOT EXISTS department (
id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
department_name VARCHAR(50) NOT NULL,
team_lead VARCHAR(50),
number_employees INTEGER
);
-- ��������� ������ ��� � �������
INSERT INTO department (department_name, team_lead, number_employees)
VALUES ('����� ������������', '������� ����� �������������', NULL),
	('����� ������� ���������', '������� ������ ���������', NULL),
	('����� ������������', '������ ������ �����', NULL),
	('����� �����', '���������� ������ ���������', NULL);




/* 1. ������� ������� � �������� ����������� � �����������: 
 * ���, ���� ��������, ���� ������ ������, ���������, 
 * ������� ���������� (jun, middle, senior, lead), 
 * ������� ��������, ������������� ������, 
 * �������/���������� ����(True/False). 
 * ��� ���� � ������� ����������� ������ ���� ���������� ����� ��� ������� ����������.*/

CREATE TABLE IF NOT EXISTS employee (
id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
employee VARCHAR(50), 
date_birth DATE NOT NULL,
empoyee_level VARCHAR(10) NOT NULL, 
start_job_date DATE NOT NULL,
post VARCHAR(30) NOT NULL,
salary_level DECIMAL(8,2),
department_id SMALLINT NOT NULL,
driver_license BOOL NOT NULL,
CONSTRAINT FK_employee_department FOREIGN KEY(department_id)
    REFERENCES department(id)
    ON DELETE CASCADE
);
-- ��������� ������ ��� � �������
INSERT INTO employee (employee, 
	date_birth, 
	empoyee_level, 
	start_job_date, 
	post, 
	salary_level, 
	department_id, 
	driver_license)
VALUES 
	('������ ���� ��������', '1987-03-04', 'middle', '2022-04-22', '�����������', 100, 4, True),
	('������� ����� ���������', '1987-03-04', 'jun', '2022-05-14', '��������', 50, 4, False),
	('���������� ������ ���������', '1931-03-02', 'lead', '2022-02-23', '���������', 300, 4, True),
	--
	('������ ���� ��������', '1981-09-03', 'jun', '2021-02-01', '������� �����������', 50, 1, False),
	('����� ����� ���������', '1990-03-23', 'middle', '2021-03-01', '������� �����������', 100, 1, False),
	('������� ����� �������������', '1879-12-21', 'lead', '2021-01-10', '���������', 300, 3, True),
	--
	('������� ����� ���������', '1987-03-04', 'jun', '2022-05-14', '������� ����������', 50, 2, False),
	('������� ����� ���������', '1987-03-04', 'jun', '2022-05-14', '������� ����������', 50, 2, False),
	('����������� ���� ��������', '1987-05-23', 'middle', '2020-09-12', '������� ����������', 100, 2, True),
	('�������� ����� ����������', '1990-12-13', 'senior', '2020-10-28', '�������', 200, 2, False),
	('������� ������ ���������', '1894-04-17', 'lead', '2020-05-13', '���������', 300, 2, False),
	--
	('����������� ���� ��������', '1987-05-23', 'middle', '2020-09-12', '������� ����������', 100, 3, True),
	('������� ����� ���������', '1973-04-08', 'jun', '2022-01-01', '������� ����������', 100, 3, True),
	('�������� ���� �������������', '1983-08-04', 'senior', '2022-01-01', '�������', 200, 3, True),
	('������ ������ �����', '1896-12-12', 'lead', '2022-01-01', '���������', 300, 3, False);
	

-- ������� � ��������� ���������� ����������� � ������ � ������� department
UPDATE department 
SET number_employees = empl.cnt
FROM (SELECT department_id, COUNT(*) AS cnt FROM employee GROUP BY department_id) AS empl
WHERE id = empl.department_id; 

/*3. �� ���� ����� ���� � ���������� ����������� ����������� ������. 
 * ������ ����� ������������� �� ���������� �������, ������� ���������� �������� � ������ �������� ����. 
 * �������� �������, � ������� ��� ������� ���������� ����� ��� ������ �� ������ �������. 
 * �������� ������ �� A � ����� �������, �� E � ����� ������.*/

CREATE TABLE IF NOT EXISTS bonus (
	id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	employee_id INTEGER,
	YEAR INTEGER NOT NULL, 
	calendar_quarter VARCHAR(5),
	estimation VARCHAR(1),
	CONSTRAINT FK_bonus_employee FOREIGN KEY(employee_id)
    REFERENCES employee(id)
    ON DELETE CASCADE
);
-- ��������� ��� � ��������
INSERT INTO bonus (employee_id, YEAR, calendar_quarter)
SELECT id, 
	(EXTRACT(YEAR FROM current_date)), 
	L AS letter	
FROM
    employee
CROSS JOIN
    (VALUES ('I��'), ('II��'), ('III��'), ('IV��')) b(L);

-- ��������� ������ ��� ������ ������
UPDATE bonus
SET estimation = (array['A', 'B', 'C', 'D', 'E']) [floor(random() * 5 + 1)]
WHERE estimation IS NULL;

/*5. ���� ������� ����������� � ����������� ������������� ������� ����� ����� � ����� ����������������� ������� ������. 
 * �� ��������� ����� � ������� ������ ������ ������������ ������ � ���� �����������. 
 * �������� ����������� ���������� � ��������������� �������.*/

-- ��������� ������ � ����� ������ '����������������� ������� ������' � ������� department
INSERT INTO department (department_name, team_lead)
VALUES 
	('����������������� ������� ������', '��������� ���� ����������');

-- ��������� ������ � employees
INSERT INTO employee (employee, 
	date_birth, 
	empoyee_level, 
	start_job_date, 
	post, 
	salary_level, 
	department_id, 
	driver_license)
VALUES 
	('�������� ���� ����������', '1982-03-04', 'jun', '2022-10-08', '��������', 50, 5, True),
	('��������� ��������� ��������', '1983-03-04', 'middle', '2022-10-08', '������� ��������', 100, 5, True),
	('��������� ���� ����������', '1931-03-02', 'lead', '2022-10-08', '���������', 300, 5, False);

-- ��������� ���������� ����������� � ������ � ������� department
UPDATE department 
SET number_employees = empl.cnt
FROM (SELECT department_id, COUNT(*) AS cnt FROM employee GROUP BY department_id) AS empl
WHERE id = empl.department_id; 

-- ��������� ������ � bonus
---- ��������� ��� � ��������
INSERT INTO bonus (employee_id, YEAR, calendar_quarter)
SELECT id, 
	(EXTRACT(YEAR FROM current_date)), 
	L AS letter	
FROM
    employee
CROSS JOIN
    (VALUES ('I��'), ('II��'), ('III��'), ('IV��')) b(L)
WHERE id NOT IN (SELECT DISTINCT employee_id FROM bonus) ;

--- ��������� ������ ��� ������ ������
UPDATE bonus
SET estimation = (array['A', 'B', 'C', 'D', 'E']) [floor(random() * 5 + 1)]
WHERE estimation IS NULL;

/*6. ������ ������ ���� ������������� ���� ������ � 
 * �������� ������� ��� ��������� ��������� ����������:*/
-- ���������� ����� ����������, ��� ��� � ���� ������ � ��� ���� ����������� ��������

SELECT id AS "���������� ����� ����������", employee AS "���", 
	date_part('year', age(current_date, start_job_date ))::float AS "����" 
FROM employee;

--   ���������� ����� ����������, ��� ��� � ���� ������ � ������ ������ 3-� �����������
SELECT id AS "���������� ����� ����������", employee AS "���", 
	date_part('year', age(current_date, start_job_date ))::float AS "����" 
FROM employee
ORDER BY start_job_date
LIMIT 3;

--   ���������� ����� ����������� - ���������
SELECT id AS "���������� ����� ����������", employee AS "���", 
	date_part('year', age(current_date, start_job_date ))::float AS "����" 
FROM employee
WHERE driver_license = True;

--   �������� ������ �����������, ������� ���� �� �� 1 ������� �������� ������ D ��� E
SELECT * 
FROM bonus
WHERE estimation IN ('D', 'E')
AND calendar_quarter = 'I��';

--   �������� ����� ������� �������� � ��������.
SELECT MAX(salary_level)
FROM employee;

--   * �������� �������� ������ �������� ������
SELECT department_name
FROM department
ORDER BY number_employees DESC
LIMIT 1;

--   * �������� ������ ����������� �� ����� ������� �� ����� ���������
SELECT employee, empoyee_level
FROM employee
ORDER BY start_job_date ASC;

--   * ����������� ������� �������� ��� ������� ������ �����������
SELECT empoyee_level, AVG(salary_level)
FROM employee
GROUP BY empoyee_level;

--   * �������� ������� � ����������� � ������������ ������� ������ � �������� �������. 
      -- ����������� �������������� �� ����� �����: ������� �������� ������������ � 1, 
      -- ������ ������ ��������� �� ����������� ���:
--         � � ����� 20%
--         D � ����� 10%
--         � � ��� ���������
--         B � ���� 10%
--         A � ���� 20%
ALTER TABLE bonus ADD COLUMN koeff decimal (5, 4) NOT NULL DEFAULT 1;
ALTER TABLE bonus ADD COLUMN final_koeff decimal (5, 4) ;

-- ������ �������� ������������ ��� ������ ������
UPDATE bonus
SET koeff = CASE 
 WHEN estimation = 'E' THEN koeff*0.8
 WHEN estimation = 'D' THEN koeff*0.9
 WHEN estimation = '�' THEN koeff*1
 WHEN estimation = 'B' THEN koeff*1.1
 WHEN estimation = 'A' THEN koeff*1.2
 ELSE koeff
END;

-- ������ ������� �������� ����������� ��� ��������� ������ �� ��� ������ 
UPDATE bonus
SET final_koeff = round(fk.final_koeff, 2)
FROM (SELECT employee_id ,
	AVG(koeff) OVER (PARTITION BY employee_id) AS final_koeff
	FROM bonus) AS fk
WHERE bonus.employee_id = fk.employee_id;




