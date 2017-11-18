import visualise::aspects::analysability::Analysability;
import visualise::aspects::changeability::Changeability;
import visualise::aspects::stability::Stability;
import visualise::aspects::testability::Testability;
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

	int unitSizeClass = ClassifyUnitSize(UnitSize(m));
	println("\nUnit Size");
	println("  Class         : <unitSizeClass>");
	println("  Rank          : <ReportSigClass(unitSizeClass)>");

	int duplicationClass = ClassifyDuplication(duplicateLines, codeVolume["source_lines"]);
	println("\nDuplication");
	println("  Class         : <duplicationClass>");
	println("  Rank          : <ReportSigClass(duplicationClass)>");
	println("  Percentage    : <toReal(duplicateLines) / codeVolume["source_lines"] * 100>%\n");

	println("\nSIG Maintainability Model");
	
	// NOTE: We dont have unittesting
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
	
	// NOTE: We dont have unittesting
	int stabilityClass = ClassifyStability();
	println("\nStability");
	println("  Class         : <stabilityClass>");
	println("  Rank          : <ReportSigClass(stabilityClass)>");
	println("  SIG Score     : <ReportSigScore(stabilityClass)>");
	
	// NOTE: We dont have unittesting
	int testabilityClass = ClassifyTestability(unitComplexityClass, unitSizeClass);
	println("\nTestability");
	println("  Class         : <testabilityClass>");
	println("  Rank          : <ReportSigClass(testabilityClass)>");
	println("  SIG Score     : <ReportSigScore(testabilityClass)>");
	
	int avgTotalScore = round((analysabilityClass + changeabilityClass + stabilityClass + testabilityClass)/4);
	println("\nSIG Grade       : <ReportSigScore(avgTotalScore)>");
