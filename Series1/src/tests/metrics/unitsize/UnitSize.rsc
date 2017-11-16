module tests::metrics::unitsize::UnitSize

import metrics::unitsize::UnitSize;

test bool unitSizeTest1() = unitSize("") == 1;
test bool unitSizeTest2() = unitSize("a\nb\nc") == 3;
test bool unitSizeTest3() = unitSize("Hello  \n World") == 2;