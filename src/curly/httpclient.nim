## ============================================================================
## Curly HTTP Client Primitives
## Native implementation for HttpClient class
## ============================================================================

import std/[strutils, tables]
import curly
import harding/core/types
import harding/interpreter/objects
import ./httpresponse

type
  HttpClientData = object
    client: Curly
    closed: bool

proc httpClientNewImpl*(interp: var Interpreter, self: Instance,
                         args: seq[NodeValue]): NodeValue {.nimcall.} =
  ## Create a new HTTP client instance
  ## HttpClient class>>new

  # Create a new instance
  let objectCls = interp.globals[]["Object"]
  if objectCls.kind != vkClass:
    return nilValue()

  let clientClsVal = interp.globals[]["HttpClient"]
  if clientClsVal.kind != vkClass:
    return nilValue()

  let clientCls = clientClsVal.classVal
  let instance = newInstance(clientCls)

  # Create Curly client
  var clientData = HttpClientData(
    client: newCurly(),
    closed: false
  )

  # Store in nimValue as raw pointer
  var dataPtr = create(HttpClientData)
  dataPtr[] = clientData
  instance.nimValue = cast[pointer](dataPtr)
  instance.isNimProxy = true

  return instance.toValue()

proc parseHeaders(headerStr: string): HttpHeaders =
  ## Parse headers from string format "Key: Value\nKey2: Value2"
  result = emptyHttpHeaders()
  if headerStr.len == 0:
    return result
  
  for line in headerStr.splitLines():
    let trimmed = line.strip()
    if trimmed.len == 0:
      continue
    let colonIdx = trimmed.find(':')
    if colonIdx > 0:
      let key = trimmed[0..<colonIdx].strip()
      let value = trimmed[colonIdx+1..^1].strip()
      result[key] = value

proc httpClientGetImpl*(interp: var Interpreter, self: Instance,
                         args: seq[NodeValue]): NodeValue {.nimcall.} =
  ## Execute HTTP GET request
  ## client get: "https://example.com"

  if not self.isNimProxy or self.nimValue == nil:
    return nilValue()

  let dataPtr = cast[ptr HttpClientData](self.nimValue)

  if dataPtr.closed:
    return nilValue()

  if args.len < 1:
    return nilValue()

  let url = args[0].toString()
  var headers = emptyHttpHeaders()
  
  # Optional headers argument
  if args.len >= 2:
    headers = parseHeaders(args[1].toString())

  try:
    let response = dataPtr.client.get(url, headers)
    return createHttpResponse(interp, response.code.int, $response.headers, response.body, url)
  except:
    return nilValue()

proc httpClientPostImpl*(interp: var Interpreter, self: Instance,
                          args: seq[NodeValue]): NodeValue {.nimcall.} =
  ## Execute HTTP POST request
  ## client post: "https://example.com" body: "data"

  if not self.isNimProxy or self.nimValue == nil:
    return nilValue()

  let dataPtr = cast[ptr HttpClientData](self.nimValue)

  if dataPtr.closed:
    return nilValue()

  if args.len < 2:
    return nilValue()

  let url = args[0].toString()
  let body = args[1].toString()
  var headers = emptyHttpHeaders()
  
  # Optional headers argument
  if args.len >= 3:
    headers = parseHeaders(args[2].toString())

  try:
    let response = dataPtr.client.post(url, headers, body)
    return createHttpResponse(interp, response.code.int, $response.headers, response.body, url)
  except:
    return nilValue()

proc httpClientPutImpl*(interp: var Interpreter, self: Instance,
                         args: seq[NodeValue]): NodeValue {.nimcall.} =
  ## Execute HTTP PUT request
  ## client put: "https://example.com" body: "data"

  if not self.isNimProxy or self.nimValue == nil:
    return nilValue()

  let dataPtr = cast[ptr HttpClientData](self.nimValue)

  if dataPtr.closed:
    return nilValue()

  if args.len < 2:
    return nilValue()

  let url = args[0].toString()
  let body = args[1].toString()
  var headers = emptyHttpHeaders()
  
  # Optional headers argument
  if args.len >= 3:
    headers = parseHeaders(args[2].toString())

  try:
    let response = dataPtr.client.put(url, headers, body)
    return createHttpResponse(interp, response.code.int, $response.headers, response.body, url)
  except:
    return nilValue()

proc httpClientDeleteImpl*(interp: var Interpreter, self: Instance,
                            args: seq[NodeValue]): NodeValue {.nimcall.} =
  ## Execute HTTP DELETE request
  ## client delete: "https://example.com"

  if not self.isNimProxy or self.nimValue == nil:
    return nilValue()

  let dataPtr = cast[ptr HttpClientData](self.nimValue)

  if dataPtr.closed:
    return nilValue()

  if args.len < 1:
    return nilValue()

  let url = args[0].toString()
  var headers = emptyHttpHeaders()
  
  # Optional headers argument
  if args.len >= 2:
    headers = parseHeaders(args[1].toString())

  try:
    let response = dataPtr.client.delete(url, headers)
    return createHttpResponse(interp, response.code.int, $response.headers, response.body, url)
  except:
    return nilValue()

proc httpClientPatchImpl*(interp: var Interpreter, self: Instance,
                           args: seq[NodeValue]): NodeValue {.nimcall.} =
  ## Execute HTTP PATCH request
  ## client patch: "https://example.com" body: "data"

  if not self.isNimProxy or self.nimValue == nil:
    return nilValue()

  let dataPtr = cast[ptr HttpClientData](self.nimValue)

  if dataPtr.closed:
    return nilValue()

  if args.len < 2:
    return nilValue()

  let url = args[0].toString()
  let body = args[1].toString()
  var headers = emptyHttpHeaders()
  
  # Optional headers argument
  if args.len >= 3:
    headers = parseHeaders(args[2].toString())

  try:
    let response = dataPtr.client.patch(url, headers, body)
    return createHttpResponse(interp, response.code.int, $response.headers, response.body, url)
  except:
    return nilValue()

proc httpClientCloseImpl*(interp: var Interpreter, self: Instance,
                           args: seq[NodeValue]): NodeValue {.nimcall.} =
  ## Close the HTTP client
  ## client close

  if not self.isNimProxy or self.nimValue == nil:
    return falseValue

  let dataPtr = cast[ptr HttpClientData](self.nimValue)

  if not dataPtr.closed:
    dataPtr.client.close()
    dataPtr.closed = true

  return trueValue
