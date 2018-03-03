# Description:
#   Find out the time
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   `frodo time`: gets the server time
# 

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

numberToEmoji = {
  1: ":one: "
  2: ":two: "
  3: ":three: "
  4: ":four: "
  5: ":five: "
  6: ":six: "
  7: ":seven: "
  8: ":eight: "
  9: ":nine: "
  0: ":zero: "
}



class Time
  
  constructor: (@robot) ->
    @time = {}
    @aggregate_time = {}
    
    @robot.brain.on 'loaded', =>
      if @robot.brain.data.time
        @time = @robot.brain.data.time
      if @robot.brain.data.aggregate_time
        @aggregate_time = @robot.brain.data.aggregate_time


  increase: (msg) ->
    if not @today
      @today = []
      
    if msg.message.user.name in @today
        msg.reply "cheater."
    else
        @today.push msg.message.user.name
        @time[msg.message.user.name] ?= 0
        @time[msg.message.user.name] += 1
        @robot.brain.data.time = @time
        

  set: (user, number) ->
    @time[user] = number
    @robot.brain.data.time = @time

  sort: (scoreboard) ->
    s = []
    for key, val of scoreboard
      s.push({ name: key, score: val })
    s.sort (a, b) -> b.score - a.score

  top: (n = 5) =>
    sorted = @sort(@time)
    sorted.slice(0, n)
  
  top_all: (n = 5) =>
    sorted = @sort(@aggregate_time)
    sorted.slice(0, n)

  find_comment: (msg, hour, minute) ->
    if (hour == 4 and minute == 20)
        @increase(msg)
        return ". Blaze It :mary_jane:"

    else if (hour == 3 and minute == 14)
        return ". :pie:"
    else
        @today = []
        return "."

  score: ->
    if not @today
      @today = []

    score = @today.length
    @today = []
    return score 

  reset: (msg) ->
    for key, val of @time
      @aggregate_time[key] ?= 0
      @aggregate_time[key] += val
      @time[key] = 0

    @robot.brain.data.time = @time
    @robot.brain.data.aggregate_time = @aggregate_time
    msg.reply "resetting the scoreboard, thanks for playing."

module.exports = (robot) ->
  time = new Time robot

  robot.respond /TIME$/i, (msg) ->
    today = new Date()
    year = today.getFullYear()  + " "
    month = monthlist[today.getMonth()] + " "
    date = today.getDate() + ", "
    day = daylist[today.getDay()] + ", "
    hour = today.getHours() % 12
    minute = today.getMinutes()
    minutes = if minute > 9 then "" + minute else "0" + minute;
    comment = time.find_comment(msg, hour, minute)
    msg.send "Server time is: " + day + month + date + year + hour  + ":" + minutes + comment

  ###
  # Function that handles best and worst list
  # @param msg The message to be parsed
  # @param title The title of the list to be returned
  # @param rankingFunction The function to call to get the ranking list
  ###
  parseListMessage = (msg, title, rankingFunction) ->
    count = if msg.match.length > 1 then msg.match[1] else null
    verbiage = [title]
    for item, rank in rankingFunction(count)
      if rank == 0
        verbiage.push ":first_place_medal: #{item.name} - #{item.score}"
      else if rank == 1
        verbiage.push ":second_place_medal: #{item.name} - #{item.score}"
      else if rank == 2
        verbiage.push ":third_place_medal: #{item.name} - #{item.score}"
      else
        verbiage.push "  #{rank + 1}. #{item.name} - #{item.score}"
    msg.send verbiage.join("\n")

  ###
  # Listen for "time best [n]" and return the top n rankings
  ###
  robot.respond /time best\s*(\d+)?$/i, (msg) ->
    parseData = parseListMessage(msg, "Most Dank", time.top)

  ###
  # Listen for "all time best [n]" and return the top n rankings all time
  ###
  robot.respond /all time best\s*(\d+)?$/i, (msg) ->
    parseData = parseListMessage(msg, "Most Dank of all time", time.top_all)

  ###
  # Listen for "time reset" and reset the ranking, and
  # recording all time stats into aggregate_time
  ###
  # robot.respond /time reset/i, (msg) ->
  #   time.reset(msg)

  ###
  # Listen for "time set x to y" and reset the ranking,
  # of user x to value y.
  # Used for one off corrections, (i.e. for jon's cheating)
  ###
  # robot.respond /time set (.*) (.*)/i, (msg) ->
  #   user = msg.match[1]
  #   numberAsString = msg.match[2]
  #   number = parseInt(numberAsString, 10 );
  #   time.set(user, number)
  #   msg.send "okay setting " + user + " to " + number

  ###
  # Listen for "tron" and list the count of responders for today
  # Note: This resets the day's count. 
  ###
  robot.respond /tron$/i, (msg) ->
    today = new Date()
    hour = today.getHours() % 12
    minute = today.getMinutes()
    if (hour == 4 and minute == 20)
      msg.respond "still calculating. Delete this."
    else
      stringScore = time.score().toString()
      emojiScore = ""
      for i in [0..(stringScore.length-1)]
        emoji = numberToEmoji[i]
        emojiScore += emoji
      msg.send "Congratulations on your " + emojiScore + "tron :b: :ok-hand: :100:"