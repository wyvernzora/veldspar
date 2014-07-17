#Contributor's Guide
Thank you for thinking about contributing to the Veldspar project! There are a few things you might need to know before you can get down to writing code.

##Server/Client
In short, anything that makes HTTP calls from the Veldspar server should be *server only*, and access to such methods should be validated. For example, functions in the `Veldspar.API` namespace should never be exposed to the client.

On the other hand, methods that are not needed on the server should be *client only*. This includes UI-related functions. For example, function that generates the character portrait URI is client only.

##View

###Layout
Overall layout should preserve the header bar on the top of the screen. All views must be placed in `#main-wrapper` element. UI sections that are not generally needed should be hidden, and shown upon user request as a *sidebar*. Please check out existing views, such as `client/views/login.html` for how this is done.

###Styles
Please use *LESS* stylesheets for consistency.

###Scripting
There is a lot of commonly used UI functionality already included in the `Veldspar.UI.view` class, therefore please extend your views as needed. When defining a new view, please wrap it in an immediate function to allow inclusion of multiple views in one file and to avoid variable conflicts. For example, a barebone definition of a view looks like this:
```javascript
	(function (view) { 
	  view = Veldspar.UI.init(view);
	  /* Your Meteor.js code here */
	})(Template.myView);
```