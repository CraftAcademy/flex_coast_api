class RemoveFlexibleFromInquiries < ActiveRecord::Migration[6.1]
  def change
    remove_column :inquiries, :flexible, :integer
  end
end
