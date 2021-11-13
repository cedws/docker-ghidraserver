#!/bin/bash

set -e

cat << 'EOF' > ~/server/server.conf
#********************************************************************
# Service Wrapper Properties
#********************************************************************

# Initial Working Directory (i.e., absolute installation directory path)
wrapper.working.dir=${ghidra_home}

# Mac OS X launchd plist directory
wrapper.launchd.dir=/Library/LaunchDaemons

# Java Application
wrapper.java.command=${java}

# Establish default permissions for generated files
wrapper.java.umask=027

# Java Classpath
include=${classpath_frag}

# Java Additional Parameters
wrapper.java.additional.1=-Djava.net.preferIPv4Stack=true

# Establishes a minimum number of rolling server.log backups to be maintained
wrapper.java.additional.2=-DApplicationRollingFileAppender.maxBackupIndex=10

# Ensure that classpath_frag is defined for service startup
wrapper.java.additional.3=-Dclasspath_frag=${classpath_frag}

# Limit server to specific TLS protocols for all secure connections.
# NOTE: multiple protocols must be separated with a semi-colon (e.g., TLSv1.2;TLSv1.3).
wrapper.java.additional.4=-Dghidra.tls.server.protocols=TLSv1.2;TLSv1.3

# A suitable cacerts file must be installed when using PKI authentication
#wrapper.java.additional.5=-Dghidra.cacerts=./Ghidra/cacerts

# If Ghidra clients must authenticate the server, the server will need to install
# a server key/certificate in a secure location (e.g., /etc/pki/...) 
# and specify the location and password via the properties below.
# Be sure to properly set permissions on the Ghidra installation and this file
# if using these settings.
#wrapper.java.additional.6=-Dghidra.keystore=
#wrapper.java.additional.7=-Dghidra.password=

# Temporary Directory Setting - uncomment the following setting to override the Java default.
# This may be necessary on certain Windows platforms when installing as a service.
#wrapper.java.additional.8=-Djava.io.tmpdir=C:\\Windows\\Temp

# Enable/Disable use of compression for DataBuffer serialization and Block Streams
wrapper.java.additional.9=-Ddb.buffers.DataBuffer.compressedOutput=true

# Uncomment to enable remote debug support
# The debug address will listen on all network interfaces, if desired the '*' may be
# set to a specific interface IP address (e.g., 127.0.0.1) if you wish to restrict.
# During debug it may be necessary to increase timeout values to prevent the wrapper
# from restarting the server due to unresponsiveness.
#wrapper.java.additional.10=-Xdebug
#wrapper.java.additional.11=-Xnoagent
#wrapper.java.additional.12=-Djava.compiler=NONE
#wrapper.java.additional.13=-Xrunjdwp:transport=dt_socket\,server=y\,suspend=n\,address=*:18200
#wrapper.startup.timeout=0
#wrapper.ping.timeout=0

# Optional debug enablement instead of using the wrapper.java.additional arguments above
# This will cause application to start in a suspended state in debug mode and increase
# timeouts to their maximum values.
#wrapper.java.debug.port=18200

# Uncomment to enable remote use of jvisualvm for profiling
# See JMX documentation for more information: http://docs.oracle.com/javase/8/docs/technotes/guides/management/agent.html
#wrapper.java.additional.14=-Dcom.sun.management.jmxremote.port=9010
#wrapper.java.additional.15=-Dcom.sun.management.jmxremote.local.only=false
#wrapper.java.additional.16=-Dcom.sun.management.jmxremote.authenticate=false
#wrapper.java.additional.17=-Dcom.sun.management.jmxremote.ssl=false

# YAJSW will by default assume a POSIX spawn for Linux and Mac OS X systems, unfortunately it has 
# not yet been implemented for Mac OS X.  The default process support within YAJSW for Mac OS X is 
# broken so we must force the use of BSD process support which appears to work properly.  To enable 
# this mode of operation the wrapper.fork_hack option must be enabled and the wrapper.posix_spawn
# option explicitly disabled.  The ghidraSvr script will attempt to make these changes automatically
# for Mac OS X.
#wrapper.fork_hack=true

# Pipe server output to console/log
#wrapper.console.pipestreams=true

# Monitor for Deadlock
wrapper.java.monitor.deadlock = true

# Main server application class
wrapper.java.app.mainclass=ghidra.server.remote.GhidraServer

# Specify the directory used to store repositories. This directory must be dedicated to this 
# Ghidra Server instance and may not contain files or folders not produced by the 
# Ghidra Server or its administrative scripts.  Relative paths originate from the 
# Ghidra installation directory, although an absolute path is preferred if not using default.
# This variable is also used by the svrAdmin script.

ghidra.repositories.dir=/srv/repositories

# Establish server process owner
# This should only be used when installing as a service using a nologin
# local user account.  Establishing a suitable account is left as a
# system administration task.  NOTE: the use of this feature is not
# yet supported for Windows installations.
#wrapper.app.account=ghidra

