class window.Config extends EnvironmentConfig
  @LOGIN_URL: "#{@API_HOST}/accounts"

$.ajaxPrefilter (options) ->
  options.xhrFields = {
    withCredentials: true
  }
