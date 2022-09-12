p = document.getElementById('result')

setInterval(function() {
    fetchApi()
  }, 10000);


const user = <YOUR_USER_NAME>
const api_key = <YOUR_API_KEY>;

function fetchApi(){
    fetch('https://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&user='+user+'&api_key='+api_key+'&format=json')
    .then((response) => response.json())
    .then(function(json){
        curr_track = json['recenttracks']['track'][0];
        try {
            if (curr_track['@attr']['nowplaying']){
                document.getElementById('listening').innerHTML = "Currently listening to:"
                document.getElementById('image').src = curr_track['image'][3]["#text"];
                document.getElementById('title').innerHTML = curr_track['name'];
                document.getElementById('artist').innerHTML = curr_track['artist']['#text'];
            }
        }
        catch{}
        
    })
}

//function for sending notification for the song to listen
function sendData(){
    $d1 = $('#d1').val();
    $d2 = $('#d2').val();
    $endpoint = ""
    $.ajax({url: $endpoint,
        data: {'d1' : $d1, 'd2' : $d2},
        type: "POST",dataType: "json",
        success: function(data){},
        error: function(){}
    });
}
fetchApi()

