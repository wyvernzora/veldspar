# Skill-related utilities
Veldspar = (this ? exports).Veldspar
Veldspar.Skill ?= { }

Veldspar.Skill._sp = [ 0, 250, 1415, 8000, 45255, 256000 ] # SP at respective levels

# Get the number of skill points for the skill of the specified level and rank
Veldspar.Skill.spAtLevel = (level, rank) ->
  Veldspar.Skill._sp[level] * rank # SP at a specific level and rank

# Gets the number of skill points a character trains in the specified skill
Veldspar.Skill.spPerMinute = (char, skill) ->
  p = char.attributes[skill.attributes.primary]
  s = char.attributes[skill.attributes.secondary]
  return p.value + p.bonus + (s.value + s.bonus) / 2

# Consolidate prerequisites
Veldspar.Skill.consolidatePrereq = (skills) ->
  result = [ ] # id: level, name list
  stack = new Array() # Temporary data structure
  for skill in skills
    stack.push skill
  while stack.length > 0
    skill = stack.pop()
    console.log skill.name
    result.push(id:skill.id, name:skill.name, level:skill.level)
    for prereq in skill.prerequisites
      stack.push prereq
  return result
