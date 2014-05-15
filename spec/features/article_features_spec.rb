# -*- coding: utf-8 -*-

require 'spec_helper'

feature "List all articles(published)" do
  background do
    @article1 = FactoryGirl.create(:article, status: 'published')
    @article2 = FactoryGirl.create(:article, status: 'banned')
    @article3 = FactoryGirl.create(:article, status: 'drafted')
    visit articles_path
  end
  scenario "all published articles are here" do
    page.should have_content @article1.title
    page.should_not have_content @article2.title
    page.should_not have_content @article3.title
  end
end

feature "List a column's articls" do
  background do
    @column1 = FactoryGirl.create(:column)
    @column2 = FactoryGirl.create(:column, name: '个股')

    @article1 = FactoryGirl.create(:article, column_ids: [@column1.id])
    @article2 = FactoryGirl.create(:article, column_ids: [@column2.id])

    visit articles_path
  end

  scenario "List all articles of a column" do
    click_link '行情'
    page.should have_content @article1.title
    page.should have_content @article1.digest
    page.should have_content I18n.localize(@article1.created_at)
    page.should_not have_content @article2.title

    click_link '个股'
    page.should have_content @article2.title
    page.should have_content @article2.digest
    page.should have_content I18n.localize(@article2.created_at)
    page.should_not have_content @article1.title
  end
end

feature "Show an article" do
  background do
    @article1 = FactoryGirl.create(:article)
    @article2 = FactoryGirl.create(:article)
    visit articles_path
  end

  scenario "Article's some detail infos are here" do
    click_link @article1.title

    page.should have_content @article1.title
    page.should have_content @article1.digest
    page.should have_content I18n.localize(@article1.created_at)
    page.should have_content @article1.content
  end
end
