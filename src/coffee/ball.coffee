define (require) ->

  config = require "config"
  anglable = require "anglable"

  cx = config.width / 2
  cy = cx
  radius  = cx
  boundDistance = radius + 50

  r2d = (rad) ->
    rad * (180 / Math.PI)


  class Ball

    minSpeed: 1

    maxSpeed: 3

    acceleration: 1.1

    constructor: () ->
      @reset().createElement()
      @

    createElement: () ->
      ball = document.createElement "div"
      ball.classList.add "ball"
      @el = ball
      @

    reset: () ->
      @x = cx
      @y = cy
      @vx = @randomSpeed() * @randomVector()
      @vy = @randomSpeed() * @randomVector()
      @angle = @calculateAngle()
      @oldLastPlayerToHit = @lastPlayerToHit
      @lastPlayerToHit = null
      @wasJustReset = true
      @

    randomSpeed: () ->
      _.random(@minSpeed, @maxSpeed)

    randomVector: () ->
      if Math.random() > .5 then 1 else -1

    calculateAngle: () ->
      rad = Math.atan2 @vy, @vx
      deg = r2d rad
      deg - 90

    update: (players) ->
      if @isOutOfBounds()
        @reset()
        return
      collided = @checkForCollisions(players)
      @vx *= if collided then -1 else 1
      @vy *= if collided then -1 else 1
      @x += @vx
      @y += @vy
      @el.style.left = @x
      @el.style.top = @y
      @wasJustReset = false
      @

    checkForCollisions: (players) ->
      return unless @isOnBound()
      for player in players
        angleRange = player.getAngleRange()
        isInRange = angleRange.min < @getNormalizedAngle() < angleRange.max
        # console.log( player.getNormalizedAngle(), angleRange.min, @getNormalizedAngle(), angleRange.max );
        if isInRange
          @lastPlayerToHit = player
          return true

    isOnBound: () ->
      (radius - 5) < @distanceFromCenter() < (radius + 5)

    isOutOfBounds: () ->
      @distanceFromCenter() > boundDistance

    distanceFromCenter: () ->
      @distanceFrom x: cx, y: cy

    distanceFrom: (point) ->
      dx = Math.abs point.x - @x
      dy = Math.abs point.y - @y
      Math.sqrt dx * dx + dy * dy



  _.extend Ball::, anglable

  Ball
