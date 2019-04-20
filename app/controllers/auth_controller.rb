class AuthController < ApplicationController
  def callback
    puts params
    render json: 'This is the callback!'
  end
end
