## ============================================================================
## Curly HTTP Response
## Native implementation for HttpResponse class
## ============================================================================

import std/tables
import harding/core/types
import harding/interpreter/objects

type
  HttpResponseData* = object
    statusCode: int
    headers: string
    body: string
    url: string

proc createHttpResponse*(interp: var Interpreter, statusCode: int, headers: string, 
                         body: string, url: string): NodeValue =
  ## Create a new HttpResponse instance with response data
  
  let responseClsVal = interp.globals[]["HttpResponse"]
  if responseClsVal.kind != vkClass:
    return nilValue()

  let responseCls = responseClsVal.classVal
  let instance = newInstance(responseCls)

  # Store response data in nimValue for Nim proxy access
  var responseData = HttpResponseData(
    statusCode: statusCode,
    headers: headers,
    body: body,
    url: url
  )

  var dataPtr = create(HttpResponseData)
  dataPtr[] = responseData
  instance.nimValue = cast[pointer](dataPtr)
  instance.isNimProxy = true

  return instance.toValue()

# Primitive accessors for response data
proc httpResponseStatusCodeImpl*(interp: var Interpreter, self: Instance,
                                 args: seq[NodeValue]): NodeValue {.nimcall.} =
  ## Get the HTTP status code
  ## response statusCode
  discard interp
  discard args
  
  if not self.isNimProxy or self.nimValue == nil:
    return nilValue()
  
  let dataPtr = cast[ptr HttpResponseData](self.nimValue)
  return dataPtr.statusCode.toValue()

proc httpResponseHeadersImpl*(interp: var Interpreter, self: Instance,
                              args: seq[NodeValue]): NodeValue {.nimcall.} =
  ## Get the response headers
  ## response headers
  discard interp
  discard args
  
  if not self.isNimProxy or self.nimValue == nil:
    return nilValue()
  
  let dataPtr = cast[ptr HttpResponseData](self.nimValue)
  return dataPtr.headers.toValue()

proc httpResponseBodyImpl*(interp: var Interpreter, self: Instance,
                           args: seq[NodeValue]): NodeValue {.nimcall.} =
  ## Get the response body
  ## response body
  discard interp
  discard args
  
  if not self.isNimProxy or self.nimValue == nil:
    return nilValue()
  
  let dataPtr = cast[ptr HttpResponseData](self.nimValue)
  return dataPtr.body.toValue()

proc httpResponseUrlImpl*(interp: var Interpreter, self: Instance,
                          args: seq[NodeValue]): NodeValue {.nimcall.} =
  ## Get the request URL
  ## response url
  discard interp
  discard args
  
  if not self.isNimProxy or self.nimValue == nil:
    return nilValue()
  
  let dataPtr = cast[ptr HttpResponseData](self.nimValue)
  return dataPtr.url.toValue()

proc httpResponseNewImpl*(interp: var Interpreter, self: Instance,
                          args: seq[NodeValue]): NodeValue {.nimcall.} =
  ## Create a new HttpResponse instance
  ## HttpResponse class>>new

  let objectCls = interp.globals[]["Object"]
  if objectCls.kind != vkClass:
    return nilValue()

  let responseClsVal = interp.globals[]["HttpResponse"]
  if responseClsVal.kind != vkClass:
    return nilValue()

  let responseCls = responseClsVal.classVal
  let instance = newInstance(responseCls)

  # Initialize with default values
  var responseData = HttpResponseData(
    statusCode: 0,
    headers: "",
    body: "",
    url: ""
  )

  var dataPtr = create(HttpResponseData)
  dataPtr[] = responseData
  instance.nimValue = cast[pointer](dataPtr)
  instance.isNimProxy = true

  return instance.toValue()
