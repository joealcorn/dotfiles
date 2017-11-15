local logger = hs.logger.new('clipper', 'debug')

x = 0
y = 0
rect = nil

dragTap = nil
downTap = nil
upTap = nil

function drawBox()
  local pos = hs.mouse.getRelativePosition()

  local fx = x
  local fy = y
  local fh = pos.y - y
  local fw = pos.x - x
  local bounds = hs.geometry.rect(fx, fy, fw, fh)

  if rect == nil then
    rect = hs.drawing.rectangle(bounds)

    rect:setStrokeWidth(2)
    rect:setStrokeColor({["alpha"] = 0.80 })
    rect:setFillColor({
      ["red"] = 1,
      ["blue"] = 1,
      ["green"] = 1,
      ["alpha"] = 0.20
    })

    rect:setStroke(true):setFill(true)
    rect:setLevel("floating")
    rect:show()
  else
    rect:setFrame(bounds)
  end
end

function mouseDown(evt)
  local pos = hs.mouse.getRelativePosition()
  x = pos.x
  y = pos.y
  return true
end

function mouseUp(evt)
  dragTap:stop()
  downTap:stop()
  upTap:stop()

  rect:setFill(false)

  local frame = rect:frame()
  rect:setFrame({0, 0, 0, 0})
  rect:delete()

  -- without this doAfter the screenshot will contain the rect we drew
  hs.timer.doAfter(0.5, function() 
    clip(frame)
    rect = nil
  end)

  return true
end

function clip(frame)
    local screen = hs.mouse.getCurrentScreen()
    local image = screen:snapshot(frame)
    image:saveToFile("/tmp/clip.png", false, 'png')
end

hs.hotkey.bind({"cmd", "shift"}, "5", function()
  if dragTap then
    dragTap:stop()
  end

  if downTap then
    downTap:stop()
  end

  if upTap then
    upTap:stop()
  end

  dragTap = hs.eventtap.new({
    hs.eventtap.event.types.leftMouseDragged,
  }, drawBox):start()

  downTap = hs.eventtap.new({
    hs.eventtap.event.types.leftMouseDown,
  }, mouseDown):start()

  upTap = hs.eventtap.new({
    hs.eventtap.event.types.leftMouseUp,
  }, mouseUp):start()

end)
