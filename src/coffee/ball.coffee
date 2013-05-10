define (require) ->

  config = require "config"
  anglable = require "anglable"

  cx = config.width / 2
  cy = cx
  radius  = cx
  boundDistance = radius # + 50


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
      @setRandomVector().calculateAngle()
      @oldLastPlayerToHit = @lastPlayerToHit
      @lastPlayerToHit = null
      @wasJustReset = true
      @

    setRandomVector: () ->
      @vx = @randomSpeed() * @randomVector()
      @vy = @randomSpeed() * @randomVector()
      @

    randomSpeed: () ->
      _.random(@minSpeed, @maxSpeed)

    randomVector: () ->
      if Math.random() > .5 then 1 else -1

    calculateAngle: () ->
      rad = Math.atan2 @vy, @vx
      deg = @r2d rad
      @angle = deg - 90
      console.log( "ball:", @getNormalizedAngle() );

    update: (players) ->
      if @isOutOfBounds()
        @reset()
        return
      collided = @checkForCollisions(players)
      @bounce() if collided
      @x += @vx
      @y += @vy
      @el.style.left = @x
      @el.style.top = @y
      @wasJustReset = false
      @

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

    bounce: () ->
      @vx *= -1
      @vy *= -1
      @calculateAngle()



  _.extend Ball::, anglable

  Ball
