diff --git a/manifests/server/options.pp b/manifests/server/options.pp
index 6e2df08..bd1f77b 100644
--- a/manifests/server/options.pp
+++ b/manifests/server/options.pp
@@ -49,6 +49,19 @@
 #            both statistic_channel_port and statistic_channel_ip must be defined
 #            for the statistic api to be enabled
 #
+# [*zone_notify*]
+#   Controls notifications when a zone for which this server is
+#   authoritative changes.  String of yes (send notifications to zone's
+#   NS records and to also-notify list), no (no notifications are sent),
+#   master-only (only send notifications for master zones), or explicit
+#   (send notifications only to also-notify list).
+#   Default: undef, meaning the BIND default of "yes"
+#
+# [*also_notify*]
+#   The list of servers to which additional zone-change notifications
+#   should be sent.
+#   Default: empty, meaning no additional servers
+#
 # === Examples
 #
 #  dns::server::options { '/etc/bind/named.conf.options':
@@ -67,6 +80,8 @@ define dns::server::options (
   $allow_query = [],
   $statistic_channel_ip = undef,
   $statistic_channel_port = undef,
+  $zone_notify = undef,
+  $also_notify = [],
 ) {
   $valid_check_names = ['fail', 'warn', 'ignore']
   $cfg_dir = $::dns::server::params::cfg_dir
@@ -98,6 +113,12 @@ define dns::server::options (
     fail('The statistic_channel_ip is not an ip string')
   }
 
+  validate_array($also_notify)
+  $valid_zone_notify = ['yes', 'no', 'explicit', 'master-only']
+  if $zone_notify != undef and !member($valid_zone_notify, $zone_notify) {
+    fail("The zone_notify must be ${valid_zone_notify}")
+  }
+
   file { $title:
     ensure  => present,
     owner   => $::dns::server::params::owner,
diff --git a/manifests/zone.pp b/manifests/zone.pp
index 018bf11..be047cb 100644
--- a/manifests/zone.pp
+++ b/manifests/zone.pp
@@ -15,7 +15,8 @@ define dns::zone (
   $allow_forwarder = [],
   $forward_policy = 'first',
   $slave_masters = undef,
-  $zone_notify = false,
+  $zone_notify = undef,
+  $also_notify = [],
   $ensure = present
 ) {
 
@@ -31,6 +32,12 @@ define dns::zone (
     error('The forward policy can only be set to either first or only')
   }
 
+  validate_array($also_notify)
+  $valid_zone_notify = ['yes', 'no', 'explicit', 'master-only']
+  if $zone_notify != undef and !member($valid_zone_notify, $zone_notify) {
+    fail("The zone_notify must be ${valid_zone_notify}")
+  }
+
   $zone = $reverse ? {
     true    => "${name}.in-addr.arpa",
     default => $name
diff --git a/spec/defines/dns__server__options_spec.rb b/spec/defines/dns__server__options_spec.rb
index 6adc8ed..2a2b3b8 100644
--- a/spec/defines/dns__server__options_spec.rb
+++ b/spec/defines/dns__server__options_spec.rb
@@ -156,5 +156,69 @@ describe 'dns::server::options', :type => :define do
     it { should contain_file('/etc/bind/named.conf.options').with_content(/inet 127\.0\.0\.1 port 12455;/)  }
   end
 
+  context 'passing no zone_notify setting' do
+    let :params do
+      {}
+    end
+    it { should contain_file('/etc/bind/named.conf.options').without_content(/^notify /) }
+  end
+
+  context 'passing a wrong zone_notify setting' do
+    let :params do
+      { :zone_notify => 'maybe' }
+    end
+    it { should raise_error(Puppet::Error, /The zone_notify/) }
+  end
+
+  context 'passing yes to zone_notify' do
+    let :params do
+      { :zone_notify => 'yes' }
+    end
+    it { should contain_file('/etc/bind/named.conf.options').with_content(/^notify yes;/) }
+  end
+
+  context 'passing no to zone_notify' do
+    let :params do
+      { :zone_notify => 'no' }
+    end
+    it { should contain_file('/etc/bind/named.conf.options').with_content(/^notify no;/) }
+  end
+
+  context 'passing master-only to zone_notify' do
+    let :params do
+      { :zone_notify => 'master-only' }
+    end
+    it { should contain_file('/etc/bind/named.conf.options').with_content(/^notify master-only;/) }
+  end
+
+  context 'passing explicit to zone_notify' do
+    let :params do
+      { :zone_notify => 'explicit' }
+    end
+    it { should contain_file('/etc/bind/named.conf.options').with_content(/^notify explicit;/) }
+  end
+
+  context 'passing no also_notify setting' do
+    let :params do
+      {}
+    end
+    it { should contain_file('/etc/bind/named.conf.options').without_content(/^also-notify /) }
+  end
+
+  context 'passing a string to also_notify' do
+    let :params do
+      { :also_notify => '8.8.8.8' }
+    end
+    it { should raise_error(Puppet::Error, /is not an Array/) }
+  end
+
+  context 'passing a valid array to also_notify' do
+    let :params do
+      { :also_notify => [ '8.8.8.8' ] }
+    end
+    it { should contain_file('/etc/bind/named.conf.options').with_content(/^also-notify {/) }
+    it { should contain_file('/etc/bind/named.conf.options').with_content(/8\.8\.8\.8;/) }
+  end
+
 end
 
diff --git a/spec/defines/dns__zone_spec.rb b/spec/defines/dns__zone_spec.rb
index 2b7e346..783569c 100644
--- a/spec/defines/dns__zone_spec.rb
+++ b/spec/defines/dns__zone_spec.rb
@@ -183,4 +183,69 @@ describe 'dns::zone' do
       end
   end
 
+  context 'passing no zone_notify setting' do
+    let :params do
+      {}
+    end
+    it { should contain_concat__fragment('named.conf.local.test.com.include').without_content(/ notify /) }
+  end
+
+  context 'passing a wrong zone_notify setting' do
+    let :params do
+      { :zone_notify => 'maybe' }
+    end
+    it { should raise_error(Puppet::Error, /The zone_notify/) }
+  end
+
+  context 'passing yes to zone_notify' do
+    let :params do
+      { :zone_notify => 'yes' }
+    end
+    it { should contain_concat__fragment('named.conf.local.test.com.include').with_content(/ notify yes;/) }
+  end
+
+  context 'passing no to zone_notify' do
+    let :params do
+      { :zone_notify => 'no' }
+    end
+    it { should contain_concat__fragment('named.conf.local.test.com.include').with_content(/ notify no;/) }
+  end
+
+  context 'passing master-only to zone_notify' do
+    let :params do
+      { :zone_notify => 'master-only' }
+    end
+    it { should contain_concat__fragment('named.conf.local.test.com.include').with_content(/ notify master-only;/) }
+  end
+
+  context 'passing explicit to zone_notify' do
+    let :params do
+      { :zone_notify => 'explicit' }
+    end
+    it { should contain_concat__fragment('named.conf.local.test.com.include').with_content(/ notify explicit;/) }
+  end
+
+  context 'passing no also_notify setting' do
+    let :params do
+      {}
+    end
+    it { should contain_concat__fragment('named.conf.local.test.com.include').without_content(/ also-notify /) }
+  end
+
+  context 'passing a string to also_notify' do
+    let :params do
+      { :also_notify => '8.8.8.8' }
+    end
+    it { should raise_error(Puppet::Error, /is not an Array/) }
+  end
+
+  context 'passing a valid array to also_notify' do
+    let :params do
+      { :also_notify => [ '8.8.8.8' ] }
+    end
+    it { should contain_concat__fragment('named.conf.local.test.com.include').with_content(/ also-notify {/) }
+    it { should contain_concat__fragment('named.conf.local.test.com.include').with_content(/8\.8\.8\.8;/) }
+  end
+
 end
+
diff --git a/templates/named.conf.options.erb b/templates/named.conf.options.erb
index ddeb7ea..e1b70b4 100644
--- a/templates/named.conf.options.erb
+++ b/templates/named.conf.options.erb
@@ -75,6 +75,17 @@ statistics-channels {
 };
 <% end -%>
 
+<% if @zone_notify -%>
+notify <%= @zone_notify %>;
+<% end -%>
+<% if @also_notify.size != 0 then -%>
+also-notify {
+    <%- @also_notify.each do |ip| -%>
+    <%= ip -%>;
+    <%- end -%>
+};
+<% end -%>
+
 	//========================================================================
 	// If BIND logs error messages about the root key being expired,
 	// you will need to update your keys.  See https://www.isc.org/bind-keys
diff --git a/templates/zone.erb b/templates/zone.erb
index 1c14fd3..0bd6a8b 100644
--- a/templates/zone.erb
+++ b/templates/zone.erb
@@ -3,6 +3,13 @@ type <%= @zone_type %>;
 <% if @zone_notify -%>
     notify <%= @zone_notify %>;
 <% end -%>
+<% if @also_notify.size != 0 -%>
+    also-notify {
+    <%- @also_notify.each do |ip| -%>
+        <%= ip %>;
+    <%- end -%>
+    };
+<% end -%>
 <% if @zone_type != 'forward' -%>
     file "<%= @zone_file %>";
 <% end -%>
