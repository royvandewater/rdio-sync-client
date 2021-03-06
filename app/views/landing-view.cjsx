class window.LandingView extends Backbone.View
  context: =>
    loginUrl: Config.LOGIN_URL

  render: =>
    React.render <LandingPage/>, @el
    @$el.html()

LandingPage = React.createClass render: ->
  <div>
    <div className="jumbotron">
      <h1>Auto sync your best Rdio music!</h1>
      <p className="lead">Reduce mobile data usage and ensure you're never caught without good music again.</p>
      <a href={Config.LOGIN_URL} className="btn btn-large btn-primary">Login with Rdio</a>
    </div>

    <hr />

    <div className="row marketing">
      <div className="col-xs-12 col-sm-6">
        <h4>Automatically Sync</h4>
        <p>Sink will detect your top played songs and automatically mark them for 'sync to mobile'</p>

        <h4>Choose Your Level of Syncitude</h4>
        <p>Once logged in, your account manage page will let you configure how many songs will auto sync to your account</p>

        <h4>The Magic Begins at Midnight</h4>
        <p>You can sync manually at any time, but the real magic is the automatic one that occurs every night at midnight</p>
      </div>

      <div className="col-xs-12 col-sm-6">
        <h4>Reduce Your Mobile Data Usage</h4>
        <p>Take a look at your mobile data usage. Most of it's Rdio, and most of it is from streaming the same few songs over and over again. Why not cache them on your phone?</p>

        <h4>Don't Be Without Good Music</h4>
        <p>Life's to short to spend it in silence. Let Sink manage which songs sync and you'll be sure to have kick ass tunes, even in the middle of nowhere</p>
      </div>
    </div>
  </div>
