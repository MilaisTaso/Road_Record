class AddImpressionsCountToCourses < ActiveRecord::Migration[6.1]
  def change
    add_column :courses, :impressions_count, :integer, default: 0
  end
end
