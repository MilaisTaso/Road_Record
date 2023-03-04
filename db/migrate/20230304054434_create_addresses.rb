class CreateAddresses < ActiveRecord::Migration[6.1]
  def change
    create_table :addresses do |t|
      t.integer :course_id, null: false
      t.string :name, null: false
      t.timestamps
    end
  end
end
