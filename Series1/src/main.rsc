module main

import IO;
import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;

import List;

import visualise::helpers::SigClass;
import util::Math;

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
import visualise::metrics::unitsize::UnitSize;
import visualise::metrics::unitcomplexity::UnitComplexity;
import visualise::metrics::duplication::Duplication;

//import visualise::aspects::analysability::Analysability;
//import visualise::aspects::changeability::Changeability;
//import visualise::aspects::stability::Stability;
//import visualise::aspects::testability::Testability;

public loc smallProject = |project://hsqldb-2.3.1/src/|;

public void run() {
	p = createM3FromEclipseProject(smallProject);
	ast = createAstsFromEclipseProject(smallProject, false);
	f = files(p);
	m = methods(p);
	
	
	vol = volume(f);
	v = ClassifyVolume(vol["source_lines"]);
	println("Volume");
	println("  Class  : <v>");
	println("  Rank   : <ReportSigClass(v)>\n");
	
	uc = ClassifyComplexity(UnitComplexity(ast));
	println("Unit Complexity");
	println("  Class  : <uc>");
	println("  Rank   : <ReportSigClass(uc)>\n");
	
	us = ClassifyUnitSize(UnitSize(m));
	println("Unit Size");
	println("  Class  : <us>");
	println("  Rank   : <ReportSigClass(us)>\n");
	
	d = Duplication(f);

	int duplicateClass = ClassifyDuplication(d, vol["source_lines"]);
	println("Duplication");
	println("  Class  : <duplicateClass>");
	println("  Rank   : <ReportSigClass(duplicateClass)>");
	println("  Percentage : <percent(d, vol["source_lines"])>\n");
}
