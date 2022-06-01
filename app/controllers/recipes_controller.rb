class RecipesController < ApplicationController
    rescue_from ActiveRecord::RecordInvalid, with: :invalid_record
        
        before_action :authorize
    
        def index
            # user = User.find_by(id: session[:user_id])
            recipes = Recipe.all
            render json: recipes, status: :created
        end
    
        def create
            # byebug
            user = User.find_by(id: session[:user_id])
            recipe = user.recipes.create!(recipe_params)
            render json: recipe, status: :created
        end
    
        private
    
        def authorize
            return render json: { errors: ["Not authorized"] }, status: :unauthorized unless session.include? :user_id
        end
    
        def recipe_params
            params.permit(:title, :instructions, :minutes_to_complete, :user_id)
        end
    
        def invalid_record(invalid)
            render json: {errors: invalid.record.errors.full_messages}, status: :unprocessable_entity
        end
    end