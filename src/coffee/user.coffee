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

    # Event handlers

    onKeydown: (e) =>
      @move KEYS[e.which] if e.which of KEYS

    onKeyup: (e) =>
      @move 0 if e.which of KEYS
