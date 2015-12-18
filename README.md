# Debug service

provides a debugger as a service for other atom packages.

![debug service](https://cloud.githubusercontent.com/assets/1881921/8181891/0c83fbae-142a-11e5-9436-6148fe26d6c2.png)

#### Only works in dev mode!

## Usage

package.json
```json
{
  "otherStuff": "otherData",
  "consumedServices": {
    "debug": {
      "versions": {
        "^0.0.1": "consumeDebug"
      }
    }
  }
}
```

your package:
```coffee
  # in your package declaration
  # so debugging is invisible to users and you can disable debugging on single packages
  config:
    debug:
      type: "integer"
      default: 0
      minimum: 0
  #in main module
  consumeDebug: (debugSetup) =>
    debug = debugSetup(pkg: "yourPackageName", nsp: "someNamespace")

    # if in dev mode, and debug variable in config of your package is at least 2
    # will print "yourPackageName.someNamespace: debug service consumed"
    debug "debug service consumed", 2

    # the level is optional, this will work also:
    debug "somethingSomething"

    # you can defer nsp setting for later
    debugCreator = debugSetup(pkg: "yourPackageName")
    debugNSP1 = debugCreator("NSP1")
    debugNSP2 = debugCreator("NSP2")
```

## License
Copyright (c) 2015 Paul Pflugradt
Licensed under the MIT license.
