// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "deps/phoenix_html/web/static/js/phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

import socket from "./socket"


$(document).ready(function() {
        alert('complete, right? '+document.readyState)

    let channel = socket.channel("attendance:lobby", {token: 'roomToken'})
    channel.on("new_msg", msg => console.log("Got message", msg) )

    $( "#foo" ).keydown(function(event) {
      console.log( "Handler for foo.keydown() called." );
      var keypressed = event.keyCode || event.which;
      if (keypressed == 13) {
        event.preventDefault();

        channel.push("new_msg", {body: event.target.val}, 10000)
          .receive("ok", (msg) => console.log("created message", msg) )
          .receive("error", (reasons) => console.log("create failed", reasons) )
          .receive("timeout", () => console.log("push Networking issue...") )
        }
    });

    channel.join()
      .receive("ok", ({messages}) => console.log("catching up", messages) )
      .receive("error", ({reason}) => console.log("failed join", reason) )
      .receive("timeout", () => console.log("join Networking issue. Still waiting...") )
})
