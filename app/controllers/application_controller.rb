class ApplicationController < ActionController::Base
  protect_from_forgery

  layout 'admin'
  
  private
  def admin?
    request.fullpath =~ /^\/admin/
  end

end
