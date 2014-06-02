# Veldspar EVE Online API Client
# global.coffee - Namespace definitions & configuration
# Copyright © Denis Luchkin-Zhou

# Global scope
root = exports ? this

# Application namespace definition
root = root.Veldspar = root.Veldspar ? { }

# Veldspar configuration namespace
config = root.Config = root.Config ? { }
config.apiHost = 'https://api.eveonline.com'
config.verbose = no
