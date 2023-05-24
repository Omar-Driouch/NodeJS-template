Liquid = require "../liquid"

module.exports = class Liquid.Engine

  constructor: () ->
    @tags = {}
    @Strainer = (@context) ->
    @registerFilters Liquid.StandardFilters

    @fileSystem = new Liquid.BlankFileSystem

    isSubclassOf = (klass, ofKlass) ->
      unless typeof klass is 'function'
        false
      else if klass == ofKlass
        true
      else
        isSubclassOf klass.__super__?.constructor, ofKlass

    for own tagName, tag of Liquid
      continue unless isSubclassOf(tag, Liquid.Tag)
      isBlockOrTagBaseClass = [Liquid.Tag,
                               Liquid.Block].indexOf(tag.constructor) >= 0
      @registerTag tagName.toLowerCase(), tag unless isBlockOrTagBaseClass

  registerTag: (name, tag) ->
    @tags[name] = tag

  registerFilters: (filters...) ->
    filters.forEach (filter) =>
      for own k, v of filter
        @Strainer::[k] = v if v instanceof Function

  parse: (source) ->
    template = new Liquid.Template
    template.parse @, source

  parseAndRender: (source, args...) ->
    @parse(source).then (template) ->
      template.render(args...)

  registerFileSystem: (fileSystem) ->
    throw Liquid.ArgumentError "Must be subclass of Liquid.BlankFileSystem" unless fileSystem instanceof Liquid.BlankFileSystem
    @fileSystem = fileSystem
