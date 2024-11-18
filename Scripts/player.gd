extends CharacterBody3D

## Variable Initialization
var camera_rotate_speed = Vector2.ZERO

## Constants
const MOVE_ACCELS = Vector3(40.0,40.0,40.0)
const MOVE_MAX_SPEEDS = Vector3(5.0,5.0,5.0)
const JUMP_VELOCITY = 30.0
const FRICT = Vector3(13.0,13.0,13.0)
const DRAG = Vector3(4.0,4.0,4.0)
const CAMERA_ROTATE_ACCEL = 1.0
const CAMERA_ROTATE_SPEED_MAX = 0.1

## Settings
var DEADZONES = 0.1

## Inputs
var move_input = Vector3.ZERO
var camera_rotation_input = Vector2.ZERO
var jump_input = false

## Assets
@onready var actorMove = $ActorModules/ActorMove
@onready var cameraPivot = $CameraPivot
@onready var camera = $CameraPivot/Camera3D

## Function Initialization

## Get player inputs
func _input(event: InputEvent) -> void:
	## Get movement inputs
	var normal_movement = Input.get_vector("gameplay_move_left", "gameplay_move_right", "gameplay_move_forwards", "gameplay_move_backwards",DEADZONES)
	var flying_movement = Input.get_axis("gameplay_fly_down","gameplay_fly_up")
	
	move_input = Vector3(normal_movement.x,flying_movement,normal_movement.y)
	
	## Dont allow flying if noclip isnt active
	if GameFunctions.noclip == false:
		move_input.y = 0.0
	
	## Get other movement inputs
	jump_input = Input.is_action_just_pressed("gameplay_jump")
		
	## Get camera inputs
	camera_rotation_input = Input.get_vector("gameplay_camera_rotate_left", "gameplay_camera_rotate_right", "gameplay_camera_rotate_up", "gameplay_camera_rotate_down",DEADZONES)
	
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
	
	velocity = actorMove.move(move_input,cameraPivot.rotation.y,MOVE_ACCELS,current_frict,MOVE_MAX_SPEEDS,delta)
	
	move_and_slide()
	
## Handle other movement types
func _process(delta: float) -> void:
	## Rotate the camera
	camera_rotate_speed = camera_rotate_speed.move_toward(camera_rotation_input * CAMERA_ROTATE_SPEED_MAX,CAMERA_ROTATE_ACCEL * delta)
	cameraPivot.rotation.x += camera_rotate_speed.y
	cameraPivot.rotation.y += camera_rotate_speed.x
