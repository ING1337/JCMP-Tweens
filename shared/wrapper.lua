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
	if self.wraps[tween.name] then
		if IsValid(self.wraps[tween.name].object) then
			WrapFunctions.Setter[self.wraps[tween.name].type](self.wraps[tween.name].object, tween.object)
			self.core:SampleEvent(tween, TweenEvents.Tick, self.wraps[tween.name].events)
		else
			self.core:SampleEvent(tween, TweenEvents.Error, self.wraps[tween.name].events)
			self:RemoveTween(tween.name)
		end
	end
end

function TweenWrapper:WrapEnd(tween)
	if self.wraps[tween.name] then
		self:WrapStep(tween)
		self.core:SampleEvent(tween, TweenEvents.End, self.wraps[tween.name].events)
		self.wraps[tween.name] = nil
	end
end

-- ########################################################################################################################################################
-- ########################################################################################################################################################
-- ########################################################################################################################################################

tweenWrapper = TweenWrapper()
