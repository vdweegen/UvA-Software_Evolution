module main

import IO;
import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;

import List;

import visualise::helpers::SigClass;
import util::Math;
import util::Benchmark;

// REORGANISE IMPORTS BEFORE DELIVERY!!!
import metrics::duplication::Duplication;
import metrics::unitcomplexity::UnitComplexity;
import metrics::unitsize::UnitSize;
import metrics::unittest::UnitTest;
import metrics::volume::Volume;

import aspects::analysability::Analysability;
import aspects::changeability::Changeability;
import aspects::stability::Stability;
import aspects::testability::Testability;

import visualise::metrics::volume::Volume;
import visualise::metrics::unitsize::UnitSize;
import visualise::metrics::unitcomplexity::UnitComplexity;
import visualise::metrics::duplication::Duplication;
import visualise::metrics::unittest::UnitTest;

import visualise::aspects::analysability::Analysability;
import visualise::aspects::changeability::Changeability;
import visualise::aspects::stability::Stability;
import visualise::aspects::testability::Testability;
//public loc largeProject = |project://hsqldb-2.3.1/src/|;
public loc smallProject = |project://smallsql0.21_src|;
public loc targetProject = smallProject;

public void run() {
	int startTime = realTime();
	p = createM3FromEclipseProject(targetProject);
	ast = createAstsFromEclipseProject(targetProject, false);
	f = files(p);
	m = methods(p);
	
	
	map[str, int] codeVolume = volume(f);
	int volumeClass = ClassifyVolume(codeVolume["source_lines"]);
	println("\nVolume");
	println("  Class         : <volumeClass>");
	println("  Rank          : <ReportSigClass(volumeClass)>");
	println("  Total lines   : <codeVolume["total_lines"]>");
	println("  Source lines  : <codeVolume["source_lines"]>");
	
	int unitComplexityClass = ClassifyComplexity(UnitComplexity(ast));
	println("\nUnit Complexity");
	println("  Class         : <unitComplexityClass>");
	println("  Rank          : <ReportSigClass(unitComplexityClass)>");
	
	list[real] c = partitionComplexity(UnitComplexity(ast));
	real ctotal = sum(c);
	println("  Percentages");
	println("    No risk     : <c[0] / ctotal * 100>%");
	println("    Low risk    : <c[1] / ctotal * 100>%");
	println("    Medium risk : <c[2] / ctotal * 100>%");
	println("    High risk   : <c[3] / ctotal * 100>%");
	
	int unitSizeClass = ClassifyUnitSize(UnitSize(m));
	println("\nUnit Size");
	println("  Class         : <unitSizeClass>");
	println("  Rank          : <ReportSigClass(unitSizeClass)>");
	
	list[real] usp = partitionUnitSize(UnitSize(m));
	real ustotal = sum(usp);
	println("  Percentages");
	println("    No risk     : <usp[0] / ustotal * 100>%");
	println("    Low risk    : <usp[1] / ustotal * 100>%");
	println("    Medium risk : <usp[2] / ustotal * 100>%");
	println("    High risk   : <usp[3] / ustotal * 100>%");
	
	
	
	
	real unitTestResult = UnitTest(ast);
	int unitTestClass = ClassifyUnitTest(unitTestResult);
	println("\nUnit Test quality");
	println("  Class         : <unitTestClass>");
	println("  Rank          : <ReportSigClass(unitTestClass)>");
	println("  Avg. Percentage: <unitTestResult>");
	
	
	int duplicateLines = Duplication(f);

	int duplicationClass = ClassifyDuplication(duplicateLines, codeVolume["source_lines"]);
	println("\nDuplication");
	println("  Class         : <duplicationClass>");
	println("  Rank          : <ReportSigClass(duplicationClass)>");
	println("  Percentage    : <toReal(duplicateLines) / codeVolume["source_lines"] * 100>%");
	println("  Duplicates    : <duplicateLines>\n");


	
	println("\nSIG Maintainability Model");
		
	int analysabilityClass = ClassifyAnalysability(volumeClass, duplicationClass, unitSizeClass);
	println("\nAnalysability");
	println("  Class         : <analysabilityClass>");
	println("  Rank          : <ReportSigClass(analysabilityClass)>");
	println("  SIG Score     : <ReportSigScore(analysabilityClass)>");
	
	int changeabilityClass = ClassifyChangeability(unitComplexityClass, duplicationClass);
	println("\nChangeability");
	println("  Class         : <changeabilityClass>");
	println("  Rank          : <ReportSigClass(changeabilityClass)>");
	println("  SIG Score     : <ReportSigScore(changeabilityClass)>");
	

	int stabilityClass = ClassifyStability();
	println("\nStability");
	println("  Class         : <stabilityClass>");
	println("  Rank          : <ReportSigClass(stabilityClass)>");
	println("  SIG Score     : <ReportSigScore(stabilityClass)>");
	

	int testabilityClass = ClassifyTestability(unitComplexityClass, unitSizeClass, unitTestClass);
	println("\nTestability");
	println("  Class         : <testabilityClass>");
	println("  Rank          : <ReportSigClass(testabilityClass)>");
	println("  SIG Score     : <ReportSigScore(testabilityClass)>");
	
	int avgTotalScore = round((analysabilityClass + changeabilityClass + stabilityClass + testabilityClass)/4);
	println("\nSIG Grade       : <ReportSigScore(avgTotalScore)>\n");
	println("Time taken <((realTime() - startTime) / 1000)> seconds");
}