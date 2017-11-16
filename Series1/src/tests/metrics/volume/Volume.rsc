module tests::metrics::volume::Volume

import metrics::volume::Volume;

test bool volumeTest1() = volume([""]) == (
		"total_lines": 1,
		"source_lines": 0,
		"comments": 0
	);
test bool volumeTest2() = volume(["", "/**/ Hello world"]) == (
		"total_lines": 2,
		"source_lines": 1,
		"comments": 1
	);
	
test bool volumeTest3() = volume(["", "/**/ Hello world //extra", "extra", "//hidden extra"]) == (
		"total_lines": 4,
		"source_lines": 2,
		"comments": 3
	);
	
test bool volumeTest4() = volume("\n/**/ Hello world //extra\n extra\n//hidden extra") == (
		"total_lines": 4,
		"source_lines": 2,
		"comments": 3
	);