# Copyright (C) 2015 VMware, Inc.
require 'pathname'
module_lib    = Pathname.new(__FILE__).parent.parent.parent
require File.join module_lib, 'puppet_x/vmware/mapper'
require File.join module_lib, 'puppet_x/vmware/vmware_lib/puppet/property/vmware'

Puppet::Type.newtype(:vm_harddisk) do
  @doc = "Manage a vCenter VM's virtual disk settings. See http://pubs.vmware.com/vsphere-55/index.jsp#com.vmware.wssdk.apiref.doc/vim.vm.device.VirtualDisk.html for class details"

  #### create parameters ####
  # the parameters are specific data points needed to set the properties pulled in by mapper and may change between types 
  ensurable do
    newvalue(:present) do
      provider.create
    end

    newvalue(:absent) do
      provider.destroy
    end

    defaultto(:present)

    def change_to_s(is, should)
      if should == :present
        provider.create_message
      else
        "removed"
      end
    end
  end

  newparam(:name) do
    desc "The display label of the virtual hard disk"
  end

  newparam(:vm_name) do
    desc "The name of the target VM"
  end

  newparam(:datacenter) do
    desc "The name of the datacenter hosting the target VM"
    newvalues(/\w/)
  end

  newparam(:datastore) do
    desc "The target datastore used for creation of the virtual disk file"
  end

  newparam(:thin_provisioned) do
    desc "Flag to indicate to the underlying filesystem, whether the virtual disk backing file should be allocated lazily (using thin provisioning)"
    newvalues(:true, :false)
    defaultto(:true)
  end

  newparam(:eager_scrub) do
    desc "Flag to indicate to the underlying filesystem whether the virtual disk backing file should be scrubbed completely at this time. If this flag is unset or set to false when creating a new disk, the disk scrubbing policy will be decided by the filesystem."
    newvalues(:true, :false)
  end

  newparam(:remove_disk) do
    desc "If attempting to destroy the resource, this will determine if the backing file is deleted from the datastore"
    newvalues(:true, :false)
    defaultto(:false)
  end

  #### create resource properties from mapper ####
  # besides the map name, this section should remain the same between types created using vmware mapper
  map = PuppetX::VMware::Mapper.new_map('VirtualDiskMap')
  map.leaf_list.each do |leaf|
    option = {}
    if type_hash = leaf.olio[t = Puppet::Property::VMware_Array]
      option.update(
        :array_matching => :all,
        :parent => t
      )
    elsif type_hash = leaf.olio[t = Puppet::Property::VMware_Array_Hash]
      option.update(
        :parent => t
      )
    end
    option.update(type_hash[:property_option]) if
        type_hash && type_hash[:property_option]

    newproperty(leaf.prop_name, option) do
      desc(leaf.desc) if leaf.desc
      newvalues(*leaf.valid_enum) if leaf.valid_enum
      munge {|val| leaf.munge.call(val)} if leaf.munge
      validate {|val| leaf.validate.call(val)} if leaf.validate
      eval <<-EOS
        def change_to_s(is,should)
          "[#{leaf.full_name}] changed \#{is_to_s(is).inspect} to \#{should_to_s(should).inspect}"
        end
      EOS
    end
  end
end
