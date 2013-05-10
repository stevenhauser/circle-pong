define (require) ->

  config = require "config"
  anglable = require "anglable"
  settable = require "settable"

  cx = config.width / 2
  cy = cx
  radius  = cx
  boundDistance = radius # + 50

  ballTimeout = 500


  class Ball

    minSpeed: 6

    maxSpeed: 20

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
      @vx = 0
      @vy = 0
      setTimeout () =>
        @setRandomVector().calculateAngle()
        @oldLastPlayerToHit = @lastPlayerToHit
        @lastPlayerToHit = null
        @wasJustReset = true
      , ballTimeout
      @

    setRandomVector: () ->
      @vx = @randomSpeed() * @randomVector()
      @vy = @randomSpeed() * @randomVector()
      @

    randomSpeed: () ->
      _.random(@minSpeed, @maxSpeed) / 10

    randomVector: () ->
      if Math.random() > .5 then 1 else -1

    calculateAngle: () ->
      rad = Math.atan2 @vy, @vx
      deg = @r2d rad
      @angle = deg - 90

    update: (players) ->
      if @isOutOfBounds()
        @reset()
        return
      collided = @checkForCollisions(players)
      @bounce() if collided
      @x += @vx
      @y += @vy
      @updateElement()
      @wasJustReset = false
      @

    updateElement: () ->
      @el.style.left = @x
      @el.style.top = @y
      @

    toJSON: () ->
      _.pick(@, "x", "y", "vx", "vy", "angle")

    checkForCollisions: (players) ->
      return unless @isOnBound()
      for player in players
        sweep = player.getAngleRange()
        ballAngle = @getNormalizedAngle()
        playerAngle = player.getNormalizedAngle()
        isInRange = sweep.min < ballAngle < sweep.max
        if isInRange
          @lastPlayerToHit = player
          return true

    isOnBound: () ->
      (radius - 5) < @distanceFromCenter()

    isOutOfBounds: () ->
      @distanceFromCenter() > boundDistance

    distanceFromCenter: () ->
      @distanceFrom x: cx, y: cy

    distanceFrom: (point) ->
      dx = Math.abs point.x - @x
      dy = Math.abs point.y - @y
      Math.sqrt dx * dx + dy * dy

    accelerate: () ->
      @vx *= @acceleration
      @vy *= @acceleration
      @

    bounce: () ->
      @vx *= -1
      @vy *= -1
      @accelerate().calculateAngle()
      @



  _.extend Ball::, anglable, settable

  Ball
