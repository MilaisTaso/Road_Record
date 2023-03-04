class CreateCourses < ActiveRecord::Migration[6.1]
  def change
    create_table :courses do |t|
      t.integer :user_id, null: false
      t.string :title, null: false
      t.text :introduction, null: false
      t.integer :suggest_time, null: false
      t.integer :signal_condition, null: false
      t.integer :traffic_volume, null: false
      t.integer :is_slope, null: false
      t.decimal :distance, precision: 6, scale: 2, null: false

      t.timestamps
    end
  end
end
