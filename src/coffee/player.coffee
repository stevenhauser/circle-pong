define (require) ->

  anglable = require "anglable"
  settable = require "settable"
  appConfig = require "config"

  radius = appConfig.width / 2
  chordOffset = 25

  config =
    svg:
      width:  300
      height: 200
      ns: "http://www.w3.org/2000/svg"
    path:
      padding: 10
      radius:  265
    lives:
      min: 1
      max: 2
    health:
      min: 1
      max: 3


  getRandomAngle = () ->
    _.random 0, 360

  square = (num) ->
    num * num



  class Player

    speed: 3

    shouldUpdate: true

    constructor: (props = {}) ->
      @id     = "player-#{Date.now()}"
      @health = config.health.max
      @lives  = config.lives.max
      @angle  = getRandomAngle()
      @isRotting = false
      @rotationDirection = 0
      @set(props).createElement().update()
      @

    createElement: () ->
      # Create elements
      player = document.createElement "div"
      paddle = document.createElement "div"
      svg    = document.createElementNS config.svg.ns, "svg"
      path   = document.createElementNS config.svg.ns, "path"
      # Configure player element
      player.classList.add "player"
      player.classList.add "entering"
      player.id = @id
      # Configure paddle element
      paddle.classList.add "paddle"
      # Configure svg element
      svg.setAttribute "width", config.svg.width
      svg.setAttribute "height", config.svg.height
      # Configure path element
      path.classList.add "arc"
      path.setAttribute "fill", "none"
      # Set up element relationships
      svg.appendChild path
      paddle.appendChild svg
      player.appendChild paddle
      # Store instance vars
      @el = player
      @arc = path
      @

    calculatePath: () ->
      x1 = @getPathX1()
      x2 = @getPathX2()
      y  = chordOffset
      "M #{x1} #{y} A 265 265 0 0 0 #{x2} #{y}"

    getPathX1: () ->
      @getChordOffset()

    getPathX2: () ->
      config.svg.width - @getPathX1()

    update: () ->
      return unless @shouldUpdate
      @updateElement()
      @setAngle @rotationDirection * @speed
      @

    updateElement: () ->
      @el.dataset.health = @health
      @el.dataset.lives = @lives
      @el.classList.add "exiting" if @isRotting
      @el.style.webkitTransform = "rotate(#{@angle}deg)"
      @arc.setAttribute "d", @calculatePath()
      @

    move: (dir) ->
      @rotationDirection = dir
      @setAngle @rotationDirection * @speed
      @

    setAngle: (offset) ->
      @angle += offset
      @

    getChordOffset: () ->
      (config.lives.max - @lives + 1) * chordOffset

    # This isn't accurate at all. Can be off by around 10 degrees.
    # Probably completely wrong math here.
    getAngleRange: () ->
      angle = @getNormalizedAngle()
      chord = @getPathX2() - @getPathX1()
      # angle of c = acos((a^2 + b^2 - c^2) / (2ab))
      numerator = square(radius) + square(radius) - square(chord)
      denominator = 2 * radius * radius
      sweepAngle = @r2d Math.acos(numerator / denominator)
      halfSweep = sweepAngle / 2
      max = @getNormalizedAngle(angle + halfSweep)
      min = @getNormalizedAngle(angle - halfSweep)
      # Ensure min is less than max
      min -= if min > max then 360 else 0
      { min: min, max: max }

    hurt: () ->
      if @health > config.health.min then @health--
      else @health = config.health.max; @die()
      @

    die: () ->
      @lives--
      @rot() if @lives < config.lives.min
      @

    rot: () ->
      @shouldUpdate = false
      @isRotting = true
      @updateElement()
      setTimeout (() => @remove()), 5000
      @

    remove: () ->
      @el.remove()
      @

    appended: () ->
      @el.classList.remove "entering"
      @

    toJSON: () ->
      _.pick @, "angle", "id", "lives", "health"


  _.extend Player::, anglable, settable

  Player
