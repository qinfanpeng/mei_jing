class ApplicationController < ActionController::Base
  protect_from_forgery

  private
  def admin?
    request.fullpath =~ /^\/admin/
  end

end
