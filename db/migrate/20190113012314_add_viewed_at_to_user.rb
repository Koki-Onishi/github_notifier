class AddViewedAtToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :issue_viewed_at, :datetime
    add_column :users, :pr_viewed_at, :datetime
  end
end
