\c music_label;

create function active_contract_check()
  returns trigger as 
  $$
    DECLARE
      contract_end_date date;
    begin
      if NEW.date_from < now() then
        RAISE EXCEPTION 'Contract cant bacome active in the past';
      end if;

      contract_end_date := (
        select vw.expired_date
        from contract_expired_date_view as vw
        where vw.artist_id = NEW.artist_id
      );

      if NEW.date_from < contract_end_date then
        RAISE EXCEPTION 'Current contract has not expired';
      end if;

      return NEW;
    end;
  $$ language plpgsql;

create trigger active_contract_trigger
before update or insert on contract
for each row execute procedure active_contract_check();

create function sold_out_check()
  returns trigger as 
  $$
    DECLARE
      concert_capacity integer;
      ticket_idx integer;
    begin
      concert_capacity := (
        select capacity
        from concert
        where concert.id = NEW.concert_id
      );

      ticket_idx := (
        select count(*)
        from ticket
        where ticket.concert_id = NEW.concert_id
      );

      if ticket_idx >= concert_capacity then
        RAISE EXCEPTION 'Concert had already got sold out';
      end if;

      return NEW;
    end;
  $$ language plpgsql;

create trigger sold_out_trigger
before insert on ticket
for each row execute procedure sold_out_check();

create function contract_expired_concert_check()
  returns trigger as 
  $$
    DECLARE
      contract_end_date date;
      concertDate date;
      album_publish_date date;
    begin
      contract_end_date := (
        select vw.expired_date
        from contract_expired_date_view as vw
        where vw.artist_id = NEW.artist_id
      );

      concertDate := (
        select concert_date
        from concert
        where concert.id = NEW.concert_id
      );

      if contract_end_date <= concertDate then
        RAISE EXCEPTION 'Artist contract will be expired before concert';
      end if;

      return NEW;
    end;
  $$ language plpgsql;

create trigger contract_expired_concert_trigger
before update or insert on ConcertArtist
for each row execute procedure contract_expired_concert_check();

create function album_publish_date_check()
  returns trigger as 
  $$
    DECLARE
      contract_end_date date;
    begin
      if NEW.publish_date > now() then
        RAISE EXCEPTION 'Publish date cant be in the future';
      end if;

      contract_end_date := (
        select vw.expired_date
        from contract_expired_date_view as vw
        where vw.artist_id = NEW.artist_id
      );

      if contract_end_date <= NEW.publish_date then
        RAISE EXCEPTION 'Artist contract will be expired before album publication';
      end if;

      return NEW;
    end;
  $$ language plpgsql;

create trigger album_publish_date_trigger
before update or insert on Album
for each row execute procedure album_publish_date_check();

create function has_content_before_concert_check()
  returns trigger as 
  $$
    DECLARE
      has_any_album boolean;
    begin
      has_any_album := (
        select max(publish_date) is not null
        from album
        where album.artist_id = NEW.artist_id
      );

      if not has_any_album then
        RAISE EXCEPTION 'Artist hasnt got any content to perform';
      end if;

      return NEW;
    end;
  $$ language plpgsql;

create trigger has_content_before_concert_trigger
before update or insert on concertArtist
for each row execute procedure has_content_before_concert_check();
