class Category < ApplicationRecord
  has_many :article_categories
  has_many :articles, through: :article_categories

  validates :name, presence: true, uniqueness: true, length: { minimum: 2, maximum: 25 }

  # Manual destruction of associated records
  before_destroy :destroy_article_categories

  private

  def destroy_article_categories
    article_categories.each(&:destroy)
  end
end
