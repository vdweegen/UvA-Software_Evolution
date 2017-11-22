module tests::metrics::unitsize::UnitSize

import metrics::unitsize::UnitSize;

test bool unitSizeTest1() = UnitSize("") == 1;
test bool unitSizeTest1a() = UnitSize(" ") == 1;
test bool unitSizeTest2() = UnitSize("a\nb\nc") == 3;
test bool unitSizeTest3() = UnitSize("Hello  \n World") == 2;