class Bloodoath
  
  constructor: (@robot) ->
    @pacts = []

    @robot.brain.on 'loaded', =>
      if @robot.brain.data.pacts
        @pacts = @robot.brain.data.pacts


  write: (pact) ->
    @pacts.push pact
    @robot.brain.data.pacts = @pacts

  get: ->
    return @pacts

  remove_all: ->
    @pacts = []
    @robot.brain.data.pacts = @pacts

module.exports = (robot) ->
  bloodoath = new Bloodoath robot

  robot.hear /^list bloodoaths$/i, (msg) ->
    pacts = bloodoath.get()
    msg.reply pacts

  robot.hear /^bloodoath (.*)$/i, (msg) ->
    pact = msg.match[1]
    bloodoath.write pact
    msg.reply "'#{pact}' is writ"
    
  robot.hear /^clear bloodoaths$/i, (msg) ->
    pacts = bloodoath.remove_all()
    msg.reply "All pacts have been marked settled"
