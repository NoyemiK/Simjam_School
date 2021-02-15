local PLAYER = {
  image = love.graphics.newImage("assets/students.png"),
  quads = {},
  student_id = 1
}

function PLAYER:init()
  
  local init_args = {
    stats      = {
      name = "",
      age  = 14,
      bio  = "",
      bday = 25,
      attributes = {
        DILIGENCE  = 2,
        ATTENDANCE = 10,
        SOCIABILITY= 2,
        CHEER      = 5
      },
      performance = {
        ACADEMICS = 2,
        CREATIVITY= 2,
        SOCIAL    = 2
      },
      trait_list = {} -- Gives us a way to sort traits by which ones we received first
    },
    time_management = {
      study    = 2,
      school   = 4, -- YOU CAN'T CUT BACK ON ATTENDANCE! YOU WILL REGRET THIS!
      social   = 2,
      projects = 0,
      free     = 4
    },
    management_memory = 0,
    traits   = {},
    projects = {}
  }
  
  self.stats = init_args.stats
  self.time_management = init_args.time_management
  self.management_memory = init_args.management_memory
  self.traits = init_args.traits
  self.projects = init_args.projects
  
  local img_width = self.image:getPixelWidth()
  local num_quads = img_width/128
  for i = 1, num_quads do
    local x = (i - 1) * 128
    self.quads[i] = love.graphics.newQuad(x, 0, 128, 256, img_width, 256)
  end
  
  local name_table = {
    "T. Vandross",
    "D. Nail",
    "X. Talsoft"
  }
  local bio_table  = {
    "  A mild-mannered student who takes joy in lighthearted pranks.\n\n  Not as studious as the glasses and well-kept uniform would have you believe.",
    "  A young member of the prestigious Nail Clan of library goths.\n\n  Despite the destructive uniform alterations, D. Nail is actually known for closely following rules.",
    ""
  }
  local bday_table = {
    15,
    23,
    8
  }
  
  self.student_id = love.math.random(1, num_quads)
  self.stats.name = name_table[self.student_id] or name_table[#name_table]
  self.stats.bio  = bio_table[self.student_id] or bio_table[#bio_table]
  self.stats.bday = bday_table[self.student_id] or bday_table[#bday_table]
  
end

-- Simulation stuff

function PLAYER:tick_attributes()
  
  local management = self.time_management
  local value_couplings = {
    DILIGENCE  = (management.study + management.projects - 2.5)/40,
    ATTENDANCE = (management.school - 3.8)/40,
    SOCIABILITY= (management.social - 2.5)/40,
    CHEER      = ((management.free + (management.projects/2)) - 2.2)/20
  }
  
  for k, v in pairs(self.stats.attributes) do
    self.stats.attributes[k] = v + value_couplings[k]
    if self.stats.attributes[k] > 10 then self.stats.attributes[k] = 10 end
    if self.stats.attributes[k] < 1 then self.stats.attributes[k] = 1 end
  end
  
end

function PLAYER:tick_project()
  
  if not self.projects[1] then return end
  GAME.projects:tick_project(self.projects[1], self.time_management.projects, self.stats.attributes.CHEER)
  
end

function PLAYER:tick_performance()
  
  local performance_ratings = self.stats.performance
  local attributes = self.stats.attributes
  local value_couplings = {
    ACADEMICS = PLAYER.calc_academics(attributes.DILIGENCE, attributes.ATTENDANCE),
    CREATIVITY= PLAYER.calc_creativity(attributes.DILIGENCE, self.time_management.projects, attributes.CHEER),
    SOCIAL    = PLAYER.calc_social(attributes.SOCIABILITY, attributes.ATTENDANCE)
  }
  
  for k, v in pairs(performance_ratings) do
    performance_ratings[k] = v + value_couplings[k]
    if performance_ratings[k] > 50 then performance_ratings[k] = 50 end
    if performance_ratings[k] < 1 then performance_ratings[k] = 1 end
  end
  
  if GAME.time.week == self.stats.bday then
    self.stats.age = self.stats.age + 1
  end
  
end

function PLAYER:add_trait(trait)
  
  if not self.traits[trait] then
    self.traits[trait] = 1
    table.insert(self.stats.trait_list, trait)
    return
  end
  
  self.traits[trait] = self.traits[trait] + 1
  
end

function PLAYER.calc_academics(diligence, attendance)
  
  if attendance == 1 then return -3.5 end
  if diligence  == 1 then return -0.75 end
  
  local base_modifier = (attendance * diligence)/10
  local retval = (base_modifier - 4)/5
  return retval
  
end

function PLAYER.calc_creativity(diligence, project_time, cheer)
  
  if cheer == 1 then return -1.5 end
  if project_time == 0 then return -0.75 end
  
  local base_modifier = (diligence * project_time) + (cheer/10)
  local retval = (base_modifier - 4)/10
  return retval
  
end

function PLAYER.calc_social(sociability, attendance)
  
  if sociability == 1 then return -1.5 end
  local base_modifier = (sociability * (attendance/5))
  local retval = (base_modifier - 4)/10
  return retval
end

function PLAYER:calc_ending()
  
  local sum = 0
  for k,v in pairs(self.traits) do
    sum = sum + v
  end
  if sum > 5 then
    return "END_GOOD"
  else
    return "END_OK"
  end

end

-- Drawing stuff

local stat_canvas = love.graphics.newCanvas(620, 280)

function PLAYER:draw(x, y)
  
  love.graphics.draw(stat_canvas, x, y)
  
end

function PLAYER:draw_stats()
  
  love.graphics.setCanvas(stat_canvas)
  love.graphics.clear()
  local x = 0
  local y = 0
  local quad = self.quads[self.student_id]
  local attributes = self.stats.attributes
  local performance = self.stats.performance
  local attribute_order = {
    "DILIGENCE",
    "ATTENDANCE",
    "SOCIABILITY",
    "CHEER"
  }
  local performance_order = {
    "ACADEMICS",
    "CREATIVITY",
    "SOCIAL"
  }
  
  -- Draw the portrait and bio
  love.graphics.draw(self.image, quad, x, y)
  love.graphics.printf(
    "NAME: "..self.stats.name.."\n".."AGE: "..self.stats.age.."\nBIO:\n"..self.stats.bio,
    x + 130,
    y + 20,
    202
  )
  
  -- Draw the separator
  do
    local line_x = x + 130 + 202
    love.graphics.line(line_x, y, line_x, y + 256)
    x = line_x + 2
  end
  
  -- Draw the attribute stats
  love.graphics.print("[ATTRIBUTES]", x, y)
  for k,v in ipairs(attribute_order) do
    local printable_attribute = math.floor(attributes[v] * 10)/10
    love.graphics.print(v..": "..printable_attribute, x + 10, y + k * 20)
  end
  
  -- Draw the performance stats
  local p_y = y + (20 * (#attribute_order + 2)) 
  love.graphics.print("[PERFORMANCE]", x, p_y)
  for k,v in ipairs(performance_order) do
    local printable_performance = math.floor(performance[v] * 10)/10
    love.graphics.print(v..": "..printable_performance, x + 10, p_y + k * 20)
  end
  
  -- Draw Traits
  x = x + 150
  love.graphics.print("[TRAITS]", x, y)
  local trait_list = self.stats.trait_list
  if #trait_list > 0 then
    love.graphics.setColor( 0.3, 0.9, 1.0 )
    for k, v in ipairs(trait_list) do
      local printable_trait = v.." Lv"..self.traits[v]
      love.graphics.print(printable_trait, x + 10, y + k * 20)
    end
    love.graphics.setColor( 1, 1, 1 )
  end
  love.graphics.setCanvas()
  
end

return PLAYER