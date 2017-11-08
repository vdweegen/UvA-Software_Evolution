module main

import IO;
import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;

import List;

import metrics::duplication;
import metrics::unitcomplexity;
import metrics::unitsize;
import metrics::unittests;
import metrics::volume;

import aspects::analysability;
import aspects::changeability;
import aspects::stability;
import aspects::testability;

public loc smallProject = |project://smallsql0.21_src|;

public void run() {
	m = createM3FromEclipseProject(smallProject);
	f = files(m);
	println("Lines: <size(Lines(f))>");
	println("LinesOfCode: <size(LinesOfCode(f))>");
}
