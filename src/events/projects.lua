local PROJECTS = {
  {
    name = "Miscellaneous Crafts",
    desc = "Spend a few weeks sinking time into various crafts to find out what you like to do.",
    conditions = {
      GAME_TIME = { week = 3, year = 1 },
    },
    completion_time = 14,
    repeat_flag = true
  },
  {
    name = "Programming Projects",
    desc = "Spend a few weeks coding up a storm. Who knows, maybe you'll get a game engine at some point...?",
    conditions = {
      GAME_TIME = { week = 40, year = 1 },
      PLAYER_TRAIT = { PROGRAMMER = 1 }
    },
    completion_time = 28,
    repeat_flag = true,
    reward = "PROGRAMMER"
  },
  {
    name = "Make a Game",
    desc = "Now that you have an engine running, it's time to make a game.",
    conditions = {
      GAME_TIME = { week = 35, year = 2 },
      PLAYER_TRAIT = { PROGRAMMER = 3 }
    },
    completion_time = 34,
    repeat_flag = true,
    reward = "GAMEDEV"
  },
  
  -- T. Vandross's project tree
  {
    name = "Basic Cooking",
    desc = "You'll learn how to make stir-fry and basic pasta dishes, and get them right every time.",
    conditions = {
      GAME_TIME = { week = 6, year = 1 },
      PLAYER_PERFORMANCE = { SOCIAL = 3, ACADEMICS = 2 },
      PLAYER_ID = 1,
    },
    completion_time = 30,
    reward = "COOK",
    event = "COOKING1"
  },
  {
    name = "Intermediate Cooking",
    desc = "Now you'll learn what goes into making a real meal. The kind of meal you serve on holidays.",
    conditions = {
      GAME_TIME = { week = 22, year = 2 },
      PLAYER_PERFORMANCE = { SOCIAL = 5, ACADEMICS = 3, CREATIVITY = 20 },
      PLAYER_ID = 1,
      PLAYER_TRAIT = { COOK = 1, ARTIST = 1 }
    },
    completion_time = 35,
    reward = "COOK",
    event = "COOKING2"
  },
  {
    name = "Advanced Cooking",
    desc = "Do you want to BE cooking? A food elemental, even? You're going to want to finish this project then&",
    conditions = {
      GAME_TIME = { week = 15, year = 3 },
      PLAYER_PERFORMANCE = { SOCIAL = 15, ACADEMICS = 12, CREATIVITY = 50 },
      PLAYER_ID = 1,
      PLAYER_TRAIT = { COOK = 2 }
    },
    completion_time = 35,
    reward = "COOK",
    event = "COOKING3"
  },
  
  -- D. Nail's project tree
  {
    name = "Digital Necromancy, Pt. 1",
    desc = "In this brave new world of computers and other stuff, someone has to teach the next generation how to revive the digital dead.",
    conditions = {
      GAME_TIME = { week = 8, year = 1 },
      PLAYER_PERFORMANCE = { ACADEMICS = 5 },
      PLAYER_ID = 2,
    },
    completion_time = 30,
    reward = "AUTHOR",
    event = "DIGINOM1"
  },
  {
    name = "Digital Necromancy, Pt. 2",
    desc = "In this brave new world of computers and other stuff, someone has to teach the next generation how to revive the digital dead.",
    conditions = {
      GAME_TIME = { week = 30, year = 2 },
      PLAYER_PERFORMANCE = { ACADEMICS = 10 },
      PLAYER_ID = 2,
      PLAYER_TRAIT = { AUTHOR = 1, PROGRAMMER = 1 }
    },
    completion_time = 32,
    reward = "AUTHOR",
    event = "DIGINOM2"
  },
  {
    name = "Digital Necromancy, Pt. 3",
    desc = "In this brave new world of computers and other stuff, someone has to teach the next generation how to revive the digital dead. The final chapter...",
    conditions = {
      GAME_TIME = { week = 8, year = 3 },
      PLAYER_PERFORMANCE = { ACADEMICS = 30, CREATIVITY = 22 },
      PLAYER_ID = 2,
      PLAYER_TRAIT = { AUTHOR = 2, COMPSCI = 1 }
    },
    completion_time = 50,
    reward = "AUTHOR",
    event = "DIGINOM3"
  },
  
  -- Student-agnostic projects
  -- Programming base projects
  {
    name = "Hello, world!",
    desc = "Learn to Code. At the end of this, you'll probably have a text game.",
    conditions = {
      GAME_TIME = { week = 30, year = 1 },
      PLAYER_PERFORMANCE = { ACADEMICS = 15 },
    },
    completion_time = 20,
    reward = "PROGRAMMER"
  },
  {
    name = "Helloer, worlder!",
    desc = "You kinda know what big O is, but you'll only REALLY know after this, probably.",
    conditions = {
      GAME_TIME = { week = 15, year = 2 },
      PLAYER_PERFORMANCE = { ACADEMICS = 15, CREATIVITY = 10 },
      PLAYER_TRAIT = { PROGRAMMER = 1 }
    },
    completion_time = 48,
    reward = "COMPSCI"
  },
  
  -- Art base projects
  {
    name = "The Fundamentals of Art",
    desc = "How does art? Well, finding out will probably be painful.",
    conditions = {
      GAME_TIME = { week = 6, year = 1 },
      PLAYER_PERFORMANCE = { ACADEMICS = 5, CREATIVITY = 5 },
    },
    completion_time = 20,
    reward = "ARTIST"
  },
  {
    name = "Explorations in Art",
    desc = "You have a basic foundation for what you need to do, to Art. But there's more to art than just being good or bad, there is also a world of context.",
    conditions = {
      GAME_TIME = { week = 15, year = 2 },
      PLAYER_PERFORMANCE = { CREATIVITY = 14 },
      PLAYER_TRAIT = { ARTIST = 1 }
    },
    completion_time = 35,
    reward = "ARTIST"
  }
}

