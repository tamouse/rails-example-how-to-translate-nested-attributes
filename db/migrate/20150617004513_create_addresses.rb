class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.references :addressable, polymorphic: true, index: true
      t.string :street
      t.string :extended
      t.string :locality
      t.string :region
      t.string :country
      t.string :postal_code
      t.string :email
      t.string :web
      t.string :phone

      t.timestamps null: false
    end
  end
end
