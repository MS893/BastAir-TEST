class CreateReservations < ActiveRecord::Migration[8.0]
  def change
    create_table :reservations do |t|
      # une réservation est effectuée par un user et est lié à un avion
      t.references :user, foreign_key: { to_table: :users }
      t.references :avion, foreign_key: true
      
      t.datetime :date_debut
      t.datetime :date_fin
      t.boolean :instruction
      t.string :fi
      t.string :type_vol  # nav, mania, etc.

      t.timestamps
    end
  end
end
