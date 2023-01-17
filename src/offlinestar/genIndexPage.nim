from std/strformat import fmt

import pkg/karax/[karaxdsl, vdom, vstyles]
from pkg/util/forFs import escapeFs

from pkg/subscribestar import Star

import "offlinestar/htmlBase.nimf"

proc genPage*(star: Star): string =
  ## Generates the page for the provided post
  let vnode = buildHtml(tdiv(class = "layout for-public")):
    tdiv(style = style({paddingTop: "8em"}), class = "layout-inner"):
      tdiv(class = "warnings-all")
      tdiv(class = "layout-content"):
        tdiv(class = "profile_main_info"):
          # tdiv(class = "profile_main_info-cover_wrap"):
          #   img(src = "https://d3ts7pb9ldoin4.cloudfront.net/uploads_v2/users/663843/covers/4a55845c-3feb-4905-a1d1-e74540018afd-1240x0_0x19_600x112.jpg")
          tdiv(class = "profile_main_info-data"):
            tdiv(class = "profile_main_info-userpic"):
              img(src = star.avatar)
            tdiv(class = "profile_main_info-user"):
              tdiv(class = "profile_main_info-name"):
                text star.name
        tdiv(style = style({position: "relative"}), class = "wrapper for-profile_columns"):
          tdiv(data-section = "feed", data-view = "app#posts_container", class = "section-body", data-role = "profile_sections_container-section"):
            tdiv(style = style({marginTop: "5em", padding: "2em"}), class = "posts"):
              for post in star.posts:
                tdiv(style = style({padding: "2em"}), class = "post is-shown false false"):
                  a(id = $post.id, style = style({fontSize: "2em"}), href = fmt"./{escapeFs post.name}/"): text post.name

  result = baseHtml(star.name, $vnode)
