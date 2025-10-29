class ElearningController < ApplicationController
  before_action :authenticate_user! # Assurez-vous que seuls les utilisateurs connectés peuvent accéder aux cours

  def index
    # On récupère tous les cours disponibles, triés par titre
    @courses = Course.all.order(:title)
    @audios = Audio.all.order(:title)
  end
end
