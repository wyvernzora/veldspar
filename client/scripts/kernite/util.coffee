# Kernite UI - UI framework for Veldspar.io
# util.coffee - Utilities and other junk
# Copyright © 2014 Denis Luchkin-Zhou <https://github.com/jluchiji>
Kernite = (this ? exports).Kernite ?= {}

Kernite.Util = {}

Kernite.Util.isEmailAddress = (str) ->
  return /^\w+(\.\w+|)*@\w+\.\w+$/.test(str)

Kernite.Util.passwordStrength = (str) ->
  s = new RegExp '^(?=.{8,})(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*\\W).*$', 'g'
  m = new RegExp '^(?=.{7,})(((?=.*[A-Z])(?=.*[a-z]))|((?=.*[A-Z])(?=.*[0-9]))|((?=.*[a-z])(?=.*[0-9]))).*$', 'g'
  e = new RegExp '(?=.{6,}).*', 'g'
  return 'invalid' if not e.test str
  return 'ok' if s.test str
  return 'medium' if m.test str
  return 'weak'