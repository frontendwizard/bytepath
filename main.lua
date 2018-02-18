_ = require 'libraries.moses.moses'
Object = require 'libraries.classic.classic'
Input = require 'libraries.boipushy.Input'
Timer = require 'libraries.chrono.Timer'
Camera = require 'libraries.stalker-x.Camera'
Physics = require 'libraries.windfield'
require 'objects.GameObject'

require 'utils'

function requireFiles(files)
  for _, file in ipairs(files) do
    local file = file:sub(1, -5)
    require(file)
  end
end

function recursiveEnumerate(folder, file_list)
  local items = love.filesystem.getDirectoryItems(folder)
  for _, item in ipairs(items) do
    local file = folder .. '/' .. item
    if love.filesystem.isFile(file) then
      table.insert(file_list, file)
    elseif love.filesystem.isDirectory(file) then
      recursiveEnumerate(file, file_list)
    end
  end
end

function resize(s)
  love.window.setMode(s*gw, s*gh)
  sx, sy = s, s
end

function love.load()
  love.graphics.setDefaultFilter('nearest')
  love.graphics.setLineStyle('rough')
  resize(2)
  
  -- globals
  input = Input()
  timer = Timer()
  camera = Camera()

  -- inputs
  input:bind('a', 'left')
  input:bind('d', 'right')

  -- loading objects
  local object_files = {}
  recursiveEnumerate('objects', object_files)
  requireFiles(object_files)
  
  -- rooms
  current_room = nil
  local room_files = {}
  recursiveEnumerate('rooms', room_files)
  requireFiles(room_files)

  -- initial room
  gotoRoom('Stage')

  -- leak tracking
  input:bind('f1', function()
    print("Before collection: " .. collectgarbage("count")/1024)
    collectgarbage()
    print("After collection: " .. collectgarbage("count")/1024)
    print("Object count: ")
    local counts = type_count()
    for k, v in pairs(counts) do print(k, v) end
    print("-------------------------------------")
  end)
end

function love.update(dt)
  timer:update(dt)
  camera:update(dt)
  if current_room then current_room:update(dt) end
end

function love.draw()
  if current_room then current_room:draw() end
end

function gotoRoom(room_type, ...)
  if current_room and current_room.destroy then current_room:destroy() end
  current_room = _G[room_type](...)
end
