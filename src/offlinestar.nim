from std/os import fileExists, dirExists, createDir, setCurrentDir, execShellCmd
from std/strformat import fmt, `&`
from std/json import `%`, `%*`, `$`, parseJson, to

import pkg/subscribestar
from pkg/util/forFs import escapeFs

const
  dataFile = "data.json"
  videoFile = "video.mp4"

proc extract(star, cookieFile, outDir: string): int =
  ## Extracts the Subscribestar content
  if not fileExists cookieFile:
    echo "Error, cookie file not exists"
    return 1
  if not dirExists outDir:
    createDir outDir
    echo fmt"Created '{outDir}' dir"
  let cookies = readFile cookieFile
  setCurrentDir outDir
  let data = star.extractStar cookies
  dataFile.writeFile($ %*data)

proc downloadFile(curl, file, dest: string): bool =
  ## Download the `file` to `dest` using curl
  execShellCmd(&"{curl} \"{file}\" -o \"{dest}\"") == 0

proc download(dirs: seq[string]; curl = "curl"): int =
  ## Downloads all videos of Subscribestar account
  for dir in dirs:
    if not dirExists dir:
      echo "Error, dir not exists"
      return 1
    setCurrentDir dir
    let data = dataFile.readFile.parseJson.to Star
    for post in data.posts:
      let postDir = post.name.escapeFs
      createDir postDir
      setCurrentDir postDir
      stdout.write fmt"Downloading '{post.name}'..."
      if not curl.downloadFile(post.videoUrl, videoFile):
        echo fmt"Error when downloading '{post.name}'"
        return 1
      else:
        echo " Success!"
      setCurrentDir ".."

when isMainModule:
  import pkg/cligen
  dispatchMulti([
    extract,
    help = {
      "star": "Subscribestar creator username",
      "cookieFile": "A file with the auth cookies inside"
    }
  ], [
    download,
  ])