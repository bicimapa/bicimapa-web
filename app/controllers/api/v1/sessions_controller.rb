module Api
  module V1
    class SessionsController < ActionController::Base
      def user_token_from_devise
        email = params[:email]
        password = params[:password]

        user = User.find_by_email(email)

        if user.valid_password?(password)
          render json:  {user: { token: user.token }}
        else
          render json:  {user: { token: "" }}
        end

      end

      def user_token_from_facebook_id
        facebook_id = params[:facebook_id]
        token = User.find_for_facebook_ios(facebook_id).token

        render json: {user: { token: token }}
      end
    end
  end
end
