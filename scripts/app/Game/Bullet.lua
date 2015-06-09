local Bullet = class("Bullet", function()
    return display.newScene("Bullet")
end)
function Bullet:ctor()
	self._speed = GameBullet.speed
end

--传入参数：单位属性，位置，攻击力，角度，射程，阵营
function Bullet:init(node,pos,power,angle,sd,camp,type,goal)
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
    self._type = type
  	self._camp = camp
  	self._goal = goal
    self._lifedistance = 0  -----shecheng
    self._range = 50
    self._state = State.move
end
function Bullet:update()
 if self._state == State.move then
 	 moveCCnode(self, self._speedX, self._speedY)
    	if(self._type ==GameBullet.bullet)then
		--moveCCnode(self, self._speedX, self._speedY)
		self._lifedistance = self._lifedistance + self._speed
		  if( self._lifedistance >= self._SD)then
			self:setState(State.null)
		  end	
	    elseif(self._type ==GameBullet.track)then
	    	if(self._goal._state == State.null)then
	    		self._type = GameBullet.fly
		    else
			   local curPos = self:getPositionInCCPoint()
			   local toPos  = self._goal:getPositionInCCPoint()
			   local distance
			   self._speedX, self._speedY,distance = getSpeedXY(curPos,toPos,self._speed)
			   local angle = getAngle(curPos,toPos,distance)
			   self:setRotation( 180-angle)
		      -- moveCCnode(self, self._speedX, self._speedY)	
		       self._lifedistance = self._lifedistance + self._speed     
	        end
	    elseif(self._type ==GameBullet.GBU)then
		   self._lifedistance = self._lifedistance + self._speed
		  if( self._lifedistance >= self._SD)then
			self:setState(State.null)
		  end
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
function Bullet:GBU() -----------------------------------爆炸弹函数
	    local num = 0
		local count = #self._camp.enemyUnit
		local i =1
		while(i<=count)do
			local obj = self._camp.enemyUnit[i]
			local distance = getDistance(self,obj)
			if distance < self._range then
				obj._life = obj._life - (self._ATK-obj._DEF)
				self:setState(State.null)
				num = 1
		    end
		    i = i+1
        end
    return num
end
function Bullet:hitUnit()
	for i,unit in ipairs( self._camp.enemyUnit) do
			local distance = getDistance(self,unit)
			if distance < self._r + unit._r then
				if(self._type == GameBullet.GBU)then
				 local i =self:GBU() ---------------------------------------调用爆炸弹函数
				else
				unit._life = unit._life - (self._ATK-unit._DEF)
				self:setState(State.null)
				return true
			end
	       end
	   end
	--return false
end

return Bullet