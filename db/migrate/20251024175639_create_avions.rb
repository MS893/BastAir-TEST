class CreateAvions < ActiveRecord::Migration[8.0]
  def change
    create_table :avions do |t|
      t.string :immatriculation
      t.string :marque
      t.string :modele
      t.integer :conso_horaire
      t.date :certif_immat
      t.date :cert_navigabilite
      t.date :cert_examen_navigabilite
      t.date :licence_station_aeronef
      t.date :cert_limitation_nuisances
      t.date :fiche_pesee
      t.date :assurance
      t.date :_50h
      t.date :_100h
      t.date :annuelle
      t.date :gv
      t.date :helice
      t.date :parachute
      t.float :potentiel_cellule
      t.float :potentiel_moteur

      t.timestamps
    end
  end
end
