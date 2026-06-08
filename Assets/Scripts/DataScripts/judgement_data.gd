extends RefCounted
class_name JudgementData

var judgement_offset: float
var judgement_type: Enums.JUDGEMENT_TYPE

func _init(init_judgement_type: Enums.JUDGEMENT_TYPE, init_judgment_offset: float):
    self.judgement_offset = init_judgment_offset

    self.judgement_type = init_judgement_type