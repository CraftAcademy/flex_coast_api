class AddWriterToNotes < ActiveRecord::Migration[6.1]
  def change
    add_reference :notes, :writer, null: true, foreign_key: { to_table: :users }
  end
end
