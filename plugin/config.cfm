<cfsilent>
<cfif not structKeyExists(variables,"pluginConfig")>
<cfset pluginID=listLast(listGetat(getDirectoryFromPath(getCurrentTemplatePath()),listLen(getDirectoryFromPath(getCurrentTemplatePath()),application.configBean.getFileDelim())-1,application.configBean.getFileDelim()),"_")>
<cfset pluginConfig=application.pluginManager.getConfig(pluginID)>
<cfset pluginConfig.setSetting("pluginMode","Admin")/>
</cfif>

<cfif pluginConfig.getSetting("pluginMode") eq "Admin" and not isUserInRole('S2')>
	<cfif not structKeyExists(session,"siteID") or not application.permUtility.getModulePerm(pluginConfig.getValue('moduleID'),session.siteid)>
		<cflocation url="#application.configBean.getContext()#/admin/" addtoken="false">
	</cfif>
</cfif>

</cfsilent>
