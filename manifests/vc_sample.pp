class vc_sample {

  transport { 'demo':
    username => 'tseadmin@vsphere.local',
    password => '****',
    server   => 'vmware-vc5-prod.ops.puppetlabs.net',
    options  => { 'insecure' => true },
  }
  transport { 'lab6':
    username => 'administrator@vsphere.local',
    password => '****',
    server   => '10.32.47.214',
    options  => { 'insecure' => true },
  }

  vcenter::host { '10.32.76.196':
    path      => '/Datacenter',
    username  => 'root',
    password  => 'puppetlabs',
    transport => Transport['lab6'],
  }
   vcenter::host { '10.32.76.221':
    path      => '/opdx5/tse',
    username  => 'root',
    password  => 'puppetlabs',
    transport => Transport['demo'],
  }
}
