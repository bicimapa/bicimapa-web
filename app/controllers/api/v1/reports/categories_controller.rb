module Api
  module V1
    module Reports
      class CategoriesController  < ActionController::Base
        def index
          @categories = ::Reports::Category.all
        end
      end
    end
  end
end
