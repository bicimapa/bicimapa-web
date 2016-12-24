class NewslettersController < ApplicationController

  layout 'devise'

  before_action :set_newsletter, only: [:unsubscribe, :destroy]

  def new
    @newsletter = Newsletter.new
  end

  # POST /newsletters
  def create
    @newsletter = Newsletter.new(newsletter_params)

    if @newsletter.save || @newsletter.errors.added?(:email, :taken)
      redirect_to :root, notice: t(:you_have_been_successfully_added_to_the_newsletter) 
    else
      render :new
    end
  end

  def unsubscribe
  end

  def destroy
    @newsletter.destroy
    redirect_to :root
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_newsletter
    require "base64"
    @newsletter = Newsletter.where(email: Base64.decode64(params[:email])).first
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def newsletter_params
    params.require(:newsletter).permit(:email)
  end
end
