define (require) ->

  Player = require "player"

  KEYS =
    37:  1 # left, clockwise
    39: -1 # right, anticlockwise


  class User extends Player

    appended: () ->
      @bindKeyboardEvents()
      @

    bindKeyboardEvents: () ->
      document.addEventListener "keydown", (e) =>
        @move KEYS[e.which] if e.which of KEYS
      document.addEventListener "keyup", (e) =>
        @move 0 if e.which of KEYS
      @
