extends Node

var current_combo: int = 0

var highest_recorded_combo: int = 0

const JUDGEMENT_TYPE_TO_BREAK_COMBO_BOOLEAN_HIT_1: Dictionary[Enums.JUDGEMENT_TYPE, bool] = {
    Enums.JUDGEMENT_TYPE.TOO_EARLY: true,
    Enums.JUDGEMENT_TYPE.EARLY_GOOD: false,
    Enums.JUDGEMENT_TYPE.EARLY_PERFECT: false,
    Enums.JUDGEMENT_TYPE.EXACT: false,
    Enums.JUDGEMENT_TYPE.LATE_PERFECT: false,
    Enums.JUDGEMENT_TYPE.LATE_GOOD: false,
    Enums.JUDGEMENT_TYPE.MISS: true,
    Enums.JUDGEMENT_TYPE.NONE: false
}

const JUDGEMENT_TYPE_TO_BREAK_COMBO_BOOLEAN_RELEASE_1: Dictionary[Enums.JUDGEMENT_TYPE, bool] = {
    Enums.JUDGEMENT_TYPE.TOO_EARLY: true,
    Enums.JUDGEMENT_TYPE.EARLY_GOOD: false,
    Enums.JUDGEMENT_TYPE.EARLY_PERFECT: false,
    Enums.JUDGEMENT_TYPE.EXACT: false,
    Enums.JUDGEMENT_TYPE.NONE: false
}

func update_combo_from_judgement_data(judgement_data: JudgementData, note_type: Enums.NOTE_TYPE, end_hit: bool):
    var break_combo: bool

    if end_hit:
        if note_type == Enums.NOTE_TYPE.HOLD_NOTE:
            break_combo = JUDGEMENT_TYPE_TO_BREAK_COMBO_BOOLEAN_RELEASE_1[judgement_data.judgement_type]

        else:
            push_error("Unknown Note Type!")

    else:
        if note_type == Enums.NOTE_TYPE.REGULAR_NOTE:
            break_combo = JUDGEMENT_TYPE_TO_BREAK_COMBO_BOOLEAN_HIT_1[judgement_data.judgement_type]

        elif note_type == Enums.NOTE_TYPE.HOLD_NOTE:
            break_combo = JUDGEMENT_TYPE_TO_BREAK_COMBO_BOOLEAN_HIT_1[judgement_data.judgement_type]

        else:
            push_error("Unknown Note Type! %d" % note_type)

    if break_combo:
        current_combo = 0
    else:
        current_combo += 1

    if current_combo > highest_recorded_combo:
        highest_recorded_combo = current_combo


func get_max_combo() -> int:
    var max_combo: int = 0
    
    for note_type in ResultHandler.total_start_note_datas:
        var note_data_count = ResultHandler.total_start_note_datas[note_type]

        max_combo += note_data_count

    for note_type in ResultHandler.total_end_note_datas:
        var note_data_count = ResultHandler.total_end_note_datas[note_type]

        max_combo += note_data_count

    print("Max Combo: %d" % max_combo)

    return max_combo