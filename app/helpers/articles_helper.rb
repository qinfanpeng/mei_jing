module ArticlesHelper

  def all_columns
    @columns = Column.all
  end

  def smart_h1(action_name)
    case action_name
    when 'banned' then content_tag :h1, t('article.banneds')
    when 'drafted' then content_tag :h1, t('article.drafteds')
    when 'published' then content_tag :h1, t('article.publisheds')
    when 'search' then content_tag :h1, t('article.searches')
    else
      content_tag :h1, t('article.all')
    end
  end

  def has_image_for?(article)
    not article.image.url(:thumb) =~ /missing.png$/
  end
end
