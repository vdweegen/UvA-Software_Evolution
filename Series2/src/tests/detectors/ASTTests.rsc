module tests::detectors::ASTTests

extend detectors:: AST;


test bool TestTreeMass1() = treeMass("A"("V")) == 1;
test bool TestTreeMass12() = treeMass("A"("V"())) == 2;
test bool TestTreeMass13() = treeMass("A"("V"(), "W")) == 2;
test bool TestTreeMass14() = treeMass("A"("V"(), "W"())) == 3;
test bool TestTreeMass15() = treeMass("A"("V"("C"()))) == 3;

test bool TestUnsetNodes1() = unsetNodes("A"("V"("C"()))) == unsetRec("A"("V"("C"())));
test bool TestUnsetNodes2() = unsetNodes("A"(A="C")) == unsetRec("A"(A="C"));
test bool TestUnsetNodes3() = unsetNodes("A"(A="C")) == "A"();
