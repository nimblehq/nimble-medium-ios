source "https://rubygems.org"

gem "cocoapods"
gem "slather"
gem "fastlane"
gem "xcov"
gem "danger"
gem "danger-swiftlint"
gem "danger-xcode_summary"
gem 'danger-swiftformat'

plugins_path = File.join(File.dirname(__FILE__), 'fastlane', 'Pluginfile')
eval_gemfile(plugins_path) if File.exist?(plugins_path)
