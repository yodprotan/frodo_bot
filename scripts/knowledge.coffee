class Knowledge
  
  constructor: (@robot) ->
    @knowledge = {}
    
    @robot.brain.on 'loaded', =>
      if @robot.brain.data.knowledge
        @knowledge = @robot.brain.data.knowledge

  remember: (msg, subject, predicate) ->
    @knowledge[subject] = predicate
    msg.reply "Ok, #{subject} is #{predicate}"

  recall: (msg, subject) ->
    maybe_knowledge = @knowledge[subject]
    if maybe_knowledge
      msg.send "#{subject} is #{maybe_knowledge}"

    else
      msg.send "#{subject} is #{subject}"

module.exports = (robot) ->
  knowledge = new Knowledge robot

  robot.respond /know that (.*) is (.*)$/i, (msg) ->
    subject = msg.match[1]
    predicate = msg.match[2]
    knowledge.remember(msg, subject, predicate)

  robot.respond /what is (.*)$/i, (msg) ->
    subject = msg.match[1]
    knowledge.recall(msg, subject)
