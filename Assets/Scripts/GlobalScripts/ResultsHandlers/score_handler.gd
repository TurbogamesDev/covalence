extends Node

const MAX_ACCURACY_SCORE = 990_000
const MAX_STRICT_ACCURACY_SCORE = 10_000
const MAX_COMBO_SCORE = 10_000

func calculate_current_score() -> int:
    var highest_recorded_combo = ComboHandler.highest_recorded_combo
    var total_combo = ComboHandler.get_max_combo()

    var combo_score = (float(highest_recorded_combo) / total_combo) * MAX_COMBO_SCORE

    return combo_score + MAX_STRICT_ACCURACY_SCORE + MAX_ACCURACY_SCORE 
