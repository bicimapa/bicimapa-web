module Api
  module V1
    class CategoriesController  < ActionController::Base
      def index
        @categories = Category.where('is_active = ?', true).all
      end
    end
  end
end
