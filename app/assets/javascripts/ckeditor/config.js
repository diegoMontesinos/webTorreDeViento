CKEDITOR.editorConfig = function(config ) {
	config.font_names = "Euphemia/euphemia, euphemia_ie; Latha/latha, latha_ie; FelixTitling/felixti, felixti_ie; Calibri/calibri, calibri_ie;" + config.font_names;

	config.toolbarGroups = [
		{ name: 'clipboard',   groups: [ 'clipboard', 'undo' ] },
		{ name: 'editing',     groups: [ 'selection', 'spellchecker' ] },
		{ name: 'basicstyles', groups: [ 'basicstyles', 'cleanup' ] },
		{ name: 'paragraph',   groups: [ 'indent', 'align' ] },
		{ name: 'links' },
		{ name: 'insert' },
		{ name: 'styles' },
		{ name: 'colors' },
		{ name: 'tools' }
	];
}