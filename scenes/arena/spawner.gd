extends Node2D
class_name Spawner

@export var spawn_area_size := Vector2(1000, 500)
@export var waves_data: Array[WaveData]
@export var enemy_collection: Array[UnitStats]

@onready var spawn_timer: Timer = $SpawnTimer
@onready var wave_timer: Timer = $WaveTimer

var wave_index := 1
var current_wave_data: WaveData
var spawned_enemies: Array[Enemy] = []

func _ready() -> void:
	print("Found ", waves_data.size(), " wave resources")
	Global.game_paused = false
	if waves_data.is_empty():
		print("!! ERROR: No waves_data assigned in Inspector")
	start_wave()

func find_wave_data() -> WaveData:
	for wave in waves_data:
		if wave and wave.is_valid_index(wave_index):
			return wave
	return null

func start_wave() -> void:
	current_wave_data = find_wave_data()
	if not current_wave_data:
		wave_index = 1
		current_wave_data = find_wave_data()
		if not current_wave_data: return
	
	wave_timer.wait_time = current_wave_data.wave_time
	wave_timer.start()
	set_spawn_timer()

func set_spawn_timer() -> void:
	if not current_wave_data: return
	match current_wave_data.spawn_type:
		WaveData.SpawnType.FIXED:
			spawn_timer.wait_time = current_wave_data.fixed_spawn_time
		WaveData.SpawnType.RANDOM:
			spawn_timer.wait_time = randf_range(current_wave_data.min_spawn_time, current_wave_data.max_spawn_time)
	spawn_timer.start()

func get_random_spawn_position() -> Vector2:
	var random_x := randf_range(-spawn_area_size.x, spawn_area_size.x)
	var random_y := randf_range(-spawn_area_size.y, spawn_area_size.y)
	return global_position + Vector2(random_x, random_y)

func spawn_enemy() -> void:
	if Global.game_paused or current_wave_data == null: return
	
	var enemy_scene = current_wave_data.get_random_unit_scene()
	if enemy_scene:
		var enemy_instance = enemy_scene.instantiate()
		enemy_instance.global_position = get_random_spawn_position()
		get_parent().add_child(enemy_instance)
		if enemy_instance is Enemy:
			spawned_enemies.append(enemy_instance)
	else:
		print("!! ERROR: WaveData returned a null enemy scene. Check your weights!")
	
	set_spawn_timer()

func update_enemies_new_wave() -> void:
	for stat in enemy_collection:
		if stat:
			stat.health += stat.health_increase_per_wave
			stat.damage += stat.damage_increase_per_wave
			print("Updated Stat: New Health is ", stat.health)

func clear_enemies() -> void:
	for enemy in spawned_enemies:
		if is_instance_valid(enemy):
			enemy.queue_free()
	spawned_enemies.clear()
	
	var remaining_enemies = get_tree().get_nodes_in_group("enemies")
	for e in remaining_enemies:
		e.queue_free()

func get_wave_text() -> String:
	return "Wave %s" % wave_index

func get_wave_timer_text() -> String:
	return str(max(0, int(wave_timer.time_left)))

func _on_spawn_timer_timeout() -> void:
	spawn_enemy()

func _on_wave_timer_timeout() -> void:
	spawn_timer.stop()
	clear_enemies()
	update_enemies_new_wave()
	wave_index += 1
	Global.game_paused = true
	await get_tree().create_timer(2.0).timeout
	Global.game_paused = false
	start_wave()
