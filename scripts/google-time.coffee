
# Description:
#   Returns the current time for a location
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot current time in <location> #time
#
# Author:
#   cpradio

module.exports = (robot) ->
    robot.hear /mika current time in (.*)/i, (msg) ->
        searchMe msg, "current time in #{msg.match[1]}", (text) ->
            msg.send text

searchMe = (msg, query, cb) ->
    searchUrl = "https://www.google.com/search?q=#{encodeURIComponent(query)}"
    msg.http('https://www.google.com/search')
        .query(q: query)
        .get() (err, res, body) ->
            searchResults = body.replace /<[^>]*>/gi, ''
            searchResults = searchResults.replace /\s+/gi, ' '
            time = searchResults.match /([0-9]{1,2}:[0-9]{1,2} (AM|PM))/gi
            date = searchResults.match /([a-z]+, [a-z]+ [0-9]{1,2}, [0-9]{4} \([a-z]+(\+|-)?([0-9]+)?\))/gi
            location = searchResults.match /Time in ([a-z,\s]+)/i
            if time?.length > 0 && date?.length > 0 && location?.length > 0
                cb "In #{location[1]} it is #{time[0]} on #{date[0]}"
            else
                cb "I was unable to find the current time for #{query}\r\nTry #{searchUrl}"

