extends Area2D
@onready var check_point: Area2D = $"."
@onready var check_point_audio: AudioStreamPlayer2D = $CheckPointAudio

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.check_point = check_point.position.x 
		check_point_audio.play()
		print(body.check_point)
		
