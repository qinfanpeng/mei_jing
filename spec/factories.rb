# -*- coding: utf-8 -*-

FactoryGirl.define do
  column = factory :column do
    name '行情'
  end

  factory :article do
    columns {|a| [a.association(:column)] }
    publisher '张三'
    title '测试标题'
    digest '测试摘要'
    content '测试内容'
    status 'published'
  end

end
