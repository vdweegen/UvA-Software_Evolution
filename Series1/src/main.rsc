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

public loc smallProject = |project://smallsql0.21_src|;

public void run() {
	p = createM3FromEclipseProject(smallProject);
	ast = createAstsFromEclipseProject(smallProject, false);
	f = files(p);
	m = methods(p);
	
	
	map[str, int] codeVolume = volume(f);
	int volumeClass = ClassifyVolume(codeVolume["source_lines"]);
	println("Volume");
	println("  Class  : <volumeClass>");
	println("  Rank   : <ReportSigClass(volumeClass)>");
	println("  Total lines   : <codeVolume["total_lines"]>");
	println("  Source lines  : <codeVolume["source_lines"]>");
	println("");
	
	int unitComplexityClass = ClassifyComplexity(UnitComplexity(ast));
	println("Unit Complexity");
	println("  Class  : <unitComplexityClass>");
	println("  Rank   : <ReportSigClass(unitComplexityClass)>\n");
	
	int unitSizeClass = ClassifyUnitSize(UnitSize(m));
	println("Unit Size");
	println("  Class  : <unitSizeClass>");
	println("  Rank   : <ReportSigClass(unitSizeClass)>\n");
	
	
	int duplicateLines = Duplication(f);

	int duplicateClass = ClassifyDuplication(duplicateLines, codeVolume["source_lines"]);
	println("Duplication");
	println("  Class  : <duplicateClass>");
	println("  Rank   : <ReportSigClass(duplicateClass)>");
	println("  Percentage : <toReal(duplicateLines) / codeVolume["source_lines"] * 100>\n");
}
