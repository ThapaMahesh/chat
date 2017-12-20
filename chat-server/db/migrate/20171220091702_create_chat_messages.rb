class CreateChatMessages < ActiveRecord::Migration
  def change
    create_table :chat_messages do |t|
    	t.integer :chat_id
    	t.text :message
    	t.integer :message_by
      	t.timestamps null: false
    end
  end
end
