/* Создание базы данных*/
create database UNIVERSITY3;

/* Смена базы данных */
\c university3;

/* Создание таблиц */
create table groups (
  id int PRIMARY KEY,
  name char(5) NOT NULL
);

create table students (
  id int PRIMARY KEY,
  name varchar(30) NOT NULL,
  group_id int REFERENCES groups (id)
);

create table courses (
    id int PRIMARY KEY,
    name varchar(30) NOT NULL
);

create table lecturers (
  id int PRIMARY KEY,
  name varchar(30) NOT NULL
);

create table marks (
  value int not null,
  course_id int REFERENCES courses (id),
  student_id int REFERENCES students (id)
    on delete cascade,
  PRIMARY KEY (course_id, student_id),
  CHECK (value between 0 and 100)
);

create table academic_plan (
  lecturer_id int REFERENCES lecturers (id),
  course_id int REFERENCES courses (id),
  group_id int REFERENCES groups (id)
    on delete cascade,
  PRIMARY KEY (lecturer_id, course_id, group_id)
);
