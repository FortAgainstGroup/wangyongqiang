local Bullet = class("Bullet", function()
    return display.newScene("Bullet")
end)
function Bullet:ctor()
	self._speed = GameBullet.speed
	self._r = GameBullet.r
end
function Bullet:init(node,pos,power,angle)
	self._img = display.newSprite(node.name)
	self._scale = node.scale
	self:setScale(self._scale)
	self._r = node.radius
    self:setAnchorPoint(ccp(0,0))
    self:addChild(self._img)

    self._speedX = cos(angle)*self._speed 
    self._speedY = sin(angle)*self._speed
    self:setPosition(pos)
    self:setRotation(angle+90)
    self._ATK = power
   -- self._camp = camp
    self._lifedistance = 0  -----shecheng
    self._state = State.move
end
function Bullet:update()
	print(self._speedX)
	if(self._lifedistance>= GameFort.SD)then
		self:setState(State.null)
	end
    if self._state == State.move then
		moveCCnode(self, self._speedX, self._speedY)	
		self._lifedistance = self._lifedistance + self._speed	
		--self:hitUnit()
		if not hitR2P(GameData.rectScreen, self:getPositionInCCPoint()) then		
			self:setState(State.null)
		end
	elseif self._state == State.null then
		return true
	end
end
function Bullet:setState(state)
	self._state = state
	if(state == State.null)then
		return true
	end
end
-- function Bullet:hitUnit()
-- 	for i,unit in ipairs( self._camp.enemyUnit) do
-- 			local distance = getDistance(self,unit)
-- 			if distance < self._r + unit._r then
-- 				--unit._life = unit._life - self._ATK
-- 				print("iii")
-- 				self:setState(State.null)
-- 				return true
-- 		end
-- 	end
-- 	return false
-- end
return Bullet