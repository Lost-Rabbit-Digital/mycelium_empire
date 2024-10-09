extends Camera3D

@export var move_speed: float = 10.0
@export var zoom_speed: float = 10.0
@export var min_zoom: float = 10.0
@export var max_zoom: float = 100.0
@export var camera_angle: Vector3 = Vector3(20, 45, 0)  # Adjustable camera angle

var _target_position: Vector3 = Vector3.ZERO
var _target_zoom: float = 50.0

func _ready():
	projection = Camera3D.PROJECTION_ORTHOGONAL
	size = _target_zoom
	near = 0.001
	far = 1000.0
	_update_camera_transform()

func _process(delta: float):
	var input_dir = Vector3.ZERO
	input_dir.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_dir.z = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	# Adjust input direction based on camera orientation
	var camera_basis = global_transform.basis
	var adjusted_input = camera_basis.x * input_dir.x + camera_basis.z * input_dir.z
	adjusted_input.y = 0  # Ensure no vertical movement
	_target_position += adjusted_input.normalized() * move_speed * delta

	var zoom_input = Input.get_action_strength("ui_page_down") - Input.get_action_strength("ui_page_up")
	_target_zoom = clamp(_target_zoom + zoom_input * zoom_speed * delta, min_zoom, max_zoom)

	global_position = global_position.lerp(_target_position, delta * 5.0)
	size = lerp(size, _target_zoom, delta * 5.0)

func _input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			_target_zoom = clamp(_target_zoom - zoom_speed * 0.1, min_zoom, max_zoom)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_target_zoom = clamp(_target_zoom + zoom_speed * 0.1, min_zoom, max_zoom)

func _update_camera_transform():
	var angle_rad = camera_angle * PI / 180.0
	var distance = 100
	
	# Calculate camera position
	var pos = Vector3(
		sin(angle_rad.y) * distance,
		sin(angle_rad.x) * distance,
		cos(angle_rad.y) * distance
	)
	
	# Look at the origin from the calculated position
	look_at_from_position(pos, Vector3.ZERO, Vector3.UP)
	
	# Rotate the camera to achieve the desired angle
	rotate_object_local(Vector3.RIGHT, -angle_rad.x)
