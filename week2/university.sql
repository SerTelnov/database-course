/* Создание базы данных*/
create database UNIVERSITY;

/* Смена базы данных */
\c university;

/* Создание таблиц */
create table groups (
  id int PRIMARY KEY,
  name char(5) NOT NULL
);

create table students (
  id int PRIMARY KEY,
  first_name varchar(15) NOT NULL,
  last_name varchar(15) NOT NULL,
  group_id int REFERENCES groups (id)
);

create table lecturers (
  id int PRIMARY KEY,
  first_name varchar(15) NOT NULL,
  last_name varchar(15) NOT NULL
);

create table subjects (
  id int PRIMARY KEY,
  name varchar(40) NOT NULL
);

create table lecturers_subjects (
  lecturer_id int REFERENCES lecturers (id),
  subject_id int REFERENCES subjects (id),
  PRIMARY KEY (lecturer_id, subject_id)
);

create table marks (
  id int PRIMARY KEY,
  value char(1) NOT NULL
);

create table academic_progress (
  student_id int REFERENCES students (id),
  subject_id int REFERENCES subjects (id),
  mark_id int REFERENCES marks (id),
  PRIMARY KEY (student_id, subject_id, mark_id)
);
