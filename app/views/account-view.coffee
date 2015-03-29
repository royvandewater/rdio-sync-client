class window.AccountView extends Backbone.View
  template: JST['account']

  initialize: ->
    @listenTo @model, 'change request sync', @render

  events:
    'submit form': 'submit'
    'click .sync': 'sync'

  context: =>
    model: @model.toJSON()

  render: =>
    context = @context()
    @$el.html @template context
    @$('[name="number-of-tracks"]').val context.model.number_of_tracks_to_sync
    @$('[name="sync-type"]').val context.model.sync_type
    @$('[name="auto-sync"]').prop checked: context.model.auto_sync
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
