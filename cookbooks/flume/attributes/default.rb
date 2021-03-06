
#By default, flume plays as a part of the cluster the machine
#belongs to.
default[:flume][:cluster_name] = node[:cluster_name]

#
# Locations
#

default[:flume][:home_dir]             = '/usr/lib/flume'
default[:flume][:conf_dir]             = '/etc/flume/conf'
default[:flume][:pid_dir]              = "/var/run/flume"
default[:flume][:lib_dir]              = File.join(default[:flume][:home_dir], 'lib')
default[:flume][:ics_extensions_pom]   = File.join(default[:flume][:conf_dir], 'ics_extensions.pom.xml')

default[:flume][:agent ][:log_dir]      = "/var/log/flume/agent"
default[:flume][:master][:log_dir]      = "/var/log/flume/master"

default[:flume][:zk]                    = Mash.new
default[:flume][:collector]             = Mash.new

default[:flume][:user]                 = 'flume'
default[:flume][:group]                 = 'flume'
default[:users ]['flume'][:uid]        = 325
default[:groups]['flume'][:gid]        = 325

# these are set by the recipes
node[:flume][:exported_jars ] = []
node[:flume][:exported_confs] = []

#
# Services
#

default[:flume][:master][:run_state] = :stop
default[:flume][:agent ][:run_state] = :start


#
# Tunables
#

# By default, flume installs its own zookeeper instance.  With
# :external_zookeeper to "true", the recipe will work out which machines are in
# the zookeeper quorum based on cluster membership; modify
# node[:discovers][:zookeeper_server] to have it use an external cluster
default[:flume][:master][:external_zookeeper] = false
default[:flume][:master][:zookeeper_port] = 2181

# If flume is not using the external_zookeeper, its internal zookeeper opens this port
default[:flume][:zookeeper][:port] = 3181

# configuration data for plugins.
# node[:flume][:plugins][:some_plugin][:classes]    = [ 'java.lang.String' ]
# node[:flume][:plugins][:some_plugin][:classpath]  = [ "/usr/lib/jruby/jruby.jar" ]
# node[:flume][:plugins][:some_plugin][:java_opts]  = [ "-Dsomething.special=1" ]
default[:flume][:plugins] = {}

default[:flume][:jars][:jruby_jar_version] = "1.0.0"

default[:flume][:ics_extensions_version]   = "1.0"

# classes to include as plugins
default[:flume][:classes] = []

# jars and dirs to put on FLUME_CLASSPATH
default[:flume][:classpath] = []

# pass in extra options to the java virtual machine
default[:flume][:java_opts] = []

# Set the following two attributes to allow writing to s3 buckets:
default[:flume][:aws_access_key] = nil
default[:flume][:aws_secret_key] = nil

 # The maximum size (in bytes) allowed for an event.  Will not be set
# (Flume will use its default value) if set to 'nil' here.
default[:flume][:max_event_size] = nil
