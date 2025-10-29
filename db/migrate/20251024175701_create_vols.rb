class CreateVols < ActiveRecord::Migration[8.0]
  def change
    create_table :vols do |t|
      # un vol est effectué par un user et est lié à un avion
      t.references :user, foreign_key: { to_table: :users }
      t.references :avion, foreign_key: true
      
      t.string :type_vol  # standard, vol découverte, vol d'initiation, vol d'essai, convoyage, vol BIA
      t.string :depart    # aérodrome de départ
      t.string :arrivee   # aérodrome d'arrivée
      t.datetime :debut_vol
      t.datetime :fin_vol
      t.float :compteur_depart
      t.float :compteur_arrivee
      t.float :duree_vol
      t.integer :nb_atterro
      t.boolean :solo
      t.boolean :supervise
      t.boolean :nav
      t.boolean :jour
      t.float :fuel_avant_vol
      t.float :fuel_apres_vol
      t.float :huile

      t.timestamps
    end
  end
end
