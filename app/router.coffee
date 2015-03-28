class Router extends Backbone.Router
  routes:
    '': 'landing'
    'account': 'account'

  landing: =>

    view = new LandingView
    $('#main-container').html view.render()

  account: =>
    account = new AccountModel
    account.fetch
    $('#main-container').html '<h1>Logged in</h1>'

router = new Router

AccountModel.checkAuth (loggedIn) =>
  Backbone.history.start pushState: true
  route = if loggedIn then '/account' else '/'
  router.navigate route, trigger: true
