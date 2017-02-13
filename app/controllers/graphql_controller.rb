class GraphqlController < ApplicationController

  skip_before_action :verify_authenticity_token

  def execute
    result_hash = Schema.execute(params[:query], variables: params[:variables])
    render json: result_hash
  end

end
