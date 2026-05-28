extends Polygon2D
class_name LaneHitEffect

const TIME_BEFORE_HIT_EFFECT_FADES = 0.2

const HIT_EFFECT_ACTIVE_ALPHA = 0.1
const HIT_EFFECT_NOT_ACTIVE_ALPHA = 0

var current_tween: Tween

func activate_hit_effect():
    if current_tween and current_tween.is_valid():
        current_tween.kill()

    self.color.a = HIT_EFFECT_ACTIVE_ALPHA

func deactivate_hit_effect():
    current_tween = get_tree().create_tween()
    current_tween.tween_property(self, "color:a", HIT_EFFECT_NOT_ACTIVE_ALPHA, TIME_BEFORE_HIT_EFFECT_FADES)


