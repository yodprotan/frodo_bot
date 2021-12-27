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
#   `frodo time` - gets the server time
#   `frodo time best n` - gets the leaderboard for this season
#   `frodo all time best n ` - gets the leaderboard for all time
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
  "1": ":one: "
  "2": ":two: "
  "3": ":three: "
  "4": ":four: "
  "5": ":five: "
  "6": ":six: "
  "7": ":seven: "
  "8": ":eight: "
  "9": ":nine: "
  "0": ":zero: "
}

snoops = [
  'https://i.pinimg.com/originals/4d/aa/38/4daa38eaaef244c0218b361ae64baea9.jpg'
  'https://i.pinimg.com/736x/e4/5f/40/e45f401e2d083048c3d6e725704d0619.jpg'
  'https://i.ytimg.com/vi/voHNHRZ0qUU/maxresdefault.jpg'
  'https://i.pinimg.com/originals/d2/83/de/d283dec6d6c8b19c3bdaf81ca31da7e9.jpg'
  'https://external-preview.redd.it/fX-BW8AT4MiiVpu9TzKk9EsOYNqpIrljDD5gao07V4k.jpg?auto=webp&s=f0e8bfa3676f55c6e5657c412ded98dafbad4f5f'
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ1I9Btkv6rcx8XrgK-TxLUinnqPtUN8pQgAg&usqp=CAU'
  'https://static.billboard.com/files/media/Snoop-Dogg-Honored-With-Star-On-The-Hollywood-Walk-Of-Fame-billboard-1548-compressed.jpg'
  'https://cdn.akamai.steamstatic.com/steamcommunity/public/images/avatars/f7/f713050effaeeb541589b11bad17f7ac2b98719c_full.jpg'
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRWklN9sW5yrV15AfvTfixhN4UwqgCFTahDMA&usqp=CAU'
  'https://images3.memedroid.com/images/UPLOADED417/5cc49ecb953ce.jpeg'
  'https://cdn.cnn.com/cnnnext/dam/assets/200826155913-snoop-dogg-martha-stewart-file-full-169.jpg'
  'https://www.nme.com/wp-content/uploads/2016/09/SnoopDogg_getty18262675_290710-1.jpg'
  'https://i.kym-cdn.com/photos/images/original/001/673/881/5fc.jpg'
  'https://i0.wp.com/www.uselessdaily.com/wp-content/uploads/2016/11/Snoop-dogg.jpg?fit=545%2C368&ssl=1'
  'https://external-preview.redd.it/ftNTNCm-TMsrab_sWo5BYUG51emFazCoWxMXxCDng0g.jpg?auto=webp&s=175b2b35cf06d8ea9c9420f72e8785bc0b0b6f49'
  'https://i1.sndcdn.com/artworks-000245722753-m3cx1n-t500x500.jpg'
]

double_digit = (number) ->
  return if number > 9 then "" + number else "0" + number;


