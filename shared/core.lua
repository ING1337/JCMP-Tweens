
class 'TweenCore'

function TweenCore:__init()
	self.tweens		= {}
	self.counter	= 0
	self.timer		= Timer()
	Events:Subscribe("TriggerTween", self, self.TriggerTween)
end

function TweenCore:CreateID(args)
	self.counter = self.counter + 1
	return Settings.DefaultID .. self.counter
end

-- ########################################################################################################################################################
-- ########################################################################################################################################################
-- ########################################################################################################################################################

function TweenCore:AddTween(args)
	args.values	= args.values or {}
	args.name	= args.name or self:CreateID()
	args.time	= args.time or 1000
	args.ticks	= args.ticks and (1000 / args.ticks) or (1000 / Settings.DefaultTicks)
	
	args.init	= self.timer:GetMilliseconds()
	args.motion	= Motions[args.motion] and args.motion or "Linear"
	args.start	= {}
	for name, value in pairs(args.values) do
		args.start[name] = args.object[name]
	end
		
	self.tweens[args.name] = args
	Events:Fire("DelayedEvent", {event = "TriggerTween", delay = args.ticks, args = args.name})
	return args.name
end

function TweenCore:RemoveTween(name)
	self.tweens[name] = nil
end

-- ########################################################################################################################################################
-- ########################################################################################################################################################
-- ########################################################################################################################################################

function TweenCore:SampleEvent(type, item)
	if item.events then
		send = item.events[TweenEvents.TickEnd] or item.events[type]
		if send then Events:Fire(send, item) end
	end
end

function TweenCore:TriggerTween(name)
	item = self.tweens[name]
	if (not item) then return end
	time = self.timer:GetMilliseconds()
	if (time >= (item.init + item.time)) then
		for name, value in pairs(item.values) do item.object[name] = value end
		self.tweens[name] = nil
		self:SampleEvent(TweenEvents.End, item)
	else
		for name, value in pairs(item.values) do
			item.object[name] = Motions[item.motion](item.start[name], value, (time - item.init) / item.time)
		end
		Events:Fire("DelayedEvent", {event = "TriggerTween", delay = item.ticks, args = item.name})
		self:SampleEvent(TweenEvents.Tick, item)
	end
end
