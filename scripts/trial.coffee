module.exports = (robot) ->

  robot.hear /deneme/i, (res) ->
    robot.logger.debug "Received message #{res.message.text}"