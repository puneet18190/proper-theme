require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
ENV.update YAML.load_file('config/application.yml')[Rails.env] rescue {}
module Proper
  class Application < Rails::Application
    config.exceptions_app = self.routes
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
  #   config.assets.precompile += %w( /bootstrap-tooltip.js )
  #   config.assets.precompile += %w( /jquery.grid-a-licious.min.js )
  #   config.assets.precompile += %w( /jquery.carouFredSel-6.2.1-packed.js )
  #   config.assets.precompile += %w( /jquery.mousewheel.min.js )
  #   config.assets.precompile += %w( /jquery.touchSwipe.min.js )
  #   config.assets.precompile += %w( /jquery.transit.min.js )
  #   config.assets.precompile += %w( /jquery.ba-throttle-debounce.min.js )
  #   config.assets.precompile += %w( /gmap3.min.js )
  #   config.assets.precompile += %w( /jquery.colorbox-min.js )
  #   config.assets.precompile += %w( /jquery.js )
  #   config.assets.precompile += %w( /bootstrap-transition.js )
  #   config.assets.precompile += %w( /bootstrap-alert.js )
  #   config.assets.precompile += %w( /bootstrap-modal.js )
  #   config.assets.precompile += %w( /bootstrap-dropdown.js )
  #   config.assets.precompile += %w( /bootstrap-scrollspy.js )
  #   config.assets.precompile += %w( /bootstrap-tab.js )
    
  #   config.assets.precompile += %w( /bootstrap-popover.js )
  #   config.assets.precompile += %w( /bootstrap-button.js )
  #   config.assets.precompile += %w( /bootstrap-collapse.js )
  #   config.assets.precompile += %w( /bootstrap-carousel.js )
  #   config.assets.precompile += %w( /bootstrap-typeahead.js )
  #   config.assets.precompile += %w( /spin.min.js )
  #   config.assets.precompile += %w( /proper.js )
  #   config.assets.precompile += %w( /bootstrap.min.css")
  # config.assets.precompile += %w( /bootstrap-responsive.min.css)
  # config.assets.precompile += %w( /style.css)
  # config.assets.precompile += %w( /colorbox.css)
  # config.middleware.use Mobvious::Manager
    config.paperclip_defaults = {
    :storage => :s3,
    :s3_credentials => {
      :bucket => "sealpropertiesus",
      :access_key_id => "AKIAI42ZRYRPLOREEEDQ",
      :secret_access_key => "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"
    }
  }

  end
end
