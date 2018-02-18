Stage = Object:extend()

function Stage:new()
  self.area = Area(self)
  self.area:addPhysicsWorld()

  self.canvas = love.graphics.newCanvas(gw, gh)
  
  self.player = self.area:addGameObject('Player', gw/2, gh/2)
  input:bind('k', function() self.player.dead = true end)
end

function Stage:update(dt)
  self.area:update(dt)
  camera:follow(gw, gh)
  camera:setFollowLerp(0.2)
  camera:setFollowStyle('LOCKON')
end

function Stage:draw()
  love.graphics.setCanvas(self.canvas)
  love.graphics.clear()
    camera:attach(0, 0, gw, gh)
    self.area:draw()
    camera:detach()
  love.graphics.setCanvas()

  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.setBlendMode('alpha', 'premultiplied')
  love.graphics.draw(self.canvas, 0, 0, 0, sx, sy)
  love.graphics.setBlendMode('alpha')
end

function Stage:destroy()
  self.area:destroy()
  self.area = nil
end
