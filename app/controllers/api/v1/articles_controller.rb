module Api
  module V1
    class ArticlesController < ApplicationController
      before_action :set_article, only: [:show, :update, :destroy, :approve, :publish]
      before_action :require_user, except: [:index, :show]
      before_action :require_same_user, only: [:update, :destroy]

      def index
        authorize Article if current_user
        articles = policy_scope(Article).includes(:categories, :user)
        if params[:published].present?
          articles = articles.where(published: params[:published] == 'true')
        end
        render json: articles.as_json(include: [:user, :categories])
      end

      def my_articles
        @articles = current_user.articles.includes(:categories, :user)
        render json: @articles.as_json(include: [:user, :categories])
      end

      def show
        render json: @article.as_json(include: [:user, :categories])
      end

      def create
        @article = current_user.articles.build(article_params)
        authorize @article
        
        @article.approved = false
        @article.published = false
        if @article.save
          render json: @article.reload.as_json(include: [:user, :categories]), status: :created
        else
          render json: { errors: @article.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        authorize @article
       
        if current_user.writer_role?
          @article.approved = false
          @article.published = false
        end
        if @article.update(article_params)
          render json: @article.reload.as_json(include: [:user, :categories])
        else
          render json: { errors: @article.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        authorize @article
        @article.destroy
        head :no_content
      end

  
      %w[approve publish].each do |action|
        define_method(action) do
          article = Article.find(params[:id])
          authorize article, "#{action}?".to_sym if action == "publish"
          if article.update("#{action}ed": true)
            if action == "publish"
              render json: { message: "Article published successfully" }
            else
              render json: article, status: :ok
            end
          else
            if action == "publish"
              render json: { errors: article.errors.full_messages }, status: :unprocessable_entity
            else
              render json: { error: "Unable to approve article" }, status: :unprocessable_entity
            end
          end
        end
      end

      private

      def set_article
        @article = Article.includes(:categories, :user).find(params[:id])
      end

      def article_params
        params.require(:article).permit(:title, :description, category_ids: [])
      end

      def require_user
        unless current_user
          render json: { error: "You must be logged in" }, status: :unauthorized
        end
      end

      def require_same_user
        if current_user.writer_role? && current_user != @article.user
          render json: { error: "You can only edit your own articles" }, status: :forbidden
        end
      end
    end
  end
end
