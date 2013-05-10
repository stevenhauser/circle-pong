define (require) ->

  getNormalizedAngle: (angle = @angle) ->
    baseAngle = angle % 360
    if baseAngle < 0 then baseAngle + 360 else baseAngle

  r2d: (rad) ->
    rad * (180 / Math.PI)

  d2r: (deg) ->
    deg * (Math.PI / 180)
