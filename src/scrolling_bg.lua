local SCROLLER = {
  image = love.graphics.newSpriteBatch(love.graphics.newImage("assets/scrolling_bg.png"), 100, "stream"),
  x_pos = 0,
  y_pos = 0
}


function SCROLLER.update()
  local s = SCROLLER
  local acc_period  = 0.75

  s.x_pos = s.x_pos + acc_period
  s.y_pos = s.y_pos + acc_period/2
  
  if s.x_pos > 128 then
    s.x_pos = 0
  end
  
  if s.y_pos > 128 then
    s.y_pos = 0
  end
  
  s:setup_spritebatch()
  
end

function SCROLLER.draw()
  
  local s = SCROLLER
  love.graphics.draw(s.image, -128, -128)
  
end

function SCROLLER:setup_spritebatch()
  
  local w, h = SYSTEM.normal_width, SYSTEM.normal_height
  self.image:clear()
  
  for x = 0, math.floor(w/128) + 1 do
    for y = 0, math.floor(h/128) + 1 do
      local xp = math.floor(self.x_pos) + (x * 128)
      local yp = math.floor(self.y_pos) + (y * 128)
      self.image:add(xp, yp)
    end
  end
  
  self.image:flush()
  
end

return SCROLLER