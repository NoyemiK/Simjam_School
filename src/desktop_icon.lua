local DESK_ICON = {
  label = "DUMMY",
  quad  = 1,
  window= nil
}
DESK_ICON.__index = DESK_ICON
setmetatable(DESK_ICON, {
    __call = function (cls, ...)
      return cls.new(...)
    end,
  })

function DESK_ICON.new(window, quad)
  
  local self = setmetatable({}, DESK_ICON)
  self.window  = window
  self.label   = window.title
  self.quad    = quad
  
  return self
end

function DESK_ICON:set_position(contents)
  
  local position_table = {
    help            = { x = 1, y = 0 },
    stats           = { x = 0, y = 2 },
    time_management = { x = 0, y = 4 },
    music_player    = { x = 0, y = 6 }
  }
  self.position = {}
  self.position.x = position_table[contents].x * 64
  self.position.y = position_table[contents].y * 64
  
end

function DESK_ICON:click(mouse_pos)
  
  if mouse_pos.x > self.position.x and mouse_pos.x < self.position.x + 64 then
    if mouse_pos.y > self.position.y and mouse_pos.y < self.position.y + 64 then
      SYSTEM:play_sfx("confirm")
      self.window.active = true
      INTERFACE:sort_windows(self.window.id)
    end
  end
  
end

function DESK_ICON:draw()
  
  local image = INTERFACE.desktop_icons
  local quad  = INTERFACE.desktop_quads[self.quad]
  
  love.graphics.draw(image, quad, self.position.x, self.position.y)
  love.graphics.printf(self.label, self.position.x, self.position.y + 64, 64)
  
end

return DESK_ICON