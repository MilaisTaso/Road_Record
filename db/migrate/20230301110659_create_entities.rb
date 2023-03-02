class CreateEntities < ActiveRecord::Migration[6.1]
  def change
    create_table :entities do |t|
      t.integer :course_id, null: false
      t.string :key_word, null: false
      t.timestamps
    end
  end
end
