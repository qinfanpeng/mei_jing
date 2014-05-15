# -*- coding: utf-8 -*-
def sign_in_with(user)
  visit new_user_session_path
  fill_in '邮箱地址',  with: user.email
  fill_in '密码',   with: user.password
  click_button '登录'
end
