extends Resource

class_name UnitStats

enum UnitType {
	PLAYER,
	ENEMY
}
@export var name: String
@export var type : UnitType
@export var icon : Texture2D
@export var health:= 1
@export var health_increase_per_wave := 1.0
