local INTERFACE = {
  image = love.graphics.newSpriteBatch(love.graphics.newImage("assets/ui_skin.png"), 500, "stream"),
  desktop_icons = love.graphics.newImage("assets/desktop_icons.png"),
  desktop_quads = {},
  sprites = {
    window = {}, button_up = {},
    button_down = {}, button_decoration = {}
  },
  windows = {
    require("src/windows/base_window").new(1, nil, { w = 30, h = 13 }, "STATS.SGF", "stats"),
    require("src/windows/base_window").new(2, { x = 86, y = 50 }, { w = 24, h = 12 }, "TIMEMGMT.SGF", "time_management"),
    require("src/windows/base_window").new(3, { x = 850,y = 0 }, { w = 12, h = 5 }, "MUS_PLAY.SGF", "music_player"),
    require("src/windows/base_window").new(4, { x = 240, y = 80}, { w = 14, h = 14 }, "HELP.MAN", "help" ),
    require("src/windows/base_window").new(5, { x = 120, y = 80}, { w = 16, h = 14 }, "--MESSAGE--", "event", false ),
    require("src/windows/base_window").new(6, { x = 350, y = 110}, { w = 10, h = 6 }, "QUIT", "quit", false )
  },
  captured = false,
}

function INTERFACE:init()
  
  -- (square) dimension of each sprite
  local s_dim = 20 
  -- Get the window quads
  for i = 1, 9 do
    local x = math.floor((i - 1) % 3) * s_dim
    local y = math.floor((i - 1) / 3) * s_dim
    self.sprites.window[i] = love.graphics.newQuad( x, y, s_dim, s_dim, 60, 120 )
  end
  
  local b_types = { "normal", "decrement", "increment" }
  
  for i = 1, 3 do
    local x = (i - 1) * s_dim
    self.sprites.button_up[i]   = love.graphics.newQuad( x, 60, s_dim, s_dim, 60, 120 )
    self.sprites.button_down[i] = love.graphics.newQuad( x, 80, s_dim, s_dim, 60, 120 )
    self.sprites.button_decoration[b_types[i]] = love.graphics.newQuad( x, 100, s_dim, s_dim, 60, 120 )
  end
  
  for i = 1, 4 do
    local x = (i - 1) * 64
    self.desktop_quads[i] = love.graphics.newQuad( x, 0, 64, 64, 256, 64 )
  end
  
end

function INTERFACE:update(mouse_pos)
  
  for i = #self.windows, 1, -1 do
    self.windows[i]:update(mouse_pos)
  end
  
end

function INTERFACE:click(mouse_pos)
  
  for i = #self.windows, 1, -1 do
    self.windows[i]:click(mouse_pos)
    if self.captured then break end
  end
  
  for i = 1, #self.windows do
    if self.captured then break end
    if self.windows[i].icon then
      self.windows[i].icon:click(mouse_pos)
    end
  end
  
  self.captured = false
  
end

-- TODO: make this non-debug
function INTERFACE:draw()
  
  for i = 1, #self.windows do
    if self.windows[i].icon then
      self.windows[i].icon:draw()
    end
  end
  
  for i = 1, #self.windows do
    self.windows[i]:draw()
  end
  
end

function INTERFACE:draw_window(x, y, wd, ht, title)
  
  local t = title or "A:/USR/home"
  local num = 20
  
  --
  --  This is the window skin itself
  --
  
  --  Window Body
  self.image:clear()
  
  for v = 1, ht - 1 do
    for h = 1, wd - 1 do
      self.image:add(self.sprites.window[5], x + (h*num), y + (v*num))
    end
  end
  
  --  Window Borders
  for v = 1, ht - 1 do
    self.image:add(self.sprites.window[4], x, y + (v * num))
    self.image:add(self.sprites.window[6], x + (wd * num), y + (v * num))
  end
  
  for h = 1, wd - 1 do
    self.image:add(self.sprites.window[2], x + (h * num), y)
    self.image:add(self.sprites.window[8], x + (h * num), y + (ht * num))
  end
  
  --  Window Corners
  self.image:add(self.sprites.window[1], x, y)
  self.image:add(self.sprites.window[3], x + (wd * num) , y)
  self.image:add(self.sprites.window[7], x, y + (ht * num))
  self.image:add(self.sprites.window[9], x + (wd * num), y + (ht * num))
  
  self.image:flush()
  
  love.graphics.draw(self.image, 0, 0)
  
  --  Draw the title
  love.graphics.setColor(0,0,0,1)
  love.graphics.print(t, x + 20, y + 2)
  love.graphics.setColor(1,1,1,1)
  
end

function INTERFACE:sort_windows(id)
  
  local temp = self.windows[id]
  table.remove(self.windows, id)
  table.insert(self.windows, temp)
  for k,v in ipairs(self.windows) do
    v.id = k
  end
  return
  
end

return INTERFACE