class known_hosts( $username = 'ubuntu' ) {
    $group = $username
    $server_list = [ 'github.com' ]
 
    file{ '/home/ubuntu/.ssh' :
      ensure => directory,
      group => $group,
      owner => $username,
      mode => 0600,
    }
 
    file{ '/home/ubuntu/.ssh/known_hosts' :
      ensure => file,
      group => $group,
      owner => $username,
      mode => 0600,
      require => File[ '/home/ubuntu/.ssh' ],
    }
 
    file{ '/tmp/known_hosts.sh' :
      ensure => present,
      group => $group,
      owner => $username,
      mode => 0755,
      source => 'puppet:///modules/known_hosts/known_hosts.sh',
    }
 
    exec{ 'add_known_hosts' :
      command => "/tmp/known_hosts.sh",
      path => "/sbin:/usr/bin:/usr/local/bin/:/bin/",
      provider => shell,
      user => 'ubuntu',
      require => File[ '/home/ubuntu/.ssh/known_hosts', '/tmp/known_hosts.sh' ]
    }
}
