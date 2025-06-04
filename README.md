# wolfram-server

JSON based Wolfram Language expression evaluation server forked from [wolfram-server](https://github.com/arnoudbuzing/wolfram-server)

## Description

The server accepts HTTP POST requests, where the body data consists of Wolfram Language code. It takes this code, as a string, and evaluates it. Finally it converts the evaluated expression to [ExpressionJSON](https://reference.wolfram.com/language/ref/format/ExpressionJSON.html) and sends this JSON expression back to the client making the request.

## Starting the Wolfram Language server

General usage:

```
wolframserver.wls [address]
```

If `address` is omitted, it defaults to 127.0.0.1:5858

Example, launch the server on port 8080 of localhost:

```
wolframserver.wls 127.0.0.1:5858
```

## Connecting to the server

```
> curl -d "DateString[]" -X POST http://127.0.0.1:5858
"'Wed 4 Jun 2025 22:12:10'"
```
