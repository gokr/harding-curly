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

  # Store response data
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
