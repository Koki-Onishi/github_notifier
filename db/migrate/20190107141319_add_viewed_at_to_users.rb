# frozen_string_literal: true

class AddViewedAtToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :issue_viewd_at, :time
    add_column :users, :pr_viewd_at, :time
  end
end
