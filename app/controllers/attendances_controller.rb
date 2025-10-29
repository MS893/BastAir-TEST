class AttendancesController < ApplicationController
  before_action :authenticate_user!

  def create
    @event = Event.find(params[:event_id])

    # Vérifie si l'utilisateur est déjà inscrit
    if @event.users.include?(current_user)
      redirect_to @event, alert: "Vous êtes déjà inscrit à cet événement."
      return
    end

    # crée la participation
    @attendance = Attendance.new(user: current_user, event: @event)

    if @attendance.save
      # envoie un email de notification à l'organisateur
      UserMailer.new_participant_notification(@attendance).deliver_now

      redirect_to @event, notice: "Félicitations ! Vous êtes inscrit à l'événement."
    else
      # en cas d'erreur, on affiche à nouveau la page de l'événement avec un message d'alerte
      render 'events/show', status: :unprocessable_entity
    end
    
  end

  def destroy
    @event = Event.find(params[:event_id])
    attendance = current_user.attendances.find_by(event_id: @event.id)

    if attendance
      attendance.destroy
      redirect_to @event, notice: "Vous avez bien été désinscrit de l'événement."
    else
      redirect_to @event, alert: "Vous n'étiez pas inscrit à cet événement."
    end
  end

end