class RemovesDateAttribute < ActiveRecord::Migration[6.1]
  def change
    remove_column :inquiries, :date
  end
end
