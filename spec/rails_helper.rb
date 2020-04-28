# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../config/environment', __dir__)

# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!

require 'simplecov'
SimpleCov.start do
  add_filter '/bin/'
  add_filter '/db/'
  add_filter '/spec/' # for rspec
end

require 'codecov'
SimpleCov.formatter = SimpleCov::Formatter::Codecov

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Dir[Rails.root.join('spec', 'support', '**', '*.rb')].each { |f| require f }

RSpec.configure do |config|
  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name)
end

FIXTURE_PATH = "#{::Rails.root}/spec/fixtures"

def json_fixture(path)
  file = File.read(File.join(FIXTURE_PATH, path))
  response = JSON.parse(file)
  if response.is_a? Hash
    response.with_indifferent_access
  elsif response.is_a? Array
    response.map(&:with_indifferent_access)
  else
    response
  end
end

def view_context
  return @view_context if @view_context.present?

  view_context = ActionController::Base.new.send(:view_context)
  view_context.class.include(ApplicationHelper)
  view_context.class.include(Rails.application.routes.url_helpers)
  @view_context ||= view_context
end
