class ApplicationController <  ActionController::Base
  respond_to :html

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_filter :authenticate_user!
  protect_from_forgery with: :exception

  def index
  	render text: "Welcome to Bat Conseil Application", layout: 'application'
  end

end
