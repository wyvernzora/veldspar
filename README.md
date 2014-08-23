#Veldspar
Veldspar is a [Meteor.js](http://meteor.com) based EVE Online account manager. It is also the JavaScript API client that powers the Veldspar application behind the scenes.

*Currently the Veldspar project is still in early development.*

##Running Veldspar
Veldspar is a [Meteor.js](http://meteor.com) application, which requires the `mrt` build tool. In order to setup a development environment, please follow the following steps:

1. Download snd install the [**Node.js** distribution for your platform](http://nodejs.org/).
2. Install **Meteorite** using the following command line: `$ sudo npm install -g meteorite`
3. Install **Meteor** using the following command line: `$ sudo curl https://install.meteor.com | sh`
4. `cd` to the `veldspar` directory, and run the following: `$ mrt update`
5. Run the veldspar: `$ mrt`

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

 - `jQuery UI (*)`
 - `ionicons`
 - `pretty-json (*)`
 - `bootstrap (*)`

**Note:** Since Veldspar is still in active development, the list of dependencies may change at any moment. Packages with `(*)` have been slightly modified to work with Veldspar, therefore their original versions may or may not work.
