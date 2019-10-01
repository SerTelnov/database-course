/* Смена базы данных */
\c university;

/* Добавим группы */
insert into groups 
(id, name)
values
(1, 'M3435'),
(2, 'M3437'),
(3, 'M3439'),
(4, 'M4139');

/* Попробуем обмануть группы */
update groups
set name = null
where id = 1;

/* Добавим оценки */
insert into marks
(id, value)
values
(1, 'A'),
(2, 'B'),
(3, 'C'),
(4, 'D'),
(5, 'E'),
(6, 'F');

/* Добавим преподавателей */
insert into lecturers
(id, first_name, last_name)
values
(1, 'Andrew', 'Stankevich'),
(2, 'George', 'Korneev'),
(3, 'Pavel', 'Mavrin');

 /* Добавим предметы */
insert into subjects
(id, name)
values
(1, 'Algorithms and data structures'),
(2, 'Java technology');

/* Добавим к предметам преподавателей */
insert into lecturers_subjects
(lecturer_id, subject_id)
values
(1, 1),
(3, 1),
(2, 2);

/* Добавим студентов */
insert into students
(id, first_name, last_name, group_id)
values
(1, 'Michael', 'Putilin', 3),
(2, 'Eugene', 'Feder', 3),
(3, 'Nina', 'Zhevtyak', 2),
(4, 'Sergey', 'Telnov', 1);
