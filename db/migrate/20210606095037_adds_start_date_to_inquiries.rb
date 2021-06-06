class AddsStartDateToInquiries < ActiveRecord::Migration[6.1]
  def change
    add_column :inquiries, :start_date, :string
  end
end
