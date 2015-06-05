local GameDirector = class("GameDirector")
ClassFort = require("app.Game.Fort")
ClassUnit = require("app.Game.Unit")
ClassButton = require("app.Game.Button")

function GameDirector:ctor()
	self._AddUnitTime = GameUnit.addTime
	self._onTouch = GameTouch.null 	----------点击的控件名称
end

function GameDirector:init(scene)
	self:initFort(scene)
	self:addFort(GameFort1)
	self:addFort(GameFort2)

	self:initUnit(scene)
	self:initUnit2(scene)	

	self:initButton(scene)													----------添加按钮
	self:addButton(GameTank1, GameTouch.addUnitAlert, ccp(128, 28),"巡逻")
	self:addButton(GameTank1,GameTouch.addUnitAttack,ccp(168, 28),"进攻")
	self:addButton(GameTank3, GameTouch.addUnitAlert, ccp(208, 28),"巡逻")	
	self:addButton(GameTank3,GameTouch.addUnitAttack,ccp(248, 28),"进攻")

    self:addButton(GameSkillLevelUp,GameTouch.levelUp,ccp(68, 375),"升级") 
    self:addButton(GameSkillDEF,GameTouch.def,ccp(128, 375),"塔防") 

    self:initBullet(scene)
	self:distributeCamp( )	 													----------分配阵营
end

function GameDirector:update()
	if self._listFort[1]:update() or self._listFort[2]:update() then 			----------城堡死亡，游戏结束
		return true
	end
	updateObjectList(self._listUnit)
	updateObjectList(self._listUnit2)
	--updateObjectList(self._listBullet)
	self:addUnit2OnTime()
end

function GameDirector:onTouch( name,x,y,prevX,prevY )
	if name == TouchEventString.began then 
		if self:touchButton(name, x, y, prevX, prevY) then 					----------点击按钮
			if self._onTouch == GameTouch.levelUp then
            	self:levelUp() 								--升级
            	self._listFort[1]._gold = self._listFort[1]._gold - GameSkillLevelUp.price
            elseif self._onTouch == GameTouch.def then
           		self._listFort[1]:setState(State.def) 		--塔防
           		self._listFort[1]._gold = self._listFort[1]._gold - GameSkillDEF.price
			end
		elseif self._listFort[1]:onTouch(name, x, y, prevX, prevY) then 		----------点击我方城堡
			self._onTouch = GameTouch.fort1
		
		elseif 	self._listFort[2]:onTouch(name, x, y, prevX, prevY) then 		----------点击敌方城堡
			self._onTouch = GameTouch.fort2
		
		elseif self._onTouch == GameTouch.addUnitAttack then 					----------增加进攻单位
			if self._listFort[1]._gold >= self._addNode.price then
	        	self:addUnit(self._addNode,State.attack,ccp(x, y))                 -------------------
	        	self._listFort[1]._gold = self._listFort[1]._gold - self._addNode.price
			end
		elseif self._onTouch == GameTouch.addUnitAlert then 					----------增加巡逻单位
	        if self._listFort[1]._gold >= self._addNode.price then
	        	self:addUnit(self._addNode,State.alert,ccp(x, y))	
	        	self._listFort[1]._gold = self._listFort[1]._gold - self._addNode.price
	        end        
	    -- elseif g_director._listAlert[1]._clicked then
	    --     g_director:checkUnit(x,y)
		end
	end	
end

function GameDirector:initFort( scene ) 										----------城堡
	self._listFort = {}
	self._layerFort = display.newNode()
	scene:addChild(self._layerFort)
end

function GameDirector:addFort(node)
    local Fort = ClassFort.new()
    Fort:init(node)
    table.insert(self._listFort, Fort)
    self._layerFort:addChild(Fort)
end

function GameDirector:initButton( scene ) 										----------按钮
	self._listButton = {}
	self._layerButton = display.newNode()
	scene:addChild(self._layerButton)
end

