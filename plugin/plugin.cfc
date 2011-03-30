<cfcomponent output="false">

	<cfset variables.config=""/>
	
	<cffunction name="init" returntype="any" access="public" output="false">
		<cfargument name="config"  type="any" default="">
		<cfset variables.config = arguments.config>
	</cffunction>
	
	<cffunction name="install" returntype="void" access="public" output="false">
		<cfset application.appInitialized=false>
	</cffunction>
	
	<cffunction name="update" returntype="void" access="public" output="false">
		<cfset application.appInitialized=false>
	</cffunction>
	
	<cffunction name="delete" returntype="void" access="public" output="false">

	</cffunction>


</cfcomponent>
