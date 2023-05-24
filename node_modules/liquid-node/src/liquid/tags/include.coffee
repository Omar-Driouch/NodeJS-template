Liquid = require "../../liquid"


module.exports = class Include extends Liquid.Tag
  Syntax = /([a-z0-9\/\\_-]+)/i
  SyntaxHelp = "Syntax Error in 'include' -
                    Valid syntax: include [templateName]"

  constructor: (template, tagName, markup, tokens) ->
    match = Syntax.exec(markup)
    throw new Liquid.SyntaxError(SyntaxHelp) unless match

    @filepath = match[1]
    @subTemplate = template.engine.fileSystem.readTemplateFile(@filepath)
      .then (src) ->
        template.engine.parse(src)


    super

  render: (context) ->
    @subTemplate.then (i) -> i.render context
