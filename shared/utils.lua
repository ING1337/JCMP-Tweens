
Settings = {
	DefaultTicks		= 30,
	DefaultID		= "tw"
}

TweenEvents = {
	End			= "End",
	Tick			= "Tick",
}

-- ########################################################################################################################################################
-- ########################################################################################################################################################
-- ########################################################################################################################################################

WrappedObjects = {
	Player			= true,
	Vehicle			= true,
	StaticObject		= true,
	ClientStaticObject	= true,
	ClientEffect		= true,
	ClientParticleSystem	= true,
	ClientLight		= true,
	ClientSound		= true,
}

WrappedTypes = {
	position		= {x   = 0, y     = 0, z    = 0},
	angle			= {yaw = 0, pitch = 0, roll = 0},
}

WrapFunctions = {
	Getter = {
		position	= function(object) return object:GetPosition() end,
		angle		= function(object) return object:GetAngle() end,
	},
	Setter = {
		position	= function(object, value) object:SetPosition(value) end,
		angle		= function(object, value) object:SetAngle(value) end,
	}
}

-- ########################################################################################################################################################
-- ########################################################################################################################################################
-- ########################################################################################################################################################

Linear = function(val1, val2, ratio)
	return val1 + (val2 - val1) * ratio
end

EaseIn = function(val1, val2, ratio)
	return val1 + (val2 - val1) * ratio * ratio * ratio
end

EaseOut = function(val1, val2, ratio)
	ratio = ratio - 1
	return (val2 - val1) * ratio * ratio * ratio + val2
end

EaseInOut = function(val1, val2, ratio)
	return .5 * (EaseIn(val1, val2, (ratio < .5 and ratio or ratio - 1) * 2) + (ratio < .5 and 0 or val2 * 2))
end

Motions = {
	Linear		= Linear,
	EaseIn		= EaseIn,
	EaseOut		= EaseOut,
	EaseInOut	= EaseInOut,
}
