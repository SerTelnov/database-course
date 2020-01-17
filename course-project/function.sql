\c music_label;

create function extend_contract(artistId integer)
returns void as $$
	declare
		contract_end_date date;
    agentId integer;
	begin
    contract_end_date := (
      select vw.expired_date
      from contract_expired_date_view as vw
      where vw.artist_id = artistId
    );
    agentId := (
      select contract.agent_id
      from contract
      where contract.artist_id = artistId
      order by date_to desc
      limit 1
    );
    insert into contract
    (date_from, date_to, artist_id, agent_id)
    values
    (contract_end_date, contract_end_date + interval '1 year', artistId, agentId);
  end;
$$ language plpgsql;

create function buy_tickets(concertId integer, quantity int)
returns void as $$
  begin
    for i in 0..quantity loop
      insert into ticket (concert_id) VALUES (concertId);
    end loop;
  end;
$$ language plpgsql;
