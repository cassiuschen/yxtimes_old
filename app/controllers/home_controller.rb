class HomeController < ApplicationController
  def index
    @vote = Vote.first
  end
end
