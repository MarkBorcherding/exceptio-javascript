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
    "error[#{encodeURIComponent prop}]=#{encodeURIComponent obj[prop]}"
  values.join "&"

url = (application, appKey) ->
  "http://except.io/applications/#{application}/errors?app_key=#{appKey}"

ExceptIO =
  appKey: ""
  application: ""
  debug: false
  environment: 'production'
  configure: (@appKey, @application, @debug = false, @environment = 'production') ->
  log: (error, file = error.file, line = error.line) ->
    request_url = window.location.href
    message = error?.message or error
    type = error?.constructor?.name
    type = '' if type == 'String' # Just ignore this type

    backtrace = if error.stack?
                  error.stack
                else
                  if file? or line?
                    "#{file}:#{line}"
                  else
                    'No Backtrace'

    body = encode
        message: message
        backtrace: backtrace
        type: type
        environment: @environment
        request_url: request_url

    if @debug
      console.log url(@application, @appKey), body
    else
      console.log 'logging error', error, body
      xhr = httpRequest()
      xhr.open 'POST', url(@application, @appKey)
      xhr.setRequestHeader 'Content-Type', 'application/x-www-form-urlencoded'
      xhr.send body


if script = exceptioScriptTag()
  ExceptIO.configure script.getAttribute('data-app-key'),
                     script.getAttribute('data-application'),
                     /true/.test(script.getAttribute('data-debug'))

window.onerror = (message, file, line) ->
  ExceptIO.log message, file, line

window.ExceptIO = ExceptIO
