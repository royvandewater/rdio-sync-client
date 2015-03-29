class window.AccountView extends Backbone.View
  initialize: ->
    @listenTo @model, 'change request sync', @render

  events:
    'submit form': 'submit'
    'click .sync': 'sync'

  render: =>
    model = @model.toJSON()
    React.render <AccountForm model=model />, @el
    @$('[name="number-of-tracks"]').val model.number_of_tracks_to_sync
    @$('[name="sync-type"]').val model.sync_type
    @$('[name="auto-sync"]').prop checked: model.auto_sync
    @$('.loading-spinner').toggle @model.loading
    @$el

  submit: ($event) =>
    $event.preventDefault()
    $event.stopPropagation()
    @model.save _.extend(sync_now: false, @values())

  sync: ($event) =>
    $event.preventDefault()
    $event.stopPropagation()
    @model.save _.extend(sync_now: true, @values())

  values: =>
    number_of_tracks_to_sync: @$('[name="number-of-tracks"]').val()
    sync_type: @$('[name="sync-type"]').val()
    auto_sync: @$('[name="auto-sync"]').prop('checked')

AccountForm = React.createClass render: ->
  <div>
    <h3>Sync Settings</h3>

    <p>Manage what syncs to account: <strong>{@props.model?.username}</strong></p>

    <hr />

    <form className="form-horizontal">
      <div className="form-group">
        <label className="control-label col-md-2" htmlFor="number-of-tracks-<%= @props.model.id %>">Number of tracks:</label>
        <div className="col-md-10">
          <input type="number" name="number-of-tracks" id="number-of-tracks-<%= @props.model.id %>" className="form-control" />
        </div>
      </div>

      <div className="form-group">
        <label className="control-label col-md-2" htmlFor="sync-type-<%= @props.model.id %>">Sync your:</label>
        <div className="col-md-10">
          <select name="sync-type" id="sync-type-<%= @props.model.id %>" className="form-control">
            <option value="playCount">Most played tracks</option>
            <option value="dateAdded">Most recently added tracks</option>
            <option value="both">Half and Half</option>
          </select>
        </div>
      </div>

      <div className="form-group">
        <div className="col-md-offset-2 col-md-10">
          <label className="checkbox">
            <input name="auto-sync" type="checkbox" className="auto-sync" />Auto Sync
            <br />
            <span className="label label-danger">Read Warning Below</span>
          </label>
        </div>
      </div>

      <div className="form-group">
        <div className="col-md-offset-2 col-md-10">
          <button type="submit" className="btn btn-primary">Save</button>
          &nbsp;
          <button type="button" className="sync btn btn-danger">Sync</button>
          &nbsp;
          <span>
            <i className="fa fa-refresh fa-spin loading-spinner"></i>
          </span>
        </div>
      </div>
    </form>

    <div className="alert alert-danger">
      <h4>Important!</h4>
      Pressing sync will wipe out all tracks currently marked for offline use and replace them
      with your most played tracks, limited by the number of tracks you indicated. There is no way
      to undo this action.
      <br/><br/>
      Auto Sync means that Sink will perform this action every night at midnight.
    </div>
  </div>
