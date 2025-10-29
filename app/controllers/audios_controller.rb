class AudiosController < ApplicationController
  before_action :authenticate_user!

  def show
    @paudio = Audio.find(params[:id])
  end

end
