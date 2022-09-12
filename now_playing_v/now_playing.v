import net.http
import x.json2
import vweb

const (
  port = 8082
)

struct App {
  vweb.Context
mut:
  state shared State
}

struct State {
mut:
  cnt int
}


struct Scrobble {
  recenttracks RecentTracks
}

struct RecentTracks {
  track []Track
}

struct Track {
  name string  
  artist Artist
}

struct Artist {
  mbid string
  text string
}

fn main() {
  mut app := App{}
  app.handle_static('assets', true)
  vweb.run(app, port)
}

['/index']
pub fn (mut app App) index() vweb.Result {
  api_key := <YOUR_API_KEY>
  username := <YOUR_USER_NAME>
  resp := http.get('https://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&user='+username'&api_key='+api_key+'&format=json') or {
    println('nope')
    exit(1)
  }
  test := json2.raw_decode(resp.body) or {
    println('nope')
    exit(1)
  }
  scrobble := test.as_map()
  recenttracks := scrobble['recenttracks'].as_map()
  first_track := recenttracks['track'].as_map()['0'].as_map()
  now_playing := first_track['@attr'].as_map()['nowplaying'].bool()
  mut curr := "Currently not listening"
  mut title := ""
  mut artist := ""
  mut img := "./" 
  if now_playing {
    curr = "Currently listening to:"

    title = first_track['name'].str()
    artist = first_track['artist'].as_map()['#text'].str()
    img = first_track['image'].as_map()['3'].as_map()['#text'].str()
    if img == "" {
      img_resp := http.get('https://ws.audioscrobbler.com/2.0/?method=track.getinfo&api_key=c5d20cdd83d5ff06032b6790307682e6&artist='+artist+'&track='+title+'&format=json') or {
          println('nope')
        exit(1)
      }
      img_fetch := json2.raw_decode(img_resp.body) or {
        println('nope')
        exit(1)
      }
      img_track := img_fetch.as_map()['track'].as_map()['album'].as_map()
      img = img_track['image'].as_map()['3'].as_map()['#text'].str()
    }
  }
  return $vweb.html()
}
