root = exports ? this
root.messenger = null

class @Generator

  this.work = ->
    ws_path = $("*[data-ws]").data('ws')
    ws = new WebSocket("ws://#{location.host}#{ws_path}");

    ws.onopen = (msg) ->
      ws.send 'wait'

    ws.onmessage = (msg) ->
      console.log 'Websocket message'
      data = JSON.parse(msg.data)
      Generator.renderSignature(data['url']) if data['url']?

    ws.onerror = (msg) ->
      console.error "Unable to connect to websocket: #{msg}"

  this.renderSignature = (url) ->
    console.log url

    root.messenger.update
      message: 'La firma ha sido generada correctamente'
      type: 'success'
      showCloseButton: true

    $("#generated").removeClass("hidden")

    img = $('<img />', {'src' : url})
    $("#generated-signature .image").html img
    $("#generated-signature .link .url").html url


$(document).ready ->

  # Signature generator form handler
  $(document).on 'ajax:beforeSend', ".signature-generator form", (e, xhr, settings) ->
    $(".section-wrapper").addClass("hidden")
    root.messenger = Messenger().post
      message: 'La firma está siendo generada'
      type: 'info'
      hideAfter: 5
      singleton: true

  $(document).on 'ajax:success', ".signature-generator form", (e, data, status, xhr) ->
    console.log 'Signature generated'
    Generator.work()

  $(document).on 'ajax:error', ".signature-generator form", (e) ->
    console.error 'Signature generator failed'

    root.messenger.update
      message: 'Ha ocurrido algún error generando la firma'
      type: 'error'
      showCloseButton: true