local MAP = {
  image = love.graphics.newSpriteBatch(love.graphics.newImage("assets/tileset.png"), 150, "stream"),
  tiles = {},
  mapdata = {}
}

function MAP:init()
  
  for i = 1, 40 do
    local x = ((i - 1) % 8) * 64
    local y = (math.floor((i - 1) / 8)) * 128
    self.tiles[i] = love.graphics.newQuad(x, y, 64, 128, 512, 640)
  end
  
  self:load_mapdata()
  
end

function MAP:load_mapdata(mapname)
  
  local file = mapname or "bedroom_"..love.math.random(1, 3)
  local map_raw = require("maps/"..file)
  
  self.mapdata.width, self.mapdata.height = map_raw.width, map_raw.height
  self.mapdata.layer_1 = map_raw.layers[1].data
  self.mapdata.layer_2 = map_raw.layers[2].data
  self:setup_draw()
  
end

function MAP:draw()
  
  love.graphics.draw(self.image, 450, 60)
  
end

function MAP:setup_draw()
  
  self.image:clear()
  
  if not self.mapdata.layer_1 then return end -- Break out of the function if there's no map to draw
  
  local dimensions = self.mapdata.width * self.mapdata.height
  for i = 1, dimensions do
    local x = (i - 1) % self.mapdata.width
    local y = math.floor((i - 1) / self.mapdata.width)
    local iso_x = (x - y) * 32
    local iso_y = (x + y) * 16
    local quad = self.tiles[self.mapdata.layer_1[i]] or self.tiles[#self.tiles]
    
    self.image:add(quad, iso_x, iso_y)
  end
  for i = 1, dimensions do
    local x = (i - 1) % self.mapdata.width
    local y = math.floor((i - 1) / self.mapdata.width)
    local iso_x = (x - y) * 32
    local iso_y = (x + y) * 16
    local quad = self.tiles[self.mapdata.layer_2[i]] or self.tiles[#self.tiles]
    
    self.image:add(quad, iso_x, iso_y)
  end
  
  self.image:flush()
  
end

return MAP