function PROJECTS:check_available(curr_time, player)
  
  if #player.projects > 1 then return {} end -- Don't go through all this rigmarole if a project is underway
  
  local available_projects = {}
  for k, v in ipairs(self) do
    
    local time_check        = v.conditions.GAME_TIME
    local performance_check = v.conditions.PLAYER_PERFORMANCE or player.stats.performance
    local id_check          = v.conditions.PLAYER_ID or player.student_id
    local trait_check       = v.conditions.PLAYER_TRAIT or player.traits
    local performance_passed = false
    local trait_passed       = true
    
    if not v.completed then
      -- See if the player meets the performance requirements. If no requirements are specified, it defaults to
      -- comparing the player's stats against... well, the player's own stats.
      for key, x in pairs(performance_check) do
        if player.stats.performance[key] >= x then
          performance_passed = true
        else
          performance_passed = false
          break
        end
      end
      
      for key, x in pairs(trait_check) do
        if player.traits[key] and player.traits[key] >= x then
          trait_passed = true
        else
          trait_passed = false
          break
        end
      end
      
      if curr_time.week >= time_check.week and curr_time.year >= time_check.year then
        if id_check == player.student_id then
          if performance_passed and trait_passed then
            table.insert(available_projects, v)
          end
        end
      end
    end
    
  end

  return available_projects
  
end

function PROJECTS:tick_project(project, amount, cheer)
  
  local player = GAME.player
  local base_amount = amount/4
  
  -- Change the level of project progress if cheer is low
  if cheer < 5 then
    local cheer_coefficients = {
      0.10, 0.25, 0.5, 0.75
    }
    local cheer_index = math.floor(cheer)
    base_amount = base_amount * cheer_coefficients[cheer_index]
  end
  if not project.progress then project.progress = 0 end
  project.progress = project.progress + base_amount
  
  if project.progress >= project.completion_time then
    table.remove(player.projects)
    if project.reward then
      player:add_trait(project.reward)
    end
    if not project.repeat_flag then
      project.completed = true
    end
    project.progress = 0
    player.management_memory = player.time_management.projects
    player.time_management.free = player.time_management.free + player.time_management.projects 
    player.time_management.projects = 0
    if project.event then GAME:push_event(project.event) end
    return
  end
  
end

function PROJECTS:restart()
  
  for k,v in ipairs(self) do
    self[k].completed = false
  end

end

return PROJECTS