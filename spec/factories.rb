# -*- coding: utf-8 -*-

FactoryGirl.define do
  column = factory :column do
    name '行情'
  end

  factory :article do
    #columns {|a| [a.association(:column)] }
    #column_ids { [FactoryGirl.create(:column).id] }
    publisher '张三'
    sequence(:title) { |n| "测试标题-#{n}" }
    digest '测试摘要'
    content '测试内容'
    status 'published'
  end

end
