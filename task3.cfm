
<h1>Task 3 - Alphabetical order</h1>
<cfquery name="myQuerytest" datasource="cruddb">
    SELECT s1.locationId, s1.locationName, s1.parentLocationId
    FROM task.tbl_location AS s1 LEFT OUTER JOIN task.tbl_location AS s2 ON (s1.parentLocationId =
    s2.locationId)
    ORDER BY s2.locationName, s1.locationName
</cfquery>

<cfset RowFromID=StructNew()>
    <cfloop query="myQuerytest">
        <cfset RowFromID[locationId]=CurrentRow>
    </cfloop>
<cfset RootItems=ArrayNew(1)>
<cfloop query="myQuerytest">
    <cfif NOT StructKeyExists(RowFromID, parentLocationId)>
        <cfset ArrayAppend(RootItems, locationId)>
    </cfif>
</cfloop>

<cfset ChildrenFromID=StructNew()>
<cfloop query="myQuerytest">
    <cfset RowFromID[locationId]=CurrentRow>
    <cfif NOT StructKeyExists(ChildrenFromID, parentLocationId)>
        <cfset ChildrenFromID[parentLocationId]=ArrayNew(1)>
    </cfif>
    <cfset ArrayAppend(ChildrenFromID[parentLocationId], locationId)>
</cfloop>

<cfloop condition="ArrayLen(RootItems) GT 0">
    <cfset ThisID=RootItems[1]>
    <cfset ArrayDeleteAt(RootItems, 1)>

    <cfif StructKeyExists(RowFromID, ThisID)>
        <cfset RowID=RowFromID[ThisID]>
        <cfoutput>
            <ul>
                <li>
                    #myQuerytest.locationName[RowID]#
                </li>
            </ul>
            <br/>
        </cfoutput>
    </cfif>
    <cfif StructKeyExists(ChildrenFromID, ThisID)>
        <cfset ChildrenIDs=ChildrenFromID[ThisID]>
        <cfloop from="#ArrayLen(ChildrenIDs)#" to="1" step="-1"
            index="i">
            <cfset ArrayPrepend(RootItems, ChildrenIDs[i])>
        </cfloop>
    </cfif>

</cfloop>



