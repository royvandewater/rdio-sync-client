class Router extends Backbone.Router
  routes:
    '': 'landing'
    'account': 'account'
    'logout': 'logout'

  landing: =>
    AccountModel.checkAuth (loggedIn) =>
      return @navigate '/account', trigger: true if loggedIn

      view = new LandingView
      $('#main-container').html view.render()
      $('li.logout').hide()

  account: =>
    AccountModel.checkAuth (loggedIn) =>
      return @navigate '/', trigger: true unless loggedIn

      account = new AccountModel
      view = new AccountView model: account
      $('#main-container').html view.render()
      $('li.logout').show()

      account.fetch()

  logout: =>
    session = new SessionModel
    session.once 'destroy', => @navigate '/', trigger: true
    session.destroy wait: true

new Router
Backbone.history.start pushState: true
