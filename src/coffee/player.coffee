define (require) ->

  anglable = require "anglable"
  appConfig = require "config"

  radius = appConfig.width / 2
  angle = -90

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
      max: 3
    health:
      min: 1
      max: 3


  getAngle = () ->
    angle = angle + 45



  class Player

    speed: 2

    shouldUpdate: true

    constructor: () ->
      @id     = _.uniqueId "player-"
      @health = config.health.max
      @lives  = config.lives.max
      @angle  = getAngle()
      @isRotting = false
      @rotationDirection = 0
      @createElement().update()
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
      x1 = @getChordOffset()
      x2 = config.svg.width - x1
      y  = 25
      "M #{x1} #{y} A 265 265 0 0 0 #{x2} #{y}"

    update: () ->
      return unless @shouldUpdate
      @el.dataset.health = @health
      @el.dataset.lives = @lives
      @el.style.webkitTransform = "rotate(#{@angle}deg)"
      @arc.setAttribute "d", @calculatePath()
      @setAngle @rotationDirection * @speed
      @

    move: (dir) ->
      @rotationDirection = dir
      @

    setAngle: (offset) ->
      @angle += offset
      @

    getChordOffset: () ->
      (config.lives.max - @lives + 1) * 25

    # @TODO: This isn't accurate at all. Somehow need to calculate
    # the overall angle a paddle covers from one end to another,
    # but my math skills are too abysmal to do so...
    getAngleRange: () ->
      angle = @getNormalizedAngle()
      halfChord = @getChordOffset()
      range = halfChord
      { min: angle - range, max: angle + range }

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
      @el.classList.add "exiting"
      setTimeout (() => @remove()), 5000
      @

    remove: () ->
      @el.remove()
      @

    appended: () ->
      @el.classList.remove "entering"
      @


  _.extend Player::, anglable

  Player
