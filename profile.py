"""This is a trivial example of a gitrepo-based profile; The profile source code and other software, documentation, etc. are stored in in a publicly accessible GIT repository (say, github.com). When you instantiate this profile, the repository is cloned to all of the nodes in your experiment, to `/local/repository`. 

This particular profile is a simple example of using a single raw PC. It can be instantiated on any cluster; the node will boot the default operating system, which is typically a recent version of Ubuntu.

Instructions:
Wait for the profile instance to start, then click on the node in the topology and choose the `shell` menu item. 
"""

# Import the Portal object.
import geni.portal as portal
# Import the ProtoGENI library.
import geni.rspec.pg as pg

import geni.rspec.emulab as emulab

# Create a portal context.
pc = portal.Context()

# Create a Request object to start building the RSpec.
request = pc.makeRequestRSpec()

# Variable number of nodes.
pc.defineParameter("nodeCount", "Number of Nodes", portal.ParameterType.INTEGER, 1,
                   longDescription="If you specify more then one node, " +
                   "we will create a lan for you.")

# Pick your OS.
imageList = [
    ('default', 'Default Image'),
    ('urn:publicid:IDN+emulab.net+image+emulab-ops//UBUNTU24-64-STD', 'Ubuntu 24.04'),
    ('urn:publicid:IDN+emulab.net+image+emulab-ops//UBUNTU22-64-STD', 'Ubuntu 22.04'),
    ('urn:publicid:IDN+emulab.net+image+emulab-ops//UBUNTU20-64-STD', 'Ubuntu 20.04'),
    ('urn:publicid:IDN+emulab.net+image+emulab-ops//UBUNTU18-64-STD', 'Ubuntu 18.04'),
    ('urn:publicid:IDN+emulab.net+image+emulab-ops//CENTOS9S-64-STD', 'CentOS 9 Stream'),
    ('urn:publicid:IDN+emulab.net+image+emulab-ops//CENTOS8S-64-STD', 'CentOS 8 Stream'),
    ('urn:publicid:IDN+emulab.net+image+emulab-ops//ROCKY9-64-STD',   'Rocky Linux 9'),
    ('urn:publicid:IDN+emulab.net+image+emulab-ops//FBSD135-64-STD',  'FreeBSD 13.5'),
    ('urn:publicid:IDN+emulab.net+image+emulab-ops//FBSD142-64-STD',  'FreeBSD 14.2')]

pc.defineParameter("osImage", "Select OS image",
                   portal.ParameterType.IMAGE,
                   imageList[0], imageList,
                   longDescription="Most clusters have this set of images, " +
                   "pick your favorite one.")

# Optional physical type for all nodes.
pc.defineParameter("phystype",  "Optional physical node type",
                   portal.ParameterType.NODETYPE, "",
                   longDescription="Pick a single physical node type (pc3000,d710,etc) " +
                   "instead of letting the resource mapper choose for you.")

params = pc.bindParameters()

pc.verifyParameters()

# Create link/lan.
if params.nodeCount > 1:
    if params.nodeCount == 2:
        lan = request.Link()
    else:
        lan = request.LAN()
        pass
    if params.bestEffort:
        lan.best_effort = True
    elif params.linkSpeed > 0:
        lan.bandwidth = params.linkSpeed
    if params.sameSwitch:
        lan.setNoInterSwitchLinks()
    pass

# Process nodes, adding to link or lan.
for i in range(params.nodeCount):
    # Create a node and add it to the request
    name = "node" + str(i)
    node = request.RawPC(name)

    # Install and execute a script that is contained in the repository.
    node.addService(pg.Execute(shell="sh", command="/local/repository/setup.sh"))

    pass
    if params.osImage and params.osImage != "default":
        node.disk_image = params.osImage
        pass
    # Add to lan
    if params.nodeCount > 1:
        iface = node.addInterface("eth1")
        lan.addInterface(iface)
        pass
    # Optional hardware type.
    if params.phystype != "":
        node.hardware_type = params.phystype
        pass
    pass

# Print the RSpec to the enclosing page.
pc.printRequestRSpec(request)
