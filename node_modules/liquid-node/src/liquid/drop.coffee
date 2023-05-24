# A drop in liquid is a class which allows you to to export DOM
# like things to liquid.
# Methods of drops are callable.
# The main use for liquid drops is the implement lazy loaded objects.
# If you would like to make data available to the web designers
# which you don't want loaded unless needed then a drop is a great
# way to do that
#
# Example:
#
#   ProductDrop = Liquid.Drop.extend
#     topSales: ->
#       Shop.current.products.all order: 'sales', limit: 10
#
#   tmpl = Liquid.Template.parse """
#     {% for product in product.top_sales %}
#       {{ product.name }}
#     {%endfor%}
#     """
#
#   tmpl.render(product: new ProductDrop) # will invoke topSales query.
#
# Your drop can either implement the methods sans any parameters or implement the
# before_method(name) method which is a
# catch all
module.exports = class Drop

  context: null

  hasKey: (key) ->
    true

  invokeDrop: (methodOrKey) ->
    if @constructor.isInvokable methodOrKey
      value = @[methodOrKey]

      if typeof value is "function"
        value.call @
      else
        value
    else
      @beforeMethod methodOrKey

  beforeMethod: (method) ->

  @isInvokable: (method) ->
    @invokableMethods ?= do =>
      blacklist = Object.keys(Drop::)
      whitelist = ["toLiquid"]

      Object.keys(@::).forEach (k) ->
        whitelist.push k unless blacklist.indexOf(k) >= 0

      whitelist

    @invokableMethods.indexOf(method) >= 0

  get: (methodOrKey) ->
    @invokeDrop methodOrKey

  toLiquid: ->
    @

  toString: ->
    "[Liquid.Drop #{@constructor.name}]"
