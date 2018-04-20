<cffunction name="anythingToStruct" access="public" output="true" returntype="struct" hint="Flattens structures, arrays  and queries">
    <cfargument name="in" type="any" required="true"><!--- struct, array or query to flatten --->
    <cfargument name="delimiter" required="false" type="string" default="." />
    <cfargument name="prefix_string" type="string" default="" required="false"><!--- result struct, returned at the end --->
    <cfargument name="out" type="struct" default="#StructNew()#" required="false"><!--- used in the processing, stores the preceding struct names in the current branch, ends in a delimeter --->

    <Cfset var local = {}>

    <Cfif isStruct(in)>
        <cfset local.keyArray = StructKeyArray(in)>
        <cfloop from=1 to=#arrayLen(local.keyArray)# index="local.x">

            <Cfif isStruct(in[local.keyArray[x]])>
                <cfset out = anythingToStruct(in[local.keyArray[x]],delimiter, prefix_string & local.keyArray[x] & delimiter,out)>
            <Cfelseif isArray(in[local.keyArray[x]])>
                <cfset out = anythingToStruct(in[local.keyArray[x]],delimiter, prefix_string & local.keyArray[x] & delimiter,out)>
            <Cfelseif isQuery(in[local.keyArray[x]])>
                <cfset out = anythingToStruct(in[local.keyArray[x]],delimiter, prefix_string & local.keyArray[x] & delimiter,out)>
            <cfelse>
              	<cfset out[prefix_string & local.keyArray[local.x]] = in[local.keyArray[local.x]]>
            </cfif>
        </cfloop>
	<Cfelseif isArray(in)>
        <cfloop from=1 to=#arrayLen(in)# index="local.y">
            <cfset out = anythingToStruct({"#local.y#":in[local.y]},delimiter, prefix_string,out)>
        </cfloop>
	<cfelseif isQuery(in)>
		<Cfset local.q.columnLabels = in.columnList>
		<Cfset local.q.array = []>

        <cfloop from=1 to=#in.recordcount# index="local.y">
			<Cfloop list="#local.q.columnLabels#" item="local.q.columnName">
	            <cfset local.q.array[local.y][local.q.columnName] = in[local.q.columnName][local.y] >
			</cfloop>
        </cfloop>
		<Cfset local.q.prefix_string = prefix_string>
		<cfif local.q.prefix_string eq delimiter><Cfset local.q.prefix_string = ""></cfif>
		 <cfset out = anythingToStruct(local.q.array,delimiter, local.q.prefix_string,out)>
    <Cfelseif isSimpleValue(in)>
	    <Cfset out = {"SimpleValue":in}>
    <Cfelse>
	    <Cfset out = {"UnkownVariable":in}>
	</cfif>

    <cfreturn out>
</cffunction>
