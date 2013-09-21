# -*- coding: utf-8 -*-

require 'spec_helper'

feature "Publish article" do
  background do
    FactoryGirl.create(:column)
    visit "/admin/articles/write"
    fill_in '发布人', with: '张三'
    fill_in '标题', with: '测试标题'
    fill_in '摘要', with: '测试摘要'
    fill_in '正文', with: '测试正文'
  end
  scenario "Publish with all necessary data" do
    check "行情"
    click_button '发布'
    expect(page).to have_content '文章发布成功'
    expect(page).to have_content '行情'
  end
  scenario "Publish without some necessary data" do

    click_button '发布'
    expect(page).to have_content '文章发布失败'
  end
end

feature "Update article" do
  background do
    @article = FactoryGirl.create(:article)
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
