Checklist
=================================================

  - Fork the repository on GitHub.

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

Please make sure you have [bundler installed](http://bundler.io/#getting-started)
on your system, then use it to install all dependencies needed for this project,
by running

```shell
% bundle install
Fetching gem metadata from https://rubygems.org/........
Fetching gem metadata from https://rubygems.org/..
Using rake (10.1.0)
Using builder (3.2.2)
-- 8><-- many more --><8 --
Using rspec-system-puppet (2.2.0)
Using serverspec (0.6.3)
Using rspec-system-serverspec (1.0.0)
Using bundler (1.3.5)
Your bundle is complete!
Use `bundle show [gemname]` to see where a bundled gem is installed.
```

NOTE some systems may require you to run this command with sudo.


Running Tests
-------------

```shell
$ bundle exec rake spec
Cloning into 'spec/fixtures/modules/stdlib'...
remote: Counting objects: 5550, done.
remote: Total 5550 (delta 0), reused 0 (delta 0)
Receiving objects: 100% (5550/5550), 1.09 MiB | 271.00 KiB/s, done.
Resolving deltas: 100% (2302/2302), done.
Checking connectivity... done.
HEAD is now at 9e8127b Merge pull request #313 from mhaskel/spec_updates
Cloning into 'spec/fixtures/modules/concat'...
remote: Counting objects: 1467, done.
remote: Compressing objects: 100% (87/87), done.
remote: Total 1467 (delta 52), reused 2 (delta 0)
Receiving objects: 100% (1467/1467), 319.82 KiB | 256.00 KiB/s, done.
Resolving deltas: 100% (688/688), done.
.....................................................................

Finished in 4.59 seconds
69 examples, 0 failures

Total resources:   72
Touched resources: 22
Resource coverage: 30.56%
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

    bundle exec rake beaker

This will run the tests on an Ubuntu 12.04 virtual machine. You can also
run the integration tests against Centos 6.6 with:

    BEAKER_set=centos-66-x64 bundle exec rake beaker

Or with Ubuntu 12.04 with:

    BEAKER_set=ubuntu-server-12-x64 bundle exec rake beaker

If you need to inspect a vm manually afterwards, you can ask beaker to not
destroy the box:

    bundle exec rake BEAKER_destroy=no beaker

Then vagrant ssh to the box that was left behind

    vagrant global-status
    vagrant ssh (box-id)

