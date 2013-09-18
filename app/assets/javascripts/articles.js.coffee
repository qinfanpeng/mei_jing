jQuery ->

  # 写文章时，当点击存为草稿按钮时候， 修改status字段的值为draft
  $('#draft_btn').click ->
    $('#article_status').val('drafted')

  # 全选和取消全选
  $('#article_check_all').click ->
    unless $(this).attr('checked')
      $(this).attr('checked', 'true')
      $('input.article_ids').each ->
        $(this).click()
    else
      $(this).removeAttr('checked')
      $('input.article_ids').each ->
        $(this).click()

  # 提交批量操作表单的函数
  submit_article_batch_form = (action)->
    form = $('#article_batch_form')
    form.attr('action', action)
    form.submit()


  $(".form-actions-batch a.btn").click ->
    submit_article_batch_form $(this).attr('href')
    return false

  $("ul.dropdown-menu-admin li a input").click (e)->
    e.stopPropagation()

  $("ul.dropdown-menu-admin li a").click (e) ->
    $(this).find('input').click()
    return false

  $('.classify_batch_ok').click ->
    submit_article_batch_form $(this).attr('href')
    return false

  $('.classify_ok').click ->
    form = $('.classify_form').submit()
    return false
