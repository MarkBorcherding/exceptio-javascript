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

url = ->
  "except.io/applications/#{application}/errors"

script = exceptioScriptTag()

apiKey = script.getAttribute 'data-api-key'
application = script.getAttribute 'data-application'
debug = /true/.test script.getAttribute 'data-debug'

window.ExceptIO =
  log: (exception, environment = "production", params = {}, session = {}, request_url = window.location.href) ->
    xhr = httpRequest()
    xhr.open 'POST', url
    xhr.setRequestHeader 'Content-Type', 'application/x-www-form-urlencoded'
    xhr.send encode
      error:
        message: exception # exception.message
        backtrace: '' # exception.backtrac
        type: '' # exception.class.name
        environment: environment
        params: params
        session: session
        request_url: request_url
