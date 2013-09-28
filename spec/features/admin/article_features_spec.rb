# -*- coding: utf-8 -*-

require 'spec_helper'

feature "Publish article" do
  background do
    create(:column, name: '行情')
    @banned_article = create(:article, status: 'banned')
    @drafted_article = create(:article, status: 'drafted')
  end
  scenario "Publish with all necessary data" do
    visit "/admin/articles/write"
    check "行情"
    fill_in '发布人', with: '张三'
    fill_in '标题', with: '测试标题'
    fill_in '摘要', with: '测试摘要'
    fill_in '正文', with: '测试正文'

    click_button '发布'
    page.should have_content '文章发布成功'
    page.should have_content '行情'
  end
  scenario "Publish without some necessary data" do
    visit "/admin/articles/write"

    fill_in '标题', with: '测试标题'
    fill_in '摘要', with: '测试摘要'
    fill_in '正文', with: '测试正文'

    click_button '发布'
    page.should have_content '文章发布失败'
  end
  scenario "Publish a banned article" do
    visit admin_article_path(@banned_article)
    click_button '发布', match: :first
    page.should have_content '文章发布成功'
    page.should have_content '已发布'
  end
  scenario "Publish a drafted article" do
    visit admin_article_path(@drafted_article)
    click_button '发布', match: :first
    page.should have_content '文章发布成功'
    page.should have_content '已发布'
  end
  scenario "Publish a batch of articles", js: true do
    visit admin_articles_path
    page.all('tr').size.should == 3
    page.all('tr', text: '已发布').size.should == 0
    find(:css, ".article_ids[value='#{@banned_article.id}']").set(true)
    find(:css, ".article_ids[value='#{@drafted_article.id}']").set(true)

    click_link '发布', match: :prefer_exact

    page.all('tr', text: '已发布').size.should == 2
    page.should have_content '文章发布成功'
  end
end


feature "Update article" do
  background do
    @article = create(:article)
    visit edit_admin_article_path(@article)
  end
  scenario "Update with valid data" do
    fill_in '发布人', with: '李四'

    click_button '更新文章'
    expect(page).to have_content '文章更新成功'
    expect(page).to have_content '李四'
  end
  scenario "Update with invalid data" do
    fill_in '发布人', with: ''

    click_button '更新文章'
    expect(page).to have_content '文章更新失败'
  end
end


feature "Ban article" do
  background do
    @article = create(:article)
    @another_article = create(:article)
  end

  scenario "Ban an article"do
    visit admin_article_path(@article)
    click_button '屏蔽', match: :first

    page.should have_content '文章屏蔽成功'
    page.should have_content '已屏蔽'
  end
  scenario "Ban a batch of articles", js: true do
    visit published_admin_articles_path
    page.all('tr', text: '已发布').size.should == 2

    find(:css, ".article_ids[value='#{@article.id}']").set(true)
    find(:css, ".article_ids[value='#{@another_article.id}']").set(true)
    click_link '屏蔽', match: :prefer_exact

    page.all('tr', text: '已发布').size.should == 0
    page.should have_content '文章屏蔽成功'
  end
end

feature "Delete article" do
  background do
    @article = create(:article)
    @another_article = create(:article)
  end
  scenario "Delete an article" do
    visit admin_article_path(@article)
    click_button '删除', match: :first

    page.should have_content '文章删除成功'
    page.all('tr', text: @article.title).size.should == 0
  end
  scenario "Delete a batch of articles", js: true do
    visit admin_articles_path
    find(:css, ".article_ids[value='#{@article.id}']").set(true)
    find(:css, ".article_ids[value='#{@another_article.id}']").set(true)
    page.all('tr').size.should == 3
    click_link '删除', match: :first

    page.all('tr').size.should == 1
    page.should have_content '文章删除成功'
  end
end


feature "Draft article"do
  background do
    @article = create(:article)
    @another_article = create(:article)
  end
  scenario "Draft an article" do
    visit admin_article_path(@article)
    click_button '存为草稿', match: :first

    page.should have_content '文章存为草稿成功'
    page.should have_content '草稿'
  end
  scenario "Draft a batch of articles", js: true do
    visit published_admin_articles_path
    page.all('tr', text: '已发布').size.should == 2

    find(:css, ".article_ids[value='#{@article.id}']").set(true)
    find(:css, ".article_ids[value='#{@another_article.id}']").set(true)
    click_link '存为草稿', match: :first

    page.all('tr', text: '已发布').size.should == 0
    page.should have_content '文章存为草稿成功'
  end
end

feature "Classify article to columns", js: true do
  background do
    @article = create(:article)
    @another_article = create(:article)
    @column1 = create(:column, name: '个股')
    @column2 = create(:column, name: '行情')
  end

  scenario "Classify an article to a column" do
    visit admin_article_path(@article)
    click_button '归属到', match: :first
    find(:css, "#column_ids_[value='#{@column1.id}']").set(true)
    click_link '确认'

    page.should have_content '个股'
    page.should have_content '文章归属到所选栏目成功'
  end
  scenario "Classify an article to many columns" do
    visit admin_article_path(@article)
    click_button '归属到', match: :first
    find(:css, "#column_ids_[value='#{@column1.id}']").set(true)
    find(:css, "#column_ids_[value='#{@column2.id}']").set(true)
    click_link '确认'

    page.should have_content '个股,行情'
    page.should have_content '文章归属到所选栏目成功'
  end
  scenario "Classify a batch of articles to many columns" do
    visit published_admin_articles_path
    page.all('tr', text: '行情,个股').size.should == 0
    find(:css, ".article_ids[value='#{@article.id}']").set(true)
    find(:css, ".article_ids[value='#{@another_article.id}']").set(true)

    click_button '归属到', match: :first
    find(:css, "#column_ids_[value='#{@column1.id}']").set(true)
    find(:css, "#column_ids_[value='#{@column2.id}']").set(true)   # 同时选择多个check_box 的语法

    click_link '确认'
    page.all('tr', text: '个股,行情').size.should == 2
    page.should have_content '文章归属到所选栏目成功'
  end
end

feature "List all published articles" do
  background do
    @article = create(:article, status: 'published')
    @another_article = create(:article, status: 'published')
    visit published_admin_articles_path
  end
  scenario "All published articles are here" do
    page.all('tr', text: '已发布').size.should == 2
  end
end

feature "List all banned articles" do
  background do
    @article = create(:article, status: 'banned')
    @another_article = create(:article, status: 'banned')
    visit banned_admin_articles_path
  end
  scenario "All banned articles are here" do
    page.all('tr', text: '已屏蔽').size.should == 2
  end
end

feature "List all drafted articles" do
  background do
    @article = create(:article, status: 'drafted')
    @another_article = create(:article, status: 'drafted')
    visit drafted_admin_articles_path
  end
  scenario "All drafted articles are here" do
    page.all('tr', text: '草稿').size.should == 2
  end
end

feature "List all articles" do
  background do
    @article1 = create(:article, status: 'banned')
    @article2 = create(:article, status: 'published')
    @article2 = create(:article, status: 'drafted')
    visit admin_articles_path
  end
  scenario "All articles are here" do
    page.all('tr', text: '已屏蔽').size.should == 1
    page.all('tr', text: '已发布').size.should == 1
    page.all('tr', text: '草稿').size.should == 1
  end
end
