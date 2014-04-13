class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_name(params[:name])
    if user and user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to admin_url, :flash => {:success => "Добро пожаловать, Александр!"}
    else
      redirect_to root_url, :flash => {:warning => "Ты кто такой? Давай, досвидания!"}
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :flash => {:info => "Счастливо и до встречи!"}
  end
end
