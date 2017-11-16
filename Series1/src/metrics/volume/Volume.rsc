module metrics::volume::Volume

import helpers::Normalizer;
import List;
import String;

/*
	Read uncleaned source?
	
*/

public map[str, int] volume(str rawSource) {
	return volumeCounter(split("\n", rawSource), rawSource);
}

public map[str, int] volume(list[str] rawSourceLines) {
	return volumeCounter(rawSourceLines, intercalate("\n", rawSourceLines));
}

public map[str, int] volumeCounter(list[str] rawSourceLines, str rawSource) {
	return (
		"total_lines": size(rawSourceLines),
		"source_lines": size(normalize(rawSourceLines)),
		"comments": size(comments(rawSource))
	);
}