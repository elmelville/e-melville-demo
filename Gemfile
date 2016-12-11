source 'https://rubygems.org'
ruby "2.3.1"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.0', '>= 5.0.0.1'

gem 'activeresource', github: 'rails/activeresource'

# Use Puma as the app server
gem 'puma', '~> 3.0'

group :assets do
    gem 'sass-rails'
      gem 'coffee-rails'
        gem 'uglifier'
end

gem 'jquery-rails'

gem "rails_apps_composer", :git => "git://github.com/lastobelus/rails_apps_composer.git", :branch => "devcloudcoder"

gem "thin"

gem "haml"

gem "email_spec", :group => :test

gem "cucumber-rails", :group => :test, :require => false

gem "database_cleaner", :group => :test

gem "launchy", :group => :test

gem "capybara", :group => :test

gem "compass-rails", :group => :assets

gem "zurb-foundation", :group => :assets

gem "simple_form"

gem "shopify_app"

gem "nokogiri"

gem "log4r"

gem "kaminari"

gem "pg"
gem "config_spartan"
gem "active_shipping"
gem 'activemerchant'
gem "unicorn"
gem "typhoeus"
gem "net-http-persistent"

# aus_controller_development branch added these
gem "activerecord-postgresql-adapter"
gem "httparty"
gem "rack-cors", :require => 'rack/cors'


# gem 'rufus-decision', git: 'https://github.com/lastobelus/rufus-decision.git', branch: 'short_circuit_matchers'
gem 'rufus-decision', :git => 'https://github.com/jmettraux/rufus-decision.git'
gem 'rudelo'

gem 'memcachier'
gem 'kgio' # improves performance of dalli
gem 'dalli' # memcached client
gem 'shydra'
# gem 'shydra', path: "/Users/lasto/clients/lasto/shydra"
gem 'oj' # fast json parser, but mainly to make multi_json stfu

# allows use of limit: false in ShopifyAPI calls
gem 'shopify_api'
gem 'savon', '~> 2.0'

gem 'foreman'
gem 'curb'

# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
end

group :development do

  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
  gem 'listen'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen'

  gem 'shopifydev'

  gem "css_canon", :git => "git://github.com/lastobelus/css_canon"

  gem "hpricot"

  gem "ruby_parser"

  gem "factory_girl_rails"

   
  gem 'pry-rails'
  gem 'haml-rails'
  gem 'guard'
  gem 'guard-rspec'
  gem 'zeus'

  gem 'rb-inotify', :require => false
  gem 'rb-fsevent', :require => false
  gem 'rb-fchange', :require => false  

end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]


group :test do
  gem "rspec-rails"
  gem "factory_girl_rails"
  gem 'simplecov', :require => false
end

