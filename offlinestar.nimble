# Package

version       = "1.1.1"
author        = "Thiago Navarro"
description   = "View the Subscribestar content offline!"
license       = "MIT"
srcDir        = "src"
bin           = @["offlinestar"]

binDir = "build"

# Dependencies

requires "nim >= 1.6.4"
requires "subscribestar"
requires "cligen"
requires "util"
requires "karax"
