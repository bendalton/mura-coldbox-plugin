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
        var cookies    = structNew();
        var temp       = structNew()
        var theCookie  = "";
        var cookiePair = [];
        var i          = 0;

        if(NOT StructKeyExists(response.ResponseHeader,"Set-Cookie")){      
            return cookies;
        }
        
        var returnedCookies = response.ResponseHeader[ "Set-Cookie" ];

        /* The expected return value is either a string or an array-like struct.
         * The string, or each element of the struct, is url-encoded, and takes the form
         *     name=value;other_information_1;...;other_information_n
         * For the purposes of this proxy, we are only interested in passing along the name
         * and value.
         *
         * Here, the response is converted into an struct if it isn't one already. */
        if (not isStruct(returnedCookies)){
        	if (not isArray(returnedCookies)){
        		temp["1"] = returnedCookies;
        	} else {
	    		for(i=1;i lte arrayLen(returnedCookies);i++){
	    	        temp[i]=returnedCookies[i];
	    		}
        	}
        	returnedCookies = duplicate(temp);
        }

        for (i in returnedCookies){
        	/* get the part before the first semicolon ("name=value") */
        	theCookie  = listFirst(returnedCookies[i], ";");

        	/* convert "name=value" to ["name", "value"] */
        	cookiePair = listToArray(theCookie, "=");

        	/* If the value was an empty string, it will not exist in the array. Insert it. */
        	if (arrayLen(cookiePair) < 2) {
        		cookiePair[2] = "";
        	}

        	cookies[urlDecode(cookiePair[1])] = urlDecode(cookiePair[2]);
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
	    
	    var pc = getpagecontext().getresponse();
        pc.getresponse().setstatus(objGet.responseHeader.status_code);
		
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