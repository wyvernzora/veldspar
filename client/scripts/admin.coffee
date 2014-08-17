# ADMIN: Admin Panel
((view) ->
  Kernite.ui view

  view.events
    'click #admin-update-static': ->
      console.log 'processing...'
      Meteor.call 'updateStaticData', (error, result) ->
        #alert(error?.reason ? result)
        console.log JSON.stringify result

)(Template.admin)
