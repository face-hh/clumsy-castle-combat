extends Node

var scaled_time: bool = false

func _process(_delta: float) -> void:
	var fps_counter: Label = $/root/GAME/CanvasLayer/FPS

	if is_instance_valid(fps_counter):
		fps_counter.text = "FPS " + str(Engine.get_frames_per_second())

	if Input.is_action_pressed("restart"):
		get_tree().reload_current_scene()

		await get_tree().create_timer(1).timeout

		(Data as DataType).reload_audio()

	if Input.is_action_just_pressed("timestop"):
		if scaled_time:
			Engine.time_scale = 1
			scaled_time = false
		else:
			Engine.time_scale = 0.1
			scaled_time = true
	if Input.is_action_just_pressed("debug"):
		var on: bool = fps_counter.visible

		for node: Button in $/root/GAME/CanvasLayer/Control.get_children():
			node.modulate.a = 0 if on else 1
		fps_counter.visible = false if on else true
