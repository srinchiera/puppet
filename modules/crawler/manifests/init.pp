class crawler () {

	class { 'python':
	   version    => '2.7',
	   pip        => true,
	   dev        => true,
	   virtualenv => true,
	 }

	package { 'git':
		name => 'git',
		ensure => present,
	}

	package { 'libmysqlclient-dev' :
		ensure  => present
	}
	package { 'chromium-chromedriver' :
		ensure  => present
	}

	package {'ubuntu-desktop':
		ensure => present
	}

	package {'vnc4server':
		ensure => present
	}

	python::pip { 'Django==1.4': } python::pip { 'Selenium': }
	python::pip { 'BeautifulSoup': }

	file { "/home/ubuntu/dev":
	    ensure => "directory",
	    owner  => "ubuntu",
	    group  => "ubuntu",
	}

	vcsrepo { "/home/ubuntu/dev/zhunka":
	  ensure   => present,
	  provider => git,
	  source   => "git@github.com:kokani/zhunka.git",
	  user     => "ubuntu",
	 }

	vcsrepo { "/home/ubuntu/dev/ragtrades":
	  ensure   => present,
	  provider => git,
	  user     => "ubuntu",
	  source   => "git@github.com:kokani/ragtrades.git",
	}

	vcsrepo { "/home/ubuntu/dev/zhunka_brandlinks":
	  ensure   => present,
	  provider => git,
	  user     => "ubuntu",
	  source   => "git@github.com:ragtrades/zhunka_brandlinks.git",
	}

	exec { 'chromedriver-download':
	  command => 'wget http://chromedriver.storage.googleapis.com/2.9/chromedriver_linux64.zip -O /tmp/chromedriver.zip',
	  unless  => 'which chromedriver',
	  path    => ['/usr/bin'],
	  notify  => Exec['chromedriver-download'],
	}

	exec { 'chromedriver-download':
	  command     => 'unzip chromedriver.zip',
	  cwd         => '/tmp',
	  path        => ['/usr/bin'],
	  refreshonly => true,
	  require     => Exec['chromedriver-download'],
	}
}
