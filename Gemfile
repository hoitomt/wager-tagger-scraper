source 'https://rubygems.org'
ruby '2.4.1'

gem 'rails', '~> 4.2.0'
gem 'rails-api'
gem 'pg', '~> 0.20.0'
gem 'nokogiri', '~> 1.8.0'
gem 'rack-cors', require: 'rack/cors'
gem 'puma', '~> 3.10.0'
gem 'active_model_serializers', '~> 0.10.0'

group :development do
  gem 'spring'
  gem 'foreman'
end

group :development, :test do
  gem 'rspec-rails', '~> 3.6.1'
  gem "factory_girl_rails", "~> 4.0"
  gem 'spin', '~> 0.7.0'
  gem 'byebug', '~> 9.1.0'
end

group :production do
  gem 'rails_12factor'
end
