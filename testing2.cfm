
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

<cffunction name ="depthbyChildrenTest" access="public" returnType="string" output="true">
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

<cffunction name ="depth" access="public" returnType="string" output="true">
    <cfargument  name="defaultId" type="string" required="yes">
    <cfargument  name="defaultTitle" type="string" required="yes">
    <cfargument  name="locationId" type="string" required="yes">
    <cfargument  name="defaultValue" type="string" required="no">


    <cfquery name="local.findLocationByCategory" returnType="query" datasource="cruddb">
        select locationid, locationName
        from task.tbl_location
        where parentLocationId = <cfqueryparam value="#arguments.defaultId#" cfsqltype="cf_sql_varchar" />
    </cfquery>
   
    <cfif findLocationByCategory.recordcount>
        
        <cfset local.showValue="0">
        <cfset depthValue = 0>
        <cfloop query="local.findLocationByCategory">

            <cfset local.showValues = depthValue+1>
            <cfif local.findLocationByCategory.locationId eq arguments.locationId>
                <cfdump var = #local.showValues#>
            </cfif>
            <cfset TreeModal(newId=findLocationByCategory.locationId,
            newTitle=findLocationByCategory.locationName,defaultValue = local.showValue+1) />

        </cfloop>
        <cfoutput>
            depth : #local.showValues#
        </cfoutput>
    </cfif>

        
</cffunction>

<cffunction name ="depthbyChildren" access="public" returnType="string" output="true">
    <cfargument  name="locationIds" type="string" required="yes">
    <cfset var local = structNew() />
    <cfquery name="LOCAL.familyTreeData" datasource="cruddb">
        SELECT 
            locationId, 
            locationName,
             parentLocationId
        FROM 
            task.tbl_location
    </cfquery>
    
    <cfquery name="LOCAL.Children" dbtype="query">
        SELECT
            locationId,
            locationName
        FROM
            familyTreeData
        WHERE
            parentLocationId = <cfqueryparam value="#arguments.locationIds#" cfsqltype="cf_sql_integer" />
        ORDER BY
        locationName ASC
    </cfquery>

    <cfif LOCAL.Children.RecordCount>

            <!--- Loop over children. --->
        <cfloop query="LOCAL.Children">

                #LOCAL.Children.locationId# &nbsp, 
                <cfset depthbyChildren(
                            locationIds = LOCAL.Children.locationId
                ) />
        </cfloop>
    </cfif>
</cffunction>

<cffunction name ="depthByParents" access="public" returnType="string" output="true">
    <cfargument  name="locationIds" type="string" required="yes">
    <cfset var local = structNew() />

    <cfquery name="findParentByLocationId" datasource="cruddb">
        SELECT locationId, locationName, parentLocationId
        FROM task.tbl_location
        WHERE locationId = #arguments.locationIds#
    </cfquery>

    <cfif len(findParentByLocationId.parentlocationId) AND (findParentByLocationId.parentlocationId != "NULL")>
        <cfset local.parentID = #findParentByLocationId.parentlocationId#>
    <cfelse>
        <cfset local.parentID = 0>
    </cfif>

    <cfquery name="LOCAL.familyTreeData" datasource="cruddb">
        SELECT 
            locationId, 
            locationName,
            parentLocationId
        FROM 
            task.tbl_location
    </cfquery>
    
    <cfquery name="LOCAL.Parents" dbtype="query">
        SELECT
            locationId,
            locationName,
            parentLocationId
        FROM
            familyTreeData
        WHERE
            LocationId = <cfqueryparam value="#local.parentID#" cfsqltype="cf_sql_varchar" /> 
    </cfquery>

    <cfif LOCAL.Parents.RecordCount>
            <!--- Loop over Parents. --->
        <cfloop query="LOCAL.Parents">
                #local.parentID#,
                <cfif LOCAL.Parents.parentLocationId != "NULL">
                    #LOCAL.Parents.parentLocationId#
                </cfif>

                <cfset depthbyParents(
                    locationIds = LOCAL.Parents.parentLocationId
                ) />
        </cfloop>
    </cfif>
</cffunction>

<cffunction name ="Alphabets" access="public" returnType="string" output="true">
    <cfargument name="locationIds" type="numeric" required="false" default="1"/>
    <cfset var local = structNew() />
    <cfquery name="LOCAL.familyTreeData" datasource="cruddb">
        SELECT 
            locationId, 
            locationName,
             parentLocationId
        FROM 
            task.tbl_location
    </cfquery>
    
    <cfquery name="LOCAL.Alpha" dbtype="query">
        SELECT
            locationId,
            locationName
        FROM
            familyTreeData
        WHERE
            parentLocationId = <cfqueryparam value="#arguments.locationIds#" cfsqltype="cf_sql_integer" />
        ORDER BY
        locationName ASC
    </cfquery>

    <cfif LOCAL.Alpha.RecordCount>

            <!--- Loop over children. --->
        <cfloop query="LOCAL.Alpha">
                #LOCAL.Alpha.locationName# &nbsp, 
                <cfset Alphabets(
                    locationIds = LOCAL.Alpha.locationId
                ) />
        </cfloop>
    </cfif>
</cffunction>
















