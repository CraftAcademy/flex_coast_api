class ChangesTypeAttributeToVariants < ActiveRecord::Migration[6.1]
  def change
    rename_column :inquiries, :type, :variants
    rename_column :inquiries, :location, :locations
  end
end
