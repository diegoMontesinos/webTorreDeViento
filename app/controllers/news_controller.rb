class NewsController < ApplicationController

	def index
	end

	def show
		url_new = "new_" + params[:id]
		render partial: url_new
	end

end
