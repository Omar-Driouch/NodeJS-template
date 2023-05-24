Liquid = require "../../liquid"

module.exports = class Assign extends Liquid.Tag
  SyntaxHelp = "Syntax Error in 'assign' - Valid syntax: assign [var] = [source]"
  Syntax = ///
      ((?:#{Liquid.VariableSignature.source})+)
      \s*=\s*
      (.*)\s*
    ///

  constructor: (template, tagName, markup) ->
    if match = Syntax.exec(markup)
      @to = match[1]
      @from = new Liquid.Variable match[2]
    else
      throw new Liquid.SyntaxError(SyntaxHelp)

    super

  render: (context) ->
    context.lastScope()[@to] = @from.render(context)
    super context
