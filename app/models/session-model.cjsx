class window.SessionModel extends Backbone.Model
  url: "#{Config.API_HOST}/sessions"
  isNew: => false
