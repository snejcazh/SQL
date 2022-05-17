drop table roles_employee;
drop table employees;
drop table roles;
drop table employee_salary;
drop table salary;


--Таблица employees
--
--Создать таблицу employees
--- id. serial,  primary key,
--- employee_name. Varchar(50), not null

create table employees(
	id serial primary key,
	employee_name varchar(50) not null
);
	
--Наполнить таблицу employee 70 строками.

do
$$
begin
	for i in 1..70 loop
		insert into employees (employee_name) 
			values ('employee_' || i);
	end loop;
end
$$;

select * from employees 

--Таблица salary
--
--Создать таблицу salary
--- id. Serial  primary key,
--- monthly_salary. Int, not null

create table salary(
	id serial primary key,
	monthly_salary int not null 
);

--Наполнить таблицу salary 15 строками:
--- 1000
--- 1100
--- 1200
--- 1300
--- 1400
--- 1500
--- 1600
--- 1700
--- 1800
--- 1900
--- 2000
--- 2100
--- 2200
--- 2300
--- 2400
--- 2500

do
$$ 
begin 
	for i in 1000..2500 by 100 loop 
		insert into salary (monthly_salary)
		values (i);
	end loop;
end
$$;

select * from salary;

--Таблица employee_salary
--
--Создать таблицу employee_salary
--- id. Serial  primary key,
--- employee_id. Int, not null, unique
--- salary_id. Int, not null

create table employee_salary(
	id serial primary key,
	employee_id int not null unique,
	salary_id int not null 
);

--Наполнить таблицу employee_salary 40 строками:
--- в 10 строк из 40 вставить несуществующие employee_id
do 
$$ 
begin 
	-- заполняем существующими id
	for i in 1..30 loop 
	insert into employee_salary (employee_id, salary_id)
	values 
		((select id from employees  
			where id not in (select employee_id from employee_salary)
			order by random()
			limit 1), 
		(select id from salary order by random() limit 1));
	end loop;
	-- заполняем несуществующими id
	for j in 101..110 loop 
	insert into employee_salary (employee_id, salary_id)
	values 
		((select max(id) from (select id from employees 
			union all select employee_id from employee_salary) as emp) + 1, 
		 (select id from salary order by random() limit 1));
	end loop;
end
$$;

select * from employee_salary;

--Таблица roles
--
--Создать таблицу roles
--- id. Serial  primary key,
--- role_name. int, not null, unique

create table roles(
	id serial primary key,
	role_name int not null unique
);

--Поменять тип столба role_name с int на varchar(30)

alter table roles
alter column role_name type varchar(30);

--Наполнить таблицу roles 20 строками

insert into roles (role_name)
values ('Junior Python developer'),
		('Middle Python developer'),
		('Senior Python developer'),
		('Junior Java developer'),
		('Middle Java developer'),
		('Senior Java developer'),
		('Junior JavaScript developer'),
		('Middle JavaScript developer'),
		('Senior JavaScript developer'),
		('Junior Manual QA engineer'),
		('Middle Manual QA engineer'),
		('Senior Manual QA engineer'),
		('Project Manager'),
		('Designer'),
		('HR'),
		('CEO'),
		('Sales manager'),
		('Junior Automation QA engineer'),
		('Middle Automation QA engineer'),
		('Senior Automation QA engineer')
;

select * from roles;

--Таблица roles_employee
--
--Создать таблицу roles_employee
--- id. Serial  primary key,
--- employee_id. Int, not null, unique (внешний ключ для таблицы employees, поле id)
--- role_id. Int, not null (внешний ключ для таблицы roles, поле id)

create table roles_employee(
	id serial primary key,
	employee_id int not null unique references employees (id),
	role_id int not null references roles (id)
);

--Наполнить таблицу roles_employee 40 строками

do 
$$
begin 
	for i in 1..40 loop 
		insert into roles_employee (employee_id, role_id)
		values 
		        ((select id from employees
					where id not in (select employee_id from roles_employee)
					order by random() limit 1),
				(select id from roles order by random() limit 1));
	end loop;
end
$$

select * from roles_employee;
