class AddsLocationArrayToInquiry < ActiveRecord::Migration[6.1]
  def change
    add_column :inquiries, :location, :string, array: true, default: []
  end
end
