\c music_label;

create view contract_expired_date_view as
(
  select artist_id,
         max(date_to) as expired_date
  from contract
  group by artist_id
);

create view contract_expired_in_month as
(
  select artist_id,
         agent_id,
         max(date_to) as expired_date
  from contract
  group by artist_id, agent_id
  having max(date_to) <= now() + interval '1 month'
);

create view statistics_per_month as
(
  with 
  all_tickets as (
    select count(ticket.id) * concert.cost as money,
          concert.id as concert_id,
          concert.concert_date as date
    from ticket
    inner join concert
      on ticket.concert_id = concert.id
    group by concert.id
    having concert.concert_date < now() + interval '1 year'),
  artists_on_concert as (
    select count(artist_id) as artists,
          concert_id
    from concertArtist
    group by concert_id),
  month_money as (
    select ca.artist_id, date, money / aoc.artists as money
    from all_tickets as at
    inner join concertArtist as ca
      on ca.concert_id = at.concert_id
    inner join artists_on_concert as aoc
      on aoc.concert_id = at.concert_id)
  select extract(month from mm.date) as month, 
         artist.name as artist_name, 
         agent.name as agent_name,
         sum(money - money * percent_per_concert / 100) as artist_money,
         sum(money * percent_per_concert / 100) as agent_money
  from month_money as mm
  inner join contract as ct
    on mm.artist_id = ct.artist_id
      and (ct.date_from <= mm.date and mm.date < ct.date_to)
  inner join agent
    on agent.id = ct.agent_id
  inner join artist
    on artist.id = mm.artist_id
  group by extract(month from mm.date), artist.name, agent.name
  order by month
);

create view number_in_chart_last_month as (
  select artist.name, reach.chart_publish as date, count(*) as number_track_in_chart
  from reach
  inner join trackArtist
    on reach.track_id = trackArtist.track_id
  inner join artist
    on artist.id = trackArtist.artist_id
  group by artist.name, reach.chart_publish
  having reach.chart_publish < now() - interval '1 month'
);
