/********************************************    ДЗ 2.3 (ДЗ 2.4 далее) ***********************************************************************************************************/

/* 2. Для будущих отчетов аналитики попросили вас создать еще одну таблицу 
 * с информацией по отделам – в таблице должен быть идентификатор 
 * для каждого отдела, на
 * звание отдела (например. Бухгалтерский или IT отдел), 
 * ФИО руководителя и количество сотрудников. a*/

CREATE TABLE IF NOT EXISTS department (
id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
department_name VARCHAR(50) NOT NULL,
team_lead VARCHAR(50),
number_employees INTEGER
);
-- Вставляем данные все в таблицу
INSERT INTO department (department_name, team_lead, number_employees)
VALUES ('Отдел безопасности', 'Строгов Иосиф Виссарионович', NULL),
	('Отдел внешних отношений', 'Кузькин Никита Сергеевич', NULL),
	('Отдел премирования', 'Бровин Леонид Ильич', NULL),
	('Отдел ПОиИТ', 'Пятилеткин Михаил Сергеевич', NULL);

/* 1. Создать таблицу с основной информацией о сотрудниках: 
 * ФИО, дата рождения, дата начала работы, должность, 
 * уровень сотрудника (jun, middle, senior, lead), 
 * уровень зарплаты, идентификатор отдела, 
 * наличие/отсутствие прав(True/False). 
 * При этом в таблице обязательно должен быть уникальный номер для каждого сотрудника.*/

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
-- Вставляем данные все в таблицу
INSERT INTO employee (employee, 
	date_birth, 
	empoyee_level, 
	start_job_date, 
	post, 
	salary_level, 
	department_id, 
	driver_license)
VALUES 
	('Петров Петр Петрович', '1981-09-03', 'jun', '2021-02-01', 'младший программист', 50, 1, False),
	('Орлов Роман Романович', '1990-03-23', 'middle', '2021-03-01', 'старший программист', 100, 1, False),
	('Строгов Иосиф Виссарионович', '1879-12-21', 'lead', '2021-01-10', 'начальник', 1000, 1, True),
	--
	('Галкина Софья Никитична', '1987-03-04', 'jun', '2022-05-14', 'младший специалист', 50, 2, False),
	('Сидоров Сидор Сидорович', '1987-03-04', 'jun', '2022-05-14', 'младший специалист', 50, 2, False),
	('Воробушкина Нина Павловна', '1987-05-23', 'middle', '2020-09-12', 'старший специалист', 100, 2, True),
	('Стрижова Ирина Генадиевна', '1990-12-13', 'senior', '2020-10-28', 'эксперт', 200, 2, False),
	('Кузькин Никита Сергеевич', '1894-04-17', 'lead', '2020-05-13', 'начальник', 300, 2, False),
	--
	('Воробушкина Нина Павловна', '1987-05-23', 'middle', '2015-09-12', 'старший специалист', 100, 3, True),
	('Семенов Семен Семенович', '1973-04-08', 'jun', '2022-01-16', 'младший специалист', 100, 3, True),
	('Церители Петр Александрович', '1983-08-04', 'senior', '2018-01-01', 'эксперт', 200, 3, True),
	('Бровин Леонид Ильич', '1896-12-12', 'lead', '2010-01-01', 'начальник', 300, 3, False),
	--
	('Иванов Иван Иванович', '1987-03-04', 'middle', '2022-04-22', 'программист', 100, 4, True),
	('Сидоров Сидор Сидорович', '1987-03-04', 'jun', '2022-05-14', 'аналитик', 50, 4, False),
	('Пятилеткин Михаил Сергеевич', '1931-03-02', 'lead', '2022-02-23', 'начальник', 300, 4, True);
	

-- Считаем и вставляем количество сотрудников в отделе в таблицу department
UPDATE department 
SET number_employees = empl.cnt
FROM (SELECT department_id, COUNT(*) AS cnt FROM employee GROUP BY department_id) AS empl
WHERE id = empl.department_id; 

/*3. На кону конец года и необходимо выплачивать сотрудникам премию. 
 * Премия будет выплачиваться по совокупным оценкам, которые сотрудники получают в каждом квартале года. 
 * Создайте таблицу, в которой для каждого сотрудника будут его оценки за каждый квартал. 
 * Диапазон оценок от A – самая высокая, до E – самая низкая.*/

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
-- Вставляем год и кварталы
INSERT INTO bonus (employee_id, YEAR, calendar_quarter)
SELECT id, 
	(EXTRACT(YEAR FROM current_date)), 
	L AS letter	
FROM
    employee
