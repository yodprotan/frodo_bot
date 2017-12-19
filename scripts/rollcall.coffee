# Description:
#     Allow marley to check if people are ready for league
# Commands:
#     marley rollcall 1234
#     marley stop rollcall
#     user is here

class Rollcalls
    constructor: (@robot) ->
        @cache = {}
        @current_timeout = null

        @robot.brain.on 'loaded', =>
            if @robot.brain.data.groups
                @cache = @robot.brain.data.groups

    add: (group) ->
        console.log 'adding group: ' + group
        @cache[group] = []
        @robot.brain.data.groups = @cache

    clear: (group) ->
        console.log 'removing group: ' + group
        delete @cache[group]; 
        @robot.brain.data.groups = @cache

    get: (group) ->
        if @cache[group]
            return @cache[group]
        return []

    add_to_group: (msg, user, group) ->
        console.log 'adding ' + user + ' to group ' + group
        if not @cache[group]:
            @cache[group] = []
        @cache[group].push user
        @robot.brain.data.groups = @cache

    remove_from_group: (msg, user, group) ->
        console.log 'removing ' + user + ' from group ' + group
        if not @cache[group]:
            msg.send "This group doesn't exist!"
            return
        index_of_user = @cache[group].indexOf(user)
        if not index_of_user:
            msg.send "The user " + user + " is not in group: " + group
            return
        
        @cache[group].splice(index_of_user, 1)
        robot.brain.data.groups = @cache

rollcall = null
# structure (when not null):
# users:     ARRAY of users in the group; requests that still need a response:
#         user:         string;                    username of pushee
#         watchers: ARRAY of string; usernames of watchers

cleanup_rollcall = ->
    return unless rollcall
    clearTimeout rollcall.timeout
    clearInterval rollcall.interval
    rollcall = null

get_responders_string = (requests) ->
    return null unless requests.length
    users = (request.user for request in requests).unique()
    response = "#{users.join(' ')}"
    return response
    return unless rollcall

remove_user = (requests, user) ->
    idx = 0
    while idx < requests.length
        if requests[idx].user is user or user in requests[idx].watchers
            requests.splice idx, 1
        else
            idx++

readyhandler = (user, msg) ->
    return unless rollcall
    remove_user rollcall.requests, user.toLowerCase()
    if rollcall.requests.length is 0
        msg.send "That's it! We're all ready to go!"
        cleanup_rollcall()
        return

module.exports = (robot) ->
    rollcalls = new Rollcalls robot

    robot.respond /group (.*)$/i, (msg) ->
        users = rollcalls.get(group)
        verbiage = ["Users"]
        for user, index in users
            verbiage.push "#{index + 1}. #{user}"
        msg.send verbiage.join("\n")

    robot.respond /add (.*) to (.*)$/i, (msg) ->
        user = msg.match[1]
        group = msg.match[2]
        rollcalls.add_to_group(msg, user, group)

    
    # robot.respond /rollcall (\d+)/i, (msg) ->
    #     group = msg.match[1]
        
    #     accepted_requests = data[1].all
    #     requests = []
    #     for request in accepted_requests
    #         user = request.user.toLowerCase()
    #         requests.push {user: user}
    #     remove_user requests, pushmaster
    #     remove_user requests, msg.message.user.name.toLowerCase()
    #     if requests.length is 0
    #         msg.send "#{pushmaster}: no users to rollcall!"
    #         return
    #     msg.send "Rollcall starting for #{stdout}"
    #     msg.send get_responders_string(requests)
    #     msg.send "note: you can say 'username is ready' to mark someone else ready"
    #     intervalCallback = ->
    #         return unless rollcall
    #         msg.send "Still waiting on: #{get_responders_string(rollcall.requests)}."
    #     interval = setInterval(intervalCallback, 100 * 1000)
    #     cancelCallback = ->
    #         return unless rollcall
    #         msg.send "#{pushmaster}: Stopping rollcall after 6 minutes and no response from #{get_responders_string(rollcall.requests)}."
    #         cleanup_rollcall()
    #     timeout = setTimeout(cancelCallback, 6 * 60 * 1000)
    #     cleanup_rollcall()
    #     rollcall = {requests: requests, pushmaster: pushmaster, timeout: timeout, interval: interval}

    # stop_rollcall = (msg) ->
    #     unless rollcall
    #         msg.send "We aren't doing a rollcall right now!"
    #         return
    #     cleanup_rollcall()
    #     msg.send "Ok, aborting this rollcall"

    # robot.respond /stop rollcall/i, stop_rollcall
    # robot.respond /rollcall stop/i, stop_rollcall

    # robot.hear /./i, (msg) ->
    #     user = msg.message.user.name.replace(/[^A-Za-z]*([A-Za-z]+).*/g, '$1')
    #     readyhandler user, msg

    # robot.hear /^([A-Za-z]+) is ready$/i, (msg) ->
    #     user = msg.match[1]
    #     readyhandler user, msg

    # robot.respond /rollcall status/i, (msg) ->
    #     unless rollcall
    #         msg.send "We aren't doing a rollcall right now!"
    #         return
    #     msg.send "Waiting on #{get_responders_string(rollcall.requests)}"