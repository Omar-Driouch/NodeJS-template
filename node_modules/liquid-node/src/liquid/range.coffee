module.exports = class Range
  constructor: (@start, @end, @step = 0) ->
    if @step is 0
      if @end < @start
        @step = -1
      else
        @step = 1

    Object.seal @

  some: (f) ->
    current = @start
    end = @end
    step = @step

    if step > 0
      while current < end
        return true if f current
        current += step
    else
      while current > end
        return true if f current
        current += step

    false

  forEach: (f) ->
    @some (e) ->
      f e
      false

  toArray: ->
    array = []
    @forEach (e) ->
      array.push e
    array

Object.defineProperty Range::, "length",
  get: ->
    Math.floor((@end - @start) / @step)
