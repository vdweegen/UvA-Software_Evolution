module main

import IO;
import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;

import List;

import visualise::helpers::SigClass;

// REORGANISE IMPORTS BEFORE DELIVERY!!!
import metrics::duplication::Duplication;
import metrics::unitcomplexity::UnitComplexity;
import metrics::unitsize::UnitSize;
import metrics::volume::Volume;

import aspects::analysability::Analysability;
import aspects::changeability::Changeability;
import aspects::stability::Stability;
import aspects::testability::Testability;

import visualise::metrics::volume::Volume;
//import visualise::metrics::unitsize::UnitSize;
import visualise::metrics::unitcomplexity::UnitComplexity;
//import visualise::metrics::duplication::Duplication;
//
//import visualise::aspects::analysability::Analysability;
//import visualise::aspects::changeability::Changeability;
//import visualise::aspects::stability::Stability;
//import visualise::aspects::testability::Testability;

public loc smallProject = |project://smallsql0.21_src|;

public void run() {
	p = createM3FromEclipseProject(smallProject);
	ast = createAstsFromEclipseProject(smallProject, false);
	f = files(p);
	
	uc = ClassifyComplexity(UnitComplexity(ast));
	println("Unit Complexity");
	println("  Class  : <uc>");
	println("  Rank   : <ReportSigClass(uc)>");
	
	println("Duplication");
	//println("  Class  : <>");
	//println("  Rank   : <>");
	
	println("Unit Size");
	//println("  Class  : <>");
	//println("  Rank   : <>");
	
	println("Volume");
	v = ClassifyVolume(volume(f)["source_lines"]);
	println("  Class  : <v>");
	println("  Rank   : <ReportSigClass(v)>");
}
