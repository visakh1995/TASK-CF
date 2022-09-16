<h3>Task 5 </h3>
<cfset newInstance = createObject("component","components.functions")> 
<cfset local.locationids = 3>
<cfset res = newInstance.depthbyChildren(local.locationids)>