CROSS JOIN
    (VALUES ('Iкв'), ('IIкв'), ('IIIкв'), ('IVкв')) b(L);

-- Вставляем оценку для оплаты бонуса
UPDATE bonus
SET estimation = (array['A', 'B', 'C', 'D', 'E']) [floor(random() * 5 + 1)]
WHERE estimation IS NULL;

/*5. Ваша команда расширяется и руководство запланировало открыть новый отдел – отдел Интеллектуального анализа данных. 
 * На начальном этапе в команду наняли одного руководителя отдела и двух сотрудников. 
 * Добавьте необходимую информацию в соответствующие таблицы.*/

-- Вставляем данные о новом отделе 'Интеллектуального анализа данных' в таблицу department
INSERT INTO department (department_name, team_lead)
VALUES 
	('Интеллектуального анализа данных', 'Татарский Иван Васильевич');

-- Вставляем данные в employees
INSERT INTO employee (employee, 
	date_birth, 
	empoyee_level, 
	start_job_date, 
	post, 
	salary_level, 
	department_id, 
	driver_license)
VALUES 
	('Синицина Алла Николаевна', '1982-03-04', 'jun', '2022-10-08', 'аналитик', 50, 5, True),
	('Курочкина Проскофья Ивановна', '1983-03-04', 'middle', '2022-10-08', 'старшой аналитик', 100, 5, True),
	('Татарский Иван Васильевич', '1931-03-02', 'lead', '2022-10-08', 'начальник', 300, 5, False);

-- Обновляем количество сотрудников в отделе в таблице department
UPDATE department 
SET number_employees = empl.cnt
FROM (SELECT department_id, COUNT(*) AS cnt FROM employee GROUP BY department_id) AS empl
WHERE id = empl.department_id; 

-- Вставляем данные в bonus
---- Вставляем год и кварталы
INSERT INTO bonus (employee_id, YEAR, calendar_quarter)
SELECT id, 
	(EXTRACT(YEAR FROM current_date)), 
	L AS letter	
FROM
    employee
CROSS JOIN
    (VALUES ('Iкв'), ('IIкв'), ('IIIкв'), ('IVкв')) b(L)
WHERE id NOT IN (SELECT DISTINCT employee_id FROM bonus) ;

--- Вставляем оценку для оплаты бонуса
UPDATE bonus
SET estimation = (array['A', 'B', 'C', 'D', 'E']) [floor(random() * 5 + 1)]
WHERE estimation IS NULL;

/*6. Теперь пришла пора анализировать наши данные – 
 * напишите запросы для получения следующей информации:*/
-- Уникальный номер сотрудника, его ФИО и стаж работы – для всех сотрудников компании

SELECT id AS "Уникальный номер сотрудника", employee AS "ФИО", 
	date_part('year', age(current_date, start_job_date ))::float AS "стаж" 
FROM employee;

--   Уникальный номер сотрудника, его ФИО и стаж работы – только первых 3-х сотрудников
SELECT id AS "Уникальный номер сотрудника", employee AS "ФИО", 
	date_part('year', age(current_date, start_job_date ))::float AS "стаж" 
FROM employee
ORDER BY start_job_date
LIMIT 3;

--   Уникальный номер сотрудников - водителей
SELECT id AS "Уникальный номер сотрудника", employee AS "ФИО", 
	date_part('year', age(current_date, start_job_date ))::float AS "стаж" 
FROM employee
WHERE driver_license = True;

--   Выведите номера сотрудников, которые хотя бы за 1 квартал получили оценку D или E
SELECT * 
FROM bonus
WHERE estimation IN ('D', 'E')
AND calendar_quarter = 'Iкв';

--   Выведите самую высокую зарплату в компании.
SELECT MAX(salary_level)
FROM employee;

--   * Выведите название самого крупного отдела
SELECT department_name
FROM department
ORDER BY number_employees DESC
LIMIT 1;

--   * Выведите номера сотрудников от самых опытных до вновь прибывших
SELECT employee, empoyee_level
FROM employee
ORDER BY start_job_date ASC;

--   * Рассчитайте среднюю зарплату для каждого уровня сотрудников
SELECT empoyee_level, AVG(salary_level)
FROM employee
GROUP BY empoyee_level;

--   * Добавьте столбец с информацией о коэффициенте годовой премии к основной таблице. 
      -- Коэффициент рассчитывается по такой схеме: базовое значение коэффициента – 1, 
      -- каждая оценка действует на коэффициент так:
--         Е – минус 20%
--         D – минус 10%
--         С – без изменений
--         B – плюс 10%
--         A – плюс 20%

