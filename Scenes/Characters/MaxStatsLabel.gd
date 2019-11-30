extends Label

func on_Stats_MaxStatsChanged(MaxStats):
	text = "Max HP:" + (MaxStats.HP as String) + "\n"
	text += "Max MP:" + (MaxStats.MP as String) + "\n"
	text += "Max Actions:" + (MaxStats.Actions as String) + "\n"
	text += "Max Movements:" + (MaxStats.Movements as String)