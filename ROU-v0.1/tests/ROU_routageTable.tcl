#!/usr/bin/tclsh

list routingTable {}

lappend routingTable { A A 0 }
lappend routingTable { B B 1 }
lappend routingTable { C B 5 }

list paramTable {}

lappend paramTable { A A 0 }
lappend paramTable { B A 1 }
lappend paramTable { C B 2 }

proc ROU_setRoute { newRoutingTable } {
	#Iterates on the remote table
	foreach updatedRoute $newRoutingTable {
		set paramDestination [lindex $updatedRoute 0]
		set paramNextHop [lindex $updatedRoute 1]
		set paramDistance [incr [lindex $updatedRoute 2]]
		
		foreach routeToUpdate $::routingTable {
			#Check if it's the right route to update
			if { [lsearch $routeToUpdate $paramDestination] == 1 } { 
				set currentDestination [lindex $routeToUpdate 0]
				set currentNextHop [lindex $routeToUpdate 1]
				#Set the distance with a +1
				set currentDistance [lindex $routeToUpdate 2]
				
				#If I have a better route, I update
				if { $paramDistance < $currentDistance } {
					#Update the next hop
					lset routeToUpdate 1 $paramNextHop
					#Update the distance
					lset routeToUpdate 2 $paramNextHop
				}
				#Otherwise... I keep my route
			}
		}
	}
}

proc ROU_getRoute { } {
	#Next hop
	return
}

proc ROU_displayRoutingTable { paramRoutingTable } {
	foreach route $paramRoutingTable {
		puts $route
	}
}

ROU_displayRoutingTable $routingTable
ROU_setRoute $paramTable
ROU_displayRoutingTable $routingTable
