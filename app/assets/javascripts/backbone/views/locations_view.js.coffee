class Zambia.Views.LocationsView extends Backbone.View
  template: JST["backbone/templates/locations"]

  render: ->
    $(this.el).html(@template())
    @

