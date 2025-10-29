class UserMailer < ApplicationMailer

  def welcome_email(user)
    # on récupère l'instance user pour ensuite pouvoir la passer à la view en @user
    @user = user 
    # on définit une variable @url qu'on utilisera dans la view d’e-mail
    @url  = 'http://bastair.com/login' 
    # c'est cet appel à mail() qui permet d'envoyer l’e-mail en définissant destinataire et sujet.
    mail(to: @user.email, subject: "Bienvenue à l'aéroclub de Basse Terre !") 
  end

  def negative_balance_email(user)
    @user = user
    @url = root_url
    mail(to: @user.email, subject: 'Alerte : Votre solde BastAir est négatif')
  end

  def validity_reminder_email(user, item_name, expiry_date)
    @user = user
    @item_name = item_name
    @expiry_date = expiry_date
    mail(to: @user.email, subject: "Rappel : Expiration imminente de #{item_name}")
  end

end
