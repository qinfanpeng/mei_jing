###-----------------------------------------
# form.js 是利用 client-side-validation
# 和 twitter-bootstrap-rails 这两个gem来
# 实现表达元素的 info, success, error三种状态
#-------------------------------------------
###
jQuery ->

  ###------------------------------------
  # 自定义focus_blur, 模仿hover函数而成
  # _focus为处理获得焦点事件的函数
  # _blur为处理失去焦点事件的函数
  # -------------------------------------
  ###
  jQuery.fn.focus_blur = (_focus, _blur)->
    _self = $(this)
    _focus = arguments[0]
    _blur = arguments[1]

    _self.each ->  # 遍历选中的类数组中的所有元素,并给它们绑定事件
      _this = $(this)
      _data_info = _this.attr('data-info') || ''
      @_control_group = _this.parents('.control-group')
      @_controls = _this.parents('.controls')
      ###
      # 下面两行分别是表单元素获得和失去焦点是显示的文本
      ###
      @_help_inline_info = $("<span class='help-inline info'>"+ _data_info + "</span>")
      @_help_inline_success = $("<span class='help-inline success'>输入有效</span>")
      _this.focus(_focus)
      _this.blur(_blur)

  _data_validate = $('form *[data-validate=true]') # 标记有validate=true的form下的所有表单元素
  _data_validate.focus_blur(->
    hide_notice(@_control_group, 'error', 'label.message')
    hide_notice(@_control_group, 'success', 'span.help-inline.success')
    show_notice(@_control_group, @_controls, 'info',
    @_help_inline_info, 'span.help-inline.info')
  ,
  ->
    hide_notice(@_control_group, 'info', 'span.help-inline.info')
    unless @_control_group.find('label.message').text() == ''
      show_notice(@_control_group, @_controls, 'error', null, 'label.message')
    else
      show_notice(@_control_group, @_controls, 'success',
      @_help_inline_success, 'span.help-inline.success')
    )

  ###----------------------------------------
  # 显示提示消息,同时完成表单三种状态
  # info, success, error的转换
  #----------------------------------------
  ###
  show_notice = (_control_group, _controls, to_add, to_append, to_show)->
    _control_group.addClass(to_add)
    _controls.append(to_append)
    _control_group.find(to_show).show()

  ###----------------------------------------
  # 隐藏提示消息 同时完成三种状态的转换
  #----------------------------------------
  ###
  hide_notice = (_target, to_rm, to_hide)->
    _target.removeClass to_rm
    _target.find(to_hide).hide()
