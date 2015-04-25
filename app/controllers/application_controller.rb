class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.


  before_filter :authenticate_user_from_token!
   private

  # To make authentication mechanism more safe,
  # require an access_token and a user_email.
  def authenticate_user_from_token!
    user_email = params[:user_email].presence
    user       = user_email && User.find_by_email(user_email)

    # Use Devise.secure_compare to compare the access_token
    # in the database with the access_token given in the params.
    if user && Devise.secure_compare(user.access_token, params[:access_token])

      # Passing store false, will not store the user in the session,
      # so an access_token is needed for every request.
      # If you want the access_token to work as a sign in token,
      # you can simply remove store: false.
      sign_in user, store: false
    end
  end
  protect_from_forgery with: :null_session
end
