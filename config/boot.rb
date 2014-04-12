# Defines our constants
PADRINO_ENV  = ENV['PADRINO_ENV'] ||= ENV['RACK_ENV'] ||= 'development'  unless defined?(PADRINO_ENV)
PADRINO_ROOT = File.expand_path('../..', __FILE__) unless defined?(PADRINO_ROOT)

Bundler.require(:default, PADRINO_ENV)

# Load our dependencies
require 'rubygems' unless defined?(Gem)
require 'bundler/setup'
require 'logger'

Padrino.require_dependencies "#{Padrino.root}/app/services/*.rb"

Padrino::Logger::Config.merge!({
                                   :dev => {:log_level => :debug, :stream => :stdout},
                                   :development => {:log_level => :debug, :stream => :stdout},
                                   :test => {:log_level => :info, :stream => :stdout},
                                   :ci => {:log_level => :debug, :stream => :to_file},
                                   :qa => {:log_level => :info, :stream => :to_file},
                                   :production => {:log_level => :info, :stream => :to_file},
                                   :e2e => {:log_level => :info, :stream => :to_file},
                                   :staging => {:log_level => :info, :stream => :to_file}
                               })
                               
# ## Configure your I18n
#
# I18n.default_locale = :en
#
# ## Configure your HTML5 data helpers
#
# Padrino::Helpers::TagHelpers::DATA_ATTRIBUTES.push(:dialog)
# text_field :foo, :dialog => true
# Generates: <input type="text" data-dialog="true" name="foo" />
#
# ## Add helpers to mailer
#
# Mail::Message.class_eval do
#   include Padrino::Helpers::NumberHelpers
#   include Padrino::Helpers::TranslationHelpers
# end

##
# Add your before (RE)load hooks here
#
Padrino.before_load do
end

##
# Add your after (RE)load hooks here
#
Padrino.after_load do
end

Padrino.load!
