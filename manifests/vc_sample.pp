class vcenter::vc_sample {

  $host_datetime = {
    ntpConfig => {
      running => true,
      policy => 'automatic',
      server => [ '0.pool.ntp.org', '1.pool.ntp.org', ],
    },
    timeZone => {
      key => 'UTC',
    },
  }

  $host_shell = {
    esxi_shell => {
      running => false,
      policy => 'off',
    },
    ssh => {
      running => false,
      policy => 'off',
    },
    esxi_shell_time_out => 0,
    esxi_shell_interactive_time_out => 0,
    suppress_shell_warning => 0,
  }

  $host_svcs = {
    dcui => {
      running => true,
      policy => 'on',
    },
  }

  transport { 'demo':
    username => 'tseadmin@vsphere.local',
    password => '****',
    server   => 'vmware-vc5-prod.ops.puppetlabs.net',
    options  => { 'insecure' => true },
  }

  vcenter::host { '10.32.76.221':
    path           => '/opdx5/tse',
    username       => 'root',
    password       => 'puppetlabs',
    dateTimeConfig => $host_datetime,
    shells         => $host_shell,
    servicesConfig => $host_svcs,
    transport      => Transport['demo'],
  }

  transport { 'lab6':
    username => 'administrator@vsphere.local',
    password => '****',
    server   => '10.32.47.214',
    options  => { 'insecure' => true },
  }

  vcenter::host { '10.32.76.196':
    path           => '/Datacenter',
    username       => 'root',
    password       => 'puppetlabs',
    dateTimeConfig => $host_datetime,
    shells         => $host_shell,
    servicesConfig => $host_svcs,
    transport      => Transport['lab6'],
  }
}
