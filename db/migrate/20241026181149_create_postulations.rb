class CreatePostulations < ActiveRecord::Migration[7.2]
  def change
    create_table :postulations do |t|
      t.string :message
      t.boolean :saw, default: false
      t.references :user, null: false, foreign_key: true
      t.references :offer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
