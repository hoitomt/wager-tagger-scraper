source 'https://rubygems.org'
ruby '2.1.2'

gem 'rails', '4.1.0'
gem 'rails-api'
gem 'pg'
gem 'nokogiri'
gem 'pry'
gem 'pry-nav'
gem 'rack-cors', require: 'rack/cors'
gem 'puma'
gem 'active_model_serializers', '~> 0.10.0.rc2'

group :development do
  gem 'spring'
  gem 'foreman'
end

group :development, :test do
  gem 'rspec-rails', '~> 3.0.0'
  gem "factory_girl_rails", "~> 4.0"
  gem 'spin'
end

group :production do
  gem 'rails_12factor'
end
