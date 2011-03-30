component extends="mura.plugin.pluginGenericEventHandler"{
    
    function init(pluginConfig,configBean){
        Super.init(pluginConfig,configBean);
        return this;
    }
    
    function onApplicationLoad(event){
        // init event handlers
        variables.pluginConfig.addEventHandler(this); 
        event.coldbox = this;
    }
    
    function onRequestStart(event){
        // init event handlers
        event.setValue(pluginConfig.getSetting('RemoteAppKey'),this);
    }
    
    function onRenderStart(event){
        // init event handlers
        event.setValue(pluginConfig.getSetting('RemoteAppKey'),this);
    }
    
    function getResponseCookies(response){
        var cookies = structnew();
	
        if(NOT StructKeyExists(response.ResponseHeader,"Set-Cookie")){      
            return cookies;
        }
        
        var returnedCookies = response.ResponseHeader[ "Set-Cookie" ];

        if (not isStruct(returnedCookies) and not isArray(returnedCookies)){
            var temp = structNew();
            temp["1"] = returnedCookies;
        }
        else if (isArray(returnedCookies)){
            temp = structNew();
    		for(var i=1;i lte arrayLen(returnedCookies);i++){
    	        temp[i]=returnedCookies[i];
    		}
    		returnedCookies = duplicate(temp);
        }
        
	    for(cookie in returnedCookies){
			for(key in cookie){
				cookies[key] = cookie[key];
			}       
	     }
		 
		 return cookies;
	}
	
	function call(params){
	
		var key = "";
		var args = structNew();
		var objGet = "";
		var response = "";
		var strCookie = "";
		var objCookies = "";
		var pSession = pluginConfig.getSession();
		var tempCurrent = structNew();
		var tempNew = structNew();

		structAppend(args,url,"yes");
		
		// form values override url parameters
		structAppend(args,form,"yes");
		
		// arguments set in display object config can NOT be overridden by form and url values for security sake
		if(structKeyExists(arguments,"params")){
			structAppend(args,params,"yes");
		}
		
		if(not isStruct(pSession.getValue('remoteCookies'))){
			pSession.setValue("remoteCookies",tempNew);
		}
		
		if(not isStruct(pSession.getValue('returnCookies'))){
			pSession.setValue("returnCookies",tempNew);
		}
		
		objCookies = pSession.getValue("remoteCookies");
	
		var service = new http();
		service.setMethod("GET");
		service.setURL( pluginConfig.getSetting('RemoteURL'));
		service.setUserAgent( CGI.http_user_agent );
		//writedump(objCookies);
		//abort;
		for(strCookie in objCookies){
			service.addParam(type="COOKIE",name=strCookie,value=objCookies[strCookie]);
		}
		
		if(not structIsEmpty(args))
		{
			for(key in args){
				service.addParam(type="FORMFIELD",name=key,value=args[key]);
			}
		}
		
		objGet = service.send().getPrefix();
		
		tempCurrent = pSession.getValue("remoteCookies");
		tempNew = getResponseCookies(objGet);
		
		structAppend(tempCurrent,tempNew,"yes");
		
		pSession.setValue("remoteCookies",tempCurrent);

		if(isJSON(objGet.fileContent))
		{
			return deserializeJSON(objGet.fileContent);
		} else {
			return objGet.fileContent;
		}				
	}
}