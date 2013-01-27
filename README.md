# exceptio-javascript

A JavaScript client for [Except.io](http://except.io)


## Status

Very very pre-alpha. Pretty much just ignore for now.

## Install

```html
<script src="exceptio.js"
  data-app-key='e6ce3360b2533165'
  data-application='markborcherding-angular-seed'
  data-environment='development'></script>
```

```javascript
ExceptIO.log('testing raw call');

try {
  caught_in_a_catch_block();
} catch (e) {
  console.log(e.stack);
  ExceptIO.log(e);
}

caught_by_window_onerror();
```

## License

The MIT License (MIT)
Copyright (c) 2013 Mark Borcherding

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
