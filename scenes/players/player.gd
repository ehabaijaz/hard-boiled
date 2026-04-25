extends Unit
class_name Player

var move_dir : Vector2
@export var dash_duration := 0.1
@export var dash_speed_multi := 2.5
@export var dash_cooldown := 3.0
@onready var trail: Trail = %Trail


@onready var dash_timer: Timer = $DashTimer
@onready var dash_cooldown_timer: Timer = $DashCooldownTimer
@onready var collision: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	self.scale = Vector2(1.0,1.0)
	dash_timer.wait_time = dash_duration
	dash_cooldown_timer.wait_time = dash_cooldown
var is_dashing := false
var dash_available := true

func _process(delta: float) -> void:
	move_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var current_velocity := move_dir * stats.speed
	if is_dashing:
		current_velocity *= dash_speed_multi
	position += current_velocity * delta
	position.x = clamp(position.x, -1000, 1000)
	position.y = clamp(position.y, -500, 500)
	
	update_animation()
	update_rotation()
	if can_dash():
		start_dash()
	
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

func start_dash():
	trail.start_trail()
	is_dashing = true
	dash_timer.start()
	visuals.modulate.a = 0.5
	collision.set_deferred("disabled" , true)

func can_dash() -> bool:
	return not is_dashing and\
	dash_cooldown_timer.is_stopped()\
	and Input.is_action_just_pressed("dash") and\
	move_dir != Vector2.ZERO

func _on_dash_timer_timeout() -> void:
	is_dashing = false 
	visuals.modulate.a = 1
	move_dir = Vector2.ZERO
	collision.set_deferred('disabled', false)
	dash_cooldown_timer.start()
