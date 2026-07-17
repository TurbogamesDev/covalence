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

func calculate_raw_accuracy_for_judgement_data(judgement_data: JudgementData, note_type: Enums.NOTE_TYPE, end_hit: bool) -> float:
    if end_hit:
        if note_type == Enums.NOTE_TYPE.HOLD_NOTE:
            return JUDGEMENT_TYPE_TO_ACCURACY_RELEASE_1[judgement_data.judgement_type]

        else:
            push_error("Unknown Note Type!")

            return 0.0

    else:
        if note_type == Enums.NOTE_TYPE.REGULAR_NOTE:
            return JUDGEMENT_TYPE_TO_ACCURACY_HIT_1[judgement_data.judgement_type]

        elif note_type == Enums.NOTE_TYPE.HOLD_NOTE:
            return JUDGEMENT_TYPE_TO_ACCURACY_HIT_1[judgement_data.judgement_type]

        else:
            push_error("Unknown Note Type!")

            return 0.0

func calculate_raw_strict_accuracy_for_judgement_data(judgement_data: JudgementData, note_type: Enums.NOTE_TYPE, end_hit: bool) -> float:
    if end_hit:
        if note_type == Enums.NOTE_TYPE.HOLD_NOTE:
            return JUDGEMENT_TYPE_TO_ACCURACY_RELEASE_2[judgement_data.judgement_type]

        else:
            push_error("Unknown Note Type!")

            return 0.0

    else:
        if note_type == Enums.NOTE_TYPE.REGULAR_NOTE:
            return JUDGEMENT_TYPE_TO_ACCURACY_HIT_2[judgement_data.judgement_type]

        elif note_type == Enums.NOTE_TYPE.HOLD_NOTE:
            return JUDGEMENT_TYPE_TO_ACCURACY_HIT_2[judgement_data.judgement_type]

        else:
            push_error("Unknown Note Type!")

            return 0.0

func add_judgement_data_to_accuracy(judgement_data: JudgementData, note_type: Enums.NOTE_TYPE, end_hit: bool):
    total_raw_accuracy += 1.0
    total_raw_strict_accuracy += 1.0

    current_raw_accuracy += calculate_raw_accuracy_for_judgement_data(judgement_data, note_type, end_hit)
    current_raw_strict_accuracy += calculate_raw_strict_accuracy_for_judgement_data(judgement_data, note_type, end_hit)

func get_max_raw_accuracy() -> float:
    var max_raw_accuracy: float = 0
    
    for note_type in ResultHandler.total_start_note_datas:
        var note_data_count = ResultHandler.total_start_note_datas[note_type]

        max_raw_accuracy += note_data_count * calculate_raw_accuracy_for_judgement_data(
            JudgementData.new(Enums.JUDGEMENT_TYPE.EXACT, 0.0),
            note_type,
            false
        )

    for note_type in ResultHandler.total_end_note_datas:
        var note_data_count = ResultHandler.total_end_note_datas[note_type]

        max_raw_accuracy += note_data_count * calculate_raw_accuracy_for_judgement_data(
            JudgementData.new(Enums.JUDGEMENT_TYPE.EXACT, 0.0),
            note_type,
            true
        )

    return max_raw_accuracy

func get_max_raw_strict_accuracy() -> float:
    var max_raw_strict_accuracy: float = 0
    
    for note_type in ResultHandler.total_start_note_datas:
        var note_data_count = ResultHandler.total_start_note_datas[note_type]

        max_raw_strict_accuracy += note_data_count * calculate_raw_strict_accuracy_for_judgement_data(
            JudgementData.new(Enums.JUDGEMENT_TYPE.EXACT, 0.0),
            note_type,
            false
        )

    for note_type in ResultHandler.total_end_note_datas:
        var note_data_count = ResultHandler.total_end_note_datas[note_type]

        max_raw_strict_accuracy += note_data_count * calculate_raw_strict_accuracy_for_judgement_data(
            JudgementData.new(Enums.JUDGEMENT_TYPE.EXACT, 0.0),
            note_type,
            true
        )

    return max_raw_strict_accuracy