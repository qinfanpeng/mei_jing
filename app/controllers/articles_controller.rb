class ArticlesController < ApplicationController

  caches_action :index, cache_path: Proc.new { |c| {page: c.params[:page]}  }
  caches_action :belong_to_column, cache_path: Proc.new { |c| {page: c.params[:page]}  }

  layout 'frontend'

  def index
    @articles = Article.published.includes(:columns)
      .paginate(:page => params[:page], per_page: 8)

    respond_to do |format|
      format.html
      format.json { render json: @articles }
    end
  end

  def show
    @article = Article.find(params[:id])
    if stale?(:last_modified => @article.updated_at.utc, :etag => @article)
      respond_to do |format|
        format.html
        format.json { render json: @article }
      end
    end
  end

  def belong_to_column
    @column = Column.find(params[:id])
    @articles = @column.articles
      .published
      .paginate(:page => params[:page], per_page: 8)
    render :index
  end
end
