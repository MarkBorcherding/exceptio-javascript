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

parseError = (error, file, line) ->
  type = error?.constructor?.name
  return [type, error.message, error.stack ] unless type == 'String'

  [type, error, backtrace] = ['', error, 'No Backtrace']

  backtrace = "#{file}:#{line}" if file? or line?

  if matches = /^Uncaught ([^:]+):(.*)$/.exec error
    [type, error] = matches[1..2]

  [type, error, backtrace]


ExceptIO =
  appKey: ""
  application: ""
  debug: false
  environment: 'production'
  configure: (@appKey, @application, @debug = false, @environment = 'production') ->
  log: (error, file = error.file, line = error.line) ->
    request_url = window.location.href

    [type, message, backtrace ] = parseError error, file, line

    body = encode
        message: message
        backtrace: backtrace
        type: type
        environment: @environment
        request_url: request_url

    if @debug
      console.log url(@application, @appKey), body
    else
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
