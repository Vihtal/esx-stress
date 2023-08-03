['water'] = {
	label = 'Water',
	weight = 300,
	stack = true,
	close = true,
	description = 'Good for Refreshing',
	client = {
		status = { stress = -300000 }, --this is what determines your stress, -300000 is remove stress, 300000 is to gain stress
		anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
		prop = { model = `prop_ld_flow_bottle`, pos = vec3(0.03, 0.03, 0.02), rot = vec3(0.0, 0.0, -1.5) },
		usetime = 5500,
		cancel = true,
		notification = 'You drank some refreshing water'
	}
},