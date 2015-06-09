local Bullet = class("Bullet", function()
    return display.newScene("Bullet")
end)
function Bullet:ctor()
	self._speed = GameBullet.speed
end

--传入参数：单位属性，位置，攻击力，角度，射程，阵营
function Bullet:init(node,pos,power,angle,sd,camp)
	self._img = display.newSprite(node.name)
	self._scale = node.scale
	self:setScale(self._scale)
	self._r = node.radius
    self:setAnchorPoint(ccp(0,0))
    self:addChild(self._img)

    self._speedX = cos(angle)*self._speed 
    self._speedY = sin(angle)*self._speed
    self:setPosition(pos)
    self:setRotation(180-angle)
    self._ATK = power
    self._SD = sd
  	self._camp = camp
    self._lifedistance = 0  -----shecheng
    self._state = State.move
end
function Bullet:update()
    if self._state == State.move then
		moveCCnode(self, self._speedX, self._speedY)	
		self._lifedistance = self._lifedistance + self._speed

		if(self._goal._state  ~= State.null and self._goal._life >0  )then 							----------跟踪弹
			local curPos = self:getPositionInCCPoint()
			local toPos  = self._goal:getPositionInCCPoint()
			local distance
			self._speedX, self._speedY,distance = getSpeedXY(curPos,toPos,self._speed)
			moveCCnode(self, self._speedX, self._speedY)
			self._lifedistance = self._lifedistance + self._speed
	    end

		if( self._lifedistance >= self._SD)then
			self:setState(State.null)
		end	
		self:hitUnit()
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

function Bullet:hitUnit()
	for i,unit in ipairs( self._camp.enemyUnit) do
			local distance = getDistance(self,unit)
			if distance < self._r + unit._r then
				unit._life = unit._life - (self._ATK-unit._DEF)
				self:setState(State.null)
				return true
		end
	end
	return false
end

return Bullet