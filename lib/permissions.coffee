# Veldspar EVE Online API Client
# api-permissions.coffee - Provides better API access mask support
# Copyright © Denis Luchkin-Zhou
Veldspar = (exports ? this).Veldspar
Permissions = Veldspar.Permissions ?= { }

# Utility Functions
Permissions.compose = (permissions...) ->
  console.log permissions
  _.reduce _.map(permissions, (i,k) -> i.mask), (mem, i) -> 
    return mem | i
  ,0

Permissions.decompose = (accessMask, type) ->
  if type is 'Character'
    return _.filter @Character, (i) -> i.mask & accessMask
  else if type is 'Corporation'
    return _.filter @Corporation, (i) -> i.mask & accessMask
  else
    throw new Meteor.Error 14, 'Unexpected access mask type.'
  
Permissions.has = (accessMask, permissions...) ->
  mask = @compose permissions
  return accessMask & mask is mask
  
# Permission Values
Permissions.Character = 
  "Locations":
    "mask":134217728
    "description":"Allows the fetching of coordinate and name data for items owned by the character."
  "Contracts":
    "mask":67108864
    "description":"List of all Contracts the character is involved in."
  "AccountStatus":
    "mask":33554432
    "description":"EVE player account status."
  "CharacterInfo":
    "mask":8388608
    "description":"Character information, exposes skill points and current ship information on top of'Show Info'information."
  "WalletTransactions":
    "mask":4194304
    "description":"Market transaction journal of character."
  "WalletJournal":
    "mask":2097152
    "description":"Wallet journal of character."
  "UpcomingCalendarEvents":
    "mask":1048576
    "description":"Upcoming events on characters calendar."
  "Standings":
    "mask":524288
    "description":"NPC Standings towards the character."
  "SkillQueue":
    "mask":262144
    "description":"Entire skill queue of character."
  "SkillInTraining":
    "mask":131072
    "description":"Skill currently in training on the character. Subset of entire Skill Queue."
  "Research":
    "mask":65536
    "description":"List of all Research agents working for the character and the progress of the research."
  "NotificationTexts":
    "mask":32768
    "description":"Actual body of notifications sent to the character. Requires Notification access to function."
  "Notifications":
    "mask":16384
    "description":"List of recent notifications sent to the character."
  "Medals":
    "mask":8192
    "description":"Medals awarded to the character."
  "MarketOrders":
    "mask":4096
    "description":"List of all Market Orders the character has made."
  "MailMessages":
    "mask":2048
    "description":"List of all messages in the characters EVE Mail Inbox."
  "MailingLists":
    "mask":1024
    "description":"List of all Mailing Lists the character subscribes to."
  "MailBodies":
    "mask":512
    "description":"EVE Mail bodies. Requires MailMessages as well to function."
  "KillLog":
    "mask":256
    "description":"Characters kill log."
  "IndustryJobs":
    "mask":128
    "description":"Character jobs, completed and active."
  "FacWarStats":
    "mask":64
    "description":"Characters Factional Warfare Statistics."
  "ContactNotifications":
    "mask":32
    "description":"Most recent contact notifications for the character."
  "ContactList":
    "mask":16
    "description":"List of character contacts and relationship levels."
  "CharacterSheet":
    "mask":8
    "description":"Character Sheet information. Contains basic'Show Info'information along with clones, account balance, implants, attributes, skills, certificates and corporation roles."
  "CalendarEventAttendees":
    "mask":4
    "description":"Event attendee responses. Requires UpcomingCalendarEvents to function."
  "AssetList":
    "mask":2
    "description":"Entire asset list of character."
  "AccountBalance":
    "mask":1
    "description":"Current balance of characters wallet."

# Corporation Level Permissions
Permissions.Corporation = 
  "MemberTrackingExtended":
    "mask":33554432
    "description":"Extensive Member information. Time of last logoff, last known location and ship."
  "Locations":
    "mask":16777216
    "description":"Allows the fetching of coordinate and name data for items owned by the corporation."
  "Contracts":
    "mask":8388608
    "description":"List of recent Contracts the corporation is involved in."
  "Titles":
    "mask":4194304
    "description":"Titles of corporation and the roles they grant."
  "WalletTransactions":
    "mask":2097152
    "description":"Market transactions of all corporate accounts."
  "WalletJournal":
    "mask":1048576
    "description":"Wallet journal for all corporate accounts."
  "StarbaseList":
    "mask":524288
    "description":"List of all corporate starbases."
  "Standings":
    "mask":262144
    "description":"NPC Standings towards corporation."
  "StarbaseDetail":
    "mask":131072
    "description":"List of all settings of corporate starbases."
  "Shareholders":
    "mask":65536
    "description":"Shareholders of the corporation."
  "OutpostServiceDetail":
    "mask":32768
    "description":"List of all service settings of corporate outposts."
  "OutpostList":
    "mask":16384
    "description":"List of all outposts controlled by the corporation."
  "Medals":
    "mask":8192
    "description":"List of all medals created by the corporation."
  "MarketOrders":
    "mask":4096
    "description":"List of all corporate market orders."
  "MemberTrackingLimited":
    "mask":2048
    "description":"Limited Member information."
  "MemberSecurityLog":
    "mask":1024
    "description":"Member role and title change log."
  "MemberSecurity":
    "mask":512
    "description":"Member roles and titles."
  "KillLog":
    "mask":256
    "description":"Corporation kill log."
  "IndustryJobs":
    "mask":128
    "description":"Corporation jobs, completed and active."
  "FacWarStats":
    "mask":64
    "description":"Corporations Factional Warfare Statistics."
  "ContainerLog":
    "mask":32
    "description":"Corporate secure container acess log."
  "ContactList":
    "mask":16
    "description":"Corporate contact list and relationships."
  "CorporationSheet":
    "mask":8
    "description":"Exposes basic'Show Info'information as well as Member Limit and basic division and wallet info."
  "MemberMedals":
    "mask":4
    "description":"List of medals awarded to corporation members."
  "AssetList":
    "mask":2
    "description":"List of all corporation assets."
  "AccountBalance":
    "mask":1
    "description":"Current balance of all corporation accounts."
