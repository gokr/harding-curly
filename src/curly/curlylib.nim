## ============================================================================
## Harding Curly HTTP Client Library
## Provides HTTP client capabilities via the Curly library
## ============================================================================

import std/[strutils, tables]
import harding/core/types
import harding/interpreter/objects
import harding/interpreter/vm
import harding/packages/package_api

import ./httpclient
import ./httpresponse

const
  BootstrapHrd = staticRead("../../lib/curly/Bootstrap.hrd")
  HttpClientHrd = staticRead("../../lib/curly/HttpClient.hrd")
  HttpResponseHrd = staticRead("../../lib/curly/HttpResponse.hrd")

## ============================================================================
## Primitive Registration
## ============================================================================

proc registerHttpClientPrimitives(interp: var Interpreter) =
  ## Register HttpClient primitives

  let clientCls = if interp.globals[].hasKey("HttpClient"):
                    let val = interp.globals[]["HttpClient"]
                    if val.kind == vkClass: val.classVal else: nil
                  else:
                    nil

  if clientCls == nil:
    warn("HttpClient class not found")
    return

  debug("Found HttpClient class, registering primitives")

  # Mark as Nim proxy
  clientCls.isNimProxy = true
  clientCls.hardingType = "HttpClient"

  # Register primitive selectors used by declarative <primitive ...> methods.
  let newMethod = createCoreMethod("primitiveHttpClientNew")
  newMethod.setNativeImpl(httpClientNewImpl)
  newMethod.hasInterpreterParam = true
  clientCls.classMethods["primitiveHttpClientNew"] = newMethod
  clientCls.allClassMethods["primitiveHttpClientNew"] = newMethod

  # Also bind the public selectors directly
  let publicNewMethod = createCoreMethod("new")
  publicNewMethod.setNativeImpl(httpClientNewImpl)
  publicNewMethod.hasInterpreterParam = true
  clientCls.classMethods["new"] = publicNewMethod
  clientCls.allClassMethods["new"] = publicNewMethod

  # Register get: primitive
  let getMethod = createCoreMethod("primitiveHttpClientGet:")
  getMethod.setNativeImpl(httpClientGetImpl)
  getMethod.hasInterpreterParam = true
  clientCls.methods["primitiveHttpClientGet:"] = getMethod
  clientCls.allMethods["primitiveHttpClientGet:"] = getMethod

  let publicGetMethod = createCoreMethod("get:")
  publicGetMethod.setNativeImpl(httpClientGetImpl)
  publicGetMethod.hasInterpreterParam = true
  clientCls.methods["get:"] = publicGetMethod
  clientCls.allMethods["get:"] = publicGetMethod

  # Register post:body: primitive
  let postMethod = createCoreMethod("primitiveHttpClientPost:body:")
  postMethod.setNativeImpl(httpClientPostImpl)
  postMethod.hasInterpreterParam = true
  clientCls.methods["primitiveHttpClientPost:body:"] = postMethod
  clientCls.allMethods["primitiveHttpClientPost:body:"] = postMethod

  let publicPostMethod = createCoreMethod("post:body:")
  publicPostMethod.setNativeImpl(httpClientPostImpl)
  publicPostMethod.hasInterpreterParam = true
  clientCls.methods["post:body:"] = publicPostMethod
  clientCls.allMethods["post:body:"] = publicPostMethod

  # Register put:body: primitive
  let putMethod = createCoreMethod("primitiveHttpClientPut:body:")
  putMethod.setNativeImpl(httpClientPutImpl)
  putMethod.hasInterpreterParam = true
  clientCls.methods["primitiveHttpClientPut:body:"] = putMethod
  clientCls.allMethods["primitiveHttpClientPut:body:"] = putMethod

  let publicPutMethod = createCoreMethod("put:body:")
  publicPutMethod.setNativeImpl(httpClientPutImpl)
  publicPutMethod.hasInterpreterParam = true
  clientCls.methods["put:body:"] = publicPutMethod
  clientCls.allMethods["put:body:"] = publicPutMethod

  # Register delete: primitive
  let deleteMethod = createCoreMethod("primitiveHttpClientDelete:")
  deleteMethod.setNativeImpl(httpClientDeleteImpl)
  deleteMethod.hasInterpreterParam = true
  clientCls.methods["primitiveHttpClientDelete:"] = deleteMethod
  clientCls.allMethods["primitiveHttpClientDelete:"] = deleteMethod

  let publicDeleteMethod = createCoreMethod("delete:")
  publicDeleteMethod.setNativeImpl(httpClientDeleteImpl)
  publicDeleteMethod.hasInterpreterParam = true
  clientCls.methods["delete:"] = publicDeleteMethod
  clientCls.allMethods["delete:"] = publicDeleteMethod

  # Register patch:body: primitive
  let patchMethod = createCoreMethod("primitiveHttpClientPatch:body:")
  patchMethod.setNativeImpl(httpClientPatchImpl)
  patchMethod.hasInterpreterParam = true
  clientCls.methods["primitiveHttpClientPatch:body:"] = patchMethod
  clientCls.allMethods["primitiveHttpClientPatch:body:"] = patchMethod

  let publicPatchMethod = createCoreMethod("patch:body:")
  publicPatchMethod.setNativeImpl(httpClientPatchImpl)
  publicPatchMethod.hasInterpreterParam = true
  clientCls.methods["patch:body:"] = publicPatchMethod
  clientCls.allMethods["patch:body:"] = publicPatchMethod

  # Register close primitive
  let closeMethod = createCoreMethod("primitiveHttpClientClose")
  closeMethod.setNativeImpl(httpClientCloseImpl)
  closeMethod.hasInterpreterParam = true
  clientCls.methods["primitiveHttpClientClose"] = closeMethod
  clientCls.allMethods["primitiveHttpClientClose"] = closeMethod

  let publicCloseMethod = createCoreMethod("close")
  publicCloseMethod.setNativeImpl(httpClientCloseImpl)
  publicCloseMethod.hasInterpreterParam = true
  clientCls.methods["close"] = publicCloseMethod
  clientCls.allMethods["close"] = publicCloseMethod

  debug("Registered HttpClient primitives")
  
  # Force rebuild of method tables
  clientCls.methodsDirty = true
  clientCls.version += 1
  invalidateSubclasses(clientCls)

