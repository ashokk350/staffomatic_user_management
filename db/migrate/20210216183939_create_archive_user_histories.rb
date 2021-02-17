class CreateArchiveUserHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :archive_user_histories do |t|
      t.references :user
      t.integer :archived_by
      t.boolean :archived

      t.timestamps
    end
  end
end
