# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command.

require 'faker'

puts "\nCleaning database..."
Audio.destroy_all
Reservation.destroy_all
Vol.destroy_all
Avion.destroy_all
Tarif.destroy_all
Event.destroy_all
Attendance.destroy_all
User.destroy_all # User doit être le dernier à être détruit si d'autres modèles en dépendent
Course.destroy_all
puts "✅ Cleaned"

puts "Réinitialisation des IDs de séquence pour SQLite..."
ActiveRecord::Base.connection.tables.each do |t|
  ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name = '#{t}'")
end
puts "✅ Cleaned"

puts "\nCreating users..."

# On désactive temporairement l'envoi d'e-mails pour éviter les erreurs de letter_opener
original_delivery_method = ActionMailer::Base.delivery_method
ActionMailer::Base.delivery_method = :test

# 1. Création de 30 adhérents, dont un administrateur
# ----------------------------------------------------

# Crée un administrateur
admin_user = User.create!(
  prenom: "Admin",
  nom: "User",
  email: "admin@bastair.com",
  password: "password",
  password_confirmation: "password",
  admin: true,
  date_naissance: Faker::Date.birthday(min_age: 61, max_age: 65),
  lieu_naissance: Faker::Address.city,
  profession: "Administrateur Système",
  adresse: Faker::Address.full_address,
  telephone: Faker::PhoneNumber.phone_number,
  contact_urgence: "#{Faker::Name.name} - #{Faker::PhoneNumber.phone_number}",
  num_ffa: Faker::Number.number(digits: 8).to_s,
  licence_type: "PPL",
  num_licence: "FRA.PPL.#{Faker::Number.number(digits: 6)}",
  date_licence: Faker::Date.backward(days: 365 * 5),
  medical: Faker::Date.forward(days: 365),
  fi: Faker::Date.forward(days: 365),
  fe: Faker::Date.forward(days: 365),
  controle: Faker::Date.forward(days: 365),
  solde: Faker::Number.decimal(l_digits: 3, r_digits: 2),
  cotisation_club: Faker::Date.forward(days: 365),
  cotisation_ffa: Faker::Date.forward(days: 365),
  autorise: true,
  fonction: "Président"
)
puts "✅ Administrator created: #{admin_user.email}"

# Crée 29 adhérents normaux
29.times do
  licence = ["PPL", "LAPL"].sample
  User.create!(
    prenom: Faker::Name.first_name,
    nom: Faker::Name.last_name,
    email: Faker::Internet.unique.email,
    password: "password",
    password_confirmation: "password",
    date_naissance: Faker::Date.birthday(min_age: 17, max_age: 70),
    lieu_naissance: Faker::Address.city,
    profession: Faker::Job.title,
    adresse: Faker::Address.full_address,
    telephone: Faker::PhoneNumber.phone_number,
    contact_urgence: "#{Faker::Name.name} - #{Faker::PhoneNumber.phone_number}",
    num_ffa: Faker::Number.number(digits: 8).to_s,
    licence_type: licence,
    num_licence: "FRA.#{licence}.#{Faker::Number.number(digits: 6)}",
    date_licence: Faker::Date.backward(days: 365 * 10),
    medical: Faker::Date.forward(days: 365),
    controle: Faker::Date.forward(days: 365),
    solde: Faker::Number.decimal(l_digits: 2, r_digits: 2),
    cotisation_club: Faker::Date.forward(days: 365),
    cotisation_ffa: Faker::Date.forward(days: 365),
    autorise: [true, true, true, false].sample, # 75% de chance d'être autorisé
    admin: false
  )
end
puts "✅ 29 regular members created."
puts "Total users: #{User.count}"

# On réactive l'envoi d'e-mails
ActionMailer::Base.delivery_method = original_delivery_method


# 2. Création d'un avion
# ----------------------------------------------------

puts "\nCreating aircraft..."
avion = Avion.create!(
  immatriculation: "F-HGBT",
  marque: "Bristell",
  modele: "B23",
  conso_horaire: 18,
  certif_immat: Faker::Date.forward(days: 365),
  cert_navigabilite: Faker::Date.forward(days: 365),
  cert_examen_navigabilite: Faker::Date.forward(days: 365),
  licence_station_aeronef: Faker::Date.forward(days: 365),
  cert_limitation_nuisances: Faker::Date.forward(days: 365),
  fiche_pesee: Faker::Date.forward(days: 365),
  assurance: Faker::Date.forward(days: 365),
  _50h: Faker::Date.forward(days: 30),
  _100h: Faker::Date.forward(days: 60),
  annuelle: Faker::Date.forward(days: 365),
  gv: Faker::Date.forward(days: 1095),
  helice: Faker::Date.forward(days: 1095),
  parachute: Faker::Date.forward(days: 1095),
  potentiel_cellule: 5000.00,
  potentiel_moteur: 2000.00
)
puts "✅ Aircraft created: #{avion.immatriculation}"


# 3. Création de 20 vols
# ----------------------------------------------------

puts "\nCreating flights..."
aerodromes = ["TFFB", "TFFS", "TFFM", "TFFR", "TFFC", "TFFA"]
types_vol = ["solo", "instruction", "contrôle FI", "vol découverte", "vol d'initiation", "vol d'essai", "convoyage", "vol BIA"]
all_users = User.all
compteur_actuel = 1234.5