proc registerHttpResponsePrimitives(interp: var Interpreter) =
  ## Register HttpResponse primitives

  let responseCls = if interp.globals[].hasKey("HttpResponse"):
                      let val = interp.globals[]["HttpResponse"]
                      if val.kind == vkClass: val.classVal else: nil
                    else:
                      nil

  if responseCls == nil:
    warn("HttpResponse class not found")
    return

  # Mark as Nim proxy
  responseCls.isNimProxy = true
  responseCls.hardingType = "HttpResponse"

  # Register primitive selectors
  let newMethod = createCoreMethod("primitiveHttpResponseNew")
  newMethod.setNativeImpl(httpResponseNewImpl)
  newMethod.hasInterpreterParam = true
  responseCls.classMethods["primitiveHttpResponseNew"] = newMethod
  responseCls.allClassMethods["primitiveHttpResponseNew"] = newMethod

  let publicNewMethod = createCoreMethod("new")
  publicNewMethod.setNativeImpl(httpResponseNewImpl)
  publicNewMethod.hasInterpreterParam = true
  responseCls.classMethods["new"] = publicNewMethod
  responseCls.allClassMethods["new"] = publicNewMethod

  debug("Registered HttpResponse primitives")
  
  # Force rebuild of method tables
  responseCls.methodsDirty = true
  responseCls.version += 1
  invalidateSubclasses(responseCls)

proc registerCurlyPrimitives(interp: var Interpreter) {.nimcall.} =
  ## Register all Curly primitives with Harding
  registerHttpClientPrimitives(interp)
  registerHttpResponsePrimitives(interp)

## ============================================================================
## Package Installation
## ============================================================================

proc installCurly*(interp: var Interpreter) =
  ## Install the Curly HTTP Client package into Harding

  let spec = HardingPackageSpec(
    name: "Curly",
    version: "0.1.0",
    bootstrapPath: "lib/curly/Bootstrap.hrd",
    sources: @[
      (path: "lib/curly/Bootstrap.hrd", source: BootstrapHrd),
      (path: "lib/curly/HttpClient.hrd", source: HttpClientHrd),
      (path: "lib/curly/HttpResponse.hrd", source: HttpResponseHrd)
    ],
    registerPrimitives: registerCurlyPrimitives
  )

  discard installPackage(interp, spec)
  debug("Curly HTTP Client package installed")
