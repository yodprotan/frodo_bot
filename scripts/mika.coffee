# Description:
#   HAH HAH HAH
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   `know that <subject> is <predicate>` - Remember a piece of information
#   `what/who is <subject>` - Recalls a piece of information
thankseses = [
    "you got it friend",
    "np boss",
    "you are most welcome",

    # Actions
    # These mimic /me messages by just using italics. To actually make a /me
    # message, a whole different API call would need to be made, and italics
    # mimics it closely enough
    "_roos helpfully_",
    "_<3_",
]

tankseses = [
    "http://i.imgur.com/P1lgSdI.jpg",
    "http://i.imgur.com/SZgHi9M.jpg",
    "http://i.imgur.com/oOUvJfP.jpg",
    "http://i.imgur.com/oozRzfp.jpg",
    "http://i.imgur.com/VPenfTf.jpg",
    "http://i.imgur.com/6A6bsFz.jpg",
    "http://i.imgur.com/f4l2sL5.gif",
    "http://i.imgur.com/RLslXl7.jpg",
    "http://i.imgur.com/Z9mXxKN.gifv",
    "http://i.imgur.com/acrGKHy.jpg",
]

mika_active_quotes = [ 
  'HAH HAH HAH',
  'PETS PETS PETS'
  'TREAT'
  '/ᐠ｡‸｡ᐟ\\'
  '/ᐠ｡ꞈ｡ᐟ❁ \\'
]

mika_inactive_quotes = [
  '_slurp_'
  '_slurping intensifies_'
  '_yawn_'
  '_curls up into ball_'
]

module.exports = (robot) ->
  robot.hear /mika time$/i, (res) ->
    res.send res.random mika_active_quotes

  robot.hear /thank you mika/i, (msg) ->
      msg.send msg.random thankseses

  robot.hear /mika thanks/i, (msg) ->
      msg.send msg.random thankseses

  robot.hear /mika tanks/i, (msg) ->
      msg.send "Tanks? " + msg.random tankseses

  robot.hear /^thanks,? mika/i, (msg) ->
      msg.send msg.random thankseses

  robot.hear /^tanks,? mika/i, (msg) ->
      msg.send "Tanks? " + msg.random tankseses

  robot.hear /^thank you mika/i, (msg) ->
      msg.send msg.random thankseses

  robot.hear /^thanks brobot/, (msg) ->
      msg.send "you got it, fleshbag"


  emote = (msg, emote) ->
      msg_match = msg.match[1].trim()
      if msg_match == "me"
          msg.reply emote
      else if msg_match != ""
          msg.send "#{msg_match}: #{emote}"
      else
          msg.send emote

  respond_to_emote = (name, value) ->
      regex = new RegExp("#{name}(\\s.*|$)", "i")
      robot.hear regex, (msg) ->
          emote(msg, value)


  respond_to_emote("mika chastise", "tsk tsk.")
  respond_to_emote("mika lenny", "( ͡° ͜ʖ ͡°)")
  respond_to_emote("mika loa", "ʘ‿ʘ")
  respond_to_emote("mika contract", "／人◕ ‿‿ ◕人＼")
  respond_to_emote("mika snowman", "☃")
  respond_to_emote("mika why", "щ(ﾟДﾟщ)")
  respond_to_emote("mika yo", "yo")

