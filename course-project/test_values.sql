\c music_label;

\copy artist(name) from 'data/artist.csv' DELIMITER ',' CSV
\copy agent(name,percent_per_concert) from 'data/agent.csv' DELIMITER ',' CSV
\copy contract(date_from,date_to,artist_id,agent_id) from 'data/contract.csv' DELIMITER ',' CSV
\copy album(name,publish_date,artist_id) from 'data/album.csv' DELIMITER ',' CSV
\copy track(name,album_id) from 'data/track.csv' DELIMITER ',' CSV
\copy trackArtist(track_id,artist_id) from 'data/trackArtist.csv' DELIMITER ',' CSV
\copy reach(track_id,chart_publish,chart_place) from 'data/reach.csv' DELIMITER ',' CSV
\copy concert(concert_date,address,cost,capacity) from 'data/concert.csv' DELIMITER ',' CSV
\copy ticket(concert_id) from 'data/ticket.csv' DELIMITER ',' CSV
\copy concertArtist(concert_id,artist_id) from 'data/concertArtist.csv' DELIMITER ',' CSV
\copy tour(name) from 'data/tour.csv' DELIMITER ',' CSV
\copy tourConcert(tour_id,concert_id) from 'data/tourConcert.csv' DELIMITER ',' CSV
