module Api
  module V1
    class UsersController  < ActionController::Base
      def show
        @user = User.find_by_token(params[:token])
      end
    end
  end
end
