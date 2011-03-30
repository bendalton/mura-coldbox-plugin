<cfinclude template="plugin/config.cfm" />
<cfsilent>
<cfset tempParams=structNew()>
<cfset params=structNew()>
<cfscript>
	StructAppend(tempParams, url, "yes");
	StructAppend(tempParams, form, "yes");
	</cfscript>
</cfsilent>
<cfsavecontent variable="body">
<cfoutput>
#pluginConfig.getApplication().getValue('remoteProxy').call(params=params)#
</cfoutput>
</cfsavecontent>
<cfoutput>
#application.pluginManager.renderAdminTemplate(body=body,pageTitle=pluginConfig.getName())#
</cfoutput>

