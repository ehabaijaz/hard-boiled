extends Node

signal on_create_block_text(unit : Node2D)
signal on_create_damage_text(unit, hitbox: HitboxComponent)
var player : Player
const FLOATING_TEXT_SCENE = preload("uid://d1q2xjpgijnkm")
const FLASH_MATERIAL = preload("uid://cbn5jqdtxi5yw")

enum UpgradeTier {
	COMMON,
	RARE,
	EPIC,
	LEGENDARY
}
var game_paused := false

func get_chance_success(chance: float)-> bool:
	var random := randf_range(0,1.0)
	if random < chance:
		return true
	return false
