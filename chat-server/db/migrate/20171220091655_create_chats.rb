class CreateChats < ActiveRecord::Migration
  def change
    create_table :chats do |t|
    	t.integer :user1
    	t.integer :user2

      	t.timestamps null: false
    end
  end
end
