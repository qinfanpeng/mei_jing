# -*- coding: utf-8 -*-
require 'spec_helper'

describe Admin::ArticlesController do
  # 调用devise的helper方法 sign_in, 需要在spec_helper.rb 中引入
  # config.include Devise::TestHelpers, :type => :controller
  before {sign_in(create(:user))}

  describe "GET #index" do
    context "with params[:page]" do
      it "populate an array of aritcles in the page" do
        article1 = create(:article, title: 'title1')
        article2 = create(:article, title: 'title2')

        get :index, page: 1
        expect(assigns(:articles)).to match_array([article1, article2])

        get :index, page: 2
        expect(assigns(:articles)).to match_array([])
      end
      it "renders the index template" do
        get :index, page: 1
        expect(response).to render_template :index
      end
    end
    context "without params[:page]" do
      it "populate an array of aritcles" do
        article1 = create(:article, title: 'title1')
        article2 = create(:article, title: 'title2')
        get :index
        expect(assigns(:articles)).to match_array([article1, article2])
      end
      it "renders the index template" do
        get :index
        expect(response).to render_template :index
      end
    end
  end

  describe "GET #show" do
    let(:article) { create(:article) }
    before { get :show, id: article }

    it "assigns the requested article to @article" do
      expect(assigns(:article)).to eq article
    end
    it "renders the show template" do
      expect(response).to render_template :show
    end
  end

  describe "GET #new" do
    before { get :new }
    it "assigns a new article to @article" do
      expect(assigns(:article)).to be_a_new(Article)
    end
    it "renders the new template" do
      expect(response).to render_template :new
    end
  end

  describe "GET #edit" do
    before do
      @article = create(:article)
      get :edit, id: @article
    end
    it "assigns requested article to @article" do
      expect(assigns(:article)).to eq @article
    end
    it "renders the edit template" do
      expect(response).to render_template :edit
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "save the new created article to database" do
        expect{
          post :create, article: attributes_for(:article)
        }.to change(Article, :count).by(1)
      end
      it "redirects to the show template" do
        post :create, article: attributes_for(:article)
        expect(response).to redirect_to [:admin, assigns(:article)]
      end
      it "flash message is '文章发布成功'" do
        post :create, article: attributes_for(:article)
        expect(flash[:notice]).to eq '文章发布成功'
      end
    end
    context "with invalid attributes" do
      it "does not save the new  article to database" do
        expect{
          post :create, article: attributes_for(:invalid_article)
        }.to_not change(Article, :count)
      end
      it "re-renders the new template" do
        post :create, article: attributes_for(:invalid_article)
        expect(response).to render_template :new
      end
      it "flash message is '文章发布失败'" do
        post :create, article: attributes_for(:invalid_article)
        expect(flash[:error]).to eq '文章发布失败'
      end
    end
  end

  describe "PUT #update" do
    context "with valid attributes" do
      before do
        @article = create(:article)
        put :update, id: @article, article: attributes_for(:article, title: 'test_title')
      end
      it "loacted the requested article to @article" do
        expect(assigns(:article)).to eq @article
      end
      it "changes articles attributes" do
        @article.reload
        expect(@article.title).to eq 'test_title'
      end
      it "redirects to the updated article" do
        @article.reload
        expect(response).to redirect_to [:admin, @article]
      end
      it "flash messiage is '文章更新成功'" do
        expect(flash[:notice]).to eq '文章更新成功'
      end
    end
    context "with invalid attributes" do
      before do
        @article = create(:article)
        put :update, id: @article, article: attributes_for(:invalid_article, publisher: 'jason')
      end
      it "does not change articles attributes" do
        @article.reload
        expect(@article.publisher).to_not eq 'jason'
      end
      it "re-renders to the edit template" do
        expect(response).to render_template :edit
      end
      it "flash messiage is '文章更新失败'" do
        expect(flash[:error]).to eq '文章更新失败'
      end
    end
  end

  describe "DELETE #destroy" do
    before { @article = create(:article) }
    it "delete the requested article" do
      expect{
        delete :destroy, id: @article
      }.to change(Article, :count).by(-1)
    end
    it "redirects to articles index "do
      delete :destroy, id: @article
      expect(response).to redirect_to admin_articles_path
    end
  end
=begin
  describe "GET #search" do
    context "with params[:query]" do
      it "populate an array of aritcles with params[:query]" do
        article1 = create(:article, title: 'test_title')
        article2 = create(:article, title: 'hello world')

        get :search, query: 'hello world'
        expect(assigns(:articles)).to match_array([article2])
      end
      it "renders the index template" do
        get :search, query: 'hello world'
        expect(response).to render_template :index
      end
    end
    context "without params[:query]" do
      it "populate an array of aritcles with params[:query]" do
        article1 = create(:article, title: 'test_title')
        article2 = create(:article, title: 'hello world')

        get :search
        expect(assigns(:articles)).to match_array([article1, article2])
      end
      it "renders the index template" do
        get :search, query: 'hello world'
        expect(response).to render_template :index
      end
    end
  end
=end
  describe "POST #ban" do
    before do
      request.env['HTTP_REFERER'] = admin_articles_url
      @article = create(:article)
      post :ban, id: @article
    end
    it "banns the requested article" do
      @article.reload
      expect(@article.status).to eq 'banned'
    end
    it "redirects to :back" do
      expect(response).to redirect_to admin_articles_url
    end
    it "flash message is '文章屏蔽成功'" do
      expect(flash[:notice]).to eq '文章屏蔽成功'
    end
  end

  describe "POST #batch_ban" do
    context "with params[:ids]" do
      before do
        request.env['HTTP_REFERER'] = admin_articles_url
        @article1 = create(:article)
        @article2 = create(:article)
        post :batch_ban, ids: [@article1.id, @article2.id]
      end
      it "banns all the requested articles" do
        @article1.reload
        @article2.reload
        expect(@article1.status).to eq 'banned'
        expect(@article2.status).to eq 'banned'
      end
      it "renders :back" do
        expect(response).to redirect_to admin_articles_url
      end
      it "flash message is '文章屏蔽成功'" do
        expect(flash[:notice]).to eq '文章屏蔽成功'
      end
    end
    context "without params[:ids]" do
      before do
        request.env['HTTP_REFERER'] = admin_articles_url
        @article = create(:article)
        post :batch_ban
      end
      it "does not ban any  article" do
        @article.reload
        expect(@article.status).to_not eq 'banned'
      end
      it "renders :back" do
        expect(response).to redirect_to admin_articles_url
      end
      it "flash message is '没有选择需要屏蔽的文章'" do
        expect(flash[:warning]).to eq '没有选择需要屏蔽的文章'
      end
    end
  end
end
