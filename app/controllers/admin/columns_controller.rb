class Admin::ColumnsController < ApplicationController

  layout 'admin'
  respond_to :html, :json

  after_filter :expire_column_framents, only: [:create, :update, :destroy]
  before_filter :get_column, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!
  
  load_and_authorize_resource
  
  def index
    @columns = Column.paginate(:page => params[:page])
    respond_with(@columns)
  end

  def show
    respond_with(@column)
  end
  def new
    @column = Column.new
    respond_with(@column)
  end

  def edit
  end

  def create
    @column = Column.new(params[:column])
    flash[:notice] = 'Column was successfully created.' if @column.save
    respond_with(@column)
  end

  def update
    flash[:notice] = 'Column was successfully updated.' if @column.update_attributes(params[:column])
    respond_with(@column)
  end

  def destroy
    @column.destroy
    respond_with(@column)
  end

  private
  def expire_column_framents
    expire_fragment :columns
  end
  def get_column
    @column = Column.find(params[:id])
  end

end
