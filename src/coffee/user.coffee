define (require) ->

  Player = require "player"

  KEYS =
    37:  1 # left, clockwise
    39: -1 # right, anticlockwise


  class User extends Player

    appended: () ->
      @handleKeyboardEvents true
      super
      @

    createElement: () ->
      super
      @el.classList.add "user"
      @

    handleKeyboardEvents: (bind) ->
      method = if bind then "add" else "remove"
      method += "EventListener"
      document[method] "keydown", @onKeydown
      document[method] "keyup", @onKeyup
      @

    rot: () ->
      @handleKeyboardEvents false
      super
      @

    set: (props) ->
      super _.omit props, "angle"

    # Event handlers

    onKeydown: (e) =>
      @move KEYS[e.which] if e.which of KEYS

    onKeyup: (e) =>
      @move 0 if e.which of KEYS
      # console.log( "user:", @getNormalizedAngle(), @getAngleRange() );
