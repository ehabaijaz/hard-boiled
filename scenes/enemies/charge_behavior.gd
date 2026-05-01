extends Node2D
class_name ChargeBehavior

@export var enemy : Enemy
@export var anim_effects: AnimationPlayer
@export var prep_time := 1.0
@export var cooldown := 3.0

var current_cooldown := 0.0
var charge_attack_position := Vector2.ZERO
var is_charging := false
var is_preparing := false

func _ready() -> void:
	current_cooldown = cooldown

func _process(delta: float) -> void:
	if enemy == null: return
	
	if is_charging:
		# MOVEMENT DEBUG
		var dist = enemy.global_position.distance_to(charge_attack_position)
		enemy.global_position = enemy.global_position.move_toward(charge_attack_position, (enemy.stats.speed * 5) * delta)
		
		if dist < 20:
			end_charge()
	else:
		if is_preparing: return 
		
		if current_cooldown > 0:
			current_cooldown -= delta
		else:
			if is_instance_valid(Global.player):
				start_charge()
			else:
				current_cooldown = 1.0 

func start_charge():
	is_preparing = true
	enemy.can_move = false
	
	if anim_effects:
		anim_effects.play("charge")
		await anim_effects.animation_finished
	else:
		await get_tree().create_timer(prep_time).timeout
		
	charge_attack_position = Global.player.global_position
	is_preparing = false
	is_charging = true

func end_charge():
	is_charging = false
	current_cooldown = cooldown
	enemy.can_move = true
