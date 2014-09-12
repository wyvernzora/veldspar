# ADMIN: Admin Panel
Meteor.startup ->
  ((view) ->
    Kernite.ui view

    view.events
      'click #admin-update-static': ->
        console.log 'processing...'
        Meteor.call 'updateStaticData', (error, result) ->
          #alert(error?.reason ? result)
          console.log JSON.stringify result

  )(Template.admin)

# AM-ST: Static
Meteor.startup ->
  ((view) ->
    Kernite.ui view


    view.events
      'click #am-st-update-skills': ->
        Session.set 'am-st.error', null
        $('#am-st-update-dlg').modal('show')
        Meteor.call 'admin.updateSkillTree', (error) ->
          if not error
            $('#am-st-update-dlg').modal('hide')
          else
            Session.set 'am-st.error', error
      'click #am-st-update-certs': ->
        Session.set 'am-st.error', null
        $('#am-st-update-dlg').modal('show')
        Meteor.call 'admin.updateCertificates', (error) ->
          if not error
            $('#am-st-update-dlg').modal('hide')
          else
            Session.set 'am-st.error', error


    view.onRender -> Session.set 'am-st.error', undefined
  )(Template['admin-static'])
