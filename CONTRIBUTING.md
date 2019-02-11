Checklist
=================================================

  - Fork the repository on GitHub.

  - Install the [Puppet Development Kit(PDK)](https://puppet.com/docs/pdk/1.x/pdk_install.html)

  - Make changes on a branch *with tests*

  - Run tests `bundle exec rake spec`

  - Check for style `bundle exec rake lint`

  - Push your changes to a topic branch in your fork of the
    repository. (the format ticket/1234-short_description_of_change is
    usually preferred for this project).

  - Submit a pull request to the repository


Testing
=======

Getting Started
---------------

Our puppet modules provide [`Gemfile`](./Gemfile)s which can tell a ruby
package manager such as [bundler](http://bundler.io/) what Ruby packages,
or Gems, are required to build, develop, and test this software.

Please make sure you have [pdk installed](https://puppet.com/docs/pdk/1.x/pdk_install.html)
on your system.  PDK uses it's own version of [bundler included](http://bundler.io)
in its installation, which can be used to install all dependencies needed for this project,
by running

```shell
% pdk bundle install
pdk (INFO): Using Ruby 2.5.1
pdk (INFO): Using Puppet 6.0.2
Fetching https://github.com/skywinder/github-changelog-generator
The dependency puppet-module-win-default-r2.5 (>= 0) will be unused by any of the platforms Bundler is installing for. Bundler is installing for ruby but the dependency is only for x86-mswin32, x86-mingw32, x64-mingw32. To add those platforms to the bundle, run `bundle lock --add-platform x86-mswin32 x86-mingw32 x64-mingw32`.
The dependency puppet-module-win-dev-r2.5 (>= 0) will be unused by any of the platforms Bundler is installing for. Bundler is installing for ruby but the dependency is only for x86-mswin32, x86-mingw32, x64-mingw32. To add those platforms to the bundle, run `bundle lock --add-platform x86-mswin32 x86-mingw32 x64-mingw32`.
The dependency puppet-module-win-system-r2.5 (>= 0) will be unused by any of the platforms Bundler is installing for. Bundler is installing for ruby but the dependency is only for x86-mswin32, x86-mingw32, x64-mingw32. To add those platforms to the bundle, run `bundle lock --add-platform x86-mswin32 x86-mingw32 x64-mingw32`.
Fetching gem metadata from https://rubygems.org/.........
Resolving dependencies....
Fetching rake 12.3.2
Installing rake 12.3.2
Fetching CFPropertyList 2.3.6
Installing CFPropertyList 2.3.6
Fetching concurrent-ruby 1.1.4
Installing concurrent-ruby 1.1.4
Fetching i18n 1.5.2
Installing i18n 1.5.2
Fetching minitest 5.11.3
Installing minitest 5.11.3
Fetching thread_safe 0.3.6
Installing thread_safe 0.3.6
Fetching tzinfo 1.2.5
Installing tzinfo 1.2.5
Fetching activesupport 5.2.2
Installing activesupport 5.2.2
Using public_suffix 3.0.3
Using addressable 2.5.2
Using ansi 1.5.0
Using ast 2.4.0
Fetching aws-eventstream 1.0.1
Installing aws-eventstream 1.0.1
Fetching aws-partitions 1.133.0
Installing aws-partitions 1.133.0
Fetching aws-sigv4 1.0.3
Installing aws-sigv4 1.0.3
Fetching jmespath 1.4.0
Installing jmespath 1.4.0
Fetching aws-sdk-core 3.46.0
Installing aws-sdk-core 3.46.0
Fetching aws-sdk-ec2 1.66.0
Installing aws-sdk-ec2 1.66.0
Fetching deep_merge 1.2.1
Installing deep_merge 1.2.1
Fetching stringify-hash 0.0.2
Installing stringify-hash 0.0.2
Fetching beaker-hostgenerator 1.1.25
Installing beaker-hostgenerator 1.1.25
Using hocon 1.2.5
Fetching in-parallel 0.1.17
Installing in-parallel 0.1.17
Fetching inifile 3.0.0
Installing inifile 3.0.0
Fetching minitar 0.8
Installing minitar 0.8
Using net-ssh 4.2.0
Using net-scp 1.2.1
Fetching open_uri_redirections 0.2.1
Installing open_uri_redirections 0.2.1
Using byebug 9.0.6
Using coderay 1.1.2
Using method_source 0.8.2
Using slop 3.6.0
Using pry 0.10.4
Fetching pry-byebug 3.4.3
Installing pry-byebug 3.4.3
Fetching rb-readline 0.5.5
Installing rb-readline 0.5.5
Fetching rsync 1.0.9
Installing rsync 1.0.9
Using thor 0.20.3
Fetching beaker 4.4.0
Installing beaker 4.4.0
Fetching beaker-abs 0.5.0
Installing beaker-abs 0.5.0
Fetching require_all 1.3.3
Installing require_all 1.3.3
Fetching beaker-answers 0.25.0
Installing beaker-answers 0.25.0
Fetching beaker-aws 0.8.1
Installing beaker-aws 0.8.1
Fetching excon 0.62.0
Installing excon 0.62.0
Using multi_json 1.13.1
Fetching docker-api 1.34.2
Installing docker-api 1.34.2
Fetching beaker-docker 0.5.1
Installing beaker-docker 0.5.1
Fetching multipart-post 2.0.0
Installing multipart-post 2.0.0
Fetching faraday 0.15.4
Installing faraday 0.15.4
Fetching jwt 2.1.0
Installing jwt 2.1.0
Fetching memoist 0.16.0
Installing memoist 0.16.0
Fetching os 1.0.0
Installing os 1.0.0
Fetching signet 0.11.0
Installing signet 0.11.0
Fetching googleauth 0.8.0
Installing googleauth 0.8.0
Using httpclient 2.8.3
Using mime-types-data 3.2018.0812
Using mime-types 3.2.2
Fetching declarative 0.0.10
Installing declarative 0.0.10
Fetching declarative-option 0.1.0
Installing declarative-option 0.1.0
Fetching uber 0.1.0
Installing uber 0.1.0
Fetching representable 3.0.4
Installing representable 3.0.4
Fetching retriable 3.1.2
Installing retriable 3.1.2
Fetching google-api-client 0.27.3
Installing google-api-client 0.27.3
Fetching beaker-google 0.1.0
Installing beaker-google 0.1.0
Fetching beaker-i18n_helper 1.1.0
Installing beaker-i18n_helper 1.1.0
Fetching beaker-module_install_helper 0.1.7
Installing beaker-module_install_helper 0.1.7
Fetching builder 3.2.3
Installing builder 3.2.3
Using formatador 0.2.5
Fetching fog-core 2.1.2
Installing fog-core 2.1.2
Fetching fog-json 1.2.0
Installing fog-json 1.2.0
Fetching ipaddress 0.8.3
Installing ipaddress 0.8.3
Fetching fog-openstack 1.0.7
Installing fog-openstack 1.0.7
Fetching beaker-openstack 0.2.0
Installing beaker-openstack 0.2.0
Using ruby-ll 2.1.2
Using oga 2.15
Fetching beaker-puppet 1.14.0
Installing beaker-puppet 1.14.0
Fetching beaker-vmpooler 1.3.1
Installing beaker-vmpooler 1.3.1
Fetching beaker-pe 2.0.6
Installing beaker-pe 2.0.6
Fetching beaker-puppet_install_helper 0.9.7
Installing beaker-puppet_install_helper 0.9.7
Using rspec-support 3.8.0
Using rspec-core 3.8.0
Using diff-lcs 1.3
Using rspec-expectations 3.8.2
Using rspec-mocks 3.8.0
Using rspec 3.8.0
Fetching rspec-its 1.2.0
Installing rspec-its 1.2.0
Using net-telnet 0.1.1
Using sfl 2.3
Fetching specinfra 2.76.7
Installing specinfra 2.76.7
Fetching serverspec 2.41.3
Installing serverspec 2.41.3
Fetching beaker-rspec 6.2.4
Installing beaker-rspec 6.2.4
Fetching beaker-task_helper 1.7.2
Installing beaker-task_helper 1.7.2
Fetching beaker-vagrant 0.6.1
Installing beaker-vagrant 0.6.1
Fetching fission 0.5.0
Installing fission 0.5.0
Using json 2.1.0
Fetching mini_portile2 2.4.0
Installing mini_portile2 2.4.0
Fetching nokogiri 1.10.1
Installing nokogiri 1.10.1 with native extensions
Fetching trollop 2.9.9
Installing trollop 2.9.9
Fetching rbvmomi 1.13.0
Installing rbvmomi 1.13.0
Fetching beaker-vmware 0.3.0
Installing beaker-vmware 0.3.0
Fetching beaker-vcloud 1.0.0
Installing beaker-vcloud 1.0.0
Using bundler 1.16.6
Using docile 1.3.1
Using simplecov-html 0.10.2
Using simplecov 0.16.1
Using url 0.3.2
Using codecov 0.1.14
Using unf_ext 0.0.7.5
Using unf 0.1.4
Using domain_name 0.5.20180417
Using facter 2.5.1
Using jgrep 1.5.0
Fetching facterdb 0.6.0
Installing facterdb 0.6.0
Fetching faraday-http-cache 2.0.0
Installing faraday-http-cache 2.0.0
Using fast_gettext 1.1.2
Using locale 2.1.2
Using text 1.3.1
Using gettext 3.2.9
Using gettext-setup 0.30
Fetching sawyer 0.8.1
Installing sawyer 0.8.1
Fetching octokit 4.13.0
Installing octokit 4.13.0
Using rainbow 2.2.2
Using github_changelog_generator 1.15.0.pre.rc from https://github.com/skywinder/github-changelog-generator (at 20ee04b@20ee04b)
Fetching hiera 3.5.0
Installing hiera 3.5.0
Using hirb 0.7.3
Using http-cookie 1.0.3
Using json-schema 2.8.1
Fetching master_manipulator 2.1.1
Installing master_manipulator 2.1.1
Fetching stomp 1.4.8
Installing stomp 1.4.8
Using systemu 2.6.5
Using mcollective-client 2.12.4
Using metaclass 0.0.4
Using spdx-licenses 1.2.0
Using metadata-json-lint 2.2.0
Using mocha 1.1.0
Using netrc 0.11.0
Fetching optimist 3.0.0
Installing optimist 3.0.0
Fetching parallel 1.13.0
Installing parallel 1.13.0
Using parallel_tests 2.14.2
Using parser 2.5.1.2
Fetching pathspec 0.2.1
Installing pathspec 0.2.1
Using powerpack 0.1.2
Using puppet-resource_api 1.6.2
Using semantic_puppet 1.0.2
Using puppet 6.0.2
Using rest-client 2.0.2
Using puppet-blacksmith 4.1.2
Using puppet-lint 2.3.6
Fetching puppet-module-posix-default-r2.5 0.3.14
Installing puppet-module-posix-default-r2.5 0.3.14
Using rgen 0.8.2
Using yard 0.9.16
Using puppet-strings 2.1.0
Using puppet-syntax 2.4.1
Using puppet_pot_generator 1.0.1
Using rspec-puppet 2.7.2
Fetching puppetlabs_spec_helper 2.13.1
Installing puppetlabs_spec_helper 2.13.1
Using rspec-puppet-facts 1.9.2
Using rspec_junit_formatter 0.4.1
Using ruby-progressbar 1.10.0
Fetching unicode-display_width 1.4.1
Installing unicode-display_width 1.4.1
Using rubocop 0.49.1
Using rubocop-i18n 1.2.0
Using rubocop-rspec 1.16.0
Using simplecov-console 0.4.2
Fetching puppet-module-posix-dev-r2.5 0.3.14
Installing puppet-module-posix-dev-r2.5 0.3.14
Fetching puppet-module-posix-system-r2.5 0.3.14
Installing puppet-module-posix-system-r2.5 0.3.14
Fetching vagrant-wrapper 2.0.3
Installing vagrant-wrapper 2.0.3
Bundle complete! 16 Gemfile dependencies, 166 gems now installed.
Use `bundle info [gemname]` to see where a bundled gem is installed.
Post-install message from i18n:

HEADS UP! i18n 1.1 changed fallbacks to exclude default locale.
But that may break your application.

Please check your Rails app for 'config.i18n.fallbacks = true'.
If you're using I18n (>= 1.1.0) and Rails (< 5.2.2), this should be
'config.i18n.fallbacks = [I18n.default_locale]'.
If not, fallbacks will be broken in your app by I18n 1.1.x.

For more info see:
https://github.com/svenfuchs/i18n/releases/tag/v1.1.0

Post-install message from minitar:
The `minitar` executable is no longer bundled with `minitar`. If you are
expecting this executable, make sure you also install `minitar-cli`.
Post-install message from trollop:
!    The 'trollop' gem has been deprecated and has been replaced by 'optimist'.
!    See: https://rubygems.org/gems/optimist
!    And: https://github.com/ManageIQ/optimist
NOTE: Gem::Specification#default_executable= is deprecated with no replacement. It will be removed on or after 2018-12-01.
Gem::Specification#default_executable= called from /home/peter/.pdk/cache/ruby/2.5.0/bundler/gems/github-changelog-generator-20ee04ba1234/github_changelog_generator.gemspec:10.
```

Running Tests
-------------

```shell
$ pdk test unit
pdk (INFO): Using Ruby 2.5.1
pdk (INFO): Using Puppet 6.0.2
[✔] Preparing to run the unit tests.
[✔] Running unit tests.
```

Individual tests can be listed by running:

```shell
$ pdk bundle exec rake -T
```


Test can then be executed by running:

```shell
$ pdk bundle exec rake $INDIVDUALTEST
```

Writing Tests
------------
See the [tutorial](http://rspec-puppet.com/tutorial/)


Integration tests
-----------------

The unit tests just check the code runs, not that it does exactly what
we want on a real machine. For that we're using
[Beaker](https://github.com/puppetlabs/beaker).
This fires up a new virtual machine (using vagrant) and runs a series of
simple tests against it after applying the module. You can run this
with:

    pdk bundle exec rake beaker

This will run the tests on an Ubuntu 12.04 virtual machine. You can also
run the integration tests against Centos 6.6 with:

    pdk bundle exec rake beaker:centos-66-x64

Or with Ubuntu 12.04 with:

    pdk bundle exec rake beaker:ubuntu-server-12-x64

If you need to inspect a vm manually afterwards, you can ask beaker to not
destroy the box:

    BEAKER_destroy=no pdk bundle exec rake beaker

Then vagrant ssh to the box that was left behind

    vagrant global-status
    vagrant ssh (box-id)

