require 'puppet'
require 'rake'
require 'puppet-lint/tasks/puppet-lint'

# Leave this in until we're ready to write documentation
PuppetLint.configuration.send("disable_documentation")

# Ruby's version of true does not equate to puppet's version of true
PuppetLint.configuration.send("disable_quoted_booleans")

PuppetLint.configuration.send("disable_autoloader_layout")
PuppetLint.configuration.send("disable_80chars")
PuppetLint.configuration.log_format = "%{path}:%{linenumber}:%{check}:%{KIND}:%{message}"

desc "Run puppet-lint"
task :default => [:lint]
