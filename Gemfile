source "https://rubygems.org"

group :development do
  gem "puppet-blacksmith"
end

group :test do
  gem "rake"
  gem "puppet", ENV['PUPPET_VERSION'] || '~> 3.7.0'
  gem "puppet-lint"
  gem "rspec-puppet", :git => 'https://github.com/rodjek/rspec-puppet.git'
  gem "puppet-syntax"
  gem "puppetlabs_spec_helper"
  gem 'rspec', '< 2.99'
end
