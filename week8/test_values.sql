\c airline;

insert into planes
(id)
values
(1),
(2);

insert into seats 
(seatNo, plane_id)
values
('123 A', 1),
('123 B', 1),
('123 C', 1);

insert into flights 
(id, flight_time, plane_id)
values
(1, TO_TIMESTAMP('2019-10-11 02:30','YYYY-MM-DD HH:MI'), 1),
(2, TO_TIMESTAMP('2019-10-25 02:30','YYYY-MM-DD HH:MI'), 1);

insert into tickets
(id, status, seatNo, flight_id, reserved_time)
values
(2, 'booked', '123 A', 1, TO_TIMESTAMP('2019-10-10 12:30','YYYY-MM-DD HH:MI'))