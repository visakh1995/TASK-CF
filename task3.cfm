<h1>Task 3 - Alphabetical order</h1>
<cfset newInstance = createObject("component","components.functions")> 
<cfset res = newInstance.findLocation()>
<cfoutput query="res">     
    <tr>                   
        <td>#locationName#</td><br>
    </tr>
</cfoutput>
