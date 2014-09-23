Veldspar = (this ? exports).Veldspar
Kernite = (this ? exports).Kernite

# Skill Level Indicator
# Arguments:
#   require: any value other than 0 will be evaluated against {level}
#   level: current skill level
#   queued: maximum level found in the skill queue
#   training: any value other than 0 will show the training animation
((view) ->

  # Kernite utilities
  view.helpers
    'styles': (level) ->
      styles = [];
      # Do we have this skill level?
      if (level <= this.level)
        styles.push 'have'
      # Do we have this skill level in queue
      if (level <= this.queued and level > this.level)
        styles.push 'queued'
      # Are we training this skill?
      if (level is this.training)
        styles.push 'training'
      # Are we evaluating prerequisite requirement?
      if (this.require and this.require >= level and level > this.level)
        styles.push 'need'

      return styles.join ' '
    'framestyle': ->
      if (not this.require)
        return '';
      if (this.require <= this.level)
        return 'ok'
      if (this.require > this.level and this.level isnt 0)
        return 'partial'
      return 'no'

  # Meteor.js callback extension
)(Template.skillLevel)


((view) ->

  view.helpers
    'styles': (level) ->
      styles = [];
      # Do we have this skill level?
      if (level <= @level)
        styles.push 'have'
      # Do we have this skill level in queue
      if (level <= @queued and level > @level)
        styles.push 'queued'
      # Are we training this skill?
      if (level is @training)
        styles.push 'training'
      # Are we evaluating prerequisite requirement?
      if (@require and @require >= level and level > @level)
        styles.push 'need'

      return styles.join ' '
)(Template.skillLevelB)
