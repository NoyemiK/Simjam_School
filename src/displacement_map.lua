local DISP = {
  texture = love.graphics.newSpriteBatch(love.graphics.newImage("assets/displacement.png"), 100, "stream"),
  t_scale = 8,
  x_pos = 0,
  y_pos = 0
}

function DISP:update()
  
  local acc_period  = 0.25

  self.x_pos = self.x_pos + acc_period
  self.y_pos = self.y_pos + acc_period/2
  
  if self.x_pos > 16 then
    self.x_pos = 0
  end
  
  if self.y_pos > 16 then
    self.y_pos = 0
  end
  
  self:setup_spritebatch()
  
end

function DISP:draw(displacement_canvas)
  love.graphics.setCanvas(displacement_canvas)
  love.graphics.clear()
  love.graphics.draw(self.texture, -16, -16, 0)
  love.graphics.setCanvas()
end

function DISP:setup_spritebatch()
  
  local w, h = 960/self.t_scale, 540/self.t_scale
  self.texture:clear()
  
  for x = 0, math.floor(w/16) + 1 do
    for y = 0, math.floor(h/16) + 1 do
      local xp = self.x_pos + (x * 16)
      local yp = self.y_pos + (y * 16)
      self.texture:add(xp, yp)
    end
  end
  
  self.texture:flush()
  
end

return DISP