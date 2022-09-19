<h3>Task 4 - Find parent Locations</h3>
<cfset newInstance = createObject("component","components.functions")> 

<cfset local.locationids = 5>
<cfset res = newInstance.depthbyParents(local.locationids)>
