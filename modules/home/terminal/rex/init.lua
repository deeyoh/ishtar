rex.unbind("cmd+d")
rex.unbind("cmd+t")

rex.bind("ctrl+s>shift+\\", "pane.split", { direction = "right" })
rex.bind("ctrl+s>-", "pane.split", { direction = "down" })
rex.bind("ctrl+s>x", "pane.close")
rex.bind("ctrl+s>e", "pane.balance")
rex.bind("ctrl+s>z", "pane.zoom")

local directions = {
  h = "left",
  j = "down",
  k = "up",
  l = "right",
}

for key, direction in pairs(directions) do
  rex.bind("ctrl+" .. key, "pane.focus", {
    direction = direction
  })

  rex.bind("ctrl+s>shift+" .. key, "pane.move", {
    direction = direction
  })
end

rex.bind("ctrl+s>r", "client.config.reload")


rex.bind("ctrl+s>c", "client.tab.new")
rex.bind("ctrl+s>shift+x", "client.tab.close")
rex.bind("ctrl+n", "client.tab.next")

for i = 1, 9 do
  rex.bind("ctrl+s>" .. i, "client.tab.goto", {
    index = i
  })
end

rex.bind("ctrl+s>k", "client.palette.toggle")


rex.bind("ctrl+s>s", "session.switch")
rex.bind("ctrl+s>n", "session.next")
rex.bind("ctrl+s>b", "session.previous")
