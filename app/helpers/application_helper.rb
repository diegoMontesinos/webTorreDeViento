# encoding: utf-8 

module ApplicationHelper

	def link_to_remove_fields(name, f, file_folder_name)

		file_folder_name.gsub! ' ', '_'

		if file_folder_name == "false"
			f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)", :id => "remove_file_folder_link")
		else
			f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)", :id => "remove_" + file_folder_name + "_ff_link")
		end
	end

	def link_to_add_fields(name, f, association, file_folder_name, file_folder_name_in_en, created_by_user)
		new_object = f.object.class.reflect_on_association(association).klass.new
		fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
			render("shared/" + association.to_s.singularize + "_fields", :f => builder, :ff_name => file_folder_name, :ff_name_in_en => file_folder_name_in_en, :cbu => created_by_user.to_s)
		end

		link_to_function(name, "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")", :id => "add_file_folder_link")
	end
end
