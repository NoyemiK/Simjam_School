local CONTENTS = {
  icons = love.graphics.newImage("assets/timepiece.png"),
  absolute_pos = { x = 0, y = 0 },
  buttons = {
    study = {
      {text = "T--", val = -1, coords = { x = 0, y = 0 } },
      {text = "T++", val =  1, coords = { x = 0, y = 0 } }
    },
    school = {
      {text = "T--", val = -1, coords = { x = 0, y = 0 } },
      {text = "T++", val =  1, coords = { x = 0, y = 0 } }
    },
    social = {
      {text = "T--", val = -1, coords = { x = 0, y = 0 } },
      {text = "T++", val =  1, coords = { x = 0, y = 0 } }
    },
    projects = {
      {text = "T--", val = -1, coords = { x = 0, y = 0 } },
      {text = "T++", val =  1, coords = { x = 0, y = 0 } }
    }
  },
  project_buttons = {}
}

local mg_keys = {
  "study",
  "school",
  "social",
  "projects",
  "free"
}

local key_size = {
  80,
  80,
  80,
  80,
  280
}

function CONTENTS:update(position)
  
  local pos_delta_x = (self.absolute_pos.x - position.x)
  local pos_delta_y = (self.absolute_pos.y - position.y)
  self.project_list = {}
  self.management = GAME.player.time_management
  
  if not GAME.player.projects[1] then
    self.project_list = GAME.available_projects
    
    for i = 1, #self.project_list do
      local d_y = position.y + 40 + ((i - 1) * 16)
      self.project_buttons[i] = {
        text = "START",
        coords = { x = position.x + 186, y = d_y + 16 },
        dimensions = { w = 20, h = 14}
      }
    end
  end
  
  if pos_delta_x == 0 and pos_delta_y == 0 then return end
  
  self.absolute_pos.x = position.x
  self.absolute_pos.y = position.y
  for i = 1, (#mg_keys - 1) do
    local key = mg_keys[i]
    local d_x = position.x + 8 + key_size[i]
    local d_y = position.y + ((i - 1) * 42) + 40
    self.buttons[key][1].coords.x = d_x
    self.buttons[key][1].coords.y = d_y
    self.buttons[key][2].coords.x = d_x + 40
    self.buttons[key][2].coords.y = d_y
  end
  
end

function CONTENTS:click(mouse_pos)
  
  local b_width = 32
  for i = 1, (#mg_keys - 1) do
    local key = mg_keys[i]
    local buttons = self.buttons[key]
    for k,v in ipairs(buttons) do
      if mouse_pos.x > v.coords.x and mouse_pos.x < v.coords.x + 32 then
        if mouse_pos.y > v.coords.y and mouse_pos.y < v.coords.y + 20 then
          self.modify_time(key, v.val)
        end
      end
    end
  end
  
  for i = 1, #self.project_list do
    local button = self.project_buttons[i]
    if not button then break end
    if mouse_pos.x > button.coords.x and mouse_pos.x < button.coords.x + button.dimensions.w then
      if mouse_pos.y > button.coords.y and mouse_pos.y < button.coords.y + button.dimensions.h then
        table.insert(GAME.player.projects, GAME.available_projects[i])
        GAME.player.time_management.projects = GAME.player.management_memory
        GAME.player.time_management.free = GAME.player.time_management.free - GAME.player.management_memory
        GAME.player.management_memory = 0
        self.project_buttons = {}
        self.project_list = {}
      end
    end
  end
  
end

function CONTENTS:draw(x, y)
  
  if not self.management then return end
  local project = GAME.player.projects[1]
  
  for i = 1, #mg_keys do
    local key = mg_keys[i]
    local k_p = string.upper(key)
    local d_x = x + 2
    local d_y = y + ((i - 1) * 42)
    love.graphics.print(k_p..": ", d_x, d_y)
    love.graphics.setColor( 0.13, 0.1, 0.12 )
    love.graphics.rectangle("fill", d_x, d_y + 20, key_size[i], 20)
    if i < #mg_keys then
      love.graphics.setColor( 0.56, 0.40, 0.48 )
      love.graphics.rectangle("line", d_x + 80, d_y + 20, 32, 20)
      love.graphics.rectangle("line", d_x + 80 + 40, d_y + 20, 32, 20)
    end
    love.graphics.setColor( 1, 1, 1 )
    if self.buttons[key] then
      local dec_button = self.buttons[key][1]
      local inc_button = self.buttons[key][2]
      love.graphics.print(dec_button.text, dec_button.coords.x, dec_button.coords.y + 2)
      love.graphics.print(inc_button.text, inc_button.coords.x, inc_button.coords.y + 2)
    end
    for i = 1, self.management[key] do
      local x = ((i - 1) * 20) + d_x
      local y = d_y + 20
      love.graphics.draw(self.icons, x, y)
    end
  end
  
  if project then
    local progress = project.progress or 0
    local fmted_string = "["..project.name.."]\n"..project.desc.."\nPROGRESS: "..progress.."/"..project.completion_time
    love.graphics.printf(fmted_string, x + 162, y + 20, 334)
  else
    if not self.project_list then
      return
    else
      local pjstring = "AVAILABLE PROJECTS:\n"
      for k,v in ipairs(self.project_list) do
        pjstring = pjstring.."  ["..v.name.."]\n"
        local button = self.project_buttons[k]
        love.graphics.setColor( 0.56, 0.40, 0.48 )
        love.graphics.rectangle("line", button.coords.x, button.coords.y, button.dimensions.w, button.dimensions.h)
        love.graphics.setColor( 1, 1, 1 )
      end
      love.graphics.printf(pjstring, x + 200, y + 20, 296)
    end
  end
  
end

function CONTENTS.modify_time(key, amount)
  
  local time_management = GAME.player.time_management
  GAME.player.management_memory = 0
  local new_val  = time_management[key] + amount
  local new_free = time_management.free - amount
  
  -- Escape this function if there's not enough free time or it goes past the bounds.
  if new_val < 0 then return end
  if new_val > 4 then return end
  if new_free < 0 then return end
  -- Escape this function if the key is "projects" and the student doesn't have a project
  if key == "projects" and #GAME.player.projects < 1 then return end
  
  SYSTEM:play_sfx("confirm")
  GAME.player.time_management[key] = new_val
  GAME.player.time_management.free = new_free
  
end

return CONTENTS