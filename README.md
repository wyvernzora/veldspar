#Veldspar
Veldspar is a [Meteor.js](http://meteor.com) based EVE Online account manager. It is also the JavaScript API client that powers the Veldspar application behind the scenes.

Currently the Veldspar project is still in early development.

##About API keys for debugging...
Obviously, my own API keys are not included in this repository. In order to add your own for debugging purposes, paste it into a `.apikey.json` file and put it into the `private` directory of the project. Then, change the path to the file in the `server/main.js`.

Format of the api key file should be like this:
```
{
  id: <api key id>,
  code: <api key verification code>,
  accessMask: <api key access mask>,
  characterID: <id of the character you wish to test with>
}
```