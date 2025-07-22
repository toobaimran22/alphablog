class AddApprovedAndPublishedToArticles < ActiveRecord::Migration[8.0]
  def change
    add_column :articles, :approved, :boolean
    add_column :articles, :published, :boolean
  end
end
