extends Resource
class_name WaveData

enum SpawnType {
	FIXED,
	RANDOM
}

@export var from: int
@export var to: int
@export var wave_time := 20.0
@export var units: Array[WaveUnitData]

@export var spawn_type := SpawnType.RANDOM
@export var fixed_spawn_time := 1.0
@export var min_spawn_time := 1.0
@export var max_spawn_time := 1.0

func get_random_unit_scene() -> PackedScene:
	if units.is_empty():
		return null
	
	var valid_scenes: Array[PackedScene] = []
	for unit in units:
		if unit.unit_scene != null:
			valid_scenes.append(unit.unit_scene)
	
	if valid_scenes.is_empty():
		return null
		
	# Pick a random one from the valid list
	return valid_scenes[randi() % valid_scenes.size()]
	var enemies: Array[PackedScene]
	var weights: Array[float]
	
	for unit in units:
		enemies.append(unit.unit_scene)
		weights.append(unit.weight)
	
	var rng := RandomNumberGenerator.new()
	var random_unit = enemies[rng.rand_weighted(weights)]
	return random_unit

func is_valid_index(index: int) -> bool:
	return index >= from and index <= to
