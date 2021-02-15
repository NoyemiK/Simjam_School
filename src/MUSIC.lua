local MUSIC = {
  tracks = {
    love.audio.newSource("music/S_MUSIC1.it", "stream"),
    love.audio.newSource("music/S_MUSIC2.it", "stream"),
    love.audio.newSource("music/S_MUSIC3.it", "stream")
  },
  curr_track = love.math.random(1,3),
  curr_volume = 2.0
}

love.audio.setVolume(MUSIC.curr_volume)

function MUSIC.play(t)
  
  local mus = MUSIC
  local track = t or mus.curr_track
  
  mus.tracks[mus.curr_track]:stop()
  --mus.tracks[track]:setLooping(true) -- Not necessary because the loop macro is inside of the tracker file generally
  mus.tracks[track]:play()
  
  mus.curr_track = track
  
end

function MUSIC.change_volume(i)
  
  local change = i or 0
  local mus = MUSIC
  
  mus.curr_volume = mus.curr_volume + i
  
  if mus.curr_volume >= 3.0 then
    mus.curr_volume = 3.0
  elseif mus.curr_volume <= 0.0 then
    mus.curr_volume = 0.0
  end
  
  love.audio.setVolume(mus.curr_volume)
  
end

return MUSIC