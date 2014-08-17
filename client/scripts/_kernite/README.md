# Kernite.UI
**Kernite** is a UI framework developed for **Veldspar.io**.

##Kernite.View

##Kernite.Form
`Kernite.Form` class simplifies various complex form validation and submission. It can be initialized like this:
	
	form = new Kernite.Form options

The `options` parameter contains the information about the form. The overall structure of the object is as follows:

 - ###`submit: function(data)`
 This callback is invoked when the entire form is successfully validated and ready to be submitted. This callback should handle application-specific data submission process.
 
