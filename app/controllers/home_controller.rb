class HomeController < ApplicationController

  def index
  	carousels = HomeCarousel.all
  	@carousel = carousels[Random.rand(carousels.length)]
  end

end
