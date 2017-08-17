class Knowledge
  
  constructor: (@robot) ->
    @knowledge = {}
    
    @robot.brain.on 'loaded', =>
      if @robot.brain.data.knowledge
        @knowledge = @robot.brain.data.knowledge

  remember: (msg, subject, predicate) ->
    @knowledge[subject] = predicate
    msg.reply "Ok, " + subject + " is " + predicate

module.exports = (robot) ->
  knowledge = new Knowledge robot

  robot.hear /^know that (.*) is (.*)$/i, (msg) ->
    subject = msg.match[1]
    predicate = msg.match[2]
    knoweldge.remember(msg, subject, predicate)
