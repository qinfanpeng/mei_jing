jQuery ->
  # 当点击存为草稿按钮时候， 修改status字段的值为draft
  $('#draft_btn').click ->
    $('#article_status').val('drafted')
