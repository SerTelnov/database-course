\c university3;

insert into groups 
(id, name)
values
(1, 'M3435'),
(2, 'M3437'),
(3, 'M3439');
-- (4, 'M4139');

insert into students
(id, name, group_id)
values
(1, 'Michael Putilin', 3),
(2, 'Eugene Feder', 3),
(3, 'Nina Zhevtyak', 2),
(4, 'Sergey Telnov', 1);

insert into courses
(id, name)
values
(1, 'Algorithms and data structures'),
(2, 'Java technology'),
(3, 'Math'),
(4, 'Paradigms'),
(5, 'Algorithms and data structures 2');

insert into lecturers
(id, name)
values
(1, 'Andrew Stankevich'),
(2, 'George Korneev'),
(3, 'Pavel Mavrin');

insert into marks
(value, course_id, student_id)
values
(100, 1, 1),
(40, 2, 1),
(90, 1, 2),
(20, 1, 4),
(40, 3, 4),
(50, 5, 4);

insert into academic_plan
(lecturer_id, course_id, group_id)
values
(3, 1, 1),
(1, 3, 1),
(3, 5, 1),
(1, 1, 3),
(2, 2, 3);
