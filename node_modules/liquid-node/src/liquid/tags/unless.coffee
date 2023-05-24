Liquid = require "../../liquid"

module.exports = class Unless extends Liquid.If

  # Unless is a conditional just like 'if' but works on the inverse logic.
  #
  #   {% unless x < 0 %} x is greater than zero {% end %}
  #
  parse: ->
    super.then =>
      @blocks[0].negate = true
