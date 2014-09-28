class crawler () {

	# Environment variables
	$django_settings = "export DJANGO_SETINGS_VARIABLE='zhunka.settings'"
	$python_path = "export PYTHON_PATH=\$PYTHONPATH:/home/ubuntu/dev"
	$exports = "${django_settings}\n${python_path}"
	file { "/etc/profile.d/zhunka.sh":
	  path => "/etc/profile.d/zhunka.sh",
	  ensure => present,
	  mode => 755,
	  content => "$exports"
	}

	# Git is included in known hosts
	class { 'known_hosts': }

	class { 'python':
	   version    => '2.7',
	   pip        => true,
	   dev        => true,
	   virtualenv => true,
	 }

	package { 'mysql-server':
		ensure => present,
	} ->
	service { 'mysql':
		ensure => running,
	}

	package { 'git':
		name => 'git',
		ensure => present,
	}

	package { 'libmysqlclient-dev' :
		ensure  => present
	}


	python::pip { 'Django==1.4': } python::pip { 'Selenium': }
	python::pip { 'BeautifulSoup4': }

	# Creates dev directory
	file { "/home/ubuntu/dev":
	    ensure => "directory",
	    owner  => "ubuntu",
	    group  => "ubuntu"
	} 
	# Get repos
	vcsrepo { "/home/ubuntu/dev/zhunka":
	  ensure   => present,
	  provider => git,
	  source   => "git@github.com:kokani/zhunka.git",
	  user     => "ubuntu",
	  require => File['/home/ubuntu/dev']
	} vcsrepo { "/home/ubuntu/dev/ragtrades": ensure   => present, provider => git, user     => "ubuntu", source   => "git@github.com:kokani/ragtrades.git", require => File['/home/ubuntu/dev'] }
	vcsrepo { "/home/ubuntu/dev/zhunka_brandlinks":
	  ensure   => present,
	  provider => git,
	  user     => "ubuntu",
	  source   => "git@github.com:ragtrades/zhunka_brandlinks.git",
	  require => File['/home/ubuntu/dev']
	}

	file { "/home/ubuntu/dev/zhunka/logs":
	    ensure  => "directory",
	    owner   => "ubuntu",
	    group   => "ubuntu",
	    require => Vcsrepo['/home/ubuntu/dev/zhunka']
	} ->
	file { "/home/ubuntu/dev/zhunka/logs/crawler":
	    ensure => "directory",
	    owner  => "ubuntu",
	    group  => "ubuntu"
	} 


	# Chromium + flash
	package { 'chromium-browser': } ->
	package { 'pepperflashplugin-nonfree': } ->
	package { 'chromium-chromedriver' :
		ensure  => present
	}

	# Gets chromedriver
	exec { 'chromedriver-download':
	  command => 'wget http://chromedriver.storage.googleapis.com/2.9/chromedriver_linux64.zip -O /tmp/chromedriver.zip',
	  unless  => 'which chromedriver',
	  path    => ['/usr/bin'],
	  notify  => Exec['chromedriver-install'],
	}
	exec { 'chromedriver-install':
	  command     => 'unzip chromedriver.zip -d /usr/local/bin',
	  cwd         => '/tmp',
	  unless      => 'which chromedriver',
	  path        => ['/usr/bin'],
	  refreshonly => true,
	  require     => Exec['chromedriver-download'],
	}
	exec { 'chmod chromedriver':
	  command => "chmod 0755 chromedriver",
	  cwd         => '/usr/local/bin',
	  unless      => 'which chromedriver',
	  path        => ['/bin'],
	  require     => Exec['chromedriver-install'],
	}

	# Allows remote vnc connections
	package {'ubuntu-desktop':
		ensure => present
	}
	package {'vnc4server':
		ensure => present
	}
}
