module metrics::unitsize

import metrics::volume;

import List;

public map[loc, int] LinesOfCodePerMethod(set[loc] files) {
	map[loc, int] fileMap = ();
	for (file <- files) {
		/*
		 * TODO: Stop using ProcessFileLine from volume.rsc
		 * TODO: Decide whether to include first/last line of method
		 *       (i.e. the declaration)
		 */
		fileMap[file] = size(ProcessFileLine(file));
	}
	return fileMap;
}