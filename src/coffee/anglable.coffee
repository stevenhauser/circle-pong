define (require) ->

  getNormalizedAngle: (angle = @angle) ->
    baseAngle = angle % 360
    if baseAngle < 0 then baseAngle + 360 else baseAngle
