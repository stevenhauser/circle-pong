define (require) ->

  angle = -90

  config =
    svg:
      width:  300
      height: 200
      ns: "http://www.w3.org/2000/svg"
    path:
      padding: 10
      radius:  265


  getAngle = () ->
    angle = angle + 45



  class Player

    speed: 2

    constructor: () ->
      @id     = _.uniqueId "player-"
      @health = 3
      @lives  = 3
      @angle  = getAngle()
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
      x1 = @lives * 5
      x2 = config.svg.width - @lives * 5
      y  = 10
      "M #{x1} #{y} A 265 265 0 0 0 #{x2} #{y}"

    update: () ->
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

    appended: () ->
