module tests::metrics::duplication::Duplication

import metrics::duplication::Duplication;
import List;
import String;
import helpers::Normalizer;

public str example = "
this is line 1
this is line 2
this is line 3
this is line 4
this is line 5
this is line 6

apples cars
are awesome

this is line 1
this is line 2
this is line 3
this is line 4
this is line 5
this is line 6


this is line 1
this is line 2
this is line 3
this is line 4
this is line 5
this is line 6

";


public str example2 = "
this is line 1
this is line 2
this is line 3
this is line 4
this is line 5
this is line 6


this is line 1
this is line 2
this is line 3
this is line 4
this is line 5
this is line 6

this is line 6



";


public str example3 = "
this is line 1
this is line 2
this is line 3
this is line 4
this is line 5
this is line 6
this is line 7
this is line 8
this is line 9
this is line 10
this is line 11
---
123
test bool duplication1() = Duplication([]) == 0;
test bool duplication2() = testWithString(example) == 18;
test bool duplication3() = testWithString(example2) == 12;
test bool duplication4() = testWithString(example3) == 33;
aa ----
this is line 1
this is line 2
this is line 3
this is line 4
this is line 5
this is line 6
this is line 7
this is line 8
this is line 9
this is line 10
this is line 11
{
test bool duplication1() = Duplication([]) == 0;
test bool duplication2() = testWithString(example) == 18;
test bool duplication3() = testWithString(example2) == 12;
test bool duplication4() = testWithString(example3) == 33;
}
this is line 1
this is line 2
this is line 3
this is line 4
this is line 5
this is line 6
this is line 7
this is line 8
this is line 9
this is line 10
this is line 11

";

test bool duplication1() = Duplication([]) == 0;
test bool duplication2() = testWithString(example) == 18;
test bool duplication3() = testWithString(example2) == 12;
test bool duplication4() = testWithString(example3) == 33;


public int testWithString(str source) = Duplication(normalize(split("\n", source)));