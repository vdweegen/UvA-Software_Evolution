module tests::detectors::ASTTests

extend detectors:: AST;


public loc testClass = |project://TestProject/src/TestClass.java|;
public set[node] testClassAst = loadAst(testClass);
//public list[node] testClassSubTress = preprocess(testClassAst, 0);



test bool TestTreeMass1() = treeMass("A"("V")) == 1;
test bool TestTreeMass12() = treeMass("A"("V"())) == 2;
test bool TestTreeMass13() = treeMass("A"("V"(), "W")) == 2;
test bool TestTreeMass14() = treeMass("A"("V"(), "W"())) == 3;
test bool TestTreeMass15() = treeMass("A"("V"("C"()))) == 3;

test bool TestUnsetNodes1() = unsetNodes("A"("V"("C"()))) == unsetRec("A"("V"("C"())));
test bool TestUnsetNodes2() = unsetNodes("A"(A="C")) == unsetRec("A"(A="C"));
test bool TestUnsetNodes3() = unsetNodes("A"(A="C")) == "A"();


public str functionExample1 = "
public String subTree() {
		
		int a = 0;
		if (a \> 10) {
			System.out.println(\"This is a text\");
		}
		return null;
	}
";

test bool testHash1() = hashFast("A"()) == sum(chars("A"));

public node A1 = "A1"()[@hash = 1];
public node A2 = "A2"()[@hash = 2];
public node A3 = "A3"()[@hash = 3];

test bool TestExtractClones1() = size(extractClones([ A1, A1 ])[1]) == 2;
test bool TestExtractClones2() = size(extractClones([ A2,  A2,  A1 ])[2]) == 2;
test bool TestExtractClones3() = extractClones([ A1,  A2,  A3 ]) == ();
test bool TestExtractClones4() = extractClones([ A1, A1,  A2,  A3, A3 ]) == (1:[A1, A1], 3:[A3, A3]);

test bool TestSubTree1() = isSubTree(A1, "B1"(A1))  == true;
test bool TestSubTree2() = isSubTree(A1, "B1"("C1"(A1), A2, A3))  == true;
test bool TestSubTree3() = isSubTree(A2, "B1"(A1))  == false;




