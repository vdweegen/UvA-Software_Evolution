module main

import IO;
import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;

import List;

// REORGANISE IMPORTS BEFORE DELIVERY!!!
import metrics::duplication::Duplication;
import metrics::unitcomplexity::UnitComplexity;
import metrics::unitsize::UnitSize;
import metrics::volume;

import aspects::analysability;
import aspects::changeability;
import aspects::stability;
import aspects::testability;

import visualise::metrics::volume;
import visualise::metrics::unitsize;
import visualise::metrics::unitcomplexity;
import visualise::metrics::duplication;

import visualise::aspects::analysability;
import visualise::aspects::changeability;
import visualise::aspects::stability;
import visualise::aspects::testability;

public loc smallProject = |project://smallsql0.21_src|;

public void run() {
	p = createM3FromEclipseProject(smallProject);
	ast = createAstsFromEclipseProject(smallProject, false);
	
	f = files(p);
	println("LinesOfPrint: <size(LinesOfPrint(f))>");
	locc = size(LinesOfCode(f));
	println("LinesOfCode: <locc>");
	println("LinesOfCode Rank: <VisualiseVolume(locc)>");
	
	println("Complexity Rank: <VisualiseComplexity(calculateComplexity(ast))>");
	
	m = methods(p);
	locm = LinesOfCodePerMethod(m);
	//println("LinesOfCodePerMethod: <locm>");
	println("LinesOfCodePerMethod Rank: <VisualiseUnitsize(locm)>");
}
