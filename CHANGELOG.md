# Change Log

## [2.1.0](https://github.com/ajjahn/puppet-dns/tree/2.1.0) (2017-01-26)
[Full Changelog](https://github.com/ajjahn/puppet-dns/compare/v2.0.2...2.1.0)

**Closed issues:**

- Function Call, validate\_re\(\): input needs to be a String, not a NilClass at modules/dns/manifests/server/default.pp:29:3 [\#190](https://github.com/ajjahn/puppet-dns/issues/190)
- Getting puppet evaluation error about $enable\_zone\_write [\#184](https://github.com/ajjahn/puppet-dns/issues/184)
- `dns::server::defaults` class fails with puppetlabs-stdlib 4.10.0 [\#181](https://github.com/ajjahn/puppet-dns/issues/181)
- Setup Travis CI Releases to Forge [\#177](https://github.com/ajjahn/puppet-dns/issues/177)
- TXT record types should properly format the data value [\#170](https://github.com/ajjahn/puppet-dns/issues/170)
- Tags and Forge releases for 2.0.1 and 2.0.2 [\#167](https://github.com/ajjahn/puppet-dns/issues/167)
- How to handle class B nets [\#166](https://github.com/ajjahn/puppet-dns/issues/166)
- Any thoughts on pointing cfg\_dir to different directory? [\#163](https://github.com/ajjahn/puppet-dns/issues/163)
- cut releases more frequently. :\) [\#157](https://github.com/ajjahn/puppet-dns/issues/157)
- Support for Views [\#156](https://github.com/ajjahn/puppet-dns/issues/156)
- statistics-channel option broken [\#148](https://github.com/ajjahn/puppet-dns/issues/148)
- named.conf not including options [\#101](https://github.com/ajjahn/puppet-dns/issues/101)
- doesnt work with dynamic dns [\#54](https://github.com/ajjahn/puppet-dns/issues/54)

**Merged pull requests:**

- Remove Ruby 1.8 from the build matrix [\#194](https://github.com/ajjahn/puppet-dns/pull/194) ([solarkennedy](https://github.com/solarkennedy))
- fixing path issue which prevents working when path is not /etc/bind [\#193](https://github.com/ajjahn/puppet-dns/pull/193) ([ppouliot](https://github.com/ppouliot))
- 2nd chance: feat query\_log - optional parameter query\_log\_enable to enable query log [\#192](https://github.com/ajjahn/puppet-dns/pull/192) ([eumel8](https://github.com/eumel8))
- Add support for stub zones [\#191](https://github.com/ajjahn/puppet-dns/pull/191) ([jjthiessen](https://github.com/jjthiessen))
- Make data\_dir configurable in defined resource types. [\#189](https://github.com/ajjahn/puppet-dns/pull/189) ([n00by](https://github.com/n00by))
- Fix template formatting for [\#188](https://github.com/ajjahn/puppet-dns/pull/188) ([n00by](https://github.com/n00by))
- Fix statistics-channels location outside named.conf.options, add supp… [\#187](https://github.com/ajjahn/puppet-dns/pull/187) ([kwisatz](https://github.com/kwisatz))
- feat re-implement serial number in dns zone as optional parameter [\#186](https://github.com/ajjahn/puppet-dns/pull/186) ([eumel8](https://github.com/eumel8))
- Ensure `validate\_re` calls are wrapped in `if` checks to avoid passing undef [\#182](https://github.com/ajjahn/puppet-dns/pull/182) ([jearls](https://github.com/jearls))
- Ignore /\*.lock files [\#175](https://github.com/ajjahn/puppet-dns/pull/175) ([sspreitzer](https://github.com/sspreitzer))
- Make lint happy:  change variables class\_\[ABC\]\_\* to class\_\[abc\]\_\* [\#174](https://github.com/ajjahn/puppet-dns/pull/174) ([jearls](https://github.com/jearls))
- Fix typos in `dns::collector` and `dns::zone` [\#173](https://github.com/ajjahn/puppet-dns/pull/173) ([jearls](https://github.com/jearls))
- Allow dynamic dns, fixes ajjahn/puppet-dns\#54 [\#172](https://github.com/ajjahn/puppet-dns/pull/172) ([sspreitzer](https://github.com/sspreitzer))
- issue \#170: Produce proper DNS quoted strings for TXT and SPF records [\#171](https://github.com/ajjahn/puppet-dns/pull/171) ([jearls](https://github.com/jearls))
- Correct indentation of template. [\#169](https://github.com/ajjahn/puppet-dns/pull/169) ([MemberIT](https://github.com/MemberIT))
- Bugfix/template named options [\#168](https://github.com/ajjahn/puppet-dns/pull/168) ([MemberIT](https://github.com/MemberIT))
- feature TSIG configuration [\#129](https://github.com/ajjahn/puppet-dns/pull/129) ([eumel8](https://github.com/eumel8))

## [v2.0.2](https://github.com/ajjahn/puppet-dns/tree/v2.0.2) (2016-05-24)
[Full Changelog](https://github.com/ajjahn/puppet-dns/compare/v2.0.0...v2.0.2)

**Closed issues:**

- Is dependency on electrical-file\_concat still required? [\#160](https://github.com/ajjahn/puppet-dns/issues/160)
- seemingly random order within the zonefile [\#154](https://github.com/ajjahn/puppet-dns/issues/154)
- Concat dependency causing builds to fail [\#142](https://github.com/ajjahn/puppet-dns/issues/142)
- Version update [\#141](https://github.com/ajjahn/puppet-dns/issues/141)

**Merged pull requests:**

- Remove unneeded dependency on electrical/file\_concat module [\#165](https://github.com/ajjahn/puppet-dns/pull/165) ([jearls](https://github.com/jearls))
- Add `reverse =\> reverse` option to dns::zone [\#162](https://github.com/ajjahn/puppet-dns/pull/162) ([jearls](https://github.com/jearls))
- Add `notify\_source` and `transfer\_source` to `dns::server::options` [\#161](https://github.com/ajjahn/puppet-dns/pull/161) ([jearls](https://github.com/jearls))
- Adjust Gemfile to Fix Tests [\#159](https://github.com/ajjahn/puppet-dns/pull/159) ([solarkennedy](https://github.com/solarkennedy))
- Removed 'ensure' setting from concat::fragment statements [\#158](https://github.com/ajjahn/puppet-dns/pull/158) ([Loewe88](https://github.com/Loewe88))
- Comparison of: String \>= Integer, is not possible [\#155](https://github.com/ajjahn/puppet-dns/pull/155) ([wazoo](https://github.com/wazoo))
- Added Package require [\#153](https://github.com/ajjahn/puppet-dns/pull/153) ([mooreandrew](https://github.com/mooreandrew))
- Allow query zone [\#152](https://github.com/ajjahn/puppet-dns/pull/152) ([gcmalloc](https://github.com/gcmalloc))
- Fix default spec, a class not a define [\#151](https://github.com/ajjahn/puppet-dns/pull/151) ([solarkennedy](https://github.com/solarkennedy))
- Control whether DNS-SEC support is enabled/disabled [\#146](https://github.com/ajjahn/puppet-dns/pull/146) ([evidex](https://github.com/evidex))
- \[WIP\] Fix fixtures [\#145](https://github.com/ajjahn/puppet-dns/pull/145) ([solarkennedy](https://github.com/solarkennedy))
- Empty Zone Generation control [\#144](https://github.com/ajjahn/puppet-dns/pull/144) ([evidex](https://github.com/evidex))
- Add support for delegation-only zone types. [\#143](https://github.com/ajjahn/puppet-dns/pull/143) ([evidex](https://github.com/evidex))
- Add `all` and `first` values to `ptr` parameter of `dns::record::a` [\#138](https://github.com/ajjahn/puppet-dns/pull/138) ([jearls](https://github.com/jearls))

## [v2.0.0](https://github.com/ajjahn/puppet-dns/tree/v2.0.0) (2015-12-03)
[Full Changelog](https://github.com/ajjahn/puppet-dns/compare/v1.2.0...v2.0.0)

**Closed issues:**

- Outdated dependencies make this module incompatible with other modules. [\#120](https://github.com/ajjahn/puppet-dns/issues/120)
- Fatal Regression in \#112- bad config means bind will not start. [\#115](https://github.com/ajjahn/puppet-dns/issues/115)
- Adding record to multiple zones or all zones? [\#105](https://github.com/ajjahn/puppet-dns/issues/105)
- Large Number of Records? [\#104](https://github.com/ajjahn/puppet-dns/issues/104)
- Tag New Release [\#97](https://github.com/ajjahn/puppet-dns/issues/97)
- SOA has additional "." [\#93](https://github.com/ajjahn/puppet-dns/issues/93)
- Error finding a dependency. [\#78](https://github.com/ajjahn/puppet-dns/issues/78)
- Allow "type forward" without file-statement [\#64](https://github.com/ajjahn/puppet-dns/issues/64)
- 'dnssec-validation auto' not supported in Debian Squeeze \(Bind 9.7.3\) [\#52](https://github.com/ajjahn/puppet-dns/issues/52)

**Merged pull requests:**

- Test NS records, provide example for README [\#140](https://github.com/ajjahn/puppet-dns/pull/140) ([roderickm](https://github.com/roderickm))
- Properly escape the { and } in the listen-on-v6 regexp check. [\#139](https://github.com/ajjahn/puppet-dns/pull/139) ([jearls](https://github.com/jearls))
- fix variable access preference with @preference [\#136](https://github.com/ajjahn/puppet-dns/pull/136) ([timogoebel](https://github.com/timogoebel))
- fixes for puppet future parser support [\#135](https://github.com/ajjahn/puppet-dns/pull/135) ([timogoebel](https://github.com/timogoebel))
- Make "listen-on-v6" a configurable option [\#134](https://github.com/ajjahn/puppet-dns/pull/134) ([djm256](https://github.com/djm256))
- Allow the dns::zone::slave\_masters parameter to be an array [\#133](https://github.com/ajjahn/puppet-dns/pull/133) ([jearls](https://github.com/jearls))
- params.pp: excluded dnssec-tools from $necessary\_package for debian 8 [\#131](https://github.com/ajjahn/puppet-dns/pull/131) ([Gril258](https://github.com/Gril258))
- Added support to modify service startup [\#130](https://github.com/ajjahn/puppet-dns/pull/130) ([Cicco0](https://github.com/Cicco0))
- add updated Gemfile.lock [\#128](https://github.com/ajjahn/puppet-dns/pull/128) ([jearls](https://github.com/jearls))
- Added initial acceptance test framework [\#126](https://github.com/ajjahn/puppet-dns/pull/126) ([solarkennedy](https://github.com/solarkennedy))
- Fix the `directory` option in named.conf.options [\#125](https://github.com/ajjahn/puppet-dns/pull/125) ([darkfoxprime](https://github.com/darkfoxprime))
- Make dnssec validation a configurable option. [\#124](https://github.com/ajjahn/puppet-dns/pull/124) ([darkfoxprime](https://github.com/darkfoxprime))
- fix zone template's @allow\_transfer check [\#123](https://github.com/ajjahn/puppet-dns/pull/123) ([darkfoxprime](https://github.com/darkfoxprime))
- Correct path for named.conf.options in tests/init.pp [\#122](https://github.com/ajjahn/puppet-dns/pull/122) ([darkfoxprime](https://github.com/darkfoxprime))
- Remove invalid reference to dns::server::options::forwarder [\#121](https://github.com/ajjahn/puppet-dns/pull/121) ([darkfoxprime](https://github.com/darkfoxprime))
- Named.options fix [\#119](https://github.com/ajjahn/puppet-dns/pull/119) ([tedivm](https://github.com/tedivm))
- Fixes \#93 - Avoid the extra dot in the soa [\#117](https://github.com/ajjahn/puppet-dns/pull/117) ([oloc](https://github.com/oloc))
- Updated concat module version [\#116](https://github.com/ajjahn/puppet-dns/pull/116) ([tedivm](https://github.com/tedivm))
- Fix comment syntax in named.conf template [\#114](https://github.com/ajjahn/puppet-dns/pull/114) ([jaxim](https://github.com/jaxim))
- Add param to manage packages [\#113](https://github.com/ajjahn/puppet-dns/pull/113) ([jaxim](https://github.com/jaxim))
- issue 101: take control of named.conf. [\#112](https://github.com/ajjahn/puppet-dns/pull/112) ([jearls](https://github.com/jearls))
- Add notify to server options & also\_notify to server and zone options. [\#110](https://github.com/ajjahn/puppet-dns/pull/110) ([jearls](https://github.com/jearls))
- Remove dnssec-tools from RedHat package list. [\#108](https://github.com/ajjahn/puppet-dns/pull/108) ([jearls](https://github.com/jearls))
- Added file\_concat as a dependent module [\#103](https://github.com/ajjahn/puppet-dns/pull/103) ([solarkennedy](https://github.com/solarkennedy))
- Use resource names instead of hosts for the aliases of dns record types.  With spec test file. [\#100](https://github.com/ajjahn/puppet-dns/pull/100) ([jearls](https://github.com/jearls))
- zone files should only be created or modified for master zones [\#99](https://github.com/ajjahn/puppet-dns/pull/99) ([jearls](https://github.com/jearls))
- spec tests: fix invalid range in regexp [\#98](https://github.com/ajjahn/puppet-dns/pull/98) ([jearls](https://github.com/jearls))
- Fixed a bug where key did not work on redhat due to incorrect pkg name [\#87](https://github.com/ajjahn/puppet-dns/pull/87) ([fhaynes](https://github.com/fhaynes))
- Bind stats [\#77](https://github.com/ajjahn/puppet-dns/pull/77) ([gcmalloc](https://github.com/gcmalloc))

## [v1.2.0](https://github.com/ajjahn/puppet-dns/tree/v1.2.0) (2015-04-10)
[Full Changelog](https://github.com/ajjahn/puppet-dns/compare/v1.1.0...v1.2.0)

**Closed issues:**

- Custom NS not supported- can't properly handle domain forwarding [\#95](https://github.com/ajjahn/puppet-dns/issues/95)
- Error: Could not set 'present' on ensure: No such file or directory - /etc/bind/named.conf.options20150404-12319-h6cff6.lock [\#94](https://github.com/ajjahn/puppet-dns/issues/94)
- dnssec-tools not available in centos 7 epel [\#83](https://github.com/ajjahn/puppet-dns/issues/83)
- Invalid relationship errors with concat [\#81](https://github.com/ajjahn/puppet-dns/issues/81)
- Dependency required for repository "epel" on CentOS [\#79](https://github.com/ajjahn/puppet-dns/issues/79)
- New Release 1.1.0 [\#75](https://github.com/ajjahn/puppet-dns/issues/75)

**Merged pull requests:**

- Added NS record type [\#96](https://github.com/ajjahn/puppet-dns/pull/96) ([tedivm](https://github.com/tedivm))
- Added in feature allowing for global allow-transfer [\#90](https://github.com/ajjahn/puppet-dns/pull/90) ([fhaynes](https://github.com/fhaynes))
- Fixed a bug where the secret line was not ending a ; [\#89](https://github.com/ajjahn/puppet-dns/pull/89) ([fhaynes](https://github.com/fhaynes))
- Fixed a bug where the key was being written with }: and not }; [\#88](https://github.com/ajjahn/puppet-dns/pull/88) ([fhaynes](https://github.com/fhaynes))
- fixed params.pp for rhel 7 and added fixes for concat issues [\#84](https://github.com/ajjahn/puppet-dns/pull/84) ([ITBlogger](https://github.com/ITBlogger))
- Added a description to make RHEL/CentOS users aware that EPEL is required. [\#82](https://github.com/ajjahn/puppet-dns/pull/82) ([robertdebock](https://github.com/robertdebock))
- Test check\_names\_response with wrong string [\#76](https://github.com/ajjahn/puppet-dns/pull/76) ([roderickm](https://github.com/roderickm))

## [v1.1.0](https://github.com/ajjahn/puppet-dns/tree/v1.1.0) (2015-02-03)
[Full Changelog](https://github.com/ajjahn/puppet-dns/compare/v1.0.0...v1.1.0)

**Closed issues:**

- Version 2.0.0 [\#38](https://github.com/ajjahn/puppet-dns/issues/38)

**Merged pull requests:**

- EL Compatible [\#74](https://github.com/ajjahn/puppet-dns/pull/74) ([roderickm](https://github.com/roderickm))
- cleanup of inline rdocs in `dns::server::options` class [\#73](https://github.com/ajjahn/puppet-dns/pull/73) ([talisto](https://github.com/talisto))
- allow port to be customized in dns::server::options [\#72](https://github.com/ajjahn/puppet-dns/pull/72) ([talisto](https://github.com/talisto))
- MX preference fix, unique alias, add tests [\#71](https://github.com/ajjahn/puppet-dns/pull/71) ([roderickm](https://github.com/roderickm))
- Add listen-on option \(with tests\) [\#70](https://github.com/ajjahn/puppet-dns/pull/70) ([roderickm](https://github.com/roderickm))
- Use the new build env on Travis [\#68](https://github.com/ajjahn/puppet-dns/pull/68) ([joshk](https://github.com/joshk))
- Zone with "type forward" are now without "file"-line [\#66](https://github.com/ajjahn/puppet-dns/pull/66) ([fr3dm4n](https://github.com/fr3dm4n))
- fix README example [\#65](https://github.com/ajjahn/puppet-dns/pull/65) ([rkcpi](https://github.com/rkcpi))
- Update README.md [\#62](https://github.com/ajjahn/puppet-dns/pull/62) ([kylecannon](https://github.com/kylecannon))

## [v1.0.0](https://github.com/ajjahn/puppet-dns/tree/v1.0.0) (2014-10-19)
[Full Changelog](https://github.com/ajjahn/puppet-dns/compare/v0.1.4...v1.0.0)

**Closed issues:**

- Error 400 on SERVER: Duplicate declaration: Dns::Record::A\[server1\] is already declared [\#44](https://github.com/ajjahn/puppet-dns/issues/44)
- Change zone-serial only on record updates \(this a solution\) [\#24](https://github.com/ajjahn/puppet-dns/issues/24)
- Possibility to set forwarders [\#22](https://github.com/ajjahn/puppet-dns/issues/22)
- Provide a feature to set the /etc/bind/named.conf.options file [\#21](https://github.com/ajjahn/puppet-dns/issues/21)
- module not found when installing from the forge using puppet module install [\#15](https://github.com/ajjahn/puppet-dns/issues/15)

**Merged pull requests:**

- Updated docs [\#60](https://github.com/ajjahn/puppet-dns/pull/60) ([solarkennedy](https://github.com/solarkennedy))
- Create ns.pp [\#53](https://github.com/ajjahn/puppet-dns/pull/53) ([gilneidp](https://github.com/gilneidp))
- Fix 'Usage' section in dns::server::options [\#51](https://github.com/ajjahn/puppet-dns/pull/51) ([strangeman](https://github.com/strangeman))
- Fix 'Usage' section in dns::acl [\#50](https://github.com/ajjahn/puppet-dns/pull/50) ([strangeman](https://github.com/strangeman))
- Spec refactor [\#49](https://github.com/ajjahn/puppet-dns/pull/49) ([danzilio](https://github.com/danzilio))
- Reformatted dns::key and wrote tests for it [\#48](https://github.com/ajjahn/puppet-dns/pull/48) ([danzilio](https://github.com/danzilio))
- allow recursion [\#47](https://github.com/ajjahn/puppet-dns/pull/47) ([gcmalloc](https://github.com/gcmalloc))
- Adding a forward option for a zone. [\#46](https://github.com/ajjahn/puppet-dns/pull/46) ([gcmalloc](https://github.com/gcmalloc))
- Update zone-serial only on changing zone-records \(sed version\) [\#45](https://github.com/ajjahn/puppet-dns/pull/45) ([kubashin-a](https://github.com/kubashin-a))
- Use FQDN as PTR name instead of octet [\#43](https://github.com/ajjahn/puppet-dns/pull/43) ([kubashin-a](https://github.com/kubashin-a))
- El compatible [\#41](https://github.com/ajjahn/puppet-dns/pull/41) ([sereinity](https://github.com/sereinity))
- Solved Syntax error at 'inherits' in ::dns::server::options.pp:18 [\#40](https://github.com/ajjahn/puppet-dns/pull/40) ([n1tr0g](https://github.com/n1tr0g))
- Params refactor for future OS support with tests... on top of danzilio's refactor [\#34](https://github.com/ajjahn/puppet-dns/pull/34) ([solarkennedy](https://github.com/solarkennedy))
- Allow transfer... on top of danzilios refactor [\#33](https://github.com/ajjahn/puppet-dns/pull/33) ([solarkennedy](https://github.com/solarkennedy))
- Update zone\_file.erb [\#31](https://github.com/ajjahn/puppet-dns/pull/31) ([seanscottking](https://github.com/seanscottking))
- Update Modulefile [\#30](https://github.com/ajjahn/puppet-dns/pull/30) ([seanscottking](https://github.com/seanscottking))
- ACL [\#29](https://github.com/ajjahn/puppet-dns/pull/29) ([danzilio](https://github.com/danzilio))
- Refactored the module with a better Gemfile and Rakefile. [\#28](https://github.com/ajjahn/puppet-dns/pull/28) ([danzilio](https://github.com/danzilio))
- Template changes [\#27](https://github.com/ajjahn/puppet-dns/pull/27) ([ppouliot](https://github.com/ppouliot))
- Add possibility to set forwarders [\#23](https://github.com/ajjahn/puppet-dns/pull/23) ([zeleznypa](https://github.com/zeleznypa))
- Added support for SRV DNS record types. [\#20](https://github.com/ajjahn/puppet-dns/pull/20) ([samcday](https://github.com/samcday))

## [v0.1.4](https://github.com/ajjahn/puppet-dns/tree/v0.1.4) (2013-02-12)
[Full Changelog](https://github.com/ajjahn/puppet-dns/compare/v0.1.3...v0.1.4)

## [v0.1.3](https://github.com/ajjahn/puppet-dns/tree/v0.1.3) (2013-01-14)
**Closed issues:**

- Named.conf Updates [\#13](https://github.com/ajjahn/puppet-dns/issues/13)
- Building PTR Records Fails With Same Resource Defined In Seperate Zones [\#12](https://github.com/ajjahn/puppet-dns/issues/12)
- Zone regenerates w/ every Puppet run [\#3](https://github.com/ajjahn/puppet-dns/issues/3)

**Merged pull requests:**

- add supoprt for managing slave zones [\#14](https://github.com/ajjahn/puppet-dns/pull/14) ([aussielunix](https://github.com/aussielunix))
- MX Records need a host field [\#11](https://github.com/ajjahn/puppet-dns/pull/11) ([aaronbbrown](https://github.com/aaronbbrown))
- Syntax error when using strings [\#10](https://github.com/ajjahn/puppet-dns/pull/10) ([aaronbbrown](https://github.com/aaronbbrown))
- Dependency version [\#9](https://github.com/ajjahn/puppet-dns/pull/9) ([aaronbbrown](https://github.com/aaronbbrown))
- A few Modulefile corrections [\#8](https://github.com/ajjahn/puppet-dns/pull/8) ([aaronbbrown](https://github.com/aaronbbrown))
- Changed single quotes to doubles [\#7](https://github.com/ajjahn/puppet-dns/pull/7) ([zodeus](https://github.com/zodeus))
- .IN-ADDR.ARPA is missing when a PTR record is created with an A record [\#2](https://github.com/ajjahn/puppet-dns/pull/2) ([guillaumerose](https://github.com/guillaumerose))
- Fix bug in mx record [\#1](https://github.com/ajjahn/puppet-dns/pull/1) ([dvigueras](https://github.com/dvigueras))



\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*