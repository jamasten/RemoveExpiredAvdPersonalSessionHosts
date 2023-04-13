# Azure Virtual Desktop - Remove Expired Personal Session Hosts

This solution removes session hosts from a personal host pool based on a defined expiration in days. To ensure the session hosts have existed during that span of the time, the script first checks the creation date / time on the OS disk.  If the disk is older than the expiration time, then a query is run in a log analytics workspace to see if anyone has connected to the session host within the expiration time. If any connections were made, the session host is ignored. However, if no connections were made, the session host is removed from the host pool and the virtual machine is deleted.
