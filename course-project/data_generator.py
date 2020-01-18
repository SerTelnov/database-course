import random
import time

NUMBER_OF_ARTIST = 6
NUMBER_OF_AGENT = 4

DATA_PATH = 'data/'

NUMBER_OF_ALBUMS = 3
NUMBER_OF_TRACKS = 9

DATE_FORMAT = '%Y-%m-%d'

def _str_random_date(start, end, format, prop):
  stime = time.mktime(time.strptime(start, format))
  etime = time.mktime(time.strptime(end, format))
  ptime = stime + prop * (etime - stime)

  return time.strftime(format, time.localtime(ptime))

def _random_date(start, end):
  return _str_random_date(start, end, DATE_FORMAT, random.random())

def generate_tracks_data(artist_id, publish_date):
  tracks = []

  for i in range(random.randrange(3, NUMBER_OF_TRACKS)):
    track = {'name': 'track#' + str(i)}
    rand = random.randrange(0, 1000)
    if 0 < rand < 100:
      other_artist = artist_id
      while other_artist == artist_id:
        other_artist = random.randrange(0, NUMBER_OF_ARTIST)
      track['other_artist'] = other_artist
    if 75 < rand < 125:
      publish_date = time.mktime(time.strptime('2020-01-30', DATE_FORMAT))
      chart_top_days = random.randrange(2, 10)
      chartor_data = []
      for i in range(chart_top_days):
        place = random.randrange(1, 1000)
        date = time.strftime(DATE_FORMAT, time.localtime(publish_date + (i + 1) * 100000))
        chartor_data.append({'date': date, 'place': place})
      track['chart'] = chartor_data

    tracks.append(track)

  return tracks

def generate_album_data():
  albums = []
  for artist in range(NUMBER_OF_ARTIST):
    for i in range(NUMBER_OF_ALBUMS):
      album_name = 'album#' + str(i)
      album_date = _random_date('2019-01-30', '2020-01-01')
      tracks = generate_tracks_data(artist, album_date)
      albums.append({'artist': artist, 'name': album_name, 'date': album_date, 'tracks': tracks})
  return albums

def write_albums(album_data):
  with open(DATA_PATH + 'album.csv',"w+") as album_file,\
    open(DATA_PATH + 'track.csv',"w+") as track_file,\
    open(DATA_PATH + 'trackArtist.csv',"w+") as track_artist_file,\
    open(DATA_PATH + 'reach.csv',"w+") as reach_file:

    track_number = 0
    for i, album in enumerate(album_data):
      curr_artist_str = str(album['artist'] + 1)
      row = ','.join([album['name'], album['date'], curr_artist_str]) + '\n'
      album_file.write(row)

      for track in album['tracks']:
        track_num_str = str(track_number + 1)

        row = ','.join([track['name'], str(i + 1)]) + '\n'
        track_file.write(row)

        row = ','.join([track_num_str, curr_artist_str]) + '\n'
        track_artist_file.write(row)

        if 'other_artist' in track:
          row = ','.join([track_num_str, str(track['other_artist'] + 1)]) + '\n'
          track_artist_file.write(row)
        if 'chart' in track:
          for chart_info in track['chart']:
            row = ','.join([track_num_str, chart_info['date'], str(chart_info['place'])]) + '\n'
            reach_file.write(row)
        track_number += 1

def generate_concerts(artist = None):
  addresses = [\
    "\"Санкт-Петербург, Пироговская наб. 5/2\"",\
    "\"г. Москва, Ленинградский пр-т, д. 80, стр. 17\"",\
    "\"г. Москва, Ленинградский проспект д.36\""
  ]

  concerts = []
  concerts_range = range(NUMBER_OF_ARTIST) if artist == None else range(artist, artist + 1)
  for artist in concerts_range:
    for _ in range(2):
      date = _random_date('2020-01-30', '2021-01-01')
      address = addresses[random.randrange(0, 3)]
      capacity = random.randrange(100, 1000)
      cost = random.randrange(750, 2000)
      tickets = random.randrange(int(capacity / 3), capacity)

      concerts.append({'artist': artist, 'cost': cost, 'date': date, 'address': address, 'capacity': capacity, 'tickets': tickets})
  return concerts

def write_concerts(concerts, tour_concerts, tours):
  all_concerts = concerts + tour_concerts
  with open(DATA_PATH + 'concert.csv',"w+") as concert_file,\
    open(DATA_PATH + 'ticket.csv',"w+") as ticket_file,\
    open(DATA_PATH + 'concertArtist.csv',"w+") as concert_artist_file,\
    open(DATA_PATH + 'tour.csv',"w+") as tour_file,\
    open(DATA_PATH + 'tourConcert.csv',"w+") as tour_concert_file:

    for i, concert in enumerate(all_concerts):
      row = ','.join([concert['date'], concert['address'], str(concert['cost']), str(concert['capacity'])]) + '\n'
      concert_file.write(row)

      row = ','.join([str(i + 1), str(concert['artist'] + 1)]) + '\n'
      concert_artist_file.write(row)
      for _ in range(concert['tickets']):
        row = ','.join([str(i + 1)]) + '\n'
        ticket_file.write(row)

    concert_idx = len(concerts) + 1
    for i, tour in enumerate(tours):
      row = ','.join([tour['name']]) + '\n'
      tour_file.write(row)
      for _ in range(len(tour['concerts'])):
        row = ','.join([str(i + 1), str(concert_idx)]) + '\n'
        tour_concert_file.write(row)
        concert_idx += 1

def generate_tours():
  tours = []
  concerts = []
  for artist in range(NUMBER_OF_ARTIST):
    tour_name = 'tour#' + str(len(tours))
    curr_concerts = generate_concerts()
    concerts += curr_concerts
    tours.append({'name': tour_name, 'concerts': curr_concerts, 'artist': artist})
  return tours, concerts

albums = generate_album_data()
write_albums(albums)

concerts = generate_concerts()
tours, tour_concerts = generate_tours()
write_concerts(concerts, tour_concerts, tours)
