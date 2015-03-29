class Router extends Backbone.Router
  routes:
    '': 'landing'
    'account': 'account'

  landing: =>
    view = new LandingView
    $('#main-container').html view.render()

  account: =>
    account = new AccountModel
    view = new AccountView model: account
    $('#main-container').html view.render()

    account.fetch()

router = new Router

AccountModel.checkAuth (loggedIn) =>
  Backbone.history.start pushState: true
  route = if loggedIn then '/account' else '/'
  router.navigate route, trigger: true
