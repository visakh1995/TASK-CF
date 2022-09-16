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

    <cfset tablo = ArrayNew(1)>
    <cfset arrayAppend(tablo, #findParent.parentLocationId#)>
    <cfset CountVar = 0> 
    <cfset rept =  #findParent.parentLocationId#>
        <cfloop condition = "CountVar LESS THAN 2">
            <cfset CountVar = CountVar + 1> 
            <cfquery name="findParentBy" datasource="cruddb">
                SELECT locationId, locationName, parentLocationId
                FROM task.tbl_location
                WHERE locationId = #rept#
            </cfquery>
            <cfset rept = "">
            <cfset rept = #findParentBy.parentLocationId#> 
            <cfset arrayAppend(tablo,#findParentBy.parentLocationId#)>
        </cfloop>

        <cfset listouts = ArrayToList(tablo)>
        <cfoutput>
            <p>parent list : #listouts#</p>
        </cfoutput>
</cffunction>

<cffunction name ="depthbyChildren" access="public" returnType="string" output="true">
    <cfargument  name="locationIds" type="string" required="yes">
    <cfquery name="findChildrenBy" datasource="cruddb">
        SELECT locationId, locationName, parentLocationId
        FROM task.tbl_location
        WHERE parentLocationId = #arguments.locationIds#
    </cfquery>
    <cfset tabChild = ArrayNew(1)>
    <cfloop query="findChildrenBy">
        <cfset tab = findChildrenBy.locationId>
        <cfset arrayAppend(tabChild, tab)>
    </cfloop>
    <cfquery name="findChild" datasource="cruddb">
        SELECT locationId, locationName, parentLocationId
        FROM task.tbl_location
        WHERE parentLocationId = #findChildrenBy.locationId#
    </cfquery>
    <cfset arrayAppend(tabChild,#findChild.locationId#)>

    <cfset listChildOuts = ArrayToList(tabChild)>
    <cfoutput>
        <p>children list : #listChildOuts#</p>
    </cfoutput>
    <cfabort>

</cffunction>

<cffunction name ="TreeModal" access="public" returnType="string" output="true">
    <cfargument  name="newId" type="numeric" >
    <cfargument  name="newTitle" type="string">

        <cfquery name="local.findLocationByCategory" returnType="query" datasource="cruddb">
            select locationid, locationName
            from task.tbl_location
            where parentLocationId = <cfqueryparam value="#arguments.newId#" cfsqltype="cf_sql_varchar" />
        </cfquery>

        <li>#arguments.newTitle#
            <cfif findLocationByCategory.recordcount>
                <ul>
                    <cfloop query="local.findLocationByCategory">
                        <cfset TreeModal(newId=findLocationByCategory.locationId,
                        newTitle=findLocationByCategory.locationName) />
                    </cfloop>
                </ul>
            </cfif>
        </li>
</cffunction>
<cffunction  name="findLocation" access="remote" output="false">
    <cfquery name="location_findings" datasource="cruddb">
        SELECT * from task.tbl_location ORDER BY locationName ASC;
    </cfquery>
    <cfreturn location_findings>     
</cffunction>

<cffunction name ="TreeSorting" access="public" returnType="string" output="true">
    <cfargument  name="newId" type="numeric">
    <cfargument  name="newTitle" type="string">
    <cfargument  name="destns" type="string">

    <cfset local.destns = ArrayNew(1)>

    <cfquery name="local.findLocationByCategory" returnType="query" datasource="cruddb">
        select locationid, locationName
        from task.tbl_location
        where parentLocationId = <cfqueryparam value="#arguments.newId#" cfsqltype="cf_sql_varchar" />
    </cfquery>

    <cfif findLocationByCategory.recordcount>
        <ul>
            <cfloop query="local.findLocationByCategory">
                <cfset arrayAppend(destns,TreeModal(newId = findLocationByCategory.locationId,
                newTitle=findLocationByCategory.locationName)) />
            </cfloop>
        </ul>
        <cfdump var = #local.destns#>
    </cfif>
</cffunction>
<cffunction name ="TreeSort" access="public" returnType="string" output="true">
    <cfquery name="location_findings" datasource="cruddb">
        SELECT * from task.tbl_location ORDER BY locationName ASC;
    </cfquery>
    <cfset myArray = ArrayNew(1)>
    <cfloop query = "location_findings">
        <cfset tmp = ArrayAppend(myArray,locationName)>
    </cfloop>
    <cfset myList = ArrayToList(myArray,",")>
    <cfoutput>
        <h3>#myList#</h3>
    </cfoutput>

</cffunction>








