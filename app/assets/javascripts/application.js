// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui

//= require twitter/bootstrap
//= require twitter/bootstrap/transition
//= require twitter/bootstrap/alert
//= require twitter/bootstrap/modal
//= require twitter/bootstrap/button
//= require twitter/bootstrap/collapse
//= require bootstrap-sprockets
//= require autocomplete-rails
//= require_tree .
//= require bootstrap

$(document).ready(function() {
    //https://datatables.net/examples/basic_init/language.html
    var datatable = $('#user_table').fadeIn().DataTable({
        paging: false,
        "language": {
            "lengthMenu": "Vis _MENU_ inputs per side.",
            "zeroRecords": "Der er ikke fundet noget data.",
            "info": "Viser side _PAGE_ ud af _PAGES_",
            "infoEmpty": "Der er ingen data tilgængelig.",
            "infoFiltered": "(Ud af _MAX_)"
        }
    });

    $("#searchBox").keyup(function () {
        datatable.search(this.value).draw()
    });
});