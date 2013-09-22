# -*- coding: utf-8 -*-
require 'colorize'

p "----create columns---------------"
columns = [
  {name: '行情'},
  {name: '个股'}
]

columns.each do |attr|
  Column.find_or_initialize_by_name(attr[:name]).tap do |column|
    column.save!
  end
end
puts "-----2 clumns successfuly added----".green

p "----create articles---------------"
Article.delete_all

status_a = %w[published banned drafted]
column_ids = %w[Column.first.id, Column.last.id]

a_real_digest = <<END
投资者可以在十一月份的改革红利的利好兑现前，在操作上面可以更加的积极。特别是对于一些与改革
END

a_real_content = File.open("#{Rails.root}/db/a_real_article_content.txt", 'r') {|f| f.read }

Article.create!({
    column_ids: [first_column_id, last_column_id],
    publisher: '李四',
    title: "后市看点：三大因素决定节后走势？",
    digest: a_real_digest,
    content: a_real_content,
    status: 'published'
    })

11.times do |i|
  Article.create!({
      column_ids: column_ids.sample,
      publisher: '张三',
      title: "标题-#{i}",
      digest: "摘要-#{i}",
      content: "内容-#{i}",
      status: status_a.sample
    })
end

puts "----21 articles successfuly added----".green
