extends Node

var current_raw_accuracy: float = 0.0
var total_raw_accuracy: float = 0.0

var current_raw_strict_accuracy: float = 0.0
var total_raw_strict_accuracy: float = 0.0


const JUDGEMENT_TYPE_TO_ACCURACY_HIT_1: Dictionary[Enums.JUDGEMENT_TYPE, float] = {
    Enums.JUDGEMENT_TYPE.TOO_EARLY: 0.0,
    Enums.JUDGEMENT_TYPE.EARLY_GOOD: 0.5,
    Enums.JUDGEMENT_TYPE.EARLY_PERFECT: 1.0,
    Enums.JUDGEMENT_TYPE.EXACT: 1.0,
    Enums.JUDGEMENT_TYPE.LATE_PERFECT: 1.0,
    Enums.JUDGEMENT_TYPE.LATE_GOOD: 0.5,
    Enums.JUDGEMENT_TYPE.MISS: 0.0,
    Enums.JUDGEMENT_TYPE.NONE: 0.0
}

const JUDGEMENT_TYPE_TO_ACCURACY_HIT_2: Dictionary[Enums.JUDGEMENT_TYPE, float] = {
    Enums.JUDGEMENT_TYPE.TOO_EARLY: -1.0,
    Enums.JUDGEMENT_TYPE.EARLY_GOOD: -0.5,
    Enums.JUDGEMENT_TYPE.EARLY_PERFECT: 0.0,
    Enums.JUDGEMENT_TYPE.EXACT: 1.0,
    Enums.JUDGEMENT_TYPE.LATE_PERFECT: 0.0,
    Enums.JUDGEMENT_TYPE.LATE_GOOD: -0.5,
    Enums.JUDGEMENT_TYPE.MISS: -1.0,
    Enums.JUDGEMENT_TYPE.NONE: 0.0
}

const JUDGEMENT_TYPE_TO_ACCURACY_RELEASE_1: Dictionary[Enums.JUDGEMENT_TYPE, float] = {
    Enums.JUDGEMENT_TYPE.TOO_EARLY: 0.0,
    Enums.JUDGEMENT_TYPE.EARLY_GOOD: 0.75,
    Enums.JUDGEMENT_TYPE.EARLY_PERFECT: 1.0,
    Enums.JUDGEMENT_TYPE.EXACT: 1.0,
}

const JUDGEMENT_TYPE_TO_ACCURACY_RELEASE_2: Dictionary[Enums.JUDGEMENT_TYPE, float] = {
    Enums.JUDGEMENT_TYPE.TOO_EARLY: -1.0,
    Enums.JUDGEMENT_TYPE.EARLY_GOOD: -0.25,
    Enums.JUDGEMENT_TYPE.EARLY_PERFECT: 0.0,
    Enums.JUDGEMENT_TYPE.EXACT: 1.0,
}

func get_current_accuracy():
    if total_raw_accuracy == 0.0:
        return 100.0

    else:
        return 100.0 * (current_raw_accuracy / total_raw_accuracy)

func get_current_strict_accuracy():
    if total_raw_strict_accuracy == 0.0:
        return 100.0

    else:
        return 100.0 * (current_raw_strict_accuracy / total_raw_strict_accuracy)

func add_judgement_data_to_accuracy(judgement_data: JudgementData, note_type: Enums.NOTE_TYPE, end_hit: bool):
    total_raw_accuracy += 1.0
    total_raw_strict_accuracy += 1.0

    if end_hit:
        if note_type == Enums.NOTE_TYPE.HOLD_NOTE:
            current_raw_accuracy += JUDGEMENT_TYPE_TO_ACCURACY_RELEASE_1[judgement_data.judgement_type]
            current_raw_strict_accuracy += JUDGEMENT_TYPE_TO_ACCURACY_RELEASE_2[judgement_data.judgement_type]

        else:
            push_error("Unknown Note Type!")

    else:
        if note_type == Enums.NOTE_TYPE.REGULAR_NOTE:
            current_raw_accuracy += JUDGEMENT_TYPE_TO_ACCURACY_HIT_1[judgement_data.judgement_type]
            current_raw_strict_accuracy += JUDGEMENT_TYPE_TO_ACCURACY_HIT_2[judgement_data.judgement_type]

        elif note_type == Enums.NOTE_TYPE.HOLD_NOTE:
            current_raw_accuracy += JUDGEMENT_TYPE_TO_ACCURACY_HIT_1[judgement_data.judgement_type]
            current_raw_strict_accuracy += JUDGEMENT_TYPE_TO_ACCURACY_HIT_2[judgement_data.judgement_type]

        else:
            push_error("Unknown Note Type!")

    



