# Description:
#   Track all the bets made
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   list bloodoaths - return list of bets made
#   bloodoath <oath> - adds a bet to the list of bets
#   clear bloodoaths - forget all of the bets that have been made
#   settle <number> - resolve a bet that has been made (based on `list bloodoaths`)

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

  remove_one: (msg, number) ->
    if (!isNaN(parseFloat(number)) && number<@pacts.length+1 && number>0)
      @pacts.splice(number-1, 1)
      @robot.brain.data.pacts = @pacts
      msg.reply "Pact #{number} has been settled"
    
    else
      msg.reply "Please enter a valid pact number"

module.exports = (robot) ->
  bloodoath = new Bloodoath robot

  robot.hear /^list bloodoaths$/i, (msg) ->
    pacts = bloodoath.get()
    verbiage = ["Pacts"]
    for pact, index in pacts
      verbiage.push "#{index + 1}. #{pact}"
    msg.send verbiage.join("\n")

  robot.hear /^bloodoath (.*)$/i, (msg) ->
    pact = msg.match[1]
    bloodoath.write pact
    msg.reply "'#{pact}' is writ"
    
  robot.hear /^clear bloodoaths$/i, (msg) ->
    bloodoath.remove_all()
    msg.reply "All pacts have been marked settled"

  robot.hear /^settle (.*)$/i, (msg) ->
    number = msg.match[1]
    bloodoath.remove_one(msg, number)
    
