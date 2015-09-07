class 'TweenCore'

function TweenCore:__init()
	self.tweens	= {}
	self.counter	= 0
	self.timer	= Timer()
	Events:Subscribe("TriggerTween", self, self.TriggerTween)
end

function TweenCore:CreateID(args)
	self.counter = self.counter + 1
	return Settings.DefaultIDPrefix .. self.counter
end

-- ########################################################################################################################################################
-- ########################################################################################################################################################
-- ########################################################################################################################################################

function TweenCore:AddTween(args)
	args.values	= args.values or {}
	args.name	= args.name or self:CreateID()
	args.time	= args.time or 3000
	args.ticks	= args.ticks and (1000 / args.ticks) or (1000 / Settings.DefaultTicks)
	
	args.init	= self.timer:GetMilliseconds()
	args.motion	= args.motion or "linear"
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

function TweenCore:Render(item, time)
	for name, value in pairs(item.values) do
		item.object[name] = Easing[item.motion]((time - item.init), item.start[name], value, item.time)
	end
end

function TweenCore:SampleEvent(item, type, events)
	if events then
		if events[TweenEvents.TickEnd] then Events:Fire(events[TweenEvents.TickEnd], item) end
		if events[type] then Events:Fire(events[type], item) end
	end
end

function TweenCore:TriggerTween(name)
	item = self.tweens[name]
	if (not item) then return end
	time = self.timer:GetMilliseconds()
	if (time >= (item.init + item.time)) then
		self:Render(item, math.min(time, (item.init + item.time)))
		self.tweens[name] = nil
		self:SampleEvent(item, TweenEvents.End, item.events)
	else
		self:Render(item, time)
		Events:Fire("DelayedEvent", {event = "TriggerTween", delay = item.ticks, args = item.name})
		self:SampleEvent(item, TweenEvents.Tick, item.events)
	end
end
