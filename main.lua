--[[
|==========================================
| SCHOOL ♥♥
|   by: Noyemi K/Delmunsoft
|   began: 1 May, 2020
|==========================================
]]

function love.load()
  textfont = love.graphics.newImageFont("assets/ENFontHalf.png", " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!?.,';:$%-+/()[]{}&~_")
  love.graphics.setFont(textfont)
  love.graphics.setBackgroundColor(0.09, 0.03, 0.04)
  love.mouse.setVisible( false )
  _DEBUG = false
  
  GAME      = require("src/GAME")
  SYSTEM    = require("src/SYSTEM")
  MUSIC     = require("src/MUSIC")
  INTERFACE = require("src/INTERFACE")
  INTERFACE:init()
  
  LOGO = love.graphics.newImage("assets/logo.png")
  MUSIC.play()
  
  GAME.map:init()
  GAME.player:init()
  GAME.player:draw_stats()
  GAME.event_window = INTERFACE.windows[5]
  GAME.exit_window = INTERFACE.windows[6]
  love.graphics.setLineStyle("rough")
end

local accumulator = 0.0
local tick_period = 1/60
local scrolling_bg = require("src/scrolling_bg")
local mouse_pos = { x = 0, y = 0 }

function love.update(dt)
  
  accumulator = accumulator + dt
  if accumulator < tick_period then
    return
  end
  accumulator = accumulator - tick_period
  
  -- Transform absolute screen mouse coords to scaled ones
  mouse_pos = SYSTEM.transform_mouse_position()
  
  scrolling_bg.update()
  INTERFACE:update(mouse_pos)
  GAME:update()
  
  function love.keypressed(key)
    if key == 'f5' then
      SYSTEM.set_fullscreen()
      GAME.player:draw_stats()
    elseif key == 'f1' then
      MUSIC.change_volume(-0.25)
    elseif key == 'f2' then
      MUSIC.change_volume(0.25)
    end
    GAME:key_handler(key)
  end
  
  function love.mousepressed( mx, my, button )
    if button == 1 then
      INTERFACE:click( mouse_pos )
    end
  end
  
end

local singen = 0

function love.draw()
  
  local sys_scale = SYSTEM.scale
  local sys_origin = SYSTEM.origin
  local sys_cursor = SYSTEM.cursor
  local mouse_pos = mouse_pos
  local syscanvas = SYSTEM.canvas
  local interface = INTERFACE
  
  singen = singen + love.timer.getDelta()
  if singen > math.pi * 2 then
    singen = 0
  end
  
  love.graphics.setCanvas(syscanvas)
  love.graphics.clear()
  do
    
    local logo = LOGO
    scrolling_bg.draw()
    love.graphics.draw(logo, 960 - 288, 540 - 128)
    GAME.map:draw()
    interface:draw()
    
    -- Debug stuff
    if _DEBUG then
      local debug_string = "FPS: "..tostring(love.timer.getFPS()).."\nMOUSE X,Y: "..mouse_pos.x..".."..mouse_pos.y.."\nORIGIN X,Y: "..sys_origin.x..".."..sys_origin.y
      love.graphics.print(debug_string, 0, 0)
    end
    GAME:draw()
    
    -- Cursor
    love.graphics.draw(sys_cursor, mouse_pos.x, mouse_pos.y)
    
  end
  love.graphics.setCanvas()
  
  love.graphics.draw(syscanvas, sys_origin.x, sys_origin.y, 0, sys_scale, sys_scale)
  
end
