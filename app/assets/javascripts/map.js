function display_map(el) {
    var map = new GMaps({
        el: el,
        lat: -12.043333,
        lng: -77.028333
    });
}

$(document).on('turbolinks:load', function(){
   display_map('.godas-map');
});