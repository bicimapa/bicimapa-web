module Api
  module V1
    module Reports
      class SubCategoriesController  < ActionController::Base
        def index
          @sub_categories = ::Reports::SubCategory.where(category_id: params[:id])
        end
      end
    end
  end
end
