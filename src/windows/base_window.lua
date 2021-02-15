local WINDOW = {
  id       = 1,
  active   = false,
  dragged  = false,
  title    = "DUMMY",
  closeable= true
}
WINDOW.__index = WINDOW
setmetatable(WINDOW, {
    __call = function (cls, ...)
      return cls.new(...)
    end,
  })

function WINDOW.new(id, position, size, title, internal_id, closeable)
  local self = setmetatable({}, WINDOW)
  local contents = internal_id or "stats"
  local default_position = { x = 24, y = 24 }
  local default_size     = { w = 18, h = 10 }
  if closeable == nil then closeable = self.closeable end
  local quad_table = {
    help = 1,
    stats = 2,
    time_management = 3,
    music_player = 4
  }
  self.id = id
  self.position = position or default_position
  self.size = size or default_size
  self.title = title or self.title
  self.contents = require("src/windows/"..contents)
  self.closeable = closeable
  
  if not quad_table[contents] then return self end -- Escape the constructor if there's no case for the specific window
  
  self.icon = require("src/desktop_icon").new(self, quad_table[contents])
  self.icon:set_position(contents)
  
  if contents == "help" or contents == "music_player" then self.active = true end
  
  return self
end

local x_offset = 0

function WINDOW:update(mouse_pos)
  
  if not self.active then return end
  
  -- Get the state of the window if we want to drag it
  local down = love.mouse.isDown(1)
  
  if self.active and down then
    if self.dragged == true and down then
      self.position.x = mouse_pos.x - x_offset
      self.position.y = mouse_pos.y - 10
    end
  end
  
  -- Ensures the window remain draggable until the mouse button is released
  if not down then
    self.dragged = false
    local normal_width, normal_height = SYSTEM.normal_width, SYSTEM.normal_height
    
    -- Position correction for windows placed outside of screen bounds
    if self.position.x < 0 then self.position.x = 0 end
    if self.position.y < 0 then self.position.y = 0 end
    if self.position.x + ((self.size.w + 1) * 20) > normal_width then
      self.position.x = normal_width - ((self.size.w + 1) * 20)
    end
    if self.position.y + ((self.size.h + 1) * 20) > normal_height then
      self.position.y = normal_height - ((self.size.h + 1) * 20)
    end
  end
  
  self.contents:update(self.position)
  
end

function WINDOW:toggle()
  self.active = not self.active
end

function WINDOW:is_inside(mouse_pos)
  
  if mouse_pos.x > self.position.x and mouse_pos.x < self.position.x + ((self.size.w + 1) * 20) then
    if mouse_pos.y > self.position.y and mouse_pos.y < self.position.y + ((self.size.h + 1) * 20) then
      return { x = mouse_pos.x - self.position.x, y = mouse_pos.y - self.position.y}
    end
  end
  
  return false
  
end

function WINDOW:handle(mouse_pos)
  
  if mouse_pos.x > self.position.x and mouse_pos.x < self.position.x + (self.size.w * 20) then
    if mouse_pos.y > self.position.y and mouse_pos.y < self.position.y + 20 then
      self.dragged = true
      x_offset = mouse_pos.x - self.position.x
      return { x = mouse_pos.x - self.position.x, y = mouse_pos.y - self.position.y}
    end
  end
  
  return false
  
end

function WINDOW:close_button(mouse_pos)
  
  if not self.closeable then return end
  local start_x  = self.position.x + (self.size.w * 20)
  local end_x    = self.position.x + (self.size.w * 20) + 20
  if mouse_pos.x > start_x and mouse_pos.x < end_x then
    if mouse_pos.y > self.position.y and mouse_pos.y < self.position.y + 20 then
      SYSTEM:play_sfx("cancel")
      self.active = false
      return { x = mouse_pos.x - self.position.x, y = mouse_pos.y - self.position.y}
    end
  end
  
end

function WINDOW:draw()
  
  if not self.active then return end
  
  INTERFACE:draw_window( self.position.x, self.position.y, self.size.w, self.size.h, self.title)
  self.contents:draw(self.position.x + 4, self.position.y + 20, self.size)
  
end

function WINDOW:click(mouse_pos)
  
  if not self.active then return end
  
  self:close_button(mouse_pos)
  if self:is_inside(mouse_pos) then
    INTERFACE.captured = true
    self.contents:click(mouse_pos)
    if self.id < #INTERFACE.windows then
      INTERFACE:sort_windows(self.id)
    end
  end
  self:handle(mouse_pos)
  
end

return WINDOW