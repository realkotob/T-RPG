extends Label

func on_Stats_ActualStatsChanged(ActualStats):
	text = "HP:" + (ActualStats.HP as String) + "\n"
	text += "MP:" + (ActualStats.MP as String) + "\n"
	text += "Actions:" + (ActualStats.Actions as String) + "\n"
	text += "Movements:" + (ActualStats.Movements as String)