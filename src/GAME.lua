local GAME = {
  speeds     = { "PAUSE", 1, 2, 8, 16 }, -- speeds are in ticks/second
  curr_speed = 1,
  time   = { quarter = 1, day = 1, week = 1, year = 1 },
  map    = require("src/map"),
  player = require("src/player"),
  time_window = love.graphics.newImage("assets/time_window.png"),
  projects = require("src/events/projects"),
  events   = require("src/events/events"),
  available_projects = {},
  event_queue = {}
}

local accumulator = 0
local s_memory = 2

function GAME:update()

  local speed = self.speeds[self.curr_speed]
  if speed == "PAUSE" then return end
  accumulator = accumulator + 1
  if accumulator < (60/speed) then return end
  accumulator = 0
  
  self:tick_time()
  self.player:draw_stats()
  self:tick_event_queue()
  
end

function GAME:tick_time()
  
  self.time.quarter = self.time.quarter + 1
  self.player:tick_attributes()
  if self.time.quarter > 4 then
    self.time.quarter = 1
    self.time.day = self.time.day + 1
    self.player:tick_project()
    self.available_projects = self.projects:check_available(self.time, self.player)
  end
  if self.time.day > 7 then
    self.time.day = 1
    self.time.week = self.time.week + 1
    self.player:tick_performance()
    if self.player.stats.attributes.ATTENDANCE < 5.5 then
      self:push_event("END_FAIL")
      self:restart()
    end
  end
  if self.time.week > 52 then
    self.time.week = 1
    self.time.year = self.time.year + 1
  end
  if self.time.year >= 4 then
    self:push_event(self.player:calc_ending())
    self:restart()
  end

end

function GAME:push_event(idx)
  
  local event = self.events.database[idx]
  table.insert(self.event_queue, 1, event)
  
end

function GAME:tick_event_queue()
  
  if not self.event_queue[1] then return end
  
  -- Hold on and don't process the next event in the queue
  if self.event_window.active then return end
  
  -- Pause the game and send the event in the last position to the event window
  local event_idx = #self.event_queue
  accumulator = 0
  self.curr_speed = 1
  self.event_window.contents:push_event(self.event_queue[event_idx], self.event_window)
  table.remove(self.event_queue, event_idx)
  
end

function GAME:key_handler(key)
  
  if key == "space" then
    self:pause()
    
  elseif key == "." or key == "kp+" then
    if self.curr_speed == 1 then return end -- break out of this if the game is already paused
    self.curr_speed = self.curr_speed + 1
    if self.curr_speed > #self.speeds then self.curr_speed = #self.speeds end
    s_memory = self.curr_speed
    
  elseif key == "," or key == "kp-" then
    if self.curr_speed == 1 then return end -- break out of this if the game is already paused
    self.curr_speed = self.curr_speed - 1
    if self.curr_speed < 2 then self.curr_speed = 2 end
    s_memory = self.curr_speed
    
  elseif key == "`" then
    _DEBUG = not _DEBUG
  elseif key == "escape" then
    if not self.exit_window.active then
      self.curr_speed = 1
      self.exit_window.contents:push(self.exit_window)
    end
  end
  
end

function GAME:pause()
  
  if self.curr_speed == 1 then
    self.curr_speed = s_memory
  else
    s_memory = self.curr_speed
    self.curr_speed = 1
  end
  
end

function GAME:restart()
  self.player:init()
  self.projects:restart()
  self.time = { quarter = 1, day = 1, week = 1, year = 1 }
  self.player:draw_stats()
  self.available_projects = self.projects:check_available(self.time, self.player)
end

function GAME:draw()
  
  local speed = self.speeds[self.curr_speed]
  local height = SYSTEM.normal_height
  local time_string  = "[Day "..self.time.day.." of week "..self.time.week.."], YEAR "..self.time.year.."\nSPEED ["..speed.."]"
  love.graphics.draw(self.time_window, 0, height - 34)
  love.graphics.print(time_string, 2, height - 32)
  
end

return GAME