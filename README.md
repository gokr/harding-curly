# harding-curly

Curly HTTP Client wrapper for Harding - provides HTTP client functionality via the [Curly](https://github.com/guzba/curly) library.

## Features

- Simple, intuitive API for HTTP requests (GET, POST, PUT, DELETE, PATCH)
- Connection pooling and reuse for better performance
- HTTP/2 multiplexing support
- Automatic gzip decompression
- Production-tested (used in Mummy web server)

## Installation

Install curly package:
```bash
nimble install curly
```

Then clone this repository into your Harding external libraries directory:
```bash
cd /path/to/harding/external
git clone https://github.com/gokr/harding-curly.git
cd harding-curly
```

## Usage

### Basic GET Request

```harding
client := HttpClient new.
response := client get: "https://api.example.com/data".

response statusCode printString print.
response body print.

client close
```

### POST Request with Body

```harding
client := HttpClient new.
response := client post: "https://api.example.com/users" body: '{"name": "John", "email": "john@example.com"}'.

response statusCode printString print.
response body print.

client close
```

### Working with Response

```harding
client := HttpClient new.
response := client get: "https://api.example.com/data".

"Status: " print. response statusCode printString print.
"Headers: " print. response headers print.
"Body: " print. response body print.
"URL: " print. response url print.

client close
```

### Using Default Client

For simple one-off requests, use the class method:

```harding
response := HttpClient default get: "https://api.example.com/test".
response body print
```

## API Reference

### HttpClient Class

#### Class Methods

- `HttpClient class>>new` - Create a new HTTP client instance
- `HttpClient class>>default` - Get a default singleton instance

#### Instance Methods

- `client get: url` - Execute GET request
- `client post: url body: body` - Execute POST request with body
- `client put: url body: body` - Execute PUT request with body
- `client delete: url` - Execute DELETE request
- `client patch: url body: body` - Execute PATCH request with body
- `client close` - Close the client and release resources

### HttpResponse Class

Properties (auto-generated accessors):

- `response statusCode` - HTTP status code (integer)
- `response headers` - Response headers as string
- `response body` - Response body as string
- `response url` - Request URL

## Requirements

- Nim >= 2.0.0
- Harding >= 0.6.0
- curly >= 1.1.0

## License

MIT License - See LICENSE file for details.

## Credits

This wrapper uses the excellent [Curly](https://github.com/guzba/curly) library by guzba.
