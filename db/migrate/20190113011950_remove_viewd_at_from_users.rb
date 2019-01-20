# frozen_string_literal: true

class RemoveViewdAtFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :issue_viewd_at, :time
    remove_column :users, :pr_viewd_at, :time
  end
end
