
<h1>Task 1 - list the state -districts-places-</h1>
<!--- <p>similar location id based list</p> --->

<cfquery name="myQuerytest" datasource="cruddb">
    SELECT s1.locationId, s1.locationName, s1.parentLocationId
    FROM task.tbl_location AS s1 LEFT OUTER JOIN task.tbl_location AS s2 ON (s1.parentLocationId =
    s2.locationId)
    ORDER BY s2.locationName, s1.locationName
</cfquery>
<!--- <cfdump var =#myQuerytest#> --->

<!--- <p> sets which row number each locationid</p> --->
<cfset RowFromID=StructNew()>
    <cfloop query="myQuerytest">
        <cfset RowFromID[locationId]=CurrentRow>
    </cfloop>
<cfset RootItems=ArrayNew(1)>
<cfset Depth=ArrayNew(1)>
<cfloop query="myQuerytest">
    <cfif NOT StructKeyExists(RowFromID, parentLocationId)>
        <cfset ArrayAppend(RootItems, locationId)>
        <cfset ArrayAppend(Depth, 0)>
    </cfif>
</cfloop>
<!--- <cfdump var = #RowFromID#>  --->
<!--- <p> location id of no parent</p> --->
<!--- <cfdump var =#RootItems#> --->
<!--- </p>parents will have multiple children, we use an array to store them by simply --->
<!--- appending the child’s locationID.</p> --->

<cfset ChildrenFromID=StructNew()>
<cfloop query="myQuerytest">
    <cfset RowFromID[locationId]=CurrentRow>
    <cfif NOT StructKeyExists(ChildrenFromID, parentLocationId)>
        <cfset ChildrenFromID[parentLocationId]=ArrayNew(1)>
    </cfif>
    <cfset ArrayAppend(ChildrenFromID[parentLocationId], locationId)>
</cfloop>
<!--- <p>RootItems have no parent ,so which is first to show</p> --->
<!--- <p>First we will need to pop the current item off the top of the stack:</p> --->

<cfloop condition="ArrayLen(RootItems) GT 0">
    <cfset ThisID=RootItems[1]>
    <cfset ArrayDeleteAt(RootItems, 1)>
    <cfset ThisDepth=Depth[1]>
    <cfset ArrayDeleteAt(Depth, 1)>

    <!---   chect with no parent place exist and if exist, make it print   --->
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
    <!--- <p>Look to see if we have any children then print </p> --->
    <cfif StructKeyExists(ChildrenFromID, ThisID)>
        <cfset ChildrenIDs=ChildrenFromID[ThisID]>
        <cfloop from="#ArrayLen(ChildrenIDs)#" to="1" step="-1"
            index="i">
            <cfset ArrayPrepend(RootItems, ChildrenIDs[i])>
            <cfset ArrayPrepend(Depth, ThisDepth + 1)><br>
        </cfloop>
    </cfif>

</cfloop>




