module ArticlesHelper

  def all_columns
    @columns = Column.all
  end

  def smart_h1(action_name)
    case action_name
    when 'banned' then t('article.banneds')
    when 'drafted' then  t('article.drafteds')
    when 'published' then  t('article.publisheds')
    when 'search' then t('article.searches')
    else
      t('article.all')
    end
  end

  def has_image_for?(article)
    not article.image.url(:thumb) =~ /missing.png$/
  end
end
