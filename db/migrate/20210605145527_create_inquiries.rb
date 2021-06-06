class CreateInquiries < ActiveRecord::Migration[6.1]
  def change
    create_table :inquiries do |t|
      t.integer :size
      t.boolean :type
      t.string :company
      t.boolean :peers
      t.string :email
      t.date :date
      t.boolean :flexible
      t.integer :phone

      t.timestamps
    end
  end
end
