# Description:
#     Gives beer.
#
# Commands:
#     `frodo beer` - Gives you a beer.
#     `frodo 3 beers` - Gives you three beers.
#     `frodo 10 beers` - Gives you a bottle of Absolut

module.exports = (robot) ->
    robot.respond /[^\d]+(\d+ )?beer/i, (msg) ->
        str = "\ud83c\udf7a "
        if msg.match[1] != ""
            num = parseInt(msg.match[1])
            if num == 0
                msg.send 'you boring...'
            else if num > 5
                msg.send "I have something special for you!"
                msg.send "\ud83c\udf78"
            else
                str += "\ud83c\udf7a " for i in [1..num-1]
                msg.send "here you go: #{str}"
        else
            msg.send str