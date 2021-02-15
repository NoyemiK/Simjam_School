local CONTENTS = {
  window = nil,
  buttons = {
    {
      text = "Yes!",
      coords = { x = 0, y = 0 },
      dimensions = { w = 20, h = 14 }
    },
    {
      text = "No!",
      coords = { x = 0, y = 0 },
      dimensions = { w = 20, h = 14 }
    }
  }
}


function CONTENTS:push(window)
  
  self.window = window
  self.window.active = true
  INTERFACE:sort_windows(self.window.id)
  SYSTEM:play_sfx("confirm")
  
end

function CONTENTS:update(position)
  
  if self.window.id < #INTERFACE.windows then
    self.window.active = false
    return
  end
  
  for k, v in ipairs(self.buttons) do
    self.buttons[k].coords.x = position.x + 20
    self.buttons[k].coords.y = position.y + (20 * k) + 40
  end
  
end

function CONTENTS:click(mouse_pos)
  
  local m_x = mouse_pos.x
  local m_y = mouse_pos.y
  for k, v in ipairs(self.buttons) do
    if m_x > v.coords.x and m_x < v.coords.x + v.dimensions.w then
      if m_y > v.coords.y and m_y < v.coords.y + v.dimensions.h then
        self.window.active = false
        if k == 1 then
          love.event.quit()
        end
      end
    end
  end
  
end

function CONTENTS:draw(x, y)
  
  love.graphics.print("Really quit?", x + 4, y)
  for k, v in ipairs(self.buttons) do
    local button = self.buttons[k]
    love.graphics.setColor( 0.56, 0.40, 0.48 )
    love.graphics.rectangle("line", button.coords.x, button.coords.y, button.dimensions.w, button.dimensions.h)
    love.graphics.setColor( 1, 1, 1 )
    love.graphics.print(button.text, button.coords.x + 30, button.coords.y)
  end
  
end

return CONTENTS