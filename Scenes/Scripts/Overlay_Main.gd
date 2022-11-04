	new_arrow.set_overlap_radius(settings.arrow_overlap_radius)
	new_arrow.connect("overlapped_arrow", self, "remove_arrow")
