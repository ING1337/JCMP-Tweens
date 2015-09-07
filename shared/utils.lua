Settings = {
	DefaultTicks		= 50,
	DefaultID		= "tw",
}

TweenEvents = {
	End			= "End",
	Tick			= "Tick",
	TickEnd			= "TickEnd",
	Error			= "Error",
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
