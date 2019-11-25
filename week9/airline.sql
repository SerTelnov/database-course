create database Airline2;

\c airline2;

create table planes (
  id int PRIMARY KEY
);

create table seats (
  seat_no int PRIMARY KEY,
  plane_id int REFERENCES planes (id)
);

create table flights (
  id int PRIMARY KEY,
  flight_time timestamp not null,
  plane_id int REFERENCES planes (id)
);

create table users (
  id int PRIMARY KEY,
  password varchar(20)
);

create table booking (
  user_id int REFERENCES users (id),
  booking_status boolean not null, -- isBought flag
  seat_no int REFERENCES seats (seat_no),
  flight_id int REFERENCES flights (id),
  reserved_time timestamp,
  CONSTRAINT tickets_unique UNIQUE (seat_no, flight_id)
);
