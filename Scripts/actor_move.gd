extends Node3D

## Handle all movement for all characters, including both the player and enemies

## Variable Initialization
var was_jumping = false
var jump_duration = 0.0
 
## Function Initialization

## This functions purpose is to move its root parent in a given direction and at the given strength
## relative to either the direction the parent is facing (for enemies) or to the direction the camera
## is pointing (for the player.)
func move(vel,dir,yrot,accel,frict,max_speeds,delta):
	## Make sure we are trying to move, if not apply friction
	if dir != Vector3.ZERO:
		
		## Get target speeds
		var tar_speed = dir.rotated(Vector3.UP,yrot) * max_speeds
		
		## Apply Accelerations
		vel.x = move_toward(vel.x,tar_speed.x,accel.x * delta)
		vel.y = move_toward(vel.y,tar_speed.y,accel.y * delta)
		vel.z = move_toward(vel.z,tar_speed.z,accel.z * delta)
	else:
		## Apply friction
		vel.x = move_toward(vel.x,0.0,frict.x * delta)
		vel.y = move_toward(vel.y,0.0,frict.y * delta)
		vel.z = move_toward(vel.z,0.0,frict.z * delta)
		
	## Return value
	return(vel)
	
## Jump with a smooth arc, and fall due to gravity
func jump_and_fall(yvel,jump_input,jump_speed,jump_stop_slowdown,jump_dur_max,grav_spd,grav_max,on_floor,delta):
	## Check if we are jumping or falling
	if was_jumping:
		## We were jumping last time we checked
		if jump_input:
			if jump_duration < jump_dur_max:
				## Track how long we have been jumping
				jump_duration += 1.0 * delta
				
				## Sustain Jump
				yvel = jump_speed
				
			else:
				was_jumping = false
		else:
			## Stop jumping prematurely
			yvel = move_toward(yvel,grav_max,jump_stop_slowdown * delta)
			was_jumping = false
	else:
		## We were not jumping last time we checked
		if on_floor and jump_input:
			## Start jumping
			yvel = jump_speed
			was_jumping = true
			jump_duration = 0.0
		else:
			## Apply gravity
			yvel = move_toward(yvel,grav_max,grav_spd * delta)
	
	return(yvel)
