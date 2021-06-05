class CreateInquiries < ActiveRecord::Migration[6.1]
  def change
    create_table :inquiries do |t|
      t.size :integer
      t.type :boolean
      t.company :string
      t.peers :boolean
      t.email :string
      t.location :array
      t.date :date
      t.flexible :boolean
      t.phone :integer

      t.timestamps
    end
  end
end
