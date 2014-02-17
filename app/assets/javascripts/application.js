// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require jquery.ui.all
//= require ckeditor/init
//= require dropzone
//= require jquery.Jcrop
//= require jquery.remotipart
//= require_tree .

function remove_fields(link) {

	$(link).parent().find("input").attr("value", "true");
	var li_tag = $(link).parent().prev("li");
	var script_tag = $(link).parent().next("script");
	var parent_tag = $(link).parent();
	var panelId = li_tag.attr("aria-controls")

	li_tag.remove();
	$("#" + panelId).remove();
	script_tag.remove();
	parent_tag.remove();

	$("#form-work-images-tabs").tabs("refresh");
	
}

function add_fields(link, association, content) {
	var new_id = new Date().getTime();
	var regexp = new RegExp("new_" + association, "g")
	$("#form-work-multimedia").append(content.replace(regexp, new_id));
}