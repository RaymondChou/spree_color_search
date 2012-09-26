class CreateColors < ActiveRecord::Migration
  def change
    create_table :spree_colors do |t|
      t.decimal :hue
      t.decimal :sat
      t.decimal :val
      t.string :name
      t.integer :image_id

      t.timestamps
    end
  end
end
