define (require) ->

  config = require "config"

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
      @

    randomSpeed: () ->
      _.random(@minSpeed, @maxSpeed)

    randomVector: () ->
      if Math.random() > .5 then 1 else -1

    calculateAngle: () ->
      rad = Math.atan2 @vy, @vx
      deg = r2d rad
      deg - 90

    update: () ->
      @reset() if @isOutOfBounds()
      @x += @vx
      @y += @vy
      @el.style.left = @x
      @el.style.top = @y
      @

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
