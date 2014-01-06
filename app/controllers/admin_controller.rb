class AdminController < ApplicationController
	before_filter :authenticate_user!

	def show
		@work = Work.new
	end
end
