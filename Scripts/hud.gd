extends CanvasLayer
@onready var player: CharacterBody2D = %Player
@onready var health: Label = $Control/Health
@onready var hud: CanvasLayer = $"."

	
func  _process(delta):
	health.text = "Health: " + str(player.health) 
	hud.follow_viewport_enabled = false
