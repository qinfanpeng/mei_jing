# -*- coding: utf-8 -*-

class Admin::ArticlesController < ApplicationController
  before_filter :expire_actions, only: [:create, :destroy, :update, :ban, :draft, :publish, :batch_ban, :batch_draft, :batch_publish, :classify, :batch_classify]
  before_filter :get_article, only: [:show, :edit, :update, :destroy, :ban, :draft, :publish, :classify]
  before_filter :authenticate_user!
  
  caches_action :index, cache_path: Proc.new { |c| {page: c.params[:page]}  }
  caches_action :drafted, cache_path: Proc.new { |c| {page: c.params[:page] } }
  caches_action :banned, cache_path: Proc.new { |c| {page:c.params[:page]} }
  caches_action :published, cache_path: Proc.new { |c| {page: c.params[:page]} }

  respond_to :html, :json
  layout 'admin'

  load_and_authorize_resource

  def index
    @articles = Article.includes(:columns)
      .paginate(:page => params[:page], per_page: 10)
    respond_with @articles
  end

  def show
    @comments = @article.comments.all
    @comment = @article.comments.build
    respond_with(@article) #if stale?(:last_modified => @article.updated_at.utc, :etag => @article)
  end

  def new
    @article = Article.new
    respond_with @article
  end

  def edit; end

  def create
    @article = Article.new(params[:article])
    respond_with(@article) do |format|
      if @article.save
        flash[:notice] = t('article.flash.create.success')
        format.html { redirect_to [:admin, @article] }
      else
        flash[:error] = t('article.flash.create.error')
      end
    end
  end

  def drafted
    @articles = Article.drafted.includes(:columns)
      .paginate(:page => params[:page])
    render :index
  end

  def banned
    @articles = Article.banned.includes(:columns)
      .paginate(page: params[:page])
    render :index
  end

  def published
    @articles = Article.published.includes(:columns)
      .paginate(:page => params[:page])
    render :index
  end

  def update
    respond_with(@article) do |format|
      if @article.update_attributes(params[:article])
        flash[:notice] = t('article.flash.update.success')
        format.html { redirect_to [:admin, @article] }
      else
        flash[:error] = t('article.flash.update.error')
      end
    end
  end

  def destroy
    @article.destroy
    redirect_to admin_articles_url, notice: t('article.flash.destroy.success')
  end

  def ban
    @article.update_attributes(status: 'banned')
    redirect_to :back, notice: t('article.flash.ban.success')
  end

  def draft
    @article.update_attributes(status: 'drafted')
    redirect_to :back, notice: t('article.flash.draft.success')
  end

  def publish
    @article.update_attributes(status: 'published')
    redirect_to :back, notice: t('article.flash.publish.success')
  end
  def classify
    @article.update_attributes(column_ids: params[:column_ids])
    redirect_to :back, notice: t('article.flash.classify.success')
  end

  def batch_ban
    batch_action(params[:ids], :ban, 'status',  'banned')
  end

  def batch_destroy
    batch_action(params[:ids], :destroy)
  end

  def batch_draft
    batch_action(params[:ids], :draft, 'status', 'drafted')
  end

  def batch_publish
    batch_action(params[:ids], :publish, 'status', 'published')
  end

  def batch_classify
    if (not params[:column_ids].nil?)
      batch_action(params[:ids], :classify, 'column_ids', params[:column_ids])
    else
      flash[:error] = t('article.flash.classify.error')
    end
  end

  def search
    search = Article.search do
      fulltext params[:query] do
        boost_fields :title => 2.0
      end
      order_by :created_at, :desc
      paginate page: params[:page]
    end
    @articles = search.results
    render :index
  end


  private
  def batch_action(ids, action, attr=nil, value=nil)
    if need_batch_action?(ids)
      actions(ids, attr, value)
      flash[:notice] = t("article.flash.#{action}.success")
    else
      flash[:warning] = t("article.flash.#{action}.warning")
    end
    redirect_to :back
  end

  def need_batch_action?(ids)
    not ids.nil?
  end

  def actions(ids, attr, value)
    ids.each do |id|
      if attr
        Article.find(id).update_attributes(attr.to_sym => value)      # 利用send 动态调用方法
      else
        Article.find(id).destroy
      end
    end
  end

  def expire_actions
    admin_cache_path = /.*\/admin\/articles(|\/published|\/drafted|\/banned)(|\?page=\d+)$/
    foreground_cache_path = /.*(|columns\/\d+)\/articles(|\?page=\d+)$/

    expire_fragment(admin_cache_path)
    expire_fragment(foreground_cache_path)
  end

  def get_article
    @article = Article.find(params[:id])
  end
end
