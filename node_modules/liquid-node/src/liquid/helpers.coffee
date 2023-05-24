module.exports =
  flatten: (array) ->
    output = []

    _flatten = (array) ->
      array.forEach (item) ->
        if Array.isArray item
          _flatten item
        else
          output.push item

    _flatten array
    output

  toFlatString: (array) ->
    @flatten(array).join("")

  scan: (string, regexp, globalMatch = false) ->
    result = []

    _scan = (s) ->
      match = regexp.exec(s)

      if match
        if match.length == 1
          result.push match[0]
        else
          result.push match[1..]

        l = match[0].length
        l = 1 if globalMatch

        if match.index + l < s.length
          _scan(s.substring(match.index + l))

    _scan(string)
    result
