class_name HealthBarUi extends Sprite3D

@onready var health_bar: ProgressBar = $SubViewport/HealthBar
@onready var damage_bar: ProgressBar = $SubViewport/HealthBar/DamageBar
@onready var timer: Timer = $SubViewport/HealthBar/DamageBar/Timer


func _ready():
	health_bar.value = 1
	damage_bar.value = 1
func update_health(current_h : float, max_h : float):
	health_bar.value = current_h / max_h
	timer.start()

func _on_timer_timeout() -> void:
	damage_bar.value = health_bar.value
