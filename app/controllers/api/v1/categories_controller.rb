module Api
  module V1
    class CategoriesController < ApplicationController
      before_action :set_category, only: %i[show update destroy]
      before_action :require_admin, except: %i[index show]

      def index
        render json: Category.all
      end

      def show
        render json: @category
      end

      def create
        category = Category.new(category_params)
        if category.save
          render json: category, status: :created
        else
          render_errors(category)
        end
      end

      %i[update destroy].each do |action|
        define_method(action) do
          success = case action
                    when :update
                      @category.update(category_params)
                    when :destroy
                      @category.destroy
                    end

          if success
            render json: (action == :update ? @category : { message: "Category deleted" })
          else
            render_errors(@category)
          end
        end
      end

      private

      def set_category
        @category = Category.find(params[:id])
      end

      def category_params
        params.require(:category).permit(:name)
      end

      def require_admin
        unless current_user&.admin_role?
          render json: { error: "Only admins can perform that action" }, status: :forbidden
        end
      end

      def render_errors(resource)
        render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end
end
