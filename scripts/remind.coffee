# Description:
#   Forgetful? Add reminders.
#
# Commands:
#   remind me to <action> in <time> or
#   remind me in <time> to <action> - Set a reminder in <time> to do an <action>
#   <time> is in the format 1 day, 2 hours, 5 minutes etc
#   Time segments are optional, as are commas

class Reminders
    constructor: (@robot) ->
        @cache = []
        @current_timeout = null

        @robot.brain.on 'loaded', =>
            if @robot.brain.data.reminders
                @cache = @robot.brain.data.reminders
                @queue()

    add: (reminder) ->
        console.log 'doing reminders.add: ' + reminder.action
        @cache.push reminder
        @cache.sort (a, b) -> a.due - b.due
        @robot.brain.data.reminders = @cache
        @queue()

    removeByAttrs: (attrs) ->
        len = @cache.length
        new_cache = []
        for item in @cache
            skip = false
            for k,v of attrs
                if v != item[k]
                    break
                skip = true
            if !skip
                new_cache.push(item)
        @cache = new_cache
        @cache.sort (a, b) -> a.due - b.due
        @robot.brain.data.reminders = @cache
        @queue()
        return len - @cache.length

    removeFirst: ->
        reminder = @cache.shift()
        @robot.brain.data.reminders = @cache
        return reminder

    queue: ->
        clearTimeout @current_timeout if @current_timeout
        if @cache.length > 0
            now = new Date().getTime()
            @removeFirst() until @cache.length is 0 or @cache[0].due > now
            if @cache.length > 0
                trigger = =>
                    reminder = @removeFirst()
                    @robot.messageRoom reminder.room, '@' + reminder.for.name + ', you asked me to remind you to ' + reminder.action
                    @queue()
                @current_timeout = setTimeout trigger, @cache[0].due - now

class Reminder
    constructor: (@for, @time, @action, @room) ->
        @time.replace(/^\s+|\s+$/g, '')

        periods =
            weeks:
                value: 0
                regex: "weeks?"
            days:
                value: 0
                regex: "days?"
            hours:
                value: 0
                regex: "hours?|hrs?|h"
            minutes:
                value: 0
                regex: "minutes?|mins?|m"
            seconds:
                value: 0
                regex: "seconds?|secs?|s"

        for period of periods
            pattern = new RegExp('^.*?([\\d\\.]+)\\s*(?:(?:' + periods[period].regex + ')).*$', 'i')
            matches = pattern.exec(@time)
            periods[period].value = parseInt(matches[1]) if matches

        @due = new Date().getTime()
        @due += (periods.weeks.value * 604800 +
                 periods.days.value * 86400 +
                 periods.hours.value * 3600 +
                 periods.minutes.value * 60 +
                 periods.seconds.value) * 1000

    dueDate: ->
        dueDate = new Date @due
        dueDate.toString()

setupReminder = ({msg, reminders, action, time}) ->
    # Send the user a PM if the reminder originated from a PM
    room = msg.message.user.room || msg.message.user.name
    reminder = new Reminder(msg.message.user, time, action, room)
    reminders.add reminder
    msg.send 'I\'ll remind you to ' + action + ' on ' + reminder.dueDate()

module.exports = (robot) ->
    reminders = new Reminders robot

    robot.respond /remind me to (.*) in ((?:\d+)\s?(?:weeks?|days?|hours?|hrs?|h|minutes?|mins?|m|seconds?|secs?|s))[ ,]*(?:time)?/i, (msg) ->
        setupReminder {msg, reminders, action: msg.match[1], time: msg.match[2]}

    robot.respond /remind me in ((?:(?:\d+)\s?(?:weeks?|days?|hours?|hrs?|h|minutes?|mins?|m|seconds?|secs?|s)[ ,]*(?:and|time)? +)+)to (.*)/i, (msg) ->
        setupReminder {msg, reminders, action: msg.match[2], time: msg.match[1]}

    robot.respond /clear reminder to (.*)/, (msg) ->
        user = msg.message.user.name
        cnt = reminders.removeByAttrs
            action: msg.match[1]
            user: user
            room: msg.message.user.room || user
        msg.send "Cleared reminders: #{cnt}"

    robot.on 'create_reminder', (reminder) ->
        reminder['reminders'] = reminders
        setupReminder reminder

    robot.on 'clear_reminder', (reminder) ->
        reminders.removeByAttrs(reminder)
