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

public loc smallProject = |project://hsqldb-2.3.1|;

public void run() {
	p = createM3FromEclipseProject(smallProject);
	ast = createAstsFromEclipseProject(smallProject, false);
	f = files(p);
	m = methods(p);
	
	
	vol = volume(f);
	volumeClass = ClassifyVolume(vol["source_lines"]);
	println("Volume");
	println("  Class  : <volumeClass>");
	println("  Rank   : <ReportSigClass(volumeClass)>");
	println("  Total lines   : <vol["total_lines"]>");
	println("  Source lines  : <vol["source_lines"]>");
	println("");
	
	unitComplexityClass = ClassifyComplexity(UnitComplexity(ast));
	println("Unit Complexity");
	println("  Class  : <unitComplexityClass>");
	println("  Rank   : <ReportSigClass(unitComplexityClass)>");
	println("");
	
	unitSizeClass = ClassifyUnitSize(UnitSize(m));
	println("Unit Size");
	println("  Class  : <unitSizeClass>");
	println("  Rank   : <ReportSigClass(unitSizeClass)>");
	println("");
	
	int duplicateLines = Duplication(f);

	int duplicateClass = ClassifyDuplication(duplicateLines, vol["source_lines"]);
	println("Duplication");
	println("  Class  : <duplicateClass>");
	println("  Rank   : <ReportSigClass(duplicateClass)>");
	println("  Percentage : <toReal(duplicateLines) / vol["source_lines"] * 100>");
	println("  Duplicate lines: <duplicateLines>");
	println("");
}
