Rails.application.routes.draw do
  get 'user/get_user'

  get 'user/get_tweets'

  get 'user/get_images'

  get 'home/index'
  root 'home#index'

end
