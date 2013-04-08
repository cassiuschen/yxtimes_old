class FeatureController < ApplicationController
  def show
    @feature =  Feature.first
  end

  def edit
  end
end
