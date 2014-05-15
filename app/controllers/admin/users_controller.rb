# -*- coding: utf-8 -*-
class Admin::UsersController < ApplicationController

  before_filter :get_user, only: [:show, :edit, :update, :destroy]
  #before_filter :authenticate_user!
  
  respond_to :html, :json
  layout 'admin'

  def index
    @users = User.paginate(:page => params[:page])
    respond_with @users
  end

  def show
    respond_with(@user)
  end

  private
  def get_user
    @user = User.find(params[:id])
  end


end
