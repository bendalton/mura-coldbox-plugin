<cfcomponent name="ColdboxRequestDisplay" output="false" extends="mura.plugin.pluginGenericEventHandler">
	<cffunction name="displayRequest" output="false" returntype="String" >
		<cfargument name="$">
		<cfscript>
			var proxyPlugin = event.getValue(pluginConfig.getSetting('RemoteAppKey'));
			var params = deserializeJSON( $.event().getValue("params") );
			if (isSimpleValue(params.properties)) {
				/* params.properties may already be an array or object, making this line unnecessary */
				params.properties = deserializeJSON( params.properties );
			}
		
			var callParameters = structNew();
			callParameters.event = params.event;
			for(prop in params.properties)
			{
				callParameters[prop.key] = evaluate(prop.cf);
			}
			
			//writedump(var=params,abort=true);

			if(structKeyExists(params,"useURLInterception") AND params.useURLInterception && event.valueExists("URLInterceptResponse"))
			{
				var eventExtra = arrayToList(event.getValue('URLInterceptResponse').getExtra(),".");
				if(len(eventExtra) && len(callParameters.event)){
					callParameters.event = callParameters.event & "." & eventExtra;
				}
				else if(not len(callParameters.event)){
					allParameters.event = eventExtra;
				}
				
			}
			var output = proxyPlugin.call(callParameters);

		</cfscript>
		
		<cfset output = output/>
		<cfreturn #output# />
		
	</cffunction>
	
	<!--- Mura Content Object dropdown renderer --->
	<cffunction name="displayRequestOptionsRender" output="false" returntype="any">
		<cfargument name="$">
		<cfargument name="event">

		<cfset var str="">
		<cfsavecontent variable="str"><cfoutput>
		<label>Coldbox Event: </label> <input class="cboxPluginInput" id="cbEvent" name="event"/><br/><br/>
		<label>Use URL Interception?</label> <input type="checkbox" class="cboxPluginInput" id="useInterception"/><br/>
		<small>Appends additional URL segments to event when checked. (depends on: <a href="http://www.grantshepert.com/post.cfm/mura-cms-urlintercepts-the-plugin">Meld URLIntercept Plugin</a>)</small><br/>		
		
		<label>Additional Properties <button type="button" id="addPropertyButton">+</button></label>
		<ul id="additionalProperties"></ul>
		<select style="display:none;" name="availableObjects" id="availableObjects"/>
		<div style="display:block; white-space:normal;line-height: 12px;width:310px;"><small>The display object will automatically include any form fields or GET parameters that are submitted to the page</small></div>
        <!--- Need to directly include this JSON.js in the plugin --->
		<script src="https://github.com/douglascrockford/JSON-js/raw/8e0b15cb492f63067a88ad786e4d5fc0fa89a241/json2.js"></script>
		<script type="text/javascript">		
		// Mura Admin interface looks for the selected value in a select input with "availableObjects" as the id
		jQuery(document).ready(function(){
			jQuery('.cboxPluginInput').keyup(updateDisplayObjectProperties);
			
			jQuery("##addPropertyButton").click(function(){
				jQuery("##additionalProperties").append("<li class='addtlProperty' onkeyup='updateDisplayObjectProperties()' style='border-bottom:2px solid ##eeeeee;'><label>Key</label><input class='key'/><br/><label>CF to Eval</label><input onclick='updateDisplayObjectProperties()' class='cf'/></li>");
				
			});
		});
			
		function updateDisplayObjectProperties(){
			var options = {};
			var properties  = [];
			jQuery('li.addtlProperty').each(function(){
				properties.push({key:jQuery('input.key',this).val(),cf:jQuery('input.cf',this).val()});
			});
			
			options.event = jQuery("##cbEvent").val();
			options.useURLInterception = jQuery("##useInterception").val() == "on";
			options.properties = properties;

			var doObjects = 'plugin~ColdBox Event: '+jQuery("##cbEvent").val();
			doObjects += '~#$.event("ObjectID")#~';
			doObjects += JSON.stringify(options);
			jQuery('##availableObjects').empty();
			jQuery('##availableObjects').append("<option value='"+doObjects+"' selected='selected'>ColdBox Event: "+jQuery("##cbEvent").val()+"</option>");
		}
		</script>
		</cfoutput>
		</cfsavecontent>

		<cfreturn str>
	</cffunction>
</cfcomponent>