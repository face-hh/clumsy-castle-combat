class_name FreeLookCamera extends Camera3D

# this doesnt work lol
const SHIFT_MULTIPLIER = 2.5
const ALT_MULTIPLIER = 1.0 / SHIFT_MULTIPLIER

@export_range(0.0, 1.0) var sensitivity: float = 0.15

# Mouse state
var _mouse_position: Vector2 = Vector2(0.0, 0.0)
var _total_pitch: float = 0.0

# Movement state
var _direction: Vector3 = Vector3(0.0, 0.0, 0.0)
var _velocity: Vector3 = Vector3(0.0, 0.0, 0.0)
var _acceleration: int = 30
var _deceleration: int = -10
var _vel_multiplier: int = 4

# Keyboard state
var _w: bool = false
var _s: bool = false
var _a: bool = false
var _d: bool = false
var _q: bool = false
var _e: bool = false
var _shift: bool = false
var _alt: bool = false

func _input(event: InputEvent) -> void:
	# Receives mouse motion
	if event is InputEventMouseMotion:
		_mouse_position = (event as InputEventMouseMotion).relative

	# Receives mouse button input
	if event is InputEventMouseButton:
		match (event as InputEventMouseButton).button_index:
			MOUSE_BUTTON_RIGHT: # Only allows rotation if right click down
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED if (event as InputEventMouseButton).pressed else Input.MOUSE_MODE_VISIBLE)
			MOUSE_BUTTON_WHEEL_UP: # Increases max velocity
				_vel_multiplier = clamp(_vel_multiplier * 1.1, 0.2, 20)
			MOUSE_BUTTON_WHEEL_DOWN: # Decereases max velocity
				_vel_multiplier = clamp(_vel_multiplier / 1.1, 0.2, 20)

	# Receives key input
	if event is InputEventKey:
		var _event: InputEventKey = event as InputEventKey
		match _event.keycode:
			KEY_W:
				_w = _event.pressed
			KEY_S:
				_s = _event.pressed
			KEY_A:
				_a = _event.pressed
			KEY_D:
				_d = _event.pressed
			KEY_Q:
				_q = _event.pressed
			KEY_E:
				_e = _event.pressed

# Updates mouselook and movement every frame
func _process(delta: float) -> void:
	if Sandbox.scaled_time:
		delta *= 10
	_update_mouselook()
	_update_movement(delta)

# Updates camera movement
func _update_movement(delta: float) -> void:
	# Computes desired direction from key states
	_direction = Vector3((_d as float) - (_a as float),
						(_e as float) - (_q as float),
						(_s as float) - (_w as float))

	# Computes the change in velocity due to desired direction and "drag"
	# The "drag" is a constant acceleration on the camera to bring it's velocity to 0
	var offset: Vector3 = _direction.normalized() * _acceleration * _vel_multiplier * delta \
		+ _velocity.normalized() * _deceleration * _vel_multiplier * delta

	# Compute modifiers' speed multiplier
	var speed_multi: int = 1
	if _shift: speed_multi *= SHIFT_MULTIPLIER
	if _alt: speed_multi *= ALT_MULTIPLIER

	# Checks if we should bother translating the camera
	if _direction == Vector3.ZERO and offset.length_squared() > _velocity.length_squared():
		# Sets the velocity to 0 to prevent jittering due to imperfect deceleration
		_velocity = Vector3.ZERO
	else:
		# Clamps speed to stay within maximum value (_vel_multiplier)
		_velocity.x = clamp(_velocity.x + offset.x, -_vel_multiplier, _vel_multiplier)
		_velocity.y = clamp(_velocity.y + offset.y, -_vel_multiplier, _vel_multiplier)
		_velocity.z = clamp(_velocity.z + offset.z, -_vel_multiplier, _vel_multiplier)

		translate(_velocity * delta * speed_multi)

# Updates mouse look
func _update_mouselook() -> void:
	# Only rotates mouse if the mouse is captured
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		_mouse_position *= sensitivity
		var yaw: float = _mouse_position.x
		var pitch: float = _mouse_position.y
		_mouse_position = Vector2(0, 0)

		# Prevents looking up/down too far
		pitch = clamp(pitch, -90 - _total_pitch, 90 - _total_pitch)
		_total_pitch += pitch

		rotate_y(deg_to_rad(-yaw))
		rotate_object_local(Vector3(1,0,0), deg_to_rad(-pitch))
