class 'TweenWrapper'

function TweenWrapper:__init()
	self.core	= TweenCore()
	self.wraps	= {}
	Events:Subscribe("CreateTween", self, self.CreateTween)
	Events:Subscribe("RemoveTween", self, self.RemoveTween)
	Events:Subscribe("WrapStep", self, self.WrapStep)
	Events:Subscribe("WrapEnd", self, self.WrapEnd)
end

-- ########################################################################################################################################################
-- ########################################################################################################################################################
-- ########################################################################################################################################################

function TweenWrapper:CreateTween(args)
	if (args.object and args.values) and args.object.__type and WrappedObjects[args.object.__type] then
		for name, data in pairs(WrappedTypes) do
			if args.values[name] then
				local current = WrapFunctions.Getter[name](args.object)
				local values  = {}
				for prop, value in pairs(WrappedTypes[name]) do
					values[prop] = args.values[name][prop]
				end
				local id = self.core:AddTween({
					object	= current,
					values	= values,
					name	= args.name,
					time	= args.time,
					ticks	= args.ticks,
					motion	= args.motion,
					events	= {Tick = "WrapStep", End = "WrapEnd"},
				})
				self.wraps[id] = {
					object	= args.object,
					events	= args.events,
					type	= name,
				}
			end
		end
	else
		self.core:AddTween(args) -- basic tween
	end
end

function TweenWrapper:RemoveTween(name)
	self.core:RemoveTween(name)
	self.wraps[name] = nil
end

-- ########################################################################################################################################################
-- ########################################################################################################################################################
-- ########################################################################################################################################################

function TweenWrapper:WrapStep(tween)
	local wrap = self.wraps[tween.name]
	if wrap then
		if IsValid(wrap.object) then
			WrapFunctions.Setter[wrap.type](wrap.object, tween.object)
			self.core:SampleEvent(wrap, TweenEvents.Tick, wrap.events)
		else
			self.core:SampleEvent(wrap, TweenEvents.Error, wrap.events)
			self:RemoveTween(tween.name)
		end
	end
end

function TweenWrapper:WrapEnd(tween)
	local wrap = self.wraps[tween.name]
	if wrap then
		self:WrapStep(wrap)
		self.core:SampleEvent(wrap, TweenEvents.End, wrap.events)
		self:RemoveTween(tween.name) --self.wraps[tween.name] = nil
	end
end

-- ########################################################################################################################################################
-- ########################################################################################################################################################
-- ########################################################################################################################################################

tweenWrapper = TweenWrapper()
