extends Unit
class_name Player

var move_dir : Vector2

func _ready() -> void:
	print(anim_player.get_animation_list())
	
func _process(delta: float) -> void:
	move_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var current_velocity := move_dir * 500
	position += current_velocity * delta
	update_animation()
	update_rotation()
	
func update_animation():
	if move_dir.length() > 0 :
		anim_player.play('move')
	else:
		anim_player.play('idle')
	
func update_rotation() -> void:
	if move_dir == Vector2.ZERO:
		return
	if move_dir.x >= 0.1:
		visuals.scale = Vector2(-0.5,0.5)
	else:
		visuals.scale = Vector2(0.5,0.5)
