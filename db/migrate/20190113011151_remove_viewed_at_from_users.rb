class RemoveViewedAtFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :issue_viewed_at, :time
    remove_column :users, :pr_viewed_at, :time
  end
end
