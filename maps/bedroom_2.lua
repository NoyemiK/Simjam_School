return {
  version = "1.2",
  luaversion = "5.1",
  tiledversion = "1.3.1",
  orientation = "isometric",
  renderorder = "right-down",
  width = 9,
  height = 7,
  tilewidth = 64,
  tileheight = 32,
  nextlayerid = 3,
  nextobjectid = 1,
  properties = {},
  tilesets = {
    {
      name = "tileset",
      firstgid = 1,
      tilewidth = 64,
      tileheight = 128,
      spacing = 0,
      margin = 0,
      columns = 8,
      image = "../assets/tileset.png",
      imagewidth = 512,
      imageheight = 640,
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 64,
        height = 128
      },
      properties = {},
      terrains = {},
      tilecount = 40,
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      id = 1,
      name = "Tile Layer 1",
      x = 0,
      y = 0,
      width = 9,
      height = 7,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 7, 8, 8, 6, 6, 6, 6,
        0, 13, 11, 11, 11, 11, 11, 11, 11,
        15, 9, 10, 9, 9, 9, 12, 12, 12,
        16, 12, 12, 12, 12, 12, 0, 0, 0,
        16, 1, 1, 1, 1, 3, 4, 0, 0,
        14, 1, 1, 1, 1, 3, 4, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      id = 2,
      name = "Tile Layer 2",
      x = 0,
      y = 0,
      width = 9,
      height = 7,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        0, 38, 0, 0, 0, 36, 0, 0, 0,
        0, 0, 0, 26, 0, 32, 0, 0, 20,
        0, 0, 25, 0, 0, 0, 0, 19, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 28, 0, 0, 0, 0, 0, 0,
        0, 27, 0, 0, 0, 0, 0, 0, 0
      }
    }
  }
}
