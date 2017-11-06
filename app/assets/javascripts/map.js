var map = null;

function display_map() {
    geo_locate();
}

function geo_locate() {
    GMaps.geolocate({
        success: function(position) {
            map.setCenter(position.coords.latitude, position.coords.longitude);
        },
        error: function(error) {
            console.log('Geolocation failed: '+error.message);
        },
        not_supported: function() {
            alert("Your browser does not support geolocation");
        },
        always: function() {
            // alert("Done!");
        }
    });
}

function search() {
    GMaps.geocode({
        address: $('#address').val() + ' Ghana',
        callback: function(results, status) {
            if (status == 'OK') {
                var latlng = results[0].geometry.location;
                map.setCenter(latlng.lat(), latlng.lng());
                map.addMarker({
                    lat: latlng.lat(),
                    lng: latlng.lng()
                });
            }else{
                alert(status);
            }
        }
    });
}

function bind_address_search(){
    $('#address').bind("enterKey",function(e){
        search();
    });
    $('#address').keyup(function(e){
        if(e.keyCode == 13)
        {
            $(this).trigger("enterKey");
        }
    });
}

function get_address(lng,lat) {
    var jqxhr = $.post( "apis/core/getaddress", { longitude: lng, latitude: lat })
        .done(function(data) {
            $(".modal-body").html(address_modal(data.data));
            $.modalwindow({
                target: '#my-modal',
                header: 'Location Details',
                overlay: false
            });
        })
        .fail(function() {
            alert( "error" );
        })
        .always(function() {
            // alert( "finished" );
        });
}

function address_modal(data) {
    return '      <table>\n' +
    '        <tbody>\n' +
    '        <tr>\n' +
    '          <td><strong>Digital Address</strong></td>\n' +
    '          <td>'+data.digital_address+'</td>\n' +
    '        </tr>\n' +
    '        <tr>\n' +
    '          <td><strong>Longitude, Latitude</strong></td>\n' +
    '          <td>'+data.longitude +' , ' +data.latitude+'</td>\n' +
    '        </tr>\n' +
    '        <tr>\n' +
    '          <td><strong>City, Suburb, Town </strong></td>\n' +
    '          <td>'+data.city+'</td>\n' +
    '        </tr>\n' +
    '        <tr>\n' +
    '          <td><strong>District</strong></td>\n' +
    '          <td>'+data.district+'</td>\n' +
    '        </tr>\n' +
    '        <tr>\n' +
    '          <td><strong>Region</strong></td>\n' +
    '          <td>'+data.region+'</td>\n' +
    '        </tr>\n' +
    '        </tbody>\n' +
    '      </table>'
}

$(document).on('turbolinks:load', function(){
    map = new GMaps({
        el: '.godas-map',
        lat: 5.554929,
        lng: -0.200690
    });
    display_map();
    bind_address_search();
    GMaps.on('click', map.map, function(event) {
        var index = map.markers.length;
        var lat = event.latLng.lat();
        var lng = event.latLng.lng();
        get_address(lng, lat);
        map.addMarker({
            lat: lat,
            lng: lng,
            title: 'Marker #' + index
        });
    });
});