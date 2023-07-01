class RecipeController < ApplicationController
    def index
        recipes = Recipe.all 
        if session[:user_id].present?
            render json: recipes, include: :user
        else
            render json: { errors: ["Unauthorized"] }, status: :unauthorized
        end
    end

    def create
        if session[:user_id].present?
          recipe = Recipe.new(recipe_params)
          recipe.user_id = session[:user_id]
      
          if recipe.save
            render json: recipe, include: { user: { only: [:username, :image_url, :bio] } }, status: :created
          else
            render json: { errors: recipe.errors.full_messages }, status: :unprocessable_entity
          end
        else
          render json: { errors: ["Unauthorized"] }, status: :unauthorized
        end
      end
      
      private
      
      def recipe_params
        params.permit(:title, :instructions, :minutes_to_complete)
      end
      
end
