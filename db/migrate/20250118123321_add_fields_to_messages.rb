class AddFieldsToMessages < ActiveRecord::Migration[8.0]
  def change
    add_column :messages, :json_content, :string, default: ""
    add_column :messages, :scene_number, :integer, default: 0
    add_column :messages, :transition, :integer, default: 0
  end
end
