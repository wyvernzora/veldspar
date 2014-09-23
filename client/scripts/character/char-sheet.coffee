Veldspar = (this ? exports).Veldspar
Kernite = (this ? exports).Kernite

# Character Sheet
Meteor.startup ->
  ((view) ->

    # Utility Variables
    maxAttrValue = 32

    view.helpers
      'skills': ->
        _.values @skills
      'dob': ->
        @dob.toLocaleDateString()
      'cloneUtilization': ->
        percent = Math.round(@skillPoints / @clone.skillPoints * 100)
        if percent < 100 then percent + '%'
        else 'Insufficient!'
      'cloneTagStyle': ->
        percent = Math.round(@skillPoints / @clone.skillPoints * 100)
        return 'success' if percent < 60
        return 'warning' if percent < 80
        return 'danger'


      'timeInCorp': ->
        dt = Veldspar.Timing.diff @date
      'joinDate': ->
        @date.toLocaleString()

      'standingStyle':  ->
        if -10.0 <= @standing <= -5.0 then 'danger'
        else if -5.0 < @standing <= -1.0 then 'warning'
        else if -1.0 < @standing < 1.0 then 'default'
        else if 1.0 <= @standing < 5.0 then 'info'
        else if 5.0 <= @standing <= 10.0 then 'primary'

      'agentStandings': ->
        return Veldspar.UserData.npcStandings.find type:'agent', {sort: {standing: -1}}
      'corpStandings': ->
        return Veldspar.UserData.npcStandings.find type:'corp', {sort: {standing: -1}}
      'factionStandings': ->
        return Veldspar.UserData.npcStandings.find type:'faction', {sort: {standing: -1}}

      'standing': ->
        val = @standing.toFixed(2)
        if val > 0 then val = '+' + val
        return val

  )(Template['char-sheet'])
