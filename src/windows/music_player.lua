local CONTENTS = {
  tracks = { "music_1", "music_2", "music_3" },
  track_titles = { "[November 2013]", "[Buny's Breakfast]", "[A Science afFair]" },
  curr_track = 2,
  absolute_pos = { x = 0, y = 0 },
  buttons = { 
    {text = "VOL--", val = -0.25, coords = { x = 0, y = 1} },
    {text = "VOL++", val =  0.25, coords = { x = 0, y = 1} } 
  }
}

function CONTENTS:update(position)
  
  self.curr_track = MUSIC.curr_track
  self.absolute_pos = position
  
end

function CONTENTS:click(mouse_pos)
  
  for k, v in ipairs(self.tracks) do
    local y_off = ((k - 1) * 20) + self.absolute_pos.y + 20
    if mouse_pos.y > y_off and mouse_pos.y < y_off + 20 then
      MUSIC.play(k)
      return
    end
  end
  
  for k, v in ipairs(self.buttons) do
    if mouse_pos.x > v.coords.x and mouse_pos.x < v.coords.x + 40 then
      if mouse_pos.y > v.coords.y and mouse_pos.y < v.coords.y + 20 then
        MUSIC.change_volume(v.val)
      end
    end
  end
  
end

function CONTENTS:draw(x, y, size)
  
  local width = (size.w * 20) + 14
  for k, v in ipairs(self.tracks) do
    local y_off = ((k - 1) * 20) + y
    if self.curr_track == k then
      love.graphics.setColor( 0, 0, 0, 1 )
      love.graphics.rectangle("fill", x - 1, y_off, width, 20 )
      love.graphics.setColor( 1, 1, 1, 1 )
    end
    love.graphics.print(self.track_titles[k], x, y_off)
  end
  
    
  local button_y = ((size.h - 1) * 20) + y
  
  -- Draw the volume meter
  local volume_scale = MUSIC.curr_volume/3.0
  local rect_width   = math.floor(width * volume_scale)
  love.graphics.setColor( 0.1, 0.5, 0.4, 1 )
  love.graphics.rectangle("fill", x - 1, button_y - 2, rect_width ,20)
  love.graphics.setColor( 1, 1, 1, 1 )
  
  for k, v in ipairs(self.buttons) do
    local x = x + ((k - 1) * 80)
    love.graphics.print(v.text, 40 + x, button_y)
    v.coords.x = 40 + x
    v.coords.y = button_y
  end
  
end

return CONTENTS