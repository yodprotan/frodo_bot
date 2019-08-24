# Description:
#   Track arbitrary pieces of knowledge
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   `frodo know that <subject> is <predicate>` - Remember a piece of information
#   `frodo what/who is <subject>` - Recalls a piece of information
#   `frodo random fact` - Recalls a random piece of information
#   `frodo total number of facts` - Recalls how many pieces of information are stored



class Knowledge
  
  constructor: (@robot) ->
    @knowledge = {}
    
    @robot.brain.on 'loaded', =>
      if @robot.brain.data.knowledge
        @knowledge = @robot.brain.data.knowledge

  random:(msg)->
    all_knowledge = ['jon is a chud']
    for subject, predicate of @knowledge
      all_knowledge.push  "#{subject} is #{predicate}"
    msg.reply all_knowledge[Math.floor(Math.random() * (all_knowledge.length + 1))]
    

  remember: (msg, subject, verb, predicate) ->
    @knowledge[subject.toLowerCase()] = predicate
    @robot.brain.data.knowledge = @knowledge
    msg.reply "Ok, #{subject} #{verb} #{predicate}"

  recall: (msg, verb, subject) ->
    maybe_knowledge = @knowledge[subject.toLowerCase()]
    if not maybe_knowledge
      maybe_knowledge = @knowledge[subject]
      
    if maybe_knowledge
      msg.send "#{subject} #{verb} #{maybe_knowledge}"

    else
      msg.send "#{subject} #{verb} #{subject}"
    
  total: (msg) ->
    memory_shards = Object.keys(@knowledge).length
    msg.reply "There are #{memory_shards} facts in my brain."

module.exports = (robot) ->
  knowledge = new Knowledge robot

  robot.respond /know that (.*) (is|are) (.*)$/i, (msg) ->
    subject = msg.match[1]
    verb = msg.match[2]
    predicate = msg.match[3]
    knowledge.remember(msg, subject, verb, predicate)


  robot.respond /(what|who) (is|are) (.*)$/i, (msg) ->
    subject = msg.match[3]
    verb = msg.match[2]
    knowledge.recall(msg, verb, subject)

  robot.respond /random fact$/i, (msg) ->
    knowledge.random(msg)

  robot.respond /total number of facts$/i, (msg) ->
    knowledge.total(msg)