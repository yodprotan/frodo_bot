# Description:
#   Example scripts for you to examine and try out.
#
# Notes:
#   They are commented out by default, because most of them are pretty silly and
#   wouldn't be useful and amusing enough for day to day huboting.
#   Uncomment the ones you want to try and experiment with.
#
#   These are from the scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md
daylist = [ 
  'Sunday'  
  'Monday'  
  'Tuesday'  
  'Wednesday'  
  'Thursday'  
  'Friday'  
  'Saturday'  
]

monthlist = [ 
  'January'
  'February'
  'March'
  'April'
  'May'
  'June'
  'July'
  'August'
  'September'
  'October'
  'November'
  'December'
]  

module.exports = (robot) ->
  robot.respond /TIME$/i, (msg) ->
    today = new Date()
    year = today.getFullYear()  + " "
    month = monthlist[today.getMonth()] + " "
    date = today.getDate() + ", "
    day = daylist[today.getDay()] + ", "
    hour = today.getHours() % 12
    minute = today.getMinutes()
    minutes = minutes > 9 ? "" + minutes: "0" + minutes;
    comment = if (hour == 4 and minute == 20) then ". Blaze It :mary_jane:" else ""
    msg.send "Server time is: " + day + month + date + year + hour  + ":" + minute + comment

  robot.hear /the pact is writ/i, (res) ->
    res.emote ":pogchamp: :pogchamp: :pogchamp:"

  robot.hear /^roo$/i, (res) ->
    res.emote "ROO ROO ROO :frodo:"

  robot.hear /shrug/i, (res) ->
    res.emote "¯\\_(ツ)_/¯"

  robot.hear /magic/i, (res) ->
    res.emote "(＠・｀ω・)v☆+ ﾟ .+ .ﾟ.ﾟ｡ ﾟ ｡. +ﾟ ｡ﾟ.ﾟ｡☆*｡｡ . ｡ o .｡ﾟ｡.o｡* ｡ .｡"
  

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

module.exports = (robot) ->
  bloodoath = new Bloodoath robot

  robot.hear /^list bloodoaths$/i, (msg) ->
    pacts = bloodoath.get
    msg.send pacts[0]

  robot.hear /^bloodoath (.*)$/i, (msg) ->
    pact = msg.match[1]
    bloodoath.write pact
    msg.send "'#{pact}' is writ"
    
    # pacts.push pact 
  
  
    
  

