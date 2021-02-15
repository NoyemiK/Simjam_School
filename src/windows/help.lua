local CONTENTS = {
  pages = {
    "--INTRO--\n\n  Welcome to [School]! Your mission, should you choose to accept it, is to observe your student as they grow and mature into the person they'll be for the rest of their young adult life.\n\n  You can just sit back and watch if you want, or you could tweak knobs in the [TIME MANAGEMENT] program in order to change how your student manages their time.",
    "--ATTENDANCE--\n\n  Make sure that you stay in school at least 60% of the time! If you cut class a bit too much (maybe to get a little bit of last minute work in on that project) you might find yourself having a bad time.\n\n  That bad time is getting expelled, mind.",
    "--PROJECTS--\n\n  If certain conditions are met, you can embark on a project through the [TIME MANAGEMENT] program. This is the very essence of keeping yourself occupied and getting real work done between the grind of school.\n\n  You might even get more opportunities in your University years if you have enough projects under your belt.",
    "--CHEER--\n\n  A happy student makes a lot of progress in creative endeavours. If you want to be stuck in a slog where you barely make any progress, then keeping cheer at rock-bottom is for you!\n\n  If you keep it above average, you will make the progress you expect on any project.",
    "--CONTROLS--\n\n[F1] Music Volume Down\n[F2] Music Volume Up\n[F5] Toggle Fullscreen\n[, OR numpad -] Lower simulation speed\n[. OR numpad +] Raise simulation speed\n[SPACE] Pause/unpause simulation"
  },
  curr_page = 1,
  absolute_pos = { x = 0, y = 0 },
  buttons = { 
    {text = "{-- PREV", val = -1, coords = { x = 0, y = 1} },
    {text = "NEXT --}", val =  1, coords = { x = 0, y = 1} } 
  }
}

function CONTENTS:update(position)
  
  self.absolute_pos = position
  
end

function CONTENTS:click(mouse_pos)
  
  for k, v in ipairs(self.buttons) do
    if mouse_pos.x > v.coords.x and mouse_pos.x < v.coords.x + 64 then
      if mouse_pos.y > v.coords.y and mouse_pos.y < v.coords.y + 20 then
        self:flip_page(v.val)
      end
    end
  end
  
end

function CONTENTS:draw(x, y, size)
  
  local width = (size.w * 20) + 14
  love.graphics.printf(self.pages[self.curr_page], x, y, width - 2)
  
  local button_y = ((size.h - 2) * 20) + y
  for k, v in ipairs(self.buttons) do
    local x = x + ((k - 1) * 80)
    love.graphics.print(v.text, 40 + x, button_y)
    v.coords.x = 40 + x
    v.coords.y = button_y
  end
  
end

function CONTENTS:flip_page(val)
  
  self.curr_page = self.curr_page + val
  
  if self.curr_page < 1 or self.curr_page > #self.pages then
    self.curr_page = self.curr_page - val
  end
  
end

return CONTENTS