class RenameIssueViewdAtColumnToIssueViewedAt < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :issue_viewd_at, :issue_viewed_at
    rename_column :users, :pr_viewd_at, :pr_viewed_at
  end
end
