require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ShopifyShippingHelper
  class Application < Rails::Application
    config.action_dispatch.default_headers['P3P'] = 'CP="Not used"'
    config.action_dispatch.default_headers.delete('X-Frame-Options')
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # don't generate RSpec tests for views and helpers
    config.generators do |g|
      
    # g.test_framework :rspec, fixture: true
      g.fixture_replacement :factory_girl
      
      
      g.view_specs false
      g.helper_specs false
    end
    
    # configuration for allowing some servers to access the aus api connection
    config.middleware.use Rack::Cors do
      allow do
        origins '*'
        resource '/australia_post_api_connections',
          :headers => ['Origin', 'Accept', 'Content-Type', 'X-CSRF-Token'],
          :methods => [:get, :post]
      end
    end
    
    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)
    config.autoload_paths += %W(#{config.root}/lib)

  end
end
