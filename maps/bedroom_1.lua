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
        0, 0, 0, 7, 8, 8, 8, 6, 0,
        0, 0, 15, 11, 11, 11, 11, 11, 0,
        0, 0, 16, 9, 9, 9, 9, 10, 0,
        0, 0, 14, 12, 12, 12, 12, 12, 0,
        0, 7, 5, 1, 1, 2, 1, 3, 4,
        15, 4, 4, 4, 1, 1, 1, 3, 4,
        14, 4, 4, 4, 1, 2, 1, 3, 4
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
        0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 31, 0, 0, 0, 0, 30,
        0, 0, 33, 0, 0, 0, 0, 29, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 22, 0, 0,
        35, 0, 0, 26, 0, 21, 0, 0, 0,
        0, 0, 25, 0, 0, 0, 0, 0, 0
      }
    }
  }
}
