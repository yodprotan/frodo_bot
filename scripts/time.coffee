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



class Time
  
  constructor: (@robot) ->
    @time = {}
    
    @robot.brain.on 'loaded', =>
      if @robot.brain.data.time
        @time = @robot.brain.data.time

  increase: (msg) ->
    @time[msg.message.user.name] ?= 0
    @time[msg.message.user.name] += 1
    @robot.brain.data.time = @time

  sort: ->
    s = []
    for key, val of @time
      s.push({ name: key, score: val })
    s.sort (a, b) -> b.score - a.score

  top: (n = 5) =>
    sorted = @sort()
    sorted.slice(0, n)

  bottom: (n = 5) =>
    sorted = @sort()
    sorted.slice(-n).reverse()

  find_comment: (msg, hour, minute) ->
    if (hour == 4 and minute == 20)
        @increase(msg)
        return ". Blaze It :mary_jane:"
    if (hour == 3 and minute == 14)
        return ". :pie:"
    return "."

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
      verbiage.push "#{rank + 1}. #{item.name} - #{item.score}"
    msg.send verbiage.join("\n")

  ###
  # Listen for "time best [n]" and return the top n rankings
  ###
  robot.respond /time best\s*(\d+)?$/i, (msg) ->
    parseData = parseListMessage(msg, "Most Dank", time.top)

  ###
  # Listen for "time worst [n]" and return the bottom n rankings
  ###
  robot.respond /time worst\s*(\d+)?$/i, (msg) ->
    parseData = parseListMessage(msg, "Least Dank", time.bottom)