#********************************************************************
# Service Wrapper Logging Properties
#********************************************************************
# Format of output for the console.  (See docs for formats)
wrapper.console.format=PM

# Log Level for console output.  (use INFO to see Ghidra Server activity)
wrapper.console.loglevel=INFO

# Provide additional wrapper debug logging info
#wrapper.debug=true

# Log file to use for wrapper output logging.
wrapper.logfile=wrapper.log

# Format of output for the log file.  (See docs for formats)
wrapper.logfile.format=LPTM

# Log Level for wrapper.log file output.  (See docs for log levels)
wrapper.logfile.loglevel=INFO

# Maximum size that the log file will be allowed to grow to before
#  the log is rolled. Size is specified in bytes.  The default value
#  of 0, disables log rolling.  May abbreviate with the 'k' (kb) or
#  'm' (mb) suffix.  For example: 10m = 10 megabytes.
wrapper.logfile.maxsize=10m

# Maximum number of rolled log files which will be allowed before old
#  files are deleted.  The default value of 0 implies no limit.
wrapper.logfile.maxfiles=10

#********************************************************************
# Service Wrapper Linux Properties
#********************************************************************
# Force initd (systemd had issues during testing on Ubuntu 21.04 with yajsw-13.00)
wrapper.daemon.system = initd

#********************************************************************
# Service Wrapper Windows Properties
#********************************************************************
# Title to use when running as a console
wrapper.console.title=Ghidra Server

#********************************************************************
# Service Wrapper Windows NT/2000/XP Service Properties
#********************************************************************
# WARNING - Do not modify any of these properties when an application
#  using this configuration file has been installed as a service.
#  Please uninstall the service before modifying this section.  The
#  service can then be reinstalled.

# Name of the service
wrapper.ntservice.name=ghidraSvr

# Display name of the service
wrapper.ntservice.displayname=Ghidra Server

# Description of the service
wrapper.ntservice.description=Repository server for Ghidra data files.

# Service dependencies.  Add dependencies as needed starting from 1
wrapper.ntservice.dependency.1=

# Mode in which the service is installed.  
wrapper.ntservice.starttype=AUTO_START

# Linux service daemon priority for Ghidra Server (start/stop)
# It is important that the network interface has started and any file-system
# dependencies are mounted prior to the Ghidra Server starting.
# NOTE: uninstall the Ghidra Server service using svrUninstall script before changing 
# the property wrapper.daemon.update_rc or wrapper.daemon.run_level_dir property.
wrapper.daemon.update_rc= 98 05

# Linux service daemon link directories
wrapper.daemon.run_level_dir=/etc/rcX.d

# Allow the service to interact with the desktop.
wrapper.ntservice.interactive=false

# Restart failed service after 1 minute delay
wrapper.ntservice.failure_actions.actions=RESTART
wrapper.ntservice.failure_actions.actions_delay=60000

wrapper.app.parameter.100=${ghidra.repositories.dir}
EOF

cat << EOF >> ~/server/server.conf
wrapper.app.parameter.1=-ip ${GHIDRASERVER_FQDN:?"GHIDRASERVER_FQDN must be specified"}
wrapper.app.parameter.2=${GHIDRASERVER_IP:+"-i $GHIDRASERVER_IP"}
wrapper.app.parameter.3=-p${GHIDRASERVER_PORT}
wrapper.app.parameter.4=${GHIDRASERVER_ENABLE_REVERSE_LOOKUP:+"-n"}
wrapper.app.parameter.5=-a${GHIDRASERVER_AUTHENTICATION_MODE}
wrapper.app.parameter.6=${GHIDRASERVER_AD_DOMAIN:+-"d$GHIDRASERVER_AD_DOMAIN"}
wrapper.app.parameter.7=-e${GHIDRASERVER_PASSWORD_EXPIRATION}
wrapper.app.parameter.8=${GHIDRASERVER_ENABLE_USERID_PROMPT:+"-u"}
wrapper.app.parameter.9=${GHIDRASERVER_ENABLE_AUTOPROVISION:+"-autoProvision"}
wrapper.app.parameter.10=${GHIDRASERVER_ENABLE_ANONYMOUS:+"-anonymous"}
wrapper.app.parameter.11=${GHIDRASERVER_ENABLE_SSH:+"-ssh"}

wrapper.java.initmemory=${GHIDRASERVER_JAVA_XMS}
wrapper.java.maxmemory=${GHIDRASERVER_JAVA_XMX}
EOF

if [ $# -gt 0 ]; then
	cd ~/server
	exec $@
fi

export java="java"
export ghidra_home="$HOME"
export classpath_frag="../Ghidra/Features/GhidraServer/data/classpath.frag"

exec java -jar $(find -name wrapper.jar) -c ~/server/server.conf