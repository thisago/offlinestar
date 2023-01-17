from std/strformat import fmt
from std/os import fileExists

import pkg/karax/[karaxdsl, vdom, vstyles]

from pkg/subscribestar import StarPost

import offlinestar/config
import "offlinestar/htmlBase.nimf"

proc genPage*(post: StarPost): string =
  ## Generates the page for the provided post
  var videoUrl = post.videoUrl
  if fileExists videoFile:
    videoUrl = videoFile
  let vnode = buildHtml(tdiv(style = style({padding: "2em"}), class = "post is-shown false false")):
    a(style = style({fontSize: "1.5em"}), href = fmt"../#{post.id}"): text "Back"
    tdiv(class = "post-body"):
      tdiv(class = "post-date"):
        a: text post.publishDate
      tdiv:
        tdiv(class = "post-content"):
          tdiv(class = "trix-content"):
            h1:
              text post.name
            tdiv:
              br()
              text post.description
              br()
              if videoUrl.len > 0 and videoUrl != videoFile:
                br()
                p(style = style({color: "red"})):
                  text "Video is remote, please download it to watch offline!"
        tdiv(class = "post-uploads for-youtube")
        if videoUrl.len > 0:
          tdiv(class = "post-uploads"):
            tdiv(class = "uploads"):
              video(controls = "on", src = videoUrl, style = style({maxWidth: "100%"}))
        tdiv(class = "post_form-uploading")
    tdiv(class = "post-edit_form")
    tdiv(class = "post-actions"):
      tdiv(class = "reactions for-post"):
        tdiv(class = "reaction is-like"):
          italic(class = "md_icon is-thumb_up"):
            svg(viewBox = "0 0 24 24", width = "24", xmlns = "http://www.w3.org/2000/svg", height = "24"):
              path(d = "M1 21h4V9H1v12zm22-11c0-1.1-.9-2-2-2h-6.31l.95-4.57.03-.32c0-.41-.17-.79-.44-1.06L14.17 1 7.59 7.59C7.22 7.95 7 8.45 7 9v10c0 1.1.9 2 2 2h9c.83 0 1.54-.5 1.84-1.22l3.02-7.05c.09-.23.14-.47.14-.73v-1.91l-.01-.01L23 10z")
          span(class = "reaction-title"):
            text "Like"
          span(class = "reaction-counter"):
            text $post.likes
        tdiv(class = "reaction is-dislike"):
          italic(class = "md_icon is-thumb_down"):
            svg(viewBox = "0 0 24 24", width = "24", xmlns = "http://www.w3.org/2000/svg", height = "24"):
              path(d = "M15 3H6c-.83 0-1.54.5-1.84 1.22l-3.02 7.05c-.09.23-.14.47-.14.73v1.91l.01.01L1 14c0 1.1.9 2 2 2h6.31l-.95 4.57-.03.32c0 .41.17.79.44 1.06L9.83 23l6.59-6.59c.36-.36.58-.86.58-1.41V5c0-1.1-.9-2-2-2zm4 0v12h4V3h-4z")
          span(class = "reaction-title"):
            text "Dislike"
          span(class = "reaction-counter"):
            text $post.dislikes
  result = baseHtml(post.name, $vnode)
