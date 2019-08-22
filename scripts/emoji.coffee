# Import the Slack Developer Kit
{WebClient} = require "@slack/client"

module.exports = (robot) ->
  web = new WebClient robot.adapter.options.token

  robot.hear /test/i, (res) ->
    web.api.test()
      .then () -> res.send "Your connection to the Slack API is working!"
      .catch (error) -> res.send "Your connection to the Slack API failed :("

  robot.respond /random emoji$/i, (res) ->
    res.reply "doink"