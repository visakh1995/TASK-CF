<h3>Task2</h3>
<cfset newInstance = createObject("component","components.functions")> 

<cfinvoke component="components.functions" method="depth"> 
    <cfinvokeargument name="defaultId" value="1">
    <cfinvokeargument name="defaultTitle" value="Kerala">
    <cfinvokeargument name="locationId" value="5">
</cfinvoke>

 

