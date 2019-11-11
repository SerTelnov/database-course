create database Airline;

\c airline;

create table planes (
  id int PRIMARY KEY
);

create table seats (
  seatNo varchar(5) PRIMARY KEY,
  plane_id int REFERENCES planes (id)
);

create table flights (
  id int PRIMARY KEY,
  flight_time timestamp not null,
  plane_id int REFERENCES planes (id)
);

create type ticket_status as enum ('booked', 'bought', 'unavailable');

create table tickets (
  id int PRIMARY KEY,
  status ticket_status not null,
  seatNo varchar(5) REFERENCES seats (seatNo),
  flight_id int REFERENCES flights (id),
  reserved_time timestamp,
  CONSTRAINT tickets_unique UNIQUE (seatNo, flight_id)
);

create function limit_time_check()
  returns trigger as 
  $$
    DECLARE
      curr_flight_time timestamp;
    begin
      curr_flight_time := (select flight_time from flights where flights.id = NEW.id);
      if NEW.status = 'booked' then
        if NEW.reserved_time > (curr_flight_time - interval '1 day') then
          RAISE EXCEPTION 'cannot booking seats later than one day before flight';
        end if;
      elsif NEW.status = 'bought' then
        if NEW.reserved_time > (curr_flight_time - interval '2 hour') then
          RAISE EXCEPTION 'cannot buy tickets later than one day before flight';
        end if;
      end if;
      return NEW;
    end;
  $$ language plpgsql;

create trigger limit_time_trigger
before update or insert on tickets
for each row execute procedure limit_time_check();

create function booking_timeout()
  returns trigger as
  $$
    DECLARE
     curr_reserved_time timestamp;
    begin
      if NEW.status = 'booked' then
        curr_reserved_time := (select reserved_time from tickets where id = NEW.id);
        if curr_reserved_time > (now() - interval '1 day') then
          delete from tickets where id = NEW.id;
        end if;
      end if;
      return NEW;
    end;
  $$ language plpgsql;

create trigger booking_timeout_trigger
after update or insert on tickets
for each row execute procedure booking_timeout();

create function remove_booking()
  returns trigger as
  $$
    DECLARE
      curr_reserved_time timestamp;
      curr_flight_time timestamp;
    begin
      if OLD.status = 'booked' then
        curr_reserved_time := (select reserved_time from tickets where id = OLD.id);
        curr_flight_time := (select flight_time from flights where flights.id = NEW.id);

        if curr_reserved_time > (curr_flight_time - interval '1 day') then
          delete from tickets where id = OLD.id;
        end if;
      end if;
      return OLD;
    end;
  $$ language plpgsql;

create trigger remove_booking_trigger
before select on tickets
for each row execute procedure remove_booking();

create function already_bought()
  returns trigger as
  $$
    begin
      if OLD.status = 'bought' then
        RAISE EXCEPTION 'this ticket had already bought';
      end if;
      return NEW;
    end;
  $$ language plpgsql;

create trigger already_bought_trigger
before update on tickets
for each row execute procedure already_bought();


create index idx_flights_time on flights (id, flight_time);
create index idx_tickets_time on tickets (id, reserved_time);
create index idx_tickets_flights on tickets (flight_id, status);
