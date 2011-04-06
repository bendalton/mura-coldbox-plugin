This is a simple plugin that allows you to integrate ColdBox applications throughout your Mura install.

Update
---
I have added support for integrating with Grant Shepert's >Meld URL Interceptor Plugin (read more at <http://www.grantshepert.com/post.cfm/mura-cms-urlintercepts-the-plugin>)

This awesome plugin allows you to define a single page in mura for all ColdBox requests to be rendered in a single template.

Here's an example use: 

1. create a page 'coldbox'

2. in the page configuration, in content objects, start to add a display object from "Plugins"->"ColdBox Proxy Plugin"->"ColdBox Request Display" 

3. Leave ColdBox Event blank, check the Use URL Interception box

4. Add the content object to a region on your page (I have a 'main content region' configured that I use) and publish the page.

5. Install and configure the Meld URL Interceptor Plugin with an interceptor configuration with the xml below:

6. Reload the application and visit http://example.com/coldbox/ and add any event to the end of the url.  

    <?xml version="1.0" encoding="UTF-8"?>
    <intercept>
    	<name>Coldbox Intercept</name>
    	<package>ColdboxIntercept</package>
    	<isactive>true</isactive>
    	<intercept>coldbox</intercept>
    	<pathprefix></pathprefix>
    	<matchfromroot>true</matchfromroot>
    	<strict>false</strict>
    	<recurse>false</recurse>
    	<keepkey>false</keepkey>
    	<siteID>default</siteID>
    	<keysets/>
    </intercept>

Additional Info
----
You can use it within templates with some syntax like
    #$.event.getValue('YourRemoteAppKey').call({event="home.index"});#

Or, where the meat of the plugin is, add new display objects to your Mura pages. You can also specify additional parameters to pass along with your call. For example, you can add UserID as a parameter and in the CF input box provide code like:
    $.currentUser("UserID")
    
Here's a short video showing how I'm using the plugin: <http://screencast.com/t/MqpW74pIWPaN>
    
I built this for CF9, so you may have issues if you are using an older CF version. There are definitely some bugs. Please post issues in the "Issues" section of the GitHub repo.


Credit:

* The plugin is based off of Mura's Remote Connector Plugin: <http://www.getmura.com/blog/new-remote-connector-plugin/>
 

* Grant Shepart's Configurable Display Objects in Mura CMS Plugins was very helpful: <http://www.grantshepert.com/post.cfm/configurable-display-objects-in-mura-cms-plugins>