function GameDirector:addButton(name,cmd,pos,label)
    local Button = ClassButton.new()
    Button:init(name,cmd,pos,label)
    table.insert(self._listButton, Button)
    self._layerButton:addChild(Button)
end

function GameDirector:touchButton(name, x, y, prevX, prevY)
	for i,Button in ipairs(self._listButton) do
		if Button:onTouch(name, x, y, prevX, prevY) then
			self._onTouch = Button._cmd 										----------所接受的指令
			self._addNode = Button._node 										----------单位的信息
			return true
		end
	end
end

function GameDirector:initUnit( scene ) 											---------我方单位
	self._listUnit = {}
	self._layerUnit = display.newNode()
	scene:addChild(self._layerUnit)
end

function GameDirector:addUnit(name,state,pos)
    local Unit = ClassUnit.new()
    Unit:init(name,state,pos,self._camp1)
    table.insert(self._listUnit, Unit)
    self._layerUnit:addChild(Unit)
end

function GameDirector:initUnit2( scene ) 										----------敌方单位
	self._listUnit2 = {}
	self._layerUnit2 = display.newNode()
	scene:addChild(self._layerUnit2)
end

function GameDirector:addUnit2(node,state,pos)
    local Unit2 = ClassUnit.new()
    Unit2:init(node,state,pos,self._camp2)
    table.insert(self._listUnit2, Unit2)
    self._layerUnit2:addChild(Unit2)
end
function  GameDirector:initBullet(scene)
	self._listBullet = {}
	self._layerBullet = display.newNode()
	scene:addChild(self._layerBullet)
end
function  GameDirector:addBullet(node,pos,angle)
	--local pos = self:getPositionInCCPoint()
	local Bullet = ClassBullet.new()
    Bullet:init(node,pos,13,angle)
    table.insert(self._listBullet, Bullet)
    self._layerBullet:addChild(Bullet)
end
function GameDirector:distributeCamp(  ) 										----------分配阵营
	self._camp1 = {} ----------我方阵营
	self._camp1.name = 1
	self._camp1.fort = self._listFort[1] --我方城堡
	self._camp1.enemyFort = self._listFort[2] --敌方城堡
	self._camp1.unit = self._listUnit --我方单位
	self._camp1.enemyUnit = self._listUnit2 --敌方单位

	self._camp2 = {} ----------敌方阵营
	self._camp2.name = 2
	self._camp2.fort = self._listFort[2] --我方城堡
	self._camp2.enemyFort = self._listFort[1] --敌方城堡
	self._camp2.unit = self._listUnit2 --我方单位
	self._camp2.enemyUnit = self._listUnit --敌方单位
end

function GameDirector:addUnit2OnTime(  ) 										----------按时间增加敌人
	if self._AddUnitTime > 0 then
		self._AddUnitTime = self._AddUnitTime - 1 								
	elseif self._AddUnitTime <= 0 and #self._listUnit2 < GameUnit.maxNum then
		if self._listFort[2]._gold >= GameTank2.price then
			local x = math.random(GameData.rectScreen.right*2/3,GameData.rectScreen.right*4/5)
			local y = math.random(GameData.rectScreen.top*2/3,GameData.rectScreen.top*4/5)
			local state = math.random(State.attack,State.alert)
			self._AddUnitTime = GameUnit.addTime
			self:addUnit2(GameTank2,state,ccp(x, y))
			self._listFort[2]._gold = self._listFort[2]._gold - GameTank2.price
		end
	end
end

function GameDirector:levelUp() 											----------升级
	local i = 1
    local count = #self._listUnit
    while (i <= count )do
        local obj = self._listUnit[i]
        obj._DEF = obj._DEF+2
        obj._ATK = obj._ATK +20
        i = i + 1
    end
end

-- function GameDirector:checkUnit(x,y)
--      --updateObjectList(self._listUnit)
--     local i = 1
--     local count = #self._listUnit
--      while i <= count do
--        local obj = self._listUnit[i]

--         --obj:moveTo(4,x,y)
--         obj:_move(x,y)
--        --print(i)
--         i = i+1
--    end
   
-- end



return GameDirector