#Veldspar
Veldspar is a [Meteor.js](http://meteor.com) based EVE Online account manager. It is also the JavaScript API client that powers the Veldspar application behind the scenes.

Currently the Veldspar project is still in early development.

##Running Veldspar
Veldspar is a [Meteor.js](http://meteor.com) application, which requires the `mrt` build tool. In order to setup a development environment, please follow the following steps:

**1. Install Meteor.js**  
`$ curl https://install.meteor.com | sh`

**2. Install Node.js and npm**  
Download the Node.js installer from [the official site](http://nodejs.org) and install it. This will also install the `npm`, which is needed to install Veldspar's dependencies.

**3. Clone Veldspar application**  
In the application root directory, run the following command to install dependencies: `$ mrt update`.

**4. Run Veldspar**  
In the application root directory, `$ mrt`.

##Dependencies
Veldspar depends on the following atmosphere packages:

 - `xml2js`
 - `blocking`

Veldspar also uses the following, which is included with Meteor.js by default:

 - `jQuery`
 - `backbone.js`
 - `underscore.js`
 - `less`
 - `coffeescript`
 
A copy of the following has been included in the `lib` or `client/lib` directory:

 - `jQuery UI` (*)
 - `ionicons`
 - `pretty-json` (*)

**Note:** Since Veldspar is still in active development, the list of dependencies may change at any moment. Packages with `(*)` have been slightly modified to work with Veldspar, therefore their original versions may or may not work.