class AuthorizationsController < ApplicationController
  def new; end

  def create
    @authorization = Authorization.generate(provider: session[:auth]['provider'],
                                            uid: session[:auth]['uid'],
                                            email: params[:email])

    sign_in_and_redirect @authorization.user, event: :authentication
  end
end
