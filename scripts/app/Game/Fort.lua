local Fort = class("Fort", function()
    return display.newScene("Fort")
end)

function Fort:ctor()
	self._listAttackMe = {} 	----------攻击自己的单位列表
    self._goal = nil 			----------攻击的目标
    self._updateTime = GameData.fps ----------更新频率

	self:initControl()
	self:setState(State.alive)

end

function Fort:init( node )
	local img = display.newSprite(node.name)
	self._scale=node.scale
	self:setScale(self._scale)
	self._r=node.radius
	self:setAnchorPoint(ccp(0,0))
	self:addChild(img)

	self:setPosition(node.pos) 					
	self._pos = node.pos ----------位置
	self._defTime  = GameSkillDEF.time ----------塔防时间											
	self._life = node.life ----------生命
	self._price = node.price ------------价格
	self._gold = node.gold ----------金钱
	self._ATK = node.ATK  ----------攻击力
	self._DEF = node.DEF  ----------防御力
	self._SD = node.SD    ----------射程
	self._ASP = node.ASP    ----------攻速
	self._goldINC = node.goldINC ----------单位时间获得的金钱
    self._lifeLabel = cc.ui.UILabel.new({text = "", size = 25}) 		----------显示生命值
    				:align(display.CENTER, 1.5*(3-2*node.camp)*self._r, 25)
    				:addTo(self)
    self._goldLabel = cc.ui.UILabel.new({text = "", size = 25}) 		----------显示金钱
    				:align(display.CENTER, 1.5*(3-2*node.camp)*self._r, -25)
    				:addTo(self)

end

function Fort:initControl()
    -- local layer = display.newLayer()
    -- layer:setTouchEnabled(true)
    -- layer:addNodeEventListener(cc.NODE_TOUCH_EVENT, 
    --     function(event)
    --         return self:onTouch(event.name, event.x, event.y, event.prevX, event.prevY)
    --     end
    --     )
    -- layer:setTouchSwallowEnabled(false)
    -- self:addChild(layer)
end

function Fort:setState( state )
	self._state = state
	if self._state == State.null then
		self:toDeath()
	elseif self._state == State.def then
    	self:toDef() 
	end
end

function Fort:update()
    if self._state == State.null then
    	return true
    elseif self._state == State.def then
    	self:skillDEF() --塔防
    end

	self._updateTime = self._updateTime - 1 											----------更新金钱和生命
	if self._updateTime <= 0 then
		self._gold = self._gold + self._goldINC
		self._updateTime = GameData.fps
	end
    self._lifeLabel:setString("生命"..self._life)
    self._goldLabel:setString("金钱"..self._gold)


end

function Fort:onTouch(name,x,y,prevX,prevY)
	if math.abs(x - self._pos.x) < self._r then
		if name == TouchEventString.began then
	        -- click(self)
		elseif name == TouchEventString.ended then
	        
		end
		return true	
	else 
		return false
	end
end

function Fort:toDeath(  )
	--self:updateAttackMe()
end

function Fort:updateAttackMe() 							----------更新敌人
	if(self._listAttackMe ~= {})then
		local i = 1
        local count = #self._listAttackMe
        while i <= count do
	        local obj = self._listAttackMe[i]
	        if obj._state == State.fight then
	            obj:setState(obj._cmd)
	        end
            i = i + 1
    	end
	end
end

function Fort:toDef(  )
	self._defTime = GameSkillDEF.time
	self._DEF  = GameSkillDEF.def
end

function Fort:skillDEF()								-----------塔防
	self._defTime = self._defTime-1
    if self._defTime <= 0 then
 	  self._DEF = GameFort.DEF
 	  self._state= State.alive
    end
end

return Fort