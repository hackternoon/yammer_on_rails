# config/initializers/omniauth.rb
# See https://github.com/intridea/omniauth
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer # unless Rails.env.production?
  provider :yammer, ENV['YAMMER_KEY'], ENV['YAMMER_SECRET']
end
