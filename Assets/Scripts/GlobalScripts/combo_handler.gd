extends Node

var current_combo: int = 0

const JUDGEMENT_TYPE_TO_BREAK_COMBO_BOOLEAN: Dictionary[Enums.JUDGEMENT_TYPE, bool] = {
    Enums.JUDGEMENT_TYPE.TOO_EARLY: true,
    Enums.JUDGEMENT_TYPE.EARLY_GOOD: false,
    Enums.JUDGEMENT_TYPE.EARLY_PERFECT: false,
    Enums.JUDGEMENT_TYPE.EXACT: false,
    Enums.JUDGEMENT_TYPE.LATE_PERFECT: false,
    Enums.JUDGEMENT_TYPE.LATE_GOOD: false,
    Enums.JUDGEMENT_TYPE.MISS: true,
    Enums.JUDGEMENT_TYPE.NONE: false
}

func update_combo_from_judgement_data(judgement_data: JudgementData):
    var break_combo: bool = JUDGEMENT_TYPE_TO_BREAK_COMBO_BOOLEAN[judgement_data.judgement_type]

    if break_combo:
        current_combo = 0
    else:
        current_combo += 1
