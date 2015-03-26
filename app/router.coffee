class Router extends Backbone.Router
  routes:
    '': 'landing'

  landing: =>
    view = new LandingView
    $('#main-container').html view.render()

new Router()
Backbone.history.start pushState: true
