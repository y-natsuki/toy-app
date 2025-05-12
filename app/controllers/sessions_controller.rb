class SessionsController < ApplicationController
  def new
  end

# app/controllers/sessions_controller.rb
def create
  user = User.find_by(email: params[:session][:email].downcase)
  if user && user.authenticate(params[:session][:password])
    # 1. 転送先のURLを、セッションリセット前にローカル変数に確実に取得します
    intended_url = session[:forwarding_url]

    # 2. セッションをリセットします (セキュリティのため、ログイン直前に行うのが一般的です)
    reset_session

    # 3. 新しいセッションでユーザーをログインさせます
    log_in user

    # 4. 「Remember me」チェックボックスの処理を行います
    params[:session][:remember_me] == '1' ? remember(user) : forget(user)

    # 5. 記憶していたURL、またはデフォルトのURLにリダイレクトします
    if intended_url
      redirect_to intended_url
    else
      redirect_to user # デフォルトはユーザーページへ
    end
  else
    flash.now[:danger] = 'Invalid email/password combination'
    render 'new', status: :unprocessable_entity
  end
end

  def destroy
    log_out
    log_out if logged_in?
    redirect_to root_url, status: :see_other
  end
end
