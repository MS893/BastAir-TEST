class ReservationsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user_balance, only: [:new, :create]
  before_action :check_user_validities, only: [:new, :create]

  def new
    @reservation = Reservation.new
    # Vous pouvez ajouter ici la logique pour pré-remplir le formulaire si nécessaire
  end

  def create
    @reservation = current_user.reservations.build(reservation_params)
    if @reservation.save
      redirect_to root_path, notice: 'Votre réservation a été créée avec succès.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  # vérifie si l'adhérent a un solde positif ou pas
  def check_user_balance
    if current_user.solde <= 0
      flash[:alert] = "Votre solde est négatif ou nul. Veuillez créditer votre compte avant de pouvoir réserver un vol."
      redirect_to credit_path
    end
  end

  # vérifie les dates butées
  def check_user_validities
    user = current_user
    expired_items = []

    if user.date_licence.present? && user.date_licence < Date.today
      expired_items << "votre licence"
    end

    if user.medical.present? && user.medical < Date.today
      expired_items << "votre visite médicale"
    end

    if user.controle.present? && user.controle < Date.today
      expired_items << "votre contrôle en vol"
    end

    if expired_items.any?
      flash[:alert] = "Vous ne pouvez pas réserver de vol car #{expired_items.to_sentence(last_word_connector: ' et ')} a expiré."
      redirect_to root_path, status: :see_other
    end
  end

  def reservation_params
    params.require(:reservation).permit(:avion_id, :date_debut, :date_fin, :instruction, :fi, :type_vol)
  end
end
