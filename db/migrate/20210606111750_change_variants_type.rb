class ChangeVariantsType < ActiveRecord::Migration[6.1]
  def change
    change_column :inquiries, :variants, :integer , using: 'variants::integer'
  end
end
