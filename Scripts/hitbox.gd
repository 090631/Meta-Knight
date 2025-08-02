class_name HitBox
extends Area2D

signal Damaged(damage : int)

func TakeDamage(damage : int) -> void:
	owner.health -= damage
	print("Damage took: ", damage, " Health: ", owner.health)
	
	if owner.entity == "player":
		owner.hit_state = true
	
	owner.animated_sprite.play("hit")
	owner.hurt_audio.play()
	await get_tree().create_timer(0.3).timeout # To let animation play
	
	if owner.entity == "player":
		owner.hit_state = false
	
	owner.animated_sprite.play("idle")
	
	#Notifies entity (player or enemy node to die)
	if owner.health == 0:
		Damaged.emit(damage)
