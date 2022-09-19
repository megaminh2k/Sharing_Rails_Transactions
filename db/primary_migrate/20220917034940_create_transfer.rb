class CreateTransfer < ActiveRecord::Migration[6.1]
  def change
    create_table :transfers do |t|
      t.integer :sender_id, foreign_key: true
      t.integer :receiver_id, foreign_key: true
      t.float :amount

      t.timestamps
    end
  end
end
