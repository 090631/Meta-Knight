extends Area2D
@onready var collect_audio: AudioStreamPlayer2D = $CollectAudio

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.heal(1)
	collect_audio.pitch_scale = randf_range(0.9, 1.1)
	collect_audio.play()
	await get_tree().create_timer(0.1).timeout
	queue_free()
