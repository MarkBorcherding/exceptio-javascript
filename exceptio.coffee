scripts = ->
  document.getElementsByTagName 'script'

exceptioScriptTag = ->
  (script for script in scripts() when /exceptio.js/.test script.src)[0]

httpRequest = ->
  if window.XMLHttpRequest
     new XMLHttpRequest()
  else if  window.ActiveXObject
     new ActiveXObject "Microsoft.XMLHTTP"

encode = (obj)  ->
  values = for prop of obj
    "#{encodeURIComponent prop}=#{encodeURIComponent obj[prop]}"
  values.join "&"

url = (application, apiKey) ->
  "https://except.io/applications/#{application}/errors?api_key=#{apiKey}"

ExceptIO =
  apiKey: ""
  application: ""
  debug: false
  environment: 'production'
  configure: (@apiKey, @application, @debug = false, @environment = 'production') ->
    console.log 'configuring', arguments
  log: (exception, params = {}, session = {}, request_url = window.location.href) ->
    body = encode
      error:
        message: exception # exception.message
        backtrace: '' # exception.backtrac
        type: '' # exception.class.name
        environment: @environment
        params: params
        session: session
        request_url: request_url
    if @debug
      console.log url(@application), body
    else
      xhr = httpRequest()
      xhr.open 'POST', url(@application, @apiKey)
      xhr.setRequestHeader 'Content-Type', 'application/x-www-form-urlencoded'
      xhr.send body


if script = exceptioScriptTag()
  ExceptIO.configure script.getAttribute('data-api-key'),
                     script.getAttribute('data-application'),
                     /true/.test(script.getAttribute('data-debug'))

window.ExceptIO = ExceptIO
