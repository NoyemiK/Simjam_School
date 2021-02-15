local SYSTEM = {
  scale = 1,
  normal_width = 960,
  normal_height = 540,
  origin = { x = 0, y = 0 },
  cursor = love.graphics.newImage("assets/cursor.png"),
  sfx    = {
    confirm = love.audio.newSource("sfx/CONFIRM.wav", "static"),
    cancel  = love.audio.newSource("sfx/CANCEL.wav", "static")
  }
}

do
  local w, h = love.window.getMode()
  SYSTEM.canvas = love.graphics.newCanvas(w, h)
  SYSTEM.normal_width, SYSTEM.normal_height = w, h
end

function SYSTEM.set_fullscreen()
  
  -- Setup
  local sys = SYSTEM
  local b, f, flags = love.window.getMode()
  local fullscreen = flags.fullscreen
  local w, h = love.window.getDesktopDimensions(flags.display)
  local ratio = w/h
  
  if fullscreen == false then
    
    -- Normally, base the new scale factor on the height of the screen. For squarer monitors, base it on the width.
    sys.scale = h/sys.normal_height
    sys.origin.x = (w/2) - ((sys.normal_width/2) * sys.scale)
    sys.origin.y = 0
    if ratio < 16/9 then
      sys.scale = w/sys.normal_width
      sys.origin.x = 0
      sys.origin.y = (h/2) - ((sys.normal_height/2) * sys.scale)
    end
    love.window.setMode(w, h, {fullscreen = true, display = flags.display})
  elseif fullscreen == true then
    sys.scale = 1
    sys.origin.x, sys.origin.y = 0, 0
    love.window.setMode(sys.normal_width, sys.normal_height, {fullscreen = false, display = flags.display})
  end
  
end

function SYSTEM.transform_mouse_position()
  
  -- Use the scale factor and the transformed origin point to scale and translate the system mouse cursor to the in-game one
  local sys_scale = SYSTEM.scale
  local sys_origin = SYSTEM.origin
  local mouse_pos = {
    x = math.floor((love.mouse.getX()/sys_scale) - (sys_origin.x/sys_scale)),
    y = math.floor((love.mouse.getY()/sys_scale) - (sys_origin.y/sys_scale))
  }
  
  return mouse_pos
  
end

function SYSTEM:play_sfx(sfx_key)
  
  self.sfx[sfx_key]:stop()
  self.sfx[sfx_key]:play()
  
end

return SYSTEM