class RemoveDescriptionFromQuests < ActiveRecord::Migration[8.0]
  def change
    remove_column :quests, :description, :text
  end
end
