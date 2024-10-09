extends CSGCombiner3D

func _ready():
	# Create the stem
	var stem = CSGCylinder3D.new()
	stem.radius = 1.5
	stem.height = 3.0
	stem.material = preload("res://materials/mushroom_stem_material.tres")
	add_child(stem)
	
	# Create the cap
	var cap = CSGSphere3D.new()
	cap.radius = 2.5
	cap.material = preload("res://materials/mushroom_cap_material.tres")
	cap.transform.origin.y = 2.5
	add_child(cap)
	
	# Flatten the bottom of the cap
	var cap_cutter = CSGBox3D.new()
	cap_cutter.width = 5.0
	cap_cutter.depth = 5.0
	cap_cutter.height = 2.5
	cap_cutter.transform.origin.y = 1.25
	cap_cutter.operation = CSGShape3D.OPERATION_SUBTRACTION
	cap.add_child(cap_cutter)
	
	# Add a door
	var door = CSGBox3D.new()
	door.width = 1.0
	door.depth = 0.1
	door.height = 1.5
	door.transform.origin = Vector3(0, 0.75, -1.4)
	door.material = preload("res://materials/door_material.tres")
	stem.add_child(door)
	
	# Add windows
	for i in range(2):
		var window = CSGSphere3D.new()
		window.radius = 0.3
		window.transform.origin = Vector3(cos(i * PI) * 1.2, 1.5, sin(i * PI) * 1.2)
		window.material = preload("res://materials/window_material.tres")
		stem.add_child(window)

# You would need to create the referenced materials separately
# For example, mushroom_stem_material.tres could be a SpatialMaterial
# with a beige color and a rough texture
