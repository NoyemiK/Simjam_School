local CONTENTS = {
  event = nil,
  window = nil,
  buttons = {}
}

function CONTENTS:push_event(event, window)
  
  self.event = event
  self.window = window
  self.window.active = true
  INTERFACE:sort_windows(self.window.id)
  SYSTEM:play_sfx("confirm")
  
end

function CONTENTS:update(position)
  
  if not self.event then self.window.active = false end
  for k, v in ipairs(self.event.choices) do
    local button = {
      text = v,
      coords = {
        x = position.x + 20,
        y = (position.y + 220) + ((k - 1) * 20)
      },
      dimensions = { w = 20, h = 14 }
    }
    self.buttons[k] = button
  end
  
end

function CONTENTS:click(mouse_pos)
  
  local m_x = mouse_pos.x
  local m_y = mouse_pos.y
  for k, v in ipairs(self.buttons) do
    if m_x > v.coords.x and m_x < v.coords.x + v.dimensions.w then
      if m_y > v.coords.y and m_y < v.coords.y + v.dimensions.h then
        self.event = nil
        self.window.active = false
        self.buttons = {}
      end
    end
  end
  
end

function CONTENTS:draw(x, y)
  
  local gfx = love.graphics
  local event_str = self.event.title.."\n\n"..self.event.text
  local choices = self.event.choices
  local limit = (self.window.size.w * 20) - 2
  gfx.printf(event_str, x + 2, y + 20, limit)
  for k,v in ipairs(choices) do
    local button = self.buttons[k]
    if not button then return end
    gfx.setColor( 0.56, 0.40, 0.48 )
    gfx.rectangle("line", button.coords.x, button.coords.y, button.dimensions.w, button.dimensions.h)
    gfx.setColor( 1, 1, 1 )
    gfx.print(v, button.coords.x + button.dimensions.w + 8, button.coords.y - 2)
  end
  
end

return CONTENTS