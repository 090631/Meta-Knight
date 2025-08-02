extends CanvasLayer
@onready var player: CharacterBody2D = %Player
@onready var health: Label = $Health

func  _process(delta):
	health.text = "Health: " + str(player.health) 
