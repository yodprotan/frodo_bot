# Description:
#   Example scripts for you to examine and try out.
#
# Dependencies:
#   None
#
# Configuration:
#   None
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

find_comment = (hour, minute) ->
  if (hour == 4 and minute == 20) 
    return ". Blaze It :mary_jane:"
  if (hour == 3 and minute == 14)
    return ". :pie:"
  return "."


# Description:
#     Flip things!
#
# Commands:
#     marley flip <thing> - Flip thing.
#     marley put <thing> back - Now put it back.
#     marley do a flip - Watch Marley perform gymnastics
#     marley come on and slam - and welcome to the jam

# flip = require('../bin/flip')

module.exports = (robot) ->
  flippers = [
      "(╯°□°）╯︵",
      "(┛◉Д◉)┛彡",
      "ヽ(`Д´)ﾉ︵",
      "(ノಠ益ಠ)ノ彡",
      "(┛ò__ó)┛彡",
      " /(ò.ó)┛彡",
      "(┛❍ᴥ❍)┛彡",
  ]

  # robot.respond /flip( (.+))?/i, (msg) ->
  #     if msg.match[2] == "nishbot"
  #         msg.emote "(╯°Д°）╯︵/(.□ . \)"
  #     else if msg.match[2] == "me"
  #         msg.emote "(╯°Д°）╯︵#{flip(msg.message.user.name)}"
  #     else
  #         flipped = if msg.match[2] then flip(msg.match[2]) else '┻━┻'
  #         idx = Math.floor(Math.random() * flippers.length)
  #         msg.emote "#{flippers[idx]} #{flipped}"

  # robot.respond /put (.+) back$/i, (msg) ->
  #     msg.emote "#{flip(msg.match[1])} ノ( ゜-゜ノ)"

  robot.respond /do a flip$/i, (msg) ->
      msg.emote "(╯°□°）╯    ︵    ノ(.ᴗ. ノ)    ︵ ヽ(`Д´)ﾉ"

  robot.respond /do a flop$/i, (msg) ->
      msg.emote "(╯°□°）╯    ︵    \|/"

  robot.respond /magic$/i, (msg) ->
      msg.emote "(ノﾟοﾟ)ノﾐ★゜・。。・゜゜・。。・゜☆゜・。。・゜゜・。。・゜゜・。。・゜☆゜・。。・゜゜・。。・゜"

  robot.respond /more magic$/i, (msg) ->
      msg.emote "(ノﾟοﾟ)ノﾐ★゜・。。・゜゜・。。・゜☆゜・。。・゜゜・。。・゜゜・。。・゜☆゜・。。・゜゜・。。・゜☆゜・。。・゜゜・。。・゜゜・。。・゜☆゜・。。・゜゜・。。・゜"

  robot.respond /less magic$/i, (msg) ->
      msg.emote "(ノﾟοﾟ)ノﾐ★゜・。。・゜゜・。。・゜"

  robot.respond /even more magic$/i, (msg) ->
      msg.emote "(ノﾟοﾟ)ノﾐ★゜・。。・゜゜・。。・゜☆゜・。。・゜゜・。。・゜゜・。。・゜☆゜・。。・゜゜・。。・゜☆゜・。。・゜゜・。。・゜゜・。。・゜☆゜・。。・゜゜・。。・゜☆゜・。。・゜゜・。。・゜゜・。。・゜☆゜・。。・゜゜・。。・゜☆゜・。。・゜゜・。。・゜゜・。。・゜"

  robot.respond /even less magic$/i, (msg) ->
      msg.emote "(ノﾟοﾟ)ノﾐ★゜・。。・゜"

  robot.respond /no$/i, (msg) ->
      msg.emote "whimpers"

  robot.respond /drop the mic$/i, (msg) ->
      msg.emote "(°□°)ノ🎤"

  robot.respond /come on and slam$/i, (msg) ->
      if msg.message.room == "#日本"
          msg.send "and welcome to japan"
      else
          msg.send "and welcome to the jam"

  robot.respond /TIME$/i, (msg) ->
    today = new Date()
    year = today.getFullYear()  + " "
    month = monthlist[today.getMonth()] + " "
    date = today.getDate() + ", "
    day = daylist[today.getDay()] + ", "
    hour = today.getHours() % 12
    minute = today.getMinutes()
    minutes = if minute > 9 then "" + minute else "0" + minute;
    comment = find_comment(hour, minute)
    msg.send "Server time is: " + day + month + date + year + hour  + ":" + minutes + comment

  robot.hear /the pact is writ/i, (res) ->
    res.emote ":pogchamp: :pogchamp: :pogchamp:"

  robot.hear /^ro(o)+$/i, (res) ->
    res.emote "ROO ROO ROO :frodo:"

  robot.hear /shrug/i, (res) ->
    res.emote "¯\\_(ツ)_/¯"

  robot.hear /^thanks frodo$/i, (res) ->
    res.emote "_roos helpfully_"
  
  robot.hear /dis nutt/i, (res) ->
    res.emote "o=======D" 

  robot.hear /good boy/i, (res) ->
    res.emote ":frodo:"

  robot.hear /^do(do)+$/i, (res) ->
    res.emote "roorooroo"
  
  robot.respond /no/i, (res) ->
    res.emote "_whimpers_"
  

