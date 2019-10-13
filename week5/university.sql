/* Создание базы данных*/
create database UNIVERSITY2;

/* Смена базы данных */
\c university2;

/* Создание таблиц */
create table groups (
  groupId int PRIMARY KEY,
  groupName char(5) NOT NULL
);

create table students (
  studentId int PRIMARY KEY,
  studentName varchar(30),
  groupId int REFERENCES groups (groupId)
);

create courses (
    courseId int PRIMARY KEY,
    courseName varchar(30)
);

create table lecturers (
  lecturerId int PRIMARY KEY,
  lecturerName varchar(30)
);

create table plan (
    groupId int REFERENCES groups (groupId),
    courseId int REFERENCES course (courseId),
    lecturerId int REFERENCES lecturers (lecturerId)
);

create table marks (
    studentId int REFERENCES students (studentId),
    courseId int REFERENCES courses (courseId),
    mark char(1)
);