class Time
  
  constructor: (@robot) ->
    @time = {}
    @aggregate_time = {}
    @score_by_day = {}
    
    @robot.brain.on 'loaded', =>
      if @robot.brain.data.time
        @time = @robot.brain.data.time
      if @robot.brain.data.aggregate_time
        @aggregate_time = @robot.brain.data.aggregate_time
      if @robot.brain.data.score_by_day
        @score_by_day = @robot.brain.data.score_by_day



  increase: (msg) ->
    if not @today
      @today = []
      
    if msg.message.user.name in @today
        msg.reply "cheater."
    else
        @today.push msg.message.user.name
        @time[msg.message.user.name] ?= 0
        @time[msg.message.user.name] += 1
        @aggregate_time[msg.message.user.name] ?= 0
        @aggregate_time[msg.message.user.name] += 1
        @robot.brain.data.time = @time
        @robot.brain.data.aggregate_time = @aggregate_time

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

  bottom: (n = 5) =>
    sorted = @sort()
    sorted.slice(-n).reverse()
  
  top_all: (n = 5) =>
    sorted = @sort(@aggregate_time)
    sorted.slice(0, n)

  find_comment: (msg, month, date, hour, minute) ->
    console.log month
    console.log date
    if (hour == 4 and minute == 20 and month == 4 and date == 20)
        @increase(msg)
        return ". " + snoops[Math.floor(Math.random() * (snoops.length + 1))]
    if (hour == 4 and minute == 20)
        @increase(msg)
        return ". Blaze It :mary_jane:"
    if (month == 4 and date == 20)
        return ". Let's get fucking lit fam :mary_jane:"
    else if (hour == 3 and minute == 14)
        return ". :pie:"
    else
        return "."

  get_today: ->
    if not @today
      @today = []
      
    console.log @today
    return @today.length

  reset_today: (today, score) ->
    year = today.getFullYear()
    month = double_digit today.getMonth() + 1
    date = double_digit today.getDate()

    # Could you find a jankier way to cast to str?
    @score_by_day[("" + year + month + date)] ?= 0
    @score_by_day[("" + year + month + date)] += score
    @robot.brain.data.score_by_day = @score_by_day
    console.log "recording " + score + " for " + year + "/" + month + "/" + date

    @today = []

  reset: (msg) ->
    for key, val of @time
      @time[key] = 0

    @robot.brain.data.time = @time
    msg.reply "resetting the scoreboard, thanks for playing."

module.exports = (robot) ->
  time = new Time robot

  robot.respond /TIME$/i, (msg) ->
    today = new Date()
    
    year_s = today.getFullYear() + " "

    month = today.getMonth() # for some dumb reason, this is indexed by 0
    month_s = monthlist[month] + " "

    date = today.getDate()
    date_s = today.getDate() + ", "
    day_s = daylist[today.getDay()] + ", "

    hour = today.getHours() % 12
    hour = if hour > 0 then hour else 12;

    minute = today.getMinutes()
    minute_s = double_digit minute;

    comment = time.find_comment(msg, month + 1, date, hour, minute)
    msg.send "Server time is: " + day_s + month_s + date_s + year_s + hour + ":" + minute_s + comment

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
  robot.respond /time reset/i, (msg) ->
    time.reset(msg)

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
  # responds with the count of responders for today automattically
  # after four twenty
  # Note: This resets the day's count. 
  ###
  robot.hear /./i, (msg) ->
    local_today = msg.message.ts
    console.log local_today
    
    today = new Date()
    hour = today.getHours() % 12
    hour = if hour > 0 then hour else 12
    minute = today.getMinutes()
    score = time.get_today(msg)
    if score > 0 and not (hour == 4 and minute == 20) and msg.message.user.room == "CK58J140P"
      emojiScore = ""
      for ch in score.toString()
        emojiScore += numberToEmoji[ch]
      msg.send "Congratulations on your " + emojiScore + "-tron :b: :ok_hand: :100:"
      time.reset_today(today, score)

  # Why not
  robot.respond /random snoop$/i, (msg) ->
    msg.send snoops[Math.floor(Math.random() * (snoops.length + 1))]

  ###
  # Listen for "tron" and list the count of responders for today
  # Note: This resets the day's count. 
  ###
  # robot.respond /tron$/i, (msg) ->
  #   today = new Date()
  #   hour = today.getHours() % 12
  #   minute = today.getMinutes()
  #   if (hour == 4 and minute == 20)
  #     msg.reply "still calculating. Delete this."
  #   else
  #     score = time.get_today(msg)
  #     if score < 1
  #       msg.send "_loooooseerrrr_ http://i.imgur.com/h9gwfrP.gif"
  #     else 
  #       emojiScore = ""
  #       for ch in score.toString()
  #         emojiScore += numberToEmoji[ch]
  #       msg.send "Congratulations on your " + emojiScore + "-tron :b: :ok_hand: :100:"
  #     time.reset_today()
