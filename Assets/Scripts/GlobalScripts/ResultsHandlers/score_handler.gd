extends Node

const MAX_ACCURACY_SCORE = 990_000
const MAX_STRICT_ACCURACY_SCORE = 10_000
const MAX_COMBO_SCORE = 10_000

func calculate_current_score() -> int:
    var highest_recorded_combo = ComboHandler.highest_recorded_combo
    var total_combo = ComboHandler.get_max_combo()

    var current_raw_strict_accuracy = AccuracyHandler.current_raw_strict_accuracy
    var total_raw_strict_accuracy = AccuracyHandler.get_max_raw_strict_accuracy()

    var current_raw_accuracy = AccuracyHandler.current_raw_accuracy
    var total_raw_accuracy = AccuracyHandler.get_max_raw_accuracy()

    





    var combo_score = (float(highest_recorded_combo) / total_combo) * MAX_COMBO_SCORE
    var strict_accuracy_score = (float(current_raw_strict_accuracy) / total_raw_strict_accuracy) * MAX_STRICT_ACCURACY_SCORE
    var accuracy_score = (float(current_raw_accuracy) / total_raw_accuracy) * MAX_ACCURACY_SCORE

    return combo_score + strict_accuracy_score + accuracy_score 
