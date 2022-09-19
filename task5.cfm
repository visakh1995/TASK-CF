<h2>Task 5 - Find child locations</h2>
<cfset newInstance = createObject("component","components.functions")> 
<cfset local.locationids = 3>
<cfset res = newInstance.depthbyChildren(local.locationids)>
