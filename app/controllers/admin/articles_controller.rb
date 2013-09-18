# -*- coding: utf-8 -*-
class Admin::ArticlesController < ApplicationController

  layout 'admin'
  def index
    @articles = Article.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @articles }
    end
  end

  def show
    @article = Article.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @article }
    end
  end

  def new
    @article = Article.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @article }
    end
  end

  def edit
    @article = Article.find(params[:id])
  end

  def create
    @article = Article.new(params[:article])
    respond_to do |format|
      if @article.save #and
        format.html { redirect_to [:admin, @article], notice: 'Article was successfully created.' }
        format.json { render json: @article, status: :created, location: @article }
      else
        format.html { render action: "new" }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def drafted
    @articles = Article.where(status: 'drafted')
    render :index
  end

  def banned
    @articles = Article.where(status: 'banned')
    render :index
  end

  def published
    @articles = Article.where(status: 'published')
    render :index
  end

  def update
    p "------"
    p params[:article][:column_ids]
    @article = Article.find(params[:id])
    respond_to do |format|
      if @article.update_attributes(params[:article])# and
        format.html { redirect_to [:admin, @article], notice: 'Article was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    destroy_article params[:id]
    respond_to do |format|
      format.html { redirect_to admin_articles_url }
      format.json { head :no_content }
    end
  end

  def ban
    ban_article params[:id]
    redirect_to :back
  end

  def draft
    draft_article params[:id]
    redirect_to :back
  end

  def publish
    publish_article params[:id]
    redirect_to :back
  end
  def classify
    id, _column_ids = params[:id], params[:column_ids]
    Article.find(id).update_attributes(column_ids: _column_ids)
    redirect_to :back
  end

  def batch_ban
    batch_action(params[:ids], :ban_article) if need_batch_action?(params[:ids])
    redirect_to :back
  end

  def batch_destroy
    batch_action(params[:ids], :destroy_article) if need_batch_action?(params[:ids])
    redirect_to :back
  end

  def batch_draft
    batch_action(params[:ids], :draft_article) if need_batch_action?(params[:ids])
    redirect_to :back
  end

  def batch_classify
    ids, _column_ids = params[:ids], params[:column_ids]
    if need_batch_action?(ids) and _column_ids.size > 0
      ids.each do |id|
        Article.find(id).update_attributes(column_ids: _column_ids)
      end
    end
    redirect_to :back
  end

  def batch_publish
    batch_action(params[:ids], :publish_article) if need_batch_action?(params[:ids])
    redirect_to :back
  end

  private
  def batch_action(ids, action)
    ids.each do |id|
      send action, id      # 利用send 动态调用方法
    end
  end

  def need_batch_action?(ids)
    not ids.nil?
  end

  def ban_article(id)
    @article = Article.find(id)
    @article.update_attributes({status: 'banned'})
  end

  def destroy_article(id)
    @article = Article.find(id)
    @article.destroy
  end

  def draft_article(id)
    @article = Article.find(id)
    @article.update_attributes({status: 'drafted'})
  end

  def publish_article(id)
    @article = Article.find(id)
    @article.update_attributes({status: 'published'})
  end
end
