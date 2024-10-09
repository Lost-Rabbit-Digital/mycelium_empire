extends TileMapLayer

# Enum for different soil types
enum SoilType {
	NORMAL,
	NUTRIENT_RICH,
	ROCKY,
	MOIST,
	DRY
}

# Dictionary to store soil properties
var soil_properties = {
	SoilType.NORMAL: {"growth_rate": 1.0, "nutrient_value": 1.0},
	SoilType.NUTRIENT_RICH: {"growth_rate": 1.5, "nutrient_value": 2.0},
	SoilType.ROCKY: {"growth_rate": 0.5, "nutrient_value": 0.5},
	SoilType.MOIST: {"growth_rate": 1.2, "nutrient_value": 1.2},
	SoilType.DRY: {"growth_rate": 0.8, "nutrient_value": 0.8}
}

# Size of the map
@export var map_width = 100
@export var map_height = 100

# Noise for procedural generation
var noise = FastNoiseLite.new()

func _ready():
	generate_map()

func generate_map():
	# Set up noise parameters
	noise.seed = randi()
	noise.frequency = 0.05
	
	for x in range(map_width):
		for y in range(map_height):
			var noise_value = noise.get_noise_2d(x, y)
			var soil_type = get_soil_type(noise_value)
			set_cell(Vector2i(x, y), 0, Vector2i(soil_type, 0))
			
func get_soil_type(noise_value):
	if noise_value < -0.2:
		return SoilType.DRY
	elif noise_value < 0:
		return SoilType.ROCKY
	elif noise_value < 0.2:
		return SoilType.NORMAL
	elif noise_value < 0.4:
		return SoilType.MOIST
	else:
		return SoilType.NUTRIENT_RICH

func get_soil_properties(x, y):
	var cell = get_cell_source_id(Vector2i(x, y))
	return soil_properties[cell]

func is_valid_tile(x, y):
	return x >= 0 and x < map_width and y >= 0 and y < map_height
