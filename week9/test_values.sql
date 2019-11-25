\c airline2;

insert into planes
(id)
values
(1),
(2);

insert into seats 
(seat_no, plane_id)
values
(1, 1),
(2, 1),
(3, 1);

insert into flights 
(id, flight_time, plane_id)
values
(1, TO_TIMESTAMP('2019-10-11 02:30','YYYY-MM-DD HH:MI'), 1),
(2, TO_TIMESTAMP('2019-10-25 02:30','YYYY-MM-DD HH:MI'), 1);

insert into users
(id, password)
VALUES
(1, 'qwerty'),
(2, '12345');

insert into booking
(user_id, booking_status, seat_no, flight_id, reserved_time)
values
(1, true, 1, 1, TO_TIMESTAMP('2019-10-10 12:30','YYYY-MM-DD HH:MI')),
(1, false, 2, 1, '2019-11-24 21:18:14.206417');
