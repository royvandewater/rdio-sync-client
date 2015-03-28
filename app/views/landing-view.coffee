class window.LandingView extends Backbone.View
  template: JST['landing']

  context: =>
    loginUrl: Config.LOGIN_URL

  render: =>
    @$el.html @template @context()
