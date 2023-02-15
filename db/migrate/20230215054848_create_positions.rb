class CreatePositions < ActiveRecord::Migration[6.1]
  def change
    create_table :positions do |t|
      t.integer :course_id, null: false
      t.decimal :lat, precision: 17, scale: 14, null: false
      t.decimal :lng, precision: 17, scale: 14, null: false
      
      t.timestamps
    end
  end
end
