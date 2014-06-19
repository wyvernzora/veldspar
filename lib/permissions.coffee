# Veldspar EVE Online API Client
# api-permissions.coffee - Provides better API access mask support
# Copyright © Denis Luchkin-Zhou
Veldspar = (exports ? this).Veldspar
Permissions = Veldspar.Permissions ?= { }

# Character Level Permissions
Permissions.Character =
  'Account Balance':
    'Description': 'Current balance of characters wallet.'
    'Mask': 1
  'Asset List':
    'Description': 'Entire asset list of character.'
    'Mask': 2
  'CalendarEventAttendees':
    'Description': 'Event attendee responses.'
    'Requires': 'UpcomingCalendarEvents'
    'Mask': 4
  'CharacterSheet':
    'Description': 'Character Sheet information. Contains basic \'Show Info\' information along with clones, account balance, implants, attributes, skills, certificates and corporation roles.'
    'Mask': 8
  'ContactList':
    'Description': 'List of character contacts and relationship levels.'
    'Mask': 16
  'ContactNotifications':
    'Description': 'Most recent contact notifications for the character.'
    'Mask': 32
  'FacWarStats':
    'Description': 'Characters Factional Warfare Statistics.'
    'Mask': 64
  'IndustryJobs':
    'Description': 'Character jobs, completed and active.'
    'Mask': 128
  'KillLog':
    'Description': 'Character\'s kill log.'
    'Mask': 256
  'MailBodies':
    'Description': 'EVE Mail bodies.'
    'Requires': 'MailMessages'
    'Mask': 512
  'MailingLists':
    'Description': 'List of all Mailing Lists the character subscribes to.'
    'Mask': 1024
  'MailMessages':
    'Description': 'List of all messages in the characters EVE Mail Inbox.'
    'Mask': 2048
  'MarketOrders':
    'Description': 'List of all Market Orders the character has made.'
    'Mask': 4096
  'Medals':
    'Description': 'Medals awarded to the character.'
    'Mask': 8192
  'Notifications':
    'Description': 'List of recent notifications sent to the character.'
    'Mask': 16384
  'NotificationTexts':
    'Description': 'Actual body of notifications sent to the character.'
    'Requires': 'Notifications'
    'Mask': 32767
  'Research':
    'Description': 'List of all Research agents working for the character and the progress of the research.'
    'Mask': 65536
