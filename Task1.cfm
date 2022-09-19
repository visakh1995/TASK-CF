<h3>Task 1 - Display locations</h3>
<cfset newInstance = createObject("component","components.functions")> 
<ul class="new">                     
    <cfinvoke component="components.functions" 
    method="TreeModal"> 
    <cfinvokeargument name="newId" value="1">
    <cfinvokeargument name="newTitle" value="Kerala">
    </cfinvoke>
</ul> 




 



