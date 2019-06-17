# Duktape bindings for Go(Golang)

[Duktape](http://duktape.org/index.html) is a thin, embeddable javascript engine.
Most of the [api](http://duktape.org/api.html) is implemented.
The exceptions are listed [here](https://github.com/crazytyper/go-duktape/blob/master/api.go#L1566).

This is a fork of https://github.com/olebedev/go-duktape.

It includes duktape v2.3.

It decodes [CESU-8](https://github.com/svaarala/duktape/blob/master/doc/utf8-internal-representation.rst) encoded strings returned by duktape into UTF-8 using https://github.com/crazytyper/go-cesu8.

### Usage

The package is fully go-getable, no need to install any external C libraries.
So, just type `go get github.com/crazytyper/go-duktape` to install.


```go
package main

import "fmt"
import "github.com/crazytyper/go-duktape"

func main() {
  ctx := duktape.New()
  ctx.PevalString(`2 + 3`)
  result := ctx.GetNumber(-1)
  ctx.Pop()
  fmt.Println("result is:", result)
  // To prevent memory leaks, don't forget to clean up after
  // yourself when you're done using a context.
  ctx.DestroyHeap()
}
```

### Go specific notes

Bindings between Go and Javascript contexts are not fully functional.
However, binding a Go function to the Javascript context is available:
```go
package main

import "fmt"
import "github.com/crazytyper/go-duktape"

func main() {
  ctx := duktape.New()
  ctx.PushGlobalGoFunction("log", func(c *duktape.Context) int {
    fmt.Println(c.SafeToString(-1))
    return 0
  })
  ctx.PevalString(`log('Go lang Go!')`)
}
```
then run it.
```bash
$ go run *.go
Go lang Go!
$
```

### Timers

There is a method to inject timers to the global scope:
```go
package main

import "fmt"
import "github.com/crazytyper/go-duktape"

func main() {
  ctx := duktape.New()

  // Let's inject `setTimeout`, `setInterval`, `clearTimeout`,
  // `clearInterval` into global scope.
  ctx.PushTimers()

  ch := make(chan string)
  ctx.PushGlobalGoFunction("second", func(_ *Context) int {
    ch <- "second step"
    return 0
  })
  ctx.PevalString(`
    setTimeout(second, 0);
    print('first step');
  `)
  fmt.Println(<-ch)
}
```
then run it
```bash
$ go run *.go
first step
second step
$
```

Also you can `FlushTimers()`.

### Command line tool

Install `go get github.com/crazytyper/go-duktape/...`.
Execute file.js: `$GOPATH/bin/go-duk file.js`.

### Benchmarks
| prog        | time  |
| ------------|-------|
|[otto](https://github.com/robertkrimen/otto)|200.13s|
|[anko](https://github.com/mattn/anko)|231.19s|
|[agora](https://github.com/PuerkitoBio/agora/)|149.33s|
|[GopherLua](https://github.com/yuin/gopher-lua/)|8.39s|
|**go-duktape**|**9.80s**|

### Status

The package is not fully tested, so be careful.


### Contribution

Pull requests are welcome! Also, if you want to discuss something send a pull request with proposal and changes.
__Convention:__ fork the repository and make changes on your fork in a feature branch.
