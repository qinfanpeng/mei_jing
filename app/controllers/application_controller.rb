class ApplicationController < ActionController::Base
  protect_from_forgery

  layout 'admin'
  
  private
  def admin?
    request.fullpath =~ /^\/admin/
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = t('cancan.flash.cannot')
    redirect_to root_url
  end

end
