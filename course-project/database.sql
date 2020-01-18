create database music_label;

\c music_label;

create table Artist (
  id serial PRIMARY KEY,
  name varchar(30) not null
);

create table Agent (
  id serial PRIMARY KEY,
  name varchar(30) not null,
  percent_per_concert decimal not null
    CHECK (percent_per_concert > 0 and percent_per_concert < 100)
);

create table Contract (
  date_from date not null,
  date_to date not null CHECK (date_to > date_from),
  artist_id integer REFERENCES Artist(id) on delete cascade,
  agent_id integer REFERENCES Agent(id) on delete cascade,
  PRIMARY KEY (artist_id, date_from)
);

create index idx_contract_date_to on contract (date_to);
create index idx_contract_date_from on contract (date_from);

create table Album (
  id serial PRIMARY KEY,
  name varchar(15) not null,
  publish_date date not null,
  artist_id integer REFERENCES Artist(id) on delete cascade
);

create table Track (
  id serial PRIMARY KEY,
  name varchar(15) not null,
  album_id integer REFERENCES Album(id) on delete cascade
);

create table TrackArtist (
  track_id integer REFERENCES Track(id) on delete cascade,
  artist_id integer REFERENCES Artist(id) on delete cascade,
  PRIMARY KEY (track_id, artist_id)
);

create table Reach (
  track_id integer REFERENCES Track(id) on delete cascade,
  chart_publish date not null,
  chart_place int not null,
  PRIMARY KEY (track_id, chart_publish)
);

create index idx_reach_publish on Reach (chart_publish);

create table Concert (
  id serial PRIMARY KEY,
  concert_date date not null,
  address varchar(50) not null,
  cost int not null CHECK (cost > 0),
  capacity int not null CHECK (capacity > 0)
);

create index idx_codert_data on Concert (concert_date);

create table Ticket (
  id serial PRIMARY KEY,
  concert_id integer REFERENCES Concert(id) on delete cascade
);

create table ConcertArtist (
  concert_id integer REFERENCES Concert(id) on delete cascade,
  artist_id integer REFERENCES Artist(id) on delete cascade,
  PRIMARY KEY (concert_id, artist_id)
);

create table Tour (
  id serial PRIMARY KEY,
  name varchar(15) default null
);

create table TourConcert (
  tour_id integer REFERENCES Tour(id) on delete cascade,
  concert_id integer REFERENCES Concert(id) on delete cascade,
  PRIMARY KEY (tour_id, concert_id)
);
