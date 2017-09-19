# Description:
#   INVOKE ZALGO
#
# Dependencies:
#   to-zalgo
# 
# Commands:
#   `frodo zalgo [text]` - summon the power of Zalgo to infect some text

zalgo = require 'to-zalgo'

module.exports = (robot) ->
    robot.respond /zalgo( me)? (.+)/i, (msg) ->
        text = msg.match[2]
        # more than 20 characters of zalgo'd text breaks things
        msg.send zalgo(text.substring(0, 20))