ALTER TABLE bonus ADD COLUMN IF NOT EXISTS koeff decimal (5, 4) NOT NULL DEFAULT 1;
ALTER TABLE bonus ADD COLUMN IF NOT EXISTS final_koeff decimal (5, 4) ;

-- Сперва получаем коэффициенты для каждой оценки
UPDATE bonus
SET koeff = CASE 
			 WHEN estimation = 'E' THEN koeff*0.8
			 WHEN estimation = 'D' THEN koeff*0.9
			 WHEN estimation = 'С' THEN koeff*1
			 WHEN estimation = 'B' THEN koeff*1.1
			 WHEN estimation = 'A' THEN koeff*1.2
			 ELSE koeff
			END;

-- Теперь считаем итоговый коэффициент для работника исходя из его оценок 
UPDATE bonus
SET final_koeff = round(fk.final_koeff, 2)
FROM (SELECT employee_id ,
	AVG(koeff) OVER (PARTITION BY employee_id) AS final_koeff
	FROM bonus) AS fk
WHERE bonus.employee_id = fk.employee_id;


/********************************************    ДЗ 2.4  ***********************************************************************************************************/

/* 2.a.     Попробуйте вывести не просто самую высокую зарплату во всей команде, 
 * а вывести именно фамилию сотрудника с самой высокой зарплатой*/

SELECT employee AS "ФИО сотрудника с самой высокой ЗП" , salary_level AS "ЗП" 
FROM employee
ORDER BY salary_level DESC
LIMIT 1;

/* 2.a.     Попробуйте вывести фамилии сотрудников в алфавитном порядке */

SELECT substring(employee, 1, position(' ' in employee)) AS "Фамилии сотрудников" 
FROM employee
ORDER BY substring(employee, 1, position(' ' in employee)) ; 

/* 2.c.     Рассчитайте средний стаж для каждого уровня сотрудников */

SELECT empoyee_level, AVG((DATE_PART('year', current_date::date) - DATE_PART('year', start_job_date::date)) * 12 +
              (DATE_PART('month', current_date::date) - DATE_PART('month', start_job_date::date))) AS "Средний стаж, месяцов" 
FROM employee
GROUP BY empoyee_level;

/* 2.d.     Выведите фамилию сотрудника и название отдела, в котором он работает */

SELECT
	substring(e.employee, 1, POSITION(' ' IN e.employee)) AS "ФИО"
	,
	d.department_name AS "Название отдела"
FROM
	employee AS e
LEFT JOIN department AS d ON
	e.department_id = d.id
ORDER BY
	substring(e.employee, 1, POSITION(' ' IN e.employee)) ;

/* 2.e.     Выведите название отдела и фамилию сотрудника с самой 
 * высокой зарплатой в данном отделе и саму зарплату также. */

SELECT d2.department_name AS "Название отдела",
	e1.employee, 
	d2.salary_level	AS "ЗП"
FROM employee AS e1
INNER JOIN (SELECT d.id, d.department_name,
			MAX(salary_level) AS salary_level
			FROM employee AS e 
			LEFT JOIN department AS d ON
				e.department_id = d.id
			GROUP BY d.id, d.department_name
			ORDER BY d.department_name,
				MAX(salary_level) DESC) AS d2 
		ON e1.department_id = d2.id 
		AND e1.salary_level = d2.salary_level;


/* 2. f.      *Выведите название отдела, сотрудники которого получат наибольшую премию по итогам года. 
 * Как рассчитать премию можно узнать в последнем задании предыдущей домашней работы */

WITH 
	koef AS (SELECT employee_id, final_koeff 
			FROM bonus
			GROUP BY employee_id, final_koeff 
			ORDER BY employee_id),
	emp AS (SELECT id, employee, salary_level, department_id 
			FROM employee e),
	dep AS (SELECT id, department_name
			FROM department),
	final_salary AS (SELECT department_name,
					salary_level * final_koeff AS finall_salary
					FROM emp
					LEFT JOIN dep ON emp.department_id = dep.id
					LEFT JOIN koef ON emp.id = koef.employee_id)
SELECT department_name, SUM(finall_salary)
FROM final_salary
GROUP BY department_name
ORDER BY SUM(finall_salary) DESC
LIMIT 1;


/* 2. g.    *Проиндексируйте зарплаты сотрудников с учетом коэффициента премии. 
 * Для сотрудников с коэффициентом премии больше 1.2 – размер индексации составит 20%, 
 * для сотрудников с коэффициентом премии от 1 до 1.2 размер индексации составит 10%. 
 * Для всех остальных сотрудников индексация не предусмотрена. */

