module main

import IO;
import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;

import List;

// REORGANISE IMPORTS BEFORE DELIVERY!!!
import metrics::duplication;
import metrics::unitcomplexity;
import metrics::unitsize;
import metrics::unittests;
import metrics::volume;

import aspects::analysability;
import aspects::changeability;
import aspects::stability;
import aspects::testability;

import visualise::metrics::volume;
import visualise::metrics::unittests;
import visualise::metrics::unitsize;
import visualise::metrics::unitcomplexity;
import visualise::metrics::duplication;

import visualise::aspects::analysability;
import visualise::aspects::changeability;
import visualise::aspects::stability;
import visualise::aspects::testability;

public loc smallProject = |project://smallsql0.21_src|;

public void run() {
	m = createM3FromEclipseProject(smallProject);
	f = files(m);
	println("LinesOfPrint: <size(LinesOfPrint(f))>");
	println("LinesOfCode: <size(LinesOfCode(f))>");
	
	println("LinesOfCode Rank: <VisualiseVolume(size(LinesOfCode(f)))>");
}
