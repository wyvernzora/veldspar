# Veldspar EVE Online API Client
# global.coffee - Namespace definitions & configuration
# Copyright © Denis Luchkin-Zhou

# Global scope
root = exports ? this

# Application namespace definition
root = root.Veldspar ?= { }

# Veldspar configuration namespace
config = root.Config ?= { }
config.apiHost = 'https://api.eveonline.com'
#config.apiHost = 'http://localhost:8888'
config.verbose = yes
