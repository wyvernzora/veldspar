# Veldspar EVE Online API Client
# util.coffee - Utility functions and such
# Copyright © Denis Luchkin-Zhou
Veldspar = (this ? exports).Veldspar


Veldspar.util =
  # Skill-related functions
  skill:
    _sp: [ 0, 250, 1415, 8000, 45255, 256000 ] # SP at respective levels
    # Gets the total number of SP for a skill of {rank} at {level}
    sp: (level, rank) ->
      Veldspar.util.skill._sp[level] * rank # SP at a specific level and rank
    # Gets the number of skill points a character trains in the specified skill
    spm: (char, skill) ->
      p = char.attributes[skill.attributes.primary]
      s = char.attributes[skill.attributes.secondary]
      return p.value + p.bonus + (s.value + s.bonus) / 2
