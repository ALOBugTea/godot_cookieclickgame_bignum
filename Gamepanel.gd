extends Panel

const cookie_effect = preload("res://cookieEffect.tscn")

@onready var super_cookies = $superCookies
@onready var cookie_earn = $%CookieEarn
@onready var not_enough_cookies = $%NotEnoughCookies
@onready var cookies_machine = {
	"autoClicker": {"button": $%AutoClicker, "level": Big.new(0), "cost": Big.new(10), "earnPer": Big.new(1), "time": 3, "txt": "Auto Clicker"},
	"factory": {"button": $%Factory, "level": Big.new(0), "cost": Big.new(500), "earnPer": Big.new(15), "time": 5, "txt": "Factory"},
	"machineFactory": {"button": $%MachineFactory, "level": Big.new(0), "cost": Big.new(10000), "time": 7, "earnPer": Big.new(250), "txt": "Machine Factory"},
	"cokiesCard": {"button": $%CokiesCard, "level": Big.new(0), "cost": Big.new(100000), "time": 10, "earnPer": Big.new(1777), "txt": "Cokies Card"},
}
var cookies = null
@onready var cookiesLabel = $Cookies

# Called when the node enters the scene tree for the first time.
func _ready():
	if cookies == null:
		cookies = Big.new(0)
	not_enough_cookies.text = ""
	cookie_earn.pressed.connect(_on_cookie_earn)
	cookies_machine["autoClicker"]["button"].pressed.connect(_on_cookie_levelUp.bind("autoClicker"))
	cookies_machine["factory"]["button"].pressed.connect(_on_cookie_levelUp.bind("factory"))
	cookies_machine["machineFactory"]["button"].pressed.connect(_on_cookie_levelUp.bind("machineFactory"))
	cookies_machine["cokiesCard"]["button"].pressed.connect(_on_cookie_levelUp.bind("cokiesCard"))
	for which in cookies_machine:
		cookies_machine[which]["button"].text = cookies_machine[which]["txt"] + "\n Level: " + cookies_machine[which]["level"].toAA() + ", cost: " + cookies_machine[which]["cost"].toAA() + "\n "
	
	super_cookies.pressed.connect(_supercookie_get)
	var timer = Timer.new()
	super_cookies.add_child(timer)
	timer.wait_time = randf_range(7, 15)
	timer.start()
	super_cookies.visible = false
	timer.timeout.connect(_supercookie_visible)
func _supercookie_visible():
	super_cookies.visible = true

func _supercookie_get():
	if super_cookies.visible:
		super_cookies.visible = false
		var timer = super_cookies.get_child(1)
		timer.wait_time = randf_range(7, 15)
		timer.start()
		var nB = Big.new(1)
		for which in cookies_machine:
			var lv = Big.new(cookies_machine[which]["level"])
			var value = 0
			match which:
				"autoClicker":
					value = lv.multiply(1)
				"factory":
					value = lv.multiply(2)
				"machineFactory":
					value = lv.multiply(3)
				"cokiesCard":
					value = lv.multiply(4)
			nB.plus(value)
		cookies.plus(nB.multiply(77))
		var msg = "You got " + nB.toAA() + " from Super Cookies!"
		tips_text(msg)
func _on_cookie_levelUp(which):
	if cookies.isLargerThanOrEqualTo(cookies_machine[which]["cost"]) == true:
		cookies_machine[which]["level"].plus(1)
		cookies.minus(cookies_machine[which]["cost"])
		cookies_machine[which]["cost"].multiply(1.349).roundDown()
		cookies_machine[which]["button"].text = cookies_machine[which]["txt"] + "\n Level: " + cookies_machine[which]["level"].toAA() + ", cost: " + cookies_machine[which]["cost"].toAA() + "\n "
		if cookies_machine[which]["level"].isEqualTo(1):
			var tween = cookies_machine[which]["button"].create_tween().set_loops()
			var bar = cookies_machine[which]["button"].get_node("Bar")
			tween.tween_property(bar, "value", 100, cookies_machine[which]["time"]).set_trans(Tween.TRANS_BOUNCE)
			tween.tween_callback(_on_cookie_earn.bind(which))
		var msg = "Level Up! " + which + " is now Level " + cookies_machine[which]["level"].toAA() + "!"
		tips_text(msg)
	else:
		var b = Big.new(cookies_machine[which]["cost"])
		var msg = "You need more " + b.minus(cookies).toAA() + " Cookies!"
		tips_text(msg)
func tips_text(msg):
	not_enough_cookies.text = msg
	await get_tree().create_timer(3).timeout
	if not_enough_cookies.text == msg:
		not_enough_cookies.text = ""
	

func _on_cookie_earn(a = ""):
	if a != "":
		#var bar = cookies_machine[a]["button"].get_node("Bar")
		var earn = Big.new(cookies_machine[a]["earnPer"])
		#print(cookies_machine[a]["earnPer"].multiply(cookies_machine[a]["level"]).toAA())
		cookies.plus(earn.multiply(cookies_machine[a]["level"]))
		for n in cookies_machine[a]["level"].toFloat():
			spawn_cookie_effect(3/cookies_machine[a]["level"].toFloat() * 0.1)
	else:
		for which in cookies_machine:
			var lv = Big.new(cookies_machine[which]["level"])
			var value = 0
			match which:
				"autoClicker":
					value = lv.multiply(1)
				"factory":
					value = lv.multiply(2)
				"machineFactory":
					value = lv.multiply(3)
				"cokiesCard":
					value = lv.multiply(4)
			cookies.plus(value)
		cookies.plus(1)
		spawn_cookie_effect()
	#print(cookies_machine)
func spawn_cookie_effect(s = 0.1):
	var width = get_viewport_rect().end.x
	var height = get_viewport_rect().end.y
	var effect = spawn_effect(cookie_effect, Vector2(randf_range(0, width), randf_range(10, 50)))
	if effect:
		var tween = effect.create_tween()
		effect.scale = Vector2(s, s)
		tween.tween_property(effect, "scale", Vector2(s+0.1, s+0.1), 1)
		tween.tween_property(effect, "global_position", Vector2(effect.global_position.x, effect.global_position.y + height - 100), 2.3)
		tween.tween_property(effect, "scale", Vector2(0, 0), 3)
		tween.tween_callback(effect.queue_free)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var nB = Big.new(1)
	for which in cookies_machine:
		var lv = Big.new(cookies_machine[which]["level"])
		var value = 0
		match which:
			"autoClicker":
				value = lv.multiply(1)
			"factory":
				value = lv.multiply(2)
			"machineFactory":
				value = lv.multiply(3)
			"cokiesCard":
				value = lv.multiply(4)
		nB.plus(value)
	cookiesLabel.text = "Cookies: " + cookies.toAA() + "\n" + "click per get: " + nB.toAA()

func spawn_effect(EFFECT: PackedScene, effect_position: Vector2 = global_position):
	if EFFECT:
		var effect = EFFECT.instantiate()
		get_tree().current_scene.add_child(effect)
		effect.global_position = effect_position
		return effect
	return null