20.times do
  depart_time = Faker::Time.between(from: DateTime.now - 30, to: DateTime.now + 30)
  duree_minutes = [30, 45, 60, 90, 120].sample
  duree_heures = duree_minutes / 60.0
  Vol.create!(
    user: all_users.sample, # Correctly assign a random user
    avion: avion,           # Assign the created aircraft
    type_vol: types_vol.sample,
    depart: aerodromes.sample,
    arrivee: aerodromes.sample,
    debut_vol: depart_time,
    fin_vol: depart_time + duree_minutes.minutes,
    compteur_depart: compteur_actuel,
    compteur_arrivee: compteur_actuel + duree_minutes,
    duree_vol: duree_minutes,
    nb_atterro: [1, 2, 3].sample,
    solo: [true, false].sample,
    supervise: [true, false].sample,
    nav: [true, false].sample,
    jour: true,
    fuel_avant_vol: Faker::Number.between(from: 80.0, to: 100.0).round(1),
    fuel_apres_vol: Faker::Number.between(from: 40.0, to: 60.0).round(1),
    huile: Faker::Number.between(from: 2.0, to: 3.0).round(1)
  )
  compteur_actuel += duree_minutes + 15 # Ajoute un petit temps au sol entre 2 vols
end
puts "✅ 20 flights created."


# 4. Création de 20 réservations
# ----------------------------------------------------

puts "\nCreating bookings..."
20.times do
  date_vol = Faker::Time.between(from: DateTime.now + 30, to: DateTime.now + 3000)
  Reservation.create!(
    user: all_users.sample, # Correctly assign a random user
    avion: avion,           # Assign the created aircraft
    date_debut: date_vol,
    date_fin: date_vol + 60.minutes,
    instruction: [true, false].sample,
    fi: "Toto",
    type_vol: types_vol.sample
  )
end
puts "✅ 20 bookings created."


puts "\nCreating 10 events..."
10.times do
  event = Event.create!(
    title: Event::ALLOWED_TITLES.sample, # titre parmi les titres autorisés
    description: Faker::Lorem.paragraph(sentence_count: 5),
    start_date: Faker::Time.forward(days: 30, period: :day),
    price: 0,
    admin: admin_user # On associe l'événement à l'administrateur créé plus haut
  )
  puts "Created event: #{event.title}"
end
puts "✅ 10 events created."


# 5. Création des tarifs annuels
# ----------------------------------------------------
puts "\nCreating annual rates..."
Tarif.create!(
  annee: Date.today.year,
  tarif_horaire_avion1: 150,
  tarif_horaire_avion2: 0,    # Mettre à jour si autres avions (faire une migration)
  tarif_simulateur: 20,
  cotisation_club_m21: 100,
  cotisation_club_p21: 200,
  cotisation_autre_ffa: 100,
  licence_ffa: 92,
  licence_ffa_info_pilote: 141,
  elearning_theorique: 70,
  pack_pilote_m21: 0,         # Offert
  pack_pilote_p21: 75
)
puts "✅ Annual rates for #{Date.today.year} created."


# 6. Création des cours théoriques
# ----------------------------------------------------
puts "\nCreating Courses..."

# Assurez-vous d'avoir un fichier d'exemple dans app/assets/files/sample.pdf
sample_pdf_path = Rails.root.join('app', 'assets', 'files', 'sample.pdf')

courses_data = [
  { title: "Principes de vol", description: "Comprendre les bases de l'aérodynamique et les forces qui agissent sur un avion.", file: "Le vol moteur réduit.pptx" },
  { title: "Réglementation aérienne", description: "Apprendre les règles de l'air, l'espace aérien et les procédures de communication.", file: "reglementation.pdf" },
  { title: "Météorologie aéronautique", description: "Savoir interpréter les cartes météo, les METAR/TAF et anticiper les conditions de vol.", file: "meteo.pdf" },
  { title: "Navigation", description: "Maîtriser les techniques de navigation à l'estime et radio-navigation.", file: "navigation.pdf" },
  { title: "Facteurs humains", description: "Prendre conscience de l'impact de la physiologie et de la psychologie sur le pilotage.", file: "facteurs_humains.pdf" }
]

courses_data.each do |course_data|
  course = Course.create!(title: course_data[:title], description: course_data[:description])
  # Attache un fichier PDF d'exemple. Créez des fichiers PDF factices dans app/assets/files/ pour que cela fonctionne.
  file_path = Rails.root.join('app', 'assets', 'files', course_data[:file])
  if File.exist?(file_path)
    content_type = course_data[:file].end_with?('.pptx') ? 'application/vnd.openxmlformats-officedocument.presentationml.presentation' : 'application/pdf'
    course.document.attach(io: File.open(file_path), filename: course_data[:file], content_type: content_type)
  else
    puts "      ⚠️  Warning: File #{course_data[:file]} not found for course '#{course_data[:title]}'."
  end
end
puts "✅ Courses created."


# 7. Création des podcasts
# ----------------------------------------------------
puts "\nCreating Podcasts..."
Audio.destroy_all

podcasts_data = [
  { title: "Voler par fortes chaleurs", description: "Un premier épisode sur les choses à vérifier avant de voler.", file: "High Temperature Flight Operations.wav" }
  # Vous pourrez ajouter d'autres podcasts ici à l'avenir
]

podcasts_data.each do |podcast_data|
  audio = Audio.create!(title: podcast_data[:title], description: podcast_data[:description])
  podcast_file_path = Rails.root.join('app', 'assets', 'files', podcast_data[:file])
  if File.exist?(podcast_file_path)
    audio.audio.attach(io: File.open(podcast_file_path), filename: podcast_data[:file], content_type: 'audio/mpeg')
  end
end
puts "✅ #{Audio.count} podcast(s) created."

puts "\nSeed finished successfully!"
puts
