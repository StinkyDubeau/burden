extends Node3D

## Handle all movement for all characters, including both the player and enemies

## Variable Initialization
var walk_accel = Vector3.ZERO
 
## Function Initialization

## This functions purpose is to move its root parent in a given direction and at the given strength
## relative to either the direction the parent is facing (for enemies) or to the direction the camera
## is pointing (for the player.)
func move(dir,yrot,accel,frict,max_speeds,delta):
	## Make sure we are trying to move, if not apply friction
	if dir != Vector3.ZERO:
		
		## Get target speeds
		var tar_speed = dir.rotated(Vector3.UP,yrot) * max_speeds
		
		## Apply Accelerations
		walk_accel.x = move_toward(walk_accel.x,tar_speed.x,accel.x * delta)
		walk_accel.y = move_toward(walk_accel.y,tar_speed.y,accel.y * delta)
		walk_accel.z = move_toward(walk_accel.z,tar_speed.z,accel.z * delta)
	else:
		## Apply friction
		walk_accel.x = move_toward(walk_accel.x,0.0,frict.x * delta)
		walk_accel.y = move_toward(walk_accel.y,0.0,frict.y * delta)
		walk_accel.z = move_toward(walk_accel.z,0.0,frict.z * delta)
		
	## Return value
	return(walk_accel)
