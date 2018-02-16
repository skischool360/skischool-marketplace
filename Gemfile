source 'https://rubygems.org'
ruby "~> 2.3.0"

#gem for server-side API calls for from Heap
gem 'heap', '~> 1.0'
#calendar views
gem "simple_calendar", "~> 2.0"

#install redis gem for actioncable troubleshooting
gem 'redis'

#delayed_jobs for sending Twilio SMS messages if instructors are unresponsive
gem 'delayed_job_active_record'

#For supporting controller tests from Rails 4
gem 'rails-controller-testing'

#Railties is dependency for various devise and jquery gems in rails 5

gem 'railties'

#sitemap generator
gem 'sitemap_generator'
# gem for cron jobs to schedule sitemap refresh, mkting emails, etc.
gem 'whenever', :require => false
#stripe for charging credit cards
gem 'stripe'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
# gem 'rails', '5.0.0.1'
gem 'rails', '5.0.0.1'
#ensure that puma server is available
gem 'puma'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.15'

#twilio for SMS notifications
gem 'twilio-ruby'

#AWS SDK's for storing images
# gem 'aws-sdk-v1'
gem 'aws-sdk', '~> 2'

#Using CKeditor as the WYSIWYG editor for potential custom formatting in-line.
# gem 'ckeditor'
#now using TinyMCE due to Malware trouble-shooting
gem 'tinymce-rails'
#paperclip for file upload management
gem 'paperclip'

#suggested by DEVEO article re. GA server-side tracking - http://blog.deveo.com/server-side-google-analytics-event-tracking-with-rails/
gem 'rest-client'

# handle 404 error & other exceptions by sending notifications
gem 'exception_notification'

group :development, :test do
  gem  'byebug'
  gem 'better_errors'
  gem 'binding_of_caller'
end

# Use SCSS for stylesheets
gem 'sass-rails'
gem 'bootstrap-sass'
gem 'sprockets-rails', :require => 'sprockets/railtie'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails', '5.0.5'
gem 'jquery-timepicker-rails'
#added to try to replace bootstrap datetimepicker(?)
gem 'rails-assets-datetimepicker', source: 'https://rails-assets.org'

#new datetimepicker gem for shifts
gem 'momentjs-rails', '>= 2.9.0'
gem 'bootstrap3-datetimepicker-rails', '~> 4.17.47'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
gem 'jquery-turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

gem 'devise'
gem 'formtastic', '~> 3.0'
gem 'formtastic-bootstrap'
gem 'omniauth-facebook'
gem 'cocoon', '>= 1.2.0'

gem 'faker'
gem 'hirb'


# Heroku
group :production do
  gem 'rails_12factor'
end
