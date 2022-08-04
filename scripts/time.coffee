# Description:
#   Helper class to store time data
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   None

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
    @score = {}
    @score_by_day = {}
    
    @robot.brain.on 'loaded', =>
      if @robot.brain.data.time
        @time = @robot.brain.data.time
      if @robot.brain.data.aggregate_time
        @aggregate_time = @robot.brain.data.aggregate_time
      if @robot.brain.data.score_by_day
        @score_by_day = @robot.brain.data.score_by_day
      if @robot.brain.data.score
        @score = @robot.brain.data.score



  increase: (msg, points) ->
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
        @score[msg.message.user.name] ?= 0
        @score[msg.message.user.name] += points
        @robot.brain.data.time = @time
        @robot.brain.data.aggregate_time = @aggregate_time
        @robot.brain.data.score = @score

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

  top_points: (n = 5) =>
    sorted = @sort(@score)
    sorted.slice(0, n)



  find_comment: (msg, month, date, hour, minute, second) ->
    if (hour == 4 and minute == 20)
        points = 60-second
        @increase(msg, points)
        return ". " + points + "points :mary_jane:"
    if (month == 4 and date == 20)
        return ". Let's get fucking lit fam :mary_jane:"
    else if (hour == 3 and minute == 14)
        return ". :pie:"
    else
        return "."

  get_today: ->
    if not @today
      @today = []
      
    return @today.length

  reset_today: (today, score) ->
    year = today.year
    month = double_digit today.month
    date = double_digit today.day

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

  reset_score: (msg) ->
    for key, val of @score
      @score[key] = 0

    @robot.brain.data.score = @score
    msg.reply "resetting the score, thanks for playing."

exports.Time = Time