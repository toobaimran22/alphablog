class Article < ApplicationRecord
  belongs_to :user

  has_many :article_categories
  has_many :categories, through: :article_categories

  
  before_destroy :destroy_article_categories

  private

  def destroy_article_categories
    article_categories.each(&:destroy)
  end
end
