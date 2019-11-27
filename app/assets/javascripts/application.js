// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require bootstrap-datepicker
//= require Chart.min
//= require_tree .

function hide_spiner(){
    document.getElementById('spiner').style.display ='none';
    document.getElementById('submit_form_container').style.display ='block';

}

$("form").submit(function(){
    $(this).hide();
})

function show_spiner(){
    document.getElementById('spiner').style.display = 'block';
    document.getElementById('submit_form_container').style.display ='none';

}

$(document).ready(function () {
    $('.datepicker').datepicker({autoclose: true});
});