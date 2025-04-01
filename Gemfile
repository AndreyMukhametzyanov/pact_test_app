source "https://rubygems.org"

gem "rails", "~> 7.2.2", ">= 7.2.2.1"
gem "sprockets-rails"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "tzinfo-data", platforms: %i[ mswin mswin64 mingw x64_mingw jruby ]
gem "bootsnap", require: false
gem "active_interaction", "~> 5.5"

group :development, :test do
  gem "debug", platforms: %i[ mri mswin mswin64 mingw x64_mingw ], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
  gem "bundle-audit", "~> 0.1.0"
  gem "bundler-leak", require: false
  gem "faker", "~> 2.23"
end

group :test do
  gem "shoulda-matchers", "~> 6.0"
  gem "factory_bot_rails"
  gem "rspec-rails", git: "https://github.com/rspec/rspec-rails"
end
