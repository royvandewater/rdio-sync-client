class window.AccountModel extends Backbone.Model
  url: "#{Config.API_HOST}/api/v1/account"

  @checkAuth: (callback=->)=>
    account = new AccountModel
    account.fetch
      success: => callback true
      error: => callback false
