module main

import IO;
import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;

import List;
import ListRelation;
import helpers::Math;

import visualise::helpers::SigClass;
import util::Math;
import util::Benchmark;

import metrics::duplication::Duplication;
import metrics::unitcomplexity::UnitComplexity;
import metrics::unitsize::UnitSize;
import metrics::unitsize::NOM;
import metrics::unitsize::WMC;
import metrics::unittest::UnitTest;
import metrics::volume::Volume;

import visualise::metrics::volume::Volume;
import visualise::metrics::unitsize::UnitSize;
import visualise::metrics::unitcomplexity::UnitComplexity;
import visualise::metrics::duplication::Duplication;
import visualise::metrics::unittest::UnitTest;

import visualise::aspects::analysability::Analysability;
import visualise::aspects::changeability::Changeability;
import visualise::aspects::stability::Stability;
import visualise::aspects::testability::Testability;

public loc largeProject = |project://hsqldb-2.3.1|;
public loc smallProject = |project://smallsql0.21_src|;
public loc targetProject = smallProject;
public bool extraMetrics = true;

public void run() {
	int startTime = realTime();
	p = createM3FromEclipseProject(targetProject);
	ast = createAstsFromEclipseProject(targetProject, false);
	f = files(p);
	m = methods(p);
	
	if (extraMetrics) {
		list[int] nomValue = NOM(classes(p));
		println("
		'NOM
		'  Classes       : <size(nomValue)>
		'  Methods       : <sum(nomValue)>
		'  Max           : <max(nomValue)>
		'  Min           : <min(nomValue)>
		'  Average       : <(0 | it + x | x <-nomValue) / size(nomValue)>");
		
		list[int] wmcValue = WMC(classes(p));
		println("
		'WMC
		'  Classes       : <size(wmcValue)>
		'  Max           : <max(wmcValue)>
		'  Min           : <min(wmcValue)>
		'  Average       : <avg(wmcValue)>");
	}
	
	map[str, int] codeVolume = volume(f);
	int volumeClass = ClassifyVolume(codeVolume["source_lines"]);
	println("
	'Volume
	'  Class         : <volumeClass>
	'  Rank          : <ReportSigClass(volumeClass)>
	'  Total lines   : <codeVolume["total_lines"]>
	'  Source lines  : <codeVolume["source_lines"]>");
	
	lrel[int comp, int sloc] uc = UnitComplexity(ast);
	ucDomain = domain(uc);
	int unitComplexityClass = ClassifyComplexity(uc);
	
	println("
	'Unit Complexity
	'  Class         : <unitComplexityClass>
	'  Max           : <max(ucDomain)>
	'  Min           : <min(ucDomain)>
	'  Rank          : <ReportSigClass(unitComplexityClass)>");
	
	list[real] c = partitionComplexity(UnitComplexity(ast));
	real ctotal = sum(c);
	println(formatRisk(c, ctotal));

	
	int unitSizeClass = ClassifyUnitSize(UnitSize(m));
	println("
	'Unit Size
	'  Class         : <unitSizeClass>
	'  Rank          : <ReportSigClass(unitSizeClass)>");
	
	list[real] usp = partitionUnitSize(UnitSize(m));
	real ustotal = sum(usp);
	println(formatRisk(usp, ustotal));
	
	real unitTestResult = UnitTest(ast);
	int unitTestClass = ClassifyUnitTest(unitTestResult);
	
	println("
	'Unit Test quality
	'  Class         : <unitTestClass>
	'  Rank          : <ReportSigClass(unitTestClass)>
	'  Avg. Percentage: <roundReport(unitTestResult)>");
	
	
	int duplicateLines = Duplication(f);

	int duplicationClass = ClassifyDuplication(duplicateLines, codeVolume["source_lines"]);
	println("
	'Duplication
	'  Class         : <duplicationClass>
	'  Rank          : <ReportSigClass(duplicationClass)>
	'  Percentage    : <roundReport(toReal(duplicateLines) / codeVolume["source_lines"] * 100)>%
	'  Duplicates    : <duplicateLines>\n");


	
	println("
	'SIG Maintainability Model");
		
	int analysabilityClass = ClassifyAnalysability(volumeClass, duplicationClass, unitSizeClass, unitTestClass);
	println("
	'Analysability
	'  Class         : <analysabilityClass>
	'  Rank          : <ReportSigClass(analysabilityClass)>
	'  SIG Score     : <ReportSigScore(analysabilityClass)>");
	
	int changeabilityClass = ClassifyChangeability(unitComplexityClass, duplicationClass);
	println("
	'Changeability
	'  Class         : <changeabilityClass>
	'  Rank          : <ReportSigClass(changeabilityClass)>
	'  SIG Score     : <ReportSigScore(changeabilityClass)>");
	

	int stabilityClass = ClassifyStability(unitTestClass);
	println("
	'Stability
	'  Class         : <stabilityClass>
	'  Rank          : <ReportSigClass(stabilityClass)>
	'  SIG Score     : <ReportSigScore(stabilityClass)>");
	

	int testabilityClass = ClassifyTestability(unitComplexityClass, unitSizeClass, unitTestClass);
	println("
	'Testability
	'  Class         : <testabilityClass>
	'  Rank          : <ReportSigClass(testabilityClass)>
	'  SIG Score     : <ReportSigScore(testabilityClass)>");
	
	int avgTotalScore = round((analysabilityClass + changeabilityClass + stabilityClass + testabilityClass)/4);
	
	println("
	'SIG Grade       : <ReportSigScore(avgTotalScore)>\n
	'Time taken <((realTime() - startTime) / 1000)> seconds");
}


str formatRisk(list[real] classes, real total) {
	return "  Percentages
	'    No risk     : <roundReport(classes[0] / total * 100)>%
	'    Low risk    : <roundReport(classes[1] / total * 100)>%
	'    Medium risk : <roundReport(classes[2] / total * 100)>%
	'    High risk   : <roundReport(classes[3] / total * 100)>%";
}

real roundReport(real i) = round(i, 0.01);