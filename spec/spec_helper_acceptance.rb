require 'beaker-rspec'
require 'beaker-puppet'
require 'beaker/puppet_install_helper'
require 'beaker/module_install_helper'
require 'beaker-task_helper'

# install_puppet_on(hosts, options)
run_puppet_install_helper_on(hosts)
configure_type_defaults_on(hosts)
install_ca_certs unless pe_install?
# install_puppet_agent_on(hosts)
# install_bolt_on(hosts)
# install_module_on(hosts)
# install_module_dependencies_on(hosts)

RSpec.configure do |c|
  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    install_module_on(hosts)
    install_module_dependencies_on(hosts)
  end
end
