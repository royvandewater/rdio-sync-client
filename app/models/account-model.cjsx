class window.AccountModel extends Backbone.Model
  url: "#{Config.API_HOST}/api/v1/account"

  initialize: =>
    @on 'request', => @loading = true
    @on 'sync',    => @loading = false

  @checkAuth: (callback=->)=>
    account = new AccountModel
    account.fetch
      success: => callback true
      error: => callback false
