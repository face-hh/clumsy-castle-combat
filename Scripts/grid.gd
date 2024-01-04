extends CSGBox3D

@onready var parent: Node3D = ($"../../Cells" as Node3D)

func generateChessboard(width: int, height: int) -> void:
	var cell_size: Vector3 = Vector3(1, 1, 1)  # Adjust the size of each cell as needed
	var dark_color: Color = Color(0, 0.707, 0, 1)  # 00ce00 in RGBA
	var light_color: Color = Color(0, 0.576, 0, 1)  # 009300 in RGBA

	for x in range(width):
		for y in range(height):
			var is_dark: bool = (x + y) % 2 == 0
			var cell: CSGBox3D = CSGBox3D.new()
			var cell_material: StandardMaterial3D = StandardMaterial3D.new()

			# Assign the material to the cell
			cell.material = cell_material
			cell.size = cell_size
			cell.position = Vector3(x * cell_size.x, y * cell_size.y, 0)


			if is_dark:
				cell_material.albedo_color = dark_color
			else:
				cell_material.albedo_color = light_color

			parent.add_child(cell)

func _ready() -> void:
	generateChessboard(43, 20)
	parent.rotate_x(deg_to_rad(90))
	parent.rotate_y(deg_to_rad(90))
	parent.position = Vector3(-9.75,-0.4,21.5)
	self.visible = false
