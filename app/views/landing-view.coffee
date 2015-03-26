class window.LandingView extends Backbone.View
  template: JST['landing']

  render: =>
    @$el.html @template()
