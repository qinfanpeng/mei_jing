# -*- coding: utf-8 -*-

require 'spec_helper'

feature "Publish article" do
  background do
    Column.create!(name: '行情')
  end
  scenario "Publish with all necessary data" do
    visit "/admin/articles/write"
    check "行情"
    fill_in '发布人', with: '张三'
    fill_in '标题', with: '测试标题'
    fill_in '摘要', with: '测试摘要'
    fill_in '正文', with: '测试正文'

    click_button '发布'
    expect(page).to have_content '文章发布成功'
  end
end
