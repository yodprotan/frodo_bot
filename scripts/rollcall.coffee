# # Description:
# #     Allow frodo to check if people are ready for league or whatever
# # Commands:
# #     frodo group <group>
# #     frodo add <user> to <group>
# #     frodo remove <user> from <group>
# #     frodo remove group <group>
# #     frodo rollcall <group> for <number>
# #     frodo stop rollcall

# class Rollcalls
#     constructor: (@robot) ->
#         @cache = {}
#         @current_timeout = null

#         @robot.brain.on 'loaded', =>
#             if @robot.brain.data.groups
#                 @cache = @robot.brain.data.groups

#     add: (group) ->
#         console.log 'adding group: ' + group
#         @cache[group] = []
#         @robot.brain.data.groups = @cache

#     remove_group: (group) ->
#         console.log 'removing group: ' + group
#         delete @cache[group]; 
#         @robot.brain.data.groups = @cache

#     get: (group) ->
#         if @cache[group]
#             return @cache[group]
#         return []

#     add_to_group: (msg, user, group) ->
        
#         if not @cache[group]
#             @cache[group] = []
#         index_of_user = @cache[group].indexOf(user)

#         if index_of_user >=0
#             msg.send "User is already in group!"
#             return
#         @cache[group].push user
#         @robot.brain.data.groups = @cache
#         msg.send 'adding ' + user + ' to group ' + group

#     remove_from_group: (msg, user, group) ->
#         if not @cache[group]
#             msg.send "This group doesn't exist!"
#             return
#         index_of_user = @cache[group].indexOf(user)
#         if index_of_user < 0
#             msg.send "The user " + user + " is not in group: " + group
#             return
        
#         @cache[group].splice(index_of_user, 1)
#         @robot.brain.data.groups = @cache
#         msg.send 'removing ' + user + ' from group ' + group

# rollcall = null
# # structure (when not null):
# # users:     ARRAY of users in the group; requests that still need a response:
# #         user:         string;                    username of pushee
# #         watchers: ARRAY of string; usernames of watchers

# cleanup_rollcall = ->
#     return unless rollcall
#     clearTimeout rollcall.timeout
#     clearInterval rollcall.interval
#     rollcall = null

# get_responders_string = (users) ->
#     return null unless users.length
#     requests = []
#     for user in users
#         requests.push user
#     response = requests.join(' ')

#     return response
#     return unless rollcall

# remove_user = (requests, user) ->
#     idx = 0
    
#     while idx < requests.length
#         console.log "looking at request " + requests[idx] + " to remove user " + user

#         if requests[idx] is user
#             requests.splice idx, 1
#             console.log 'marking user as ready: ' + user
#             return true
#         else
#             idx++
    
#     return false

# readyhandler = (user, msg) ->
#     return unless rollcall
#     succ = remove_user rollcall.requests, user
#     if succ
#         rollcall.numberLeft--

#     if rollcall.requests.length is 0 or rollcall.numberLeft is 0
#         msg.send "That's it! We're all ready to go!"
#         cleanup_rollcall()
#         return

# module.exports = (robot) ->
#     rollcalls = new Rollcalls robot

#     robot.respond /group (.*)$/i, (msg) ->
#         group = msg.match[1]
#         users = rollcalls.get(group)

#         if users.length < 1
#             msg.send "This group is empty!"
#             return
#         verbiage = ["Users"]
#         for user, index in users
#             verbiage.push "#{index + 1}. #{user}"
#         msg.send verbiage.join("\n")

#     robot.respond /add (.*) to (.*)$/i, (msg) ->
#         user = msg.match[1]
#         group = msg.match[2]
#         rollcalls.add_to_group(msg, user, group)


#     robot.respond /remove (.*) from (.*)$/i, (msg) ->
#         user = msg.match[1]
#         group = msg.match[2]
#         rollcalls.remove_from_group(msg, user, group)

#     robot.respond /remove group (.*)$/i, (msg) ->
#         group = msg.match[1]
#         rollcalls.remove_group(group)
    
#     robot.respond /rollcall (.*) for (.*)/i, (msg) ->
#         group = msg.match[1]
#         number = msg.match[2]
#         users = rollcalls.get(group)

#         if isNaN(parseFloat(number)) or number<1
#             msg.send "Please enter a valid number"
#             return
#         else if number>users.length
#             msg.send "Not enough people in group!"
#             return

        
#         requests = []
#         for user in users
#             requests.push user

#         if requests.length is 0
#             msg.send "No users to rollcall!"
#             return
#         msg.send "Rollcall starting for group " + group +  " for " + number
#         msg.send get_responders_string(requests)
#         msg.send "note: you can say 'username is ready' to mark someone else ready"
#         intervalCallback = ->
#             return unless rollcall
#             msg.send "Still waiting on: #{get_responders_string(rollcall.requests)}."
#         interval = setInterval(intervalCallback, 100 * 1000)
#         cancelCallback = ->
#             return unless rollcall
#             msg.send "#{pushmaster}: Stopping rollcall after 6 minutes and no response from #{get_responders_string(rollcall.requests)}."
#             cleanup_rollcall()
#         timeout = setTimeout(cancelCallback, 6 * 60 * 1000)
#         cleanup_rollcall()
#         rollcall = {requests: requests, numberLeft: number, timeout: timeout, interval: interval}

#     stop_rollcall = (msg) ->
#         unless rollcall
#             msg.send "We aren't doing a rollcall right now!"
#             return
#         cleanup_rollcall()
#         msg.send "Ok, aborting this rollcall"

#     robot.respond /stop rollcall/i, stop_rollcall
#     robot.respond /rollcall stop/i, stop_rollcall

#     robot.hear /^(.*) is ready$/i, (msg) ->
#         user = msg.match[1]
#         readyhandler user, msg

#     robot.hear /./i, (msg) ->
#         user = "@" + msg.message.user.name
#         readyhandler user, msg



#     robot.respond /rollcall status/i, (msg) ->
#         unless rollcall
#             msg.send "We aren't doing a rollcall right now!"
#             return
#         msg.send "Waiting on #{get_responders_string(rollcall.requests)}"