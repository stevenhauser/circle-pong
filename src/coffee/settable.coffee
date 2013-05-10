define (require) ->

  set: (props) ->
    @[prop] = val for own prop, val of props
    @
