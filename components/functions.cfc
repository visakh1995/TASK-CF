<cffunction name ="depth" access="public" returnType="string" output="true">
    <cfargument  name="locationIds" type="string" required="yes">
    <cfquery name="myQuerytest" datasource="cruddb">
        SELECT s1.locationId, s1.locationName, s1.parentLocationId
        FROM task.tbl_location AS s1 LEFT OUTER JOIN task.tbl_location AS s2 ON (s1.parentLocationId =
        s2.locationId)
        ORDER BY s2.locationName, s1.locationName
    </cfquery>
    
    <!--- <p> sets which row number each locationid</p> --->
        <cfset RowFromID=StructNew()>
        <cfloop query="myQuerytest">
            <cfset RowFromID[locationId]=CurrentRow>
        </cfloop>

        <cfif StructKeyExists(RowFromID, arguments.locationIds)>
            <cfset RowID=RowFromID[arguments.locationIds]>
            <cfoutput>
                Depth :  #RowID#<br/>
            </cfoutput>
        </cfif>
        
</cffunction>

<cffunction name ="depthByList" access="public" returnType="string" output="true">
    <cfargument  name="locationIds" type="string" required="yes">
    <cfquery name="findParent" datasource="cruddb">
        SELECT locationId, locationName, parentLocationId
        FROM task.tbl_location
        WHERE locationId = #arguments.locationIds#
    </cfquery>
    <cfquery name="findParentBy" datasource="cruddb">
        SELECT locationId, locationName, parentLocationId
        FROM task.tbl_location
        WHERE locationId = #findParent.parentLocationId#
    </cfquery>

    <cfset tablo = ArrayNew(1)>
    <cfset arrayAppend(tablo, #findParent.parentLocationId#)>
    <cfset arrayAppend(tablo, #findParentBy.parentLocationId#)>
    <cfset listouts = ArrayToList(tablo)>
    <cfoutput>
        <p>parent list : #listouts#</p>
    </cfoutput>
</cffunction>

<cffunction name ="depthbyChildren" access="public" returnType="string" output="true">
    <cfargument  name="locationIds" type="string" required="yes">
</cffunction>


