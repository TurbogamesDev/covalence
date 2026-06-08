extends Node

var current_raw_accuracy: float = 0.0
var total_raw_accuracy: float = 0.0

const JUDGEMENT_TYPE_TO_ACCURACY: Dictionary[Enums.JUDGEMENT_TYPE, float] = {
    Enums.JUDGEMENT_TYPE.TOO_EARLY: 0.0,
    Enums.JUDGEMENT_TYPE.EARLY_GOOD: 0.5,
    Enums.JUDGEMENT_TYPE.EARLY_PERFECT: 1.0,
    Enums.JUDGEMENT_TYPE.EXACT: 1.0,
    Enums.JUDGEMENT_TYPE.LATE_PERFECT: 1.0,
    Enums.JUDGEMENT_TYPE.LATE_GOOD: 0.5,
    Enums.JUDGEMENT_TYPE.MISS: 0.0,
    Enums.JUDGEMENT_TYPE.NONE: 0.0
}

func get_current_accuracy():
    if total_raw_accuracy == 0.0:
        return 100.0

    else:
        return 100 * (current_raw_accuracy / total_raw_accuracy)

func add_judgement_data_to_accuracy(judgement_data: JudgementData):
    total_raw_accuracy += 1

    current_raw_accuracy += JUDGEMENT_TYPE_TO_ACCURACY[judgement_data.judgement_type]



