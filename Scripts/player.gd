extends CharacterBody3D

## Variable Initialization
var camera_rotate_speed = Vector2.ZERO
var grabbed_object = null

## Constants
const MOVE_ACCELS = Vector3(40.0, 40.0, 40.0)
const MOVE_MAX_SPEEDS = Vector3(7.0, 7.0, 7.0)
const JUMP_VELOCITY = 15.0
const JUMP_DUR_MAX = 0.15
const JUMP_STOP_SLOWDOWN = 100.0
const FRICT = Vector3(13.0, 13.0, 13.0)
const DRAG = Vector3(4.0, 4.0, 4.0)
const CAMERA_ROTATE_ACCEL = 1.0
const CAMERA_ROTATE_SPEED_MAX = 0.1
const GRAVITY_SPEED = 50.0
const GRAVITY_MAX = -60.0
const BASE_REFERENCE_MASS = 4.0
const GRAB_STRENGTH = 10.0
const THROW_STRENGTH = 50.0

## Settings
var DEADZONES = 0.1

## Inputs
var move_input = Vector3.ZERO
var camera_rotation_input = Vector2.ZERO
var jump_input = false
var grab_input : set = grab_or_throw

## Other 

## Assets
@onready var actorMove = $ActorModules/ActorMove
@onready var cameraPivot = $CameraPivot
@onready var camera = $CameraPivot/Camera3D
@onready var grabArea = $CameraPivot/GrabArea
@onready var throwDir = $CameraPivot/ThrowDir

## Function Initialization

## Get player inputs
func _input(event: InputEvent) -> void:
	## Get movement inputs
	var normal_movement = Input.get_vector("gameplay_move_left", "gameplay_move_right", "gameplay_move_forwards", "gameplay_move_backwards", DEADZONES)
	var flying_movement = Input.get_axis("gameplay_fly_down", "gameplay_fly_up")
	
	move_input = Vector3(normal_movement.x, flying_movement, normal_movement.y)
	
	## Dont allow flying if noclip isnt active
	if GameFunctions.noclip == false:
		move_input.y = 0.0
	
	## Get other movement inputs
	jump_input = Input.is_action_pressed("gameplay_jump")
	
	## Get other player action inputs
	self.grab_input = Input.is_action_pressed("gameplay_grab")
		
	## Get camera inputs
	camera_rotation_input = Input.get_vector("gameplay_camera_rotate_left", "gameplay_camera_rotate_right", "gameplay_camera_rotate_up", "gameplay_camera_rotate_down", DEADZONES)
	
## Handle all basic movement inputs
func _physics_process(delta: float) -> void:
	## Get if we are on the ground, this will affect friction and gravity
	var current_frict = Vector3.ZERO
	
	if is_on_floor():
		current_frict = FRICT
	else:
		current_frict = DRAG
	
	## No drag on y velocity unless noclip is active
	if GameFunctions.noclip == false:
		current_frict.y = 0.0
		
	## Get our current accelerations
	var current_accel = MOVE_ACCELS
	
	## Zero y accel if noclip is disabled
	if GameFunctions.noclip == false:
		current_accel.y = 0.0
	
	velocity = actorMove.move(velocity, move_input, cameraPivot.rotation.y, current_accel, current_frict, MOVE_MAX_SPEEDS, delta)
	
	## Apply jump and gravity
	velocity.y = actorMove.jump_and_fall(velocity.y, jump_input, JUMP_VELOCITY, JUMP_STOP_SLOWDOWN, JUMP_DUR_MAX, GRAVITY_SPEED, GRAVITY_MAX, is_on_floor(), delta)
	
	move_and_slide()
	
	## Hold Grabbed object
	if not grabbed_object == null:
		## Get object center
		var grabbed_object_center = grabbed_object.global_transform.origin
		
		## Get distance
		var grab_distance = grabbed_object_center.distance_to(grabArea.global_transform.origin)
		
		## Get grab strength
		var grab_strength = (GRAB_STRENGTH * grab_distance) * (grabbed_object.mass / BASE_REFERENCE_MASS)
		
		## Get grab vector
		var grab_direction = grabbed_object_center.direction_to(grabArea.global_transform.origin)
		var grab_vector = grab_direction * Vector3(grab_strength,grab_strength,grab_strength)
		
		## Move grabbed object to player
		grabbed_object.apply_central_impulse(-grabbed_object.linear_velocity)
		grabbed_object.apply_central_impulse(grab_vector)
	
## Handle other movement types
func _process(delta: float) -> void:
	## Rotate the camera
	camera_rotate_speed = camera_rotate_speed.move_toward(camera_rotation_input * CAMERA_ROTATE_SPEED_MAX, CAMERA_ROTATE_ACCEL * delta)
	cameraPivot.rotation.x += camera_rotate_speed.y
	cameraPivot.rotation.y += camera_rotate_speed.x
	
## A grab input has been detected, grab and or throw our object
func grab_or_throw(state):
	if not state == grab_input:
		if state:
			if grabArea.has_overlapping_areas():
				for area in grabArea.get_overlapping_areas():
					if area.is_in_group("Grabbable"):
						grabbed_object = area.get_node("../")
		else:
			## Throw object
			if not grabbed_object == null:
				var throw_direction = global_transform.origin.direction_to(throwDir.global_transform.origin)
				grabbed_object.apply_central_impulse(throw_direction * (THROW_STRENGTH * (grabbed_object.mass / BASE_REFERENCE_MASS)))
			grabbed_object = null
		
		grab_input = state
