function sendData(){
    $d1 = $('#d1').val();
    document.getElementById("d1").value = "";
    $d2 = $('#d2').val();
    document.getElementById("d2").value = ""; 
    $endpoint = ""
    $('#d2').value = "";
    $.ajax({url: $endpoint,
        data: {'d1' : $d1, 'd2' : $d2},
        type: "POST",dataType: "json",
        success: function(data){},
        error: function(){}
    });
}