ALTER TABLE employee ADD COLUMN IF NOT EXISTS indexed_salary_level DECIMAL(8,2) DEFAULT 0;
ALTER TABLE employee ADD COLUMN IF NOT EXISTS bonus DECIMAL(8,2) DEFAULT 0;

WITH 
	koef AS (SELECT employee_id, final_koeff 
			FROM bonus
			GROUP BY employee_id, final_koeff 
			ORDER BY employee_id)
UPDATE employee
SET indexed_salary_level =  CASE 
							    WHEN koef.final_koeff >= 1.2 THEN salary_level*1.2
							    WHEN 1.1 <= koef.final_koeff AND koef.final_koeff <= 1.2 THEN salary_level * 1.1
						    	ELSE salary_level
					    	END,
	bonus =  salary_level * final_koeff - final_koeff
FROM koef
WHERE employee.id = koef.employee_id;


/* 2. h.    ***По итогам индексации отдел финансов хочет получить следующий отчет: 
вам необходимо на уровень каждого отдела вывести следующую информацию: */
-- i.     Название отдела
-- ii.     Фамилию руководителя
-- iii.     Количество сотрудников
-- iv.     Средний стаж
-- v.     Средний уровень зарплаты

SELECT department_id,
	AVG(age(DATE_TRUNC('month', current_date), DATE_TRUNC('month',start_job_date))) AS "Средний стаж",
	ROUND(AVG(salary_level), 2) AS "Средний уровень ЗП",
FROM employee e 
GROUP BY department_id);

-- vi.     Количество сотрудников уровня junior
-- vii.     Количество сотрудников уровня middle
-- viii.     Количество сотрудников уровня senior
-- ix.     Количество сотрудников уровня lead
-- x.     Общий размер оплаты труда всех сотрудников до индексации
-- xi.     Общий размер оплаты труда всех сотрудников после индексации

SELECT department_id, 
	 COUNT(CASE WHEN empoyee_level = 'jun' THEN 1 ELSE NULL END) AS "Количество jun",
	 COUNT(CASE WHEN empoyee_level = 'middle' THEN 1 ELSE NULL END) AS "Количество middle",
	 COUNT(CASE WHEN empoyee_level = 'senior' THEN 1 ELSE NULL END) AS "Количество senior",
	 COUNT(CASE WHEN empoyee_level = 'lead' THEN 1 ELSE NULL END) AS "Количество lead",
	 SUM(salary_level) AS "ЗП до индексации",
	 SUM(indexed_salary_level) AS "ЗП после индексации"
FROM employee
GROUP BY department_id;

-- xii.     Общее количество оценок А
-- xiii.     Общее количество оценок B
-- xiv.     Общее количество оценок C
-- xv.     Общее количество оценок D
-- xvi.     Общее количество оценок Е
-- xvii.     Средний показатель коэффициента премии
-- xviii.     Общий размер премии.
-- xix.     Общую сумму зарплат(+ премии) до индексации
-- xx.     Общую сумму зарплат(+ премии) после индексации(премии не индексируются)
-- xxi.     Разницу в % между предыдущими двумя суммами(первая/вторая)

SELECT e.department_id,
	COUNT(CASE WHEN b.estimation = 'A' THEN 1 ELSE NULL END) AS "Количество оценок A",
	COUNT(CASE WHEN b.estimation = 'B' THEN 1 ELSE NULL END) AS "Количество оценок B",
	COUNT(CASE WHEN b.estimation = 'C' THEN 1 ELSE NULL END) AS "Количество оценок C",
	COUNT(CASE WHEN b.estimation = 'D' THEN 1 ELSE NULL END) AS "Количество оценок D",
	COUNT(CASE WHEN b.estimation = 'E' THEN 1 ELSE NULL END) AS "Количество оценок E",
	AVG(final_koeff) AS "Средний показатель коэффициента премии",
	SUM(e.bonus)/4 AS "Общий размер премии",
	SUM(e.salary_level + e.bonus)/4 AS "Общую сумму ЗП(+ премии) до индексации",
	SUM(e.indexed_salary_level + e.bonus)/4 AS "Общую сумму ЗП(+ премии) после индексации",
	ROUND((SUM(e.salary_level + e.bonus)/4 - SUM(e.indexed_salary_level + e.bonus)/4)/(SUM(e.indexed_salary_level + e.bonus)/4)*100, 1)
			AS "Разница в % между предыдущими двумя суммами(первая/вторая)"
FROM bonus b
LEFT JOIN employee AS e ON b.employee_id = e.id
GROUP BY e.department_id;





























