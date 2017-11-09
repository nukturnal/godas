function resize_map_container(container) {
    $(container).css('height', $(window).height() - 70);
}
$(document).on('turbolinks:load', function(){
    resize_map_container('#godas-map');
});
$(window).resize(function(){
    resize_map_container('#godas-map');
});