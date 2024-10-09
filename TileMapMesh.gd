extends MeshInstance3D

var tilemap_layer: TileMapLayer

func _ready():
	var parent = get_parent()
	if parent is TileMapLayer:
		tilemap_layer = parent
		generate_mesh()
	else:
		push_error("Parent node is not a TileMapLayer")

func generate_mesh():
	var surface_tool = SurfaceTool.new()
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)

	for cell_pos in tilemap_layer.get_used_cells():
		var cell_data = tilemap_layer.get_cell_tile_data(cell_pos)
		var tile_size = tilemap_layer.tile_set.tile_size

		var vertices = [
			Vector3(cell_pos.x * tile_size.x, 0, cell_pos.y * tile_size.y),
			Vector3(cell_pos.x * tile_size.x + tile_size.x, 0, cell_pos.y * tile_size.y),
			Vector3(cell_pos.x * tile_size.x + tile_size.x, 0, cell_pos.y * tile_size.y + tile_size.y),
			Vector3(cell_pos.x * tile_size.x, 0, cell_pos.y * tile_size.y + tile_size.y)
		]

		var uvs = [
			Vector2(0, 0),
			Vector2(1, 0),
			Vector2(1, 1),
			Vector2(0, 1)
		]

		surface_tool.add_vertex(vertices[0])
		surface_tool.add_vertex(vertices[1])
		surface_tool.add_vertex(vertices[2])
		surface_tool.add_vertex(vertices[0])
		surface_tool.add_vertex(vertices[2])
		surface_tool.add_vertex(vertices[3])

		for i in range(6):
			surface_tool.add_uv(uvs[i % 4])

	surface_tool.generate_normals()
	mesh = surface_tool.commit()
