# Kernite UI - UI framework for Veldspar.io
# view.coffee
# Copyright © 2014 Denis Luchkin-Zhou <https://github.com/jluchiji>
Kernite = (this ? exports).Kernite ?= { }

# Base class for Kernite views
class Kernite.view
  @_kern = { }
  @_kern.render = []
  
  util: (methods) ->
    $.extend @util, methods
    @util
  
  
  
  
  