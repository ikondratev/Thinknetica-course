class AuthorizationsController < ApplicationController
  def new; end

  def create
    @authorization = Authorization.generate(provider: session[:auth]['provider'],
                                            uid: session[:auth]['uid'],
                                            email: params[:email])
    success_omniauth_login(@authorization.user, @authorization.provider.capitalize)
  end
end
