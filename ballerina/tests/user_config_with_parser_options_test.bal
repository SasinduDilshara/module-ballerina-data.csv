import ballerina/test;

boolean enable = true;

@test:Config {enable: !enable}
function debugTest() returns error? {

    string csvValue1 = string `
        "a", b, c
                                1, "2a\t", "3b\n"
                                "1c\n", 2, 3
                                1, "2a\"", 3
                                
                                "1a\\", "2b\\"", "3"`;

    string csvValue2 = string `
        "a\"", "\tb\t\n", c
                                1, "2a\t", "3b\n"
                                "1c\n", "/2/", 3
                                1, "2a\"", "3"
                                
                                "1a\\", "2b\\"", "3"`;

    record {}[]|CsvConversionError cn = parseStringToRecord(csvValue1, {header: 1});
    test:assertEquals(cn, [{"a": 1, "b": "2a\t", "c": "3b\n"}, {"a": "1c\n", "b": 2, "c": 3}, {"a": 1, "b": "2a\"", "c": 3}, {"a": "1a\\", "b": "2b\\\"", "c": 3}]);

    record {}[]|CsvConversionError cn2 = parseStringToRecord(csvValue2, {header: 1});
    test:assertEquals(cn2, [{"a\"": 1, "\tb\t\n": "2a\t", "c": "3b\n"}, {"a\"": "1c\n", "\tb\t\n": "/2/", "c": 3}, {"a\"": 1, "\tb\t\n": "2a\"", "c": 3}, {"a\"": "1a\\", "\tb\t\n": "2b\\\"", "c": 3}]);
}

@test:Config {enable}
function testFromCsvStringWithParserOptions() {
    [int, string, boolean, decimal, float, string][]|CsvConversionError csv1op3 = parseStringToList(csvStringData1, option3);
    test:assertEquals(csv1op3, [
        [3, "string3", false, <decimal>1.23, <float>1.23, "()"],
        [4, "string4", true, <decimal>-6.51, <float>-6.51, "()"],
        [5, "string5", true, <decimal>3, <float>3.0, "()"]
    ]);

    record {int a; string b; boolean c; decimal d; float e; string f;}[]|CsvConversionError csv1op3_2 = parseStringToRecord(csvStringData1, ptOption1);
    test:assertEquals(csv1op3_2, [
        {a: 1, b: "string1", c: true, d: <decimal>2.234, e: <float>2.234, f: "()"},
        {a: 3, b: "string3", c: false, d: <decimal>1.23, e: <float>1.23, f: "()"},
        {a: 5, b: "string5", c: true, d: <decimal>3, e: <float>3.0, f: "()"}
    ]);

    record {int a; string b; boolean c; decimal d; float e; string f;}[]|CsvConversionError csv1op3_3 = parseStringToRecord(csvStringData1, ptOption2);
    test:assertEquals(csv1op3_3, [
        {a: 1, b: "string1", c: true, d: <decimal>2.234, e: <float>2.234, f: "()"},
        {a: 5, b: "string5", c: true, d: <decimal>3, e: <float>3.0, f: "()"}
    ]);

    [int, string, boolean, decimal, float, string][]|CsvConversionError csv2op4 = parseStringToList(csvStringData2, option4);
    test:assertEquals(csv2op4, []);

    record {}[]|CsvConversionError csv2op4_2 = parseStringToRecord(csvStringData2, ptOption3);
    test:assertEquals(csv2op4_2, []);

    record {}[]|CsvConversionError csv2op4_3 = parseStringToRecord(csvStringData2, ptOption4);
    test:assertEquals(csv2op4_3, [
        {a: 1, b: "string1", c: true, d: 2.234, e: 2.234, f: "()"},
        {a: 3, b: "string3", c: 0, d: 1.23, e: 1.23, f: "()"},
        {a: 5, b: "string5", c: true, d: 3, e: 3, f: "()"}
    ]);

    [int, string, boolean, decimal, float, string][]|CsvConversionError csv3op3 = parseStringToList(csvStringData3, option3);
    test:assertEquals(csv3op3, [
        [3, "string3", false, <decimal>1.23, <float>1.23, "()"],
        [4, "string4", true, <decimal>-6.51, <float>-6.51, "()"],
        [5, "string5", true, <decimal>3, <float>3.0, "()"]
    ]);

    record {}[]|CsvConversionError csv3op3_2 = parseStringToRecord(csvStringData3, ptOption1);
    test:assertEquals(csv3op3_2, [
        {a: 1, b: "string1", c: true, d: 2.234, e: 2.234, f: "()"},
        {a: 3, b: "string3", c: 0, d: 1.23, e: 1.23, f: "()"},
        {a: 5, b: "string5", c: true, d: 3, e: 3, f: "()"}
    ]);

    record {}[]|CsvConversionError csv3op3_3 = parseStringToRecord(csvStringData3, ptOption2);
    test:assertEquals(csv3op3_3, [
        {a: 1, b: "string1", c: true, d: 2.234, e: 2.234, f: "()"},
        {a: 5, b: "string5", c: true, d: 3, e: 3, f: "()"}
    ]);

    record {}[]|CsvConversionError csv3op3_4 = parseStringToRecord(csvStringData3, {header: 9, skipLines: "2-10"});
    test:assertEquals(csv3op3_4, [
        {'4: 5, string4: "string5", '1: true, "-6.51": 3, "()": null}
    ]);
}

@test:Config {enable}
function testFromCsvStringWithHeaderLessParserOptions() {
    [int, string, boolean, decimal, float, ()][]|CsvConversionError csv1op6 = parseStringToList(csvStringData1, option6);
    test:assertTrue(csv1op6 is CsvConversionError);
    test:assertEquals((<error>csv1op6).message(), generateErrorMessageForInvalidCast("null", "()"));

    record {}[]|CsvConversionError csv1op5_2 = parseStringToRecord(csvStringData1, ptOption5);
    test:assertEquals(csv1op5_2, [
        {'1: "a", '2: "b", '3: "c", '4: "d", '5: "e", '6: "f"},
        {'1: 1, '2: "string1", '3: true, '4: 2.234, '5: 2.234, '6: ()},
        {'1: 3, '2: "string3", '3: 0, '4: 1.23, '5: 1.23, '6: ()},
        {'1: 5, '2: "string5", '3: true, '4: 3, '5: 3, '6: ()}
    ]);

    record {}[]|CsvConversionError csv1op6_2 = parseStringToRecord(csvStringData1, {header: false, skipLines: [3, 5]});
    test:assertEquals(csv1op6_2, [
        {'1: "a", '2: "b", '3: "c", '4: "d", '5: "e", '6: "f"},
        {'1: 1, '2: "string1", '3: true, '4: 2.234, '5: 2.234, '6: ()},
        {'1: 3, '2: "string3", '3: 0, '4: 1.23, '5: 1.23, '6: ()},
        {'1: 5, '2: "string5", '3: true, '4: 3, '5: 3, '6: ()}
    ]);

    record {}[]|CsvConversionError csv3op6_2 = parseStringToRecord(csvStringData3, {header: false, skipLines: [1, 3, 5, -1, 100, 100]});
    test:assertEquals(csv3op6_2, [
        {'1: 1, '2: "string1", '3: true, '4: 2.234, '5: 2.234, '6: ()},
        {'1: 3, '2: "string3", '3: 0, '4: 1.23, '5: 1.23, '6: ()},
        {'1: 5, '2: "string5", '3: true, '4: 3, '5: 3, '6: ()}
    ]);

    record {}[]|CsvConversionError csv4op6_2 = parseStringToRecord(csvStringData4, {header: false, skipLines: [2, 4, -1, 100, 100]});
    test:assertEquals(csv4op6_2, [
        {'1: 1, '2: "string1", '3: true, '4: 2.234, '5: 2.234, '6: ()},
        {'1: 3, '2: "string3", '3: 0, '4: 1.23, '5: 1.23, '6: ()},
        {'1: 5, '2: "string5", '3: true, '4: 3, '5: 3, '6: ()}
    ]);

    record {}[]|CsvConversionError csv5op6_2 = parseStringToRecord(csvStringData5, {header: false, skipLines: [2, 4, -1, 100, 100]});
    test:assertEquals(csv5op6_2, [
        {'1: 1, '2: "string1", '3: true, '4: 2.234, '5: 2.234, '6: ()},
        {'1: 3, '2: "string3", '3: 0, '4: 1.23, '5: 1.23, '6: ()},
        {'1: 5, '2: "string5", '3: true, '4: 3, '5: 3, '6: ()}
    ]);

    record {}[]|CsvConversionError csv6op6_2 = parseStringToRecord(csvStringData6, {header: false, skipLines: [2, 4, -1, 100, 100]});
    test:assertEquals(csv6op6_2, [
        {'1: 1, '2: "string1", '3: true, '4: 2.234, '5: 2.234, '6: ()},
        {'1: 3, '2: "string3", '3: 0, '4: 1.23, '5: 1.23, '6: ()},
        {'1: 5, '2: "string5", '3: true, '4: 3, '5: 3, '6: ()}
    ]);

    record {}[]|CsvConversionError csv2op6_2 = parseStringToRecord(csvStringData2, {header: false, skipLines: [5, 7]});
    test:assertEquals(csv2op6_2, [
        {'1: "hello", '2: "hello", '3: (), '4: 12, '5: true, '6: 12.34},
        {'1: "//comment"},
        {'1: "a", '2: "b", '3: "c", '4: "d", '5: "e", '6: "f"},
        {'1: 1, '2: "string1", '3: true, '4: 2.234, '5: 2.234, '6: ()},
        {'1: 3, '2: "string3", '3: 0, '4: 1.23, '5: 1.23, '6: ()},
        {'1: 5, '2: "string5", '3: true, '4: 3, '5: 3, '6: ()}
    ]);
}

@test:Config {enable}
function testHeaderOption() {
    record {}[]|CsvConversionError csv2cop1 = parseStringToRecord(csvStringData2, {header: 4});
    test:assertEquals(csv2cop1, [
        {a: 1, b: "string1", c: true, d: 2.234, e: 2.234, f: ()},
        {a: 2, b: "string2", c: false, d: 0, e: 0, f: ()},
        {a: 3, b: "string3", c: 0, d: 1.23, e: 1.23, f: ()},
        {a: 4, b: "string4", c: 1, d: -6.51, e: -6.51, f: ()},
        {a: 5, b: "string5", c: true, d: 3, e: 3, f: ()}
    ]);

    record {}[]|CsvConversionError csv2cop2 = parseStringToRecord(csvStringData2, {header: 100});
    test:assertEquals(csv2cop2, []);

    record {}[]|CsvConversionError csv2cop3 = parseStringToRecord(csvStringData2, {header: 11});
    test:assertEquals(csv2cop3, []);

    record {}[]|CsvConversionError csv2cop4 = parseStringToRecord(csvStringData2, {header: 10});
    test:assertEquals(csv2cop4, [{'4: 5, string4: "string5", '1: true, "-6.51": 3, "()": ()}]);

    record {}[]|CsvConversionError csv1cop5 = parseStringToRecord(csvStringData1, {});
    test:assertTrue(csv1cop5 is CsvConversionError);
    test:assertEquals((<error>csv1cop5).message(), "The provided header row is empty");
}

@test:Config {enable}
function testNullConfigOption() {
    string csvValue1 = string `a
                                ()`;
    string csvValue2 = string `a 
                                null`;
    string csvValue3 = string `c, a 
                            true, e`;
    string csvValue4 = string `a 
                                Null`;
    string csvValue5 = string `b, a
                                bN/Aa,N/A`;

    record {() a;}[]|CsvConversionError cn = parseStringToRecord(csvValue1, {nilValue: ()});
    test:assertEquals(cn, [{a: ()}]);

    cn = parseStringToRecord(csvValue2, {nilValue: ()});
    test:assertEquals(cn, [{a: ()}]);

    cn = parseStringToRecord(csvValue3, {nilValue: ()});
    test:assertTrue(cn is CsvConversionError);
    test:assertEquals((<error>cn).message(), generateErrorMessageForInvalidCast("e", "()"));

    cn = parseStringToRecord(csvValue4, {nilValue: ()});
    test:assertEquals(cn, [{a: ()}]);

    cn = parseStringToRecord(csvValue1, {nilValue: null});
    test:assertEquals(cn, [{a: ()}]);

    cn = parseStringToRecord(csvValue2, {nilValue: null});
    test:assertEquals(cn, [{a: ()}]);

    cn = parseStringToRecord(csvValue3, {nilValue: null});
    test:assertTrue(cn is CsvConversionError);
    test:assertEquals((<error>cn).message(), generateErrorMessageForInvalidCast("e", "()"));

    cn = parseStringToRecord(csvValue4, {nilValue: null});
    test:assertEquals(cn, [{a: ()}]);

    cn = parseStringToRecord(csvValue1, {nilValue: "()"});
    test:assertEquals(cn, [{a: ()}]);

    cn = parseStringToRecord(csvValue2, {nilValue: "()"});
    test:assertTrue(cn is CsvConversionError);
    test:assertEquals((<error>cn).message(), generateErrorMessageForInvalidCast("null", "()"));

    cn = parseStringToRecord(csvValue3, {nilValue: "()"});
    test:assertTrue(cn is CsvConversionError);
    test:assertEquals((<error>cn).message(), generateErrorMessageForInvalidCast("e", "()"));

    cn = parseStringToRecord(csvValue4, {nilValue: "()"});
    test:assertTrue(cn is CsvConversionError);
    test:assertEquals((<error>cn).message(), generateErrorMessageForInvalidCast("Null", "()"));

    cn = parseStringToRecord(csvValue5, {nilValue: "N/A"});
    test:assertEquals(cn, [{b: "bN/Aa", a: ()}]);

    cn = parseStringToRecord(csvValue2, {nilValue: "null"});
    test:assertEquals(cn, [{a: ()}]);

    cn = parseStringToRecord(csvValue4, {nilValue: "null"});
    test:assertTrue(cn is CsvConversionError);
    test:assertEquals((<error>cn).message(), generateErrorMessageForInvalidCast("Null", "()"));

    cn = parseStringToRecord(csvValue1, {nilValue: "null"});
    test:assertTrue(cn is CsvConversionError);
    test:assertEquals((<error>cn).message(), generateErrorMessageForInvalidCast("()", "()"));

    // TODO: add nilValue -> "", with str quotes
}

@test:Config {enable}
function testCommentConfigOption() {
    string csvValue1 = string `a
                                1`;
    string csvValue2 = string `a # comment
                                1`;
    string csvValue3 = string `a #, c 
                            1#, e`;
    string csvValue4 = string `a 
                        # comment
                                1`;
    string csvValue5 = string `a, b
                                1,2
                                # comment`;
    string csvValue6 = string `a, b
                                1,2 # comment
                                # comment`;
    string csvValue7 = string `a, b
                                1#,2 comment
                                # comment`;
    string csvValue8 = string `a#, b
                                1, 2 # comment
                                # comment`;
    string csvValue9 = string `a,# b
                                1 ,#2 # comment
                                # comment`;

    record {int a;}[]|CsvConversionError cn;

    cn = parseStringToRecord(csvValue1);
    test:assertEquals(cn, [{a: 1}]);

    cn = parseStringToRecord(csvValue2);
    test:assertEquals(cn, [{a: 1}]);

    cn = parseStringToRecord(csvValue3);
    test:assertEquals(cn, [{a: 1}]);

    cn = parseStringToRecord(csvValue4);
    test:assertEquals(cn, [{a: 1}]);

    cn = parseStringToRecord(csvValue5);
    test:assertEquals(cn, [{a: 1, b: 2}]);

    cn = parseStringToRecord(csvValue6);
    test:assertEquals(cn, [{a: 1, b: 2}]);

    cn = parseStringToRecord(csvValue7);
    test:assertEquals(cn, [{a: 1}]);

    record {|int a; int b;|}[]|CsvConversionError cn2 = parseStringToRecord(csvValue7, {header: 0});
    test:assertEquals(cn2, [{a: 1, b: 0}]);

    cn = parseStringToRecord(csvValue8);
    test:assertTrue(cn is CsvConversionError);
    // TODO:Fix
    // test:assertEquals((<error> cn).message(), generateErrorMessageForInvalidCast("1, 2", "int"));

    cn = parseStringToRecord(csvValue9);
    test:assertEquals(cn, [{a: 1}]);
}

@test:Config {enable}
function testCommentConfigOption2() {
    string csvValue1 = string `a
                                1`;
    string csvValue2 = string `a & comment
                                1`;
    string csvValue3 = string `a &, c 
                            1&, e`;
    string csvValue4 = string `a 
                        
                        
                        
                        & comment
                                1`;
    string csvValue5 = string `a&, b
                                1, 2 & comment
                                
                                
                                & comment`;
    string csvValue6 = string `
    
    a,& b
                                1 ,&2 & comment

                                & comment`;

    record {int a; int b;}[]|CsvConversionError cn;
    record {int c;}[]|CsvConversionError cn2;

    cn = parseStringToRecord(csvValue1, {comment: "&"});
    test:assertTrue(cn is CsvConversionError);
    test:assertEquals((<error>cn).message(), generateErrorMessageForMissingRequiredField("b"));

    cn = parseStringToRecord(csvValue2, {comment: "&"});
    test:assertTrue(cn is CsvConversionError);
    test:assertEquals((<error>cn).message(), generateErrorMessageForMissingRequiredField("b"));

    cn = parseStringToRecord(csvValue3, {comment: "&"});
    test:assertTrue(cn is CsvConversionError);
    test:assertEquals((<error>cn).message(), generateErrorMessageForMissingRequiredField("b"));

    cn = parseStringToRecord(csvValue4, {comment: "&"});
    test:assertTrue(cn is CsvConversionError);
    test:assertEquals((<error>cn).message(), generateErrorMessageForMissingRequiredField("b"));

    cn = parseStringToRecord(csvValue5, {comment: "&"});
    test:assertTrue(cn is CsvConversionError);
    // TODO: Fix
    // test:assertEquals((<error> cn).message(), generateErrorMessageForMissingRequiredField("b"));

    cn = parseStringToRecord(csvValue6, {comment: "&", header: 2});
    test:assertTrue(cn is CsvConversionError);
    test:assertEquals((<error>cn).message(), generateErrorMessageForMissingRequiredField("b"));

    cn2 = parseStringToRecord(csvValue1, {comment: "&"});
    test:assertTrue(cn2 is CsvConversionError);
    test:assertEquals((<error>cn2).message(), generateErrorMessageForMissingRequiredField("c"));

    cn2 = parseStringToRecord(csvValue2, {comment: "&"});
    test:assertTrue(cn2 is CsvConversionError);
    test:assertEquals((<error>cn2).message(), generateErrorMessageForMissingRequiredField("c"));

    cn2 = parseStringToRecord(csvValue3, {comment: "&"});
    test:assertTrue(cn2 is CsvConversionError);
    test:assertEquals((<error>cn2).message(), generateErrorMessageForMissingRequiredField("c"));

    cn2 = parseStringToRecord(csvValue4, {comment: "&"});
    test:assertTrue(cn2 is CsvConversionError);
    test:assertEquals((<error>cn2).message(), generateErrorMessageForMissingRequiredField("c"));

    cn2 = parseStringToRecord(csvValue5, {comment: "&"});
    test:assertTrue(cn2 is CsvConversionError);
    // TODO: Fix
    // test:assertEquals((<error> cn2).message(), generateErrorMessageForMissingRequiredField("c"));

    cn2 = parseStringToRecord(csvValue6, {header: 2, comment: "&"});
    test:assertTrue(cn2 is CsvConversionError);
    test:assertEquals((<error>cn2).message(), generateErrorMessageForMissingRequiredField("c"));
}

@test:Config {enable}
function testSkipLineParserOption() {
    [int, string, boolean, decimal, float, ()][]|CsvConversionError csv1cp = parseStringToList(csvStringData1, {skipLines: [], header: 1});
    test:assertEquals(csv1cp, [
        [1, "string1", true, <decimal>2.234, <float>2.234, ()],
        [2, "string2", false, <decimal>0, <float>0, ()],
        [3, "string3", false, <decimal>1.23, <float>1.23, ()],
        [4, "string4", true, <decimal>-6.51, <float>-6.51, ()],
        [5, "string5", true, <decimal>3, <float>3.0, ()]
    ]);

    csv1cp = parseStringToList(csvStringData1, {skipLines: [0], header: 1});
    test:assertEquals(csv1cp, [
        [1, "string1", true, <decimal>2.234, <float>2.234, ()],
        [2, "string2", false, <decimal>0, <float>0, ()],
        [3, "string3", false, <decimal>1.23, <float>1.23, ()],
        [4, "string4", true, <decimal>-6.51, <float>-6.51, ()],
        [5, "string5", true, <decimal>3, <float>3.0, ()]
    ]);

    csv1cp = parseStringToList(csvStringData1, {skipLines: [0, 4, 10], header: 1});
    test:assertEquals(csv1cp, [
        [1, "string1", true, <decimal>2.234, <float>2.234, ()],
        [2, "string2", false, <decimal>0, <float>0, ()],
        [3, "string3", false, <decimal>1.23, <float>1.23, ()],
        [5, "string5", true, <decimal>3, <float>3.0, ()]
    ]);

    csv1cp = parseStringToList(csvStringData1, {skipLines: [1, 2, 3, 4, 5], header: 1});
    test:assertEquals(csv1cp, [
    ]);

    csv1cp = parseStringToList(csvStringData1, {skipLines: "1-5", header: 1});
    test:assertEquals(csv1cp, [
    ]);

    csv1cp = parseStringToList(csvStringData1, {skipLines: [4, 2], header: 1});
    test:assertEquals(csv1cp, [
        [1, "string1", true, <decimal>2.234, <float>2.234, ()],
        [3, "string3", false, <decimal>1.23, <float>1.23, ()],
        [5, "string5", true, <decimal>3, <float>3.0, ()]
    ]);

    csv1cp = parseStringToList(csvStringData1, {skipLines: "2-4", header: 1});
    test:assertEquals(csv1cp, [
        [1, "string1", true, <decimal>2.234, <float>2.234, ()],
        [5, "string5", true, <decimal>3, <float>3.0, ()]
    ]);

    csv1cp = parseStringToList(csvStringData1, {skipLines: [4, 2, -1], header: 1});
    test:assertEquals(csv1cp, [
        [1, "string1", true, <decimal>2.234, <float>2.234, ()],
        [3, "string3", false, <decimal>1.23, <float>1.23, ()],
        [5, "string5", true, <decimal>3, <float>3.0, ()]
    ]);

    csv1cp = parseStringToList(csvStringData1, {skipLines: [4, -1, 2], header: 1});
    test:assertEquals(csv1cp, [
        [1, "string1", true, <decimal>2.234, <float>2.234, ()],
        [3, "string3", false, <decimal>1.23, <float>1.23, ()],
        [5, "string5", true, <decimal>3, <float>3.0, ()]
    ]);

    csv1cp = parseStringToList(csvStringData1, {skipLines: [5, 4, 3, 2, 1], header: 1});
    test:assertEquals(csv1cp, [
    ]);

    csv1cp = parseStringToList(csvStringData1, {skipLines: [10], header: 1});
    test:assertEquals(csv1cp, [
        [1, "string1", true, <decimal>2.234, <float>2.234, ()],
        [2, "string2", false, <decimal>0, <float>0, ()],
        [3, "string3", false, <decimal>1.23, <float>1.23, ()],
        [4, "string4", true, <decimal>-6.51, <float>-6.51, ()],
        [5, "string5", true, <decimal>3, <float>3.0, ()]
    ]);

    csv1cp = parseStringToList(csvStringData1, {skipLines: [-2], header: 1});
    test:assertEquals(csv1cp, [
        [1, "string1", true, <decimal>2.234, <float>2.234, ()],
        [2, "string2", false, <decimal>0, <float>0, ()],
        [3, "string3", false, <decimal>1.23, <float>1.23, ()],
        [4, "string4", true, <decimal>-6.51, <float>-6.51, ()],
        [5, "string5", true, <decimal>3, <float>3.0, ()]
    ]);

    csv1cp = parseStringToList(csvStringData1, {skipLines: [-2, 0, 2], header: 1});
    test:assertEquals(csv1cp, [
        [1, "string1", true, <decimal>2.234, <float>2.234, ()],
        [3, "string3", false, <decimal>1.23, <float>1.23, ()],
        [4, "string4", true, <decimal>-6.51, <float>-6.51, ()],
        [5, "string5", true, <decimal>3, <float>3.0, ()]
    ]);

    csv1cp = parseStringToList(csvStringData1, {skipLines: "0-2", header: 1});
    test:assertEquals(csv1cp, [
        [3, "string3", false, <decimal>1.23, <float>1.23, ()],
        [4, "string4", true, <decimal>-6.51, <float>-6.51, ()],
        [5, "string5", true, <decimal>3, <float>3.0, ()]
    ]);
}

@test:Config {enable}
function testCustomHeaderOption() {
    anydata[][]|CsvConversionError bm1ba = parseRecordAsListType([bm1, bm1], ["b1", "b2"], {});
    test:assertEquals(bm1ba, [
        [true, false],
        [true, false]
    ]);

    anydata[][]|CsvConversionError bm1ba2 = parseRecordAsListType([bm1, bm1], ["b2", "b1"], {});
    test:assertEquals(bm1ba2, [
        [false, true],
        [false, true]
    ]);

    anydata[][]|CsvConversionError bm2ba = parseRecordAsListType([bm2, bm2], ["b1", "n1", "b2", "n2", "b3"], {});
    test:assertTrue(bm2ba is CsvConversionError);
    test:assertEquals((<error>bm2ba).message(), generateErrorMessageForInvalidCustomHeader("n2"));

    anydata[][]|CsvConversionError bm3ba = parseRecordAsListType([bm3, bm3], ["b1", "b4", "b2", "n2", "i1"], {});
    test:assertTrue(bm3ba is CsvConversionError);
    test:assertEquals((<error>bm3ba).message(), generateErrorMessageForInvalidCustomHeader("n2"));

    anydata[][]|CsvConversionError bm3ba2 = parseRecordAsListType([bm3, bm3], ["b1", "b3", "b4", "b2", "i2"], {});
    test:assertTrue(bm3ba2 is CsvConversionError);
    test:assertEquals((<error>bm3ba2).message(), generateErrorMessageForInvalidCustomHeader("i2"));

    [boolean...][]|CsvConversionError bm3ba4 = parseRecordAsListType([bm3, bm3], ["n2"], {});
    test:assertTrue(bm3ba4 is CsvConversionError);
    test:assertEquals((<error>bm3ba4).message(), "Invalid length for the header names");

    [boolean...][]|CsvConversionError bm3ba5 = parseRecordAsListType([bm3, bm3], [], {});
    test:assertTrue(bm3ba5 is CsvConversionError);
    test:assertEquals((<error>bm3ba5).message(), "Invalid length for the header names");

    // -------------------------------------------------------------

    record {}[]|CsvConversionError ct1br = parseListAsRecordType([["a", "1", "true"], ["a", "1", "true"]], ["a", "b"], {});
    test:assertTrue(ct1br is CsvConversionError);
    test:assertEquals((<error>ct1br).message(), "Invalid length for the custom headers");

    record {}[]|CsvConversionError ct1br2 = parseListAsRecordType([["a", "1", "true"], ["a", "1", "true"]], ["a", "b", "c", "d"], {});
    test:assertTrue(ct1br2 is CsvConversionError);
    test:assertEquals((<error>ct1br2).message(), "Invalid length for the custom headers");

    record {}[]|CsvConversionError ct1br2_2 = parseListAsRecordType([["a", "1", "true"], ["a", "1", "true"]], ["a", "c", "b", "d"], {});
    test:assertTrue(ct1br2_2 is CsvConversionError);
    test:assertEquals((<error>ct1br2_2).message(), "Invalid length for the custom headers");

    record {}[]|CsvConversionError ct1br3 = parseListAsRecordType([["a", "1", "true"], ["a", "1", "true"]], [], {});
    test:assertTrue(ct1br3 is CsvConversionError);
    test:assertEquals((<error>ct1br3).message(), "Invalid length for the custom headers");

    record {|string a; string b; string c;|}[]|CsvConversionError ct1br5 = parseListAsRecordType([["a", "1", "true"], ["a", "1", "true"]], ["a", "e", "b"], {});
    test:assertTrue(ct1br5 is CsvConversionError);
    // TODO: Fix
    test:assertEquals((<error>ct1br5).message(), generateErrorMessageForMissingRequiredField("c"));

    record {string a; string b; string c;}[]|CsvConversionError ct1br6 = parseListAsRecordType([["a", "1", "true"], ["a", "1", "true"]], ["a", "e", "b"], {});
    test:assertTrue(ct1br6 is CsvConversionError);
    test:assertEquals((<error>ct1br6).message(), generateErrorMessageForMissingRequiredField("c"));

    record {string a; string b;}[]|CsvConversionError ct1br7 = parseListAsRecordType([["a", "1", "true"], ["a", "1", "true"]], ["a", "e", "b"], {});
    test:assertEquals(ct1br7, [
        {a: "a", e: "1", b: "true"},
        {a: "a", e: "1", b: "true"}
    ]);

    record {|string a; string b;|}[]|CsvConversionError ct1br8 = parseListAsRecordType([["a", "1", "true"], ["a", "1", "true"]], ["a", "e", "b"], {});
    test:assertEquals(ct1br8, [
        {a: "a", b: "true"},
        {a: "a", b: "true"}
    ]);

    record {|string...;|}[]|CsvConversionError ct1br9 = parseListAsRecordType([["a", "1", "true"], ["a", "1", "true"]], ["a", "e", "b"], {});
    test:assertEquals(ct1br9, [
        {a: "a", b: "true", e: "1"},
        {a: "a", b: "true", e: "1"}
    ]);

    record {|string...;|}[]|CsvConversionError ct1br10 = parseListAsRecordType([["a", "1", "true"], ["a", "1", "true"]], (), {});
    test:assertEquals(ct1br10, [
        {'1: "a", '3: "true", '2: "1"},
        {'1: "a", '3: "true", '2: "1"}
    ]);
}

@test:Config {enable}
function testCustomHeaderParserOption2() {
    // parseStringToRecord
    // parseRecordAsRecordType

    record {}[]|CsvConversionError ct1br = parseStringToRecord(csvStringData1, {header: 1, customHeaders: ["a", "b"]});
    test:assertTrue(ct1br is CsvConversionError);
    test:assertEquals((<error>ct1br).message(), "Invalid length for the custom headers");

    // record{}[]|CsvConversionError ct1br2 = parseStringToRecord(csvStringData1, {header: 1, customHeaders: ["a", "b", "aa", "aaa", "aaaaa", "bb", "ccc"]});
    // // TODO: Fix this
    // test:assertTrue(ct1br2 is CsvConversionError);
    // test:assertEquals((<error> ct1br2).message(), "Invalid length for the custom headers");

    record {}[]|CsvConversionError ct1br2 = parseStringToRecord(csvStringData1, {header: 1, customHeaders: []});
    test:assertTrue(ct1br2 is CsvConversionError);
    test:assertEquals((<error>ct1br2).message(), "Invalid length for the custom headers");

    record {int a; string b; boolean c; decimal d; float e; () f;}[]|CsvConversionError ct1br3 = parseStringToRecord(csvStringData1, {header: 1, customHeaders: ["a", "b"]});
    test:assertTrue(ct1br3 is CsvConversionError);
    test:assertEquals((<error>ct1br3).message(), "Invalid length for the custom headers");

    record {int a; string b; boolean c; decimal d; float e; () f;}[]|CsvConversionError ct1br4 = parseStringToRecord(csvStringData1, {header: 1, customHeaders: ["a", "b", "c", "d", "e", "f"]});
    test:assertEquals(ct1br4, [
        {a: 1, b: "string1", c: true, d: <decimal>2.234, e: <float>2.234, f: ()},
        {a: 2, b: "string2", c: false, d: <decimal>0, e: <float>0, f: ()},
        {a: 3, b: "string3", c: false, d: <decimal>1.23, e: <float>1.23, f: ()},
        {a: 4, b: "string4", c: true, d: <decimal>-6.51, e: <float>-6.51, f: ()},
        {a: 5, b: "string5", c: true, d: <decimal>3, e: <float>3, f: ()}
    ]);

    record {() a; float b; decimal c; boolean d; string e; int f;}[]|CsvConversionError ct1br5 = parseStringToRecord(csvStringData1, {header: 1, customHeaders: ["f", "e", "d", "c", "b", "a"]});
    test:assertEquals(ct1br5, [
        {f: 1, e: "string1", d: true, c: <decimal>2.234, b: <float>2.234, a: ()},
        {f: 2, e: "string2", d: false, c: <decimal>0, b: <float>0, a: ()},
        {f: 3, e: "string3", d: false, c: <decimal>1.23, b: <float>1.23, a: ()},
        {f: 4, e: "string4", d: true, c: <decimal>-6.51, b: <float>-6.51, a: ()},
        {f: 5, e: "string5", d: true, c: <decimal>3, b: <float>3, a: ()}
    ]);

    record {() a; float b; decimal c; boolean d; string e; int f;}[]|CsvConversionError ct1br5_2 = parseStringToRecord(csvStringData1, {header: false, skipLines: [1], customHeaders: ["f", "e", "d", "c", "b", "a"]});
    test:assertEquals(ct1br5_2, [
        {f: 1, e: "string1", d: true, c: <decimal>2.234, b: <float>2.234, a: ()},
        {f: 2, e: "string2", d: false, c: <decimal>0, b: <float>0, a: ()},
        {f: 3, e: "string3", d: false, c: <decimal>1.23, b: <float>1.23, a: ()},
        {f: 4, e: "string4", d: true, c: <decimal>-6.51, b: <float>-6.51, a: ()},
        {f: 5, e: "string5", d: true, c: <decimal>3, b: <float>3, a: ()}
    ]);

    record {() a; float b; decimal c; boolean d; string e; int f;}[]|CsvConversionError ct1br5_3 = parseStringToRecord(csvStringData1, {skipLines: [1], customHeaders: ["f", "e", "d", "c", "b", "a"]});
    test:assertEquals(ct1br5_3, [
        {f: 1, e: "string1", d: true, c: <decimal>2.234, b: <float>2.234, a: ()},
        {f: 2, e: "string2", d: false, c: <decimal>0, b: <float>0, a: ()},
        {f: 3, e: "string3", d: false, c: <decimal>1.23, b: <float>1.23, a: ()},
        {f: 4, e: "string4", d: true, c: <decimal>-6.51, b: <float>-6.51, a: ()},
        {f: 5, e: "string5", d: true, c: <decimal>3, b: <float>3, a: ()}
    ]);

    record {|() a1; float b1; decimal c1; boolean d1; string e1; int f1;|}[]|CsvConversionError ct1br6 = parseStringToRecord(csvStringData1, {header: 1, customHeaders: ["f1", "e1", "d1", "c1", "b1", "a1"]});
    test:assertEquals(ct1br6, [
        {f1: 1, e1: "string1", d1: true, c1: <decimal>2.234, b1: <float>2.234, a1: ()},
        {f1: 2, e1: "string2", d1: false, c1: <decimal>0, b1: <float>0, a1: ()},
        {f1: 3, e1: "string3", d1: false, c1: <decimal>1.23, b1: <float>1.23, a1: ()},
        {f1: 4, e1: "string4", d1: true, c1: <decimal>-6.51, b1: <float>-6.51, a1: ()},
        {f1: 5, e1: "string5", d1: true, c1: <decimal>3, b1: <float>3, a1: ()}
    ]);

    record {|boolean d1; string e1;|}[]|CsvConversionError ct1br7 = parseStringToRecord(csvStringData1, {header: 1, customHeaders: ["f1", "e1", "d1", "c1", "b1", "a1"]});
    test:assertEquals(ct1br7, [
        {e1: "string1", d1: true},
        {e1: "string2", d1: false},
        {e1: "string3", d1: false},
        {e1: "string4", d1: true},
        {e1: "string5", d1: true}
    ]);

    record {|boolean d1; string e1;|}[]|CsvConversionError ct1br7_2 = parseStringToRecord(csvStringData1, {header: false, skipLines: [1], customHeaders: ["f1", "e1", "d1", "c1", "b1", "a1"]});
    test:assertEquals(ct1br7_2, [
        {e1: "string1", d1: true},
        {e1: "string2", d1: false},
        {e1: "string3", d1: false},
        {e1: "string4", d1: true},
        {e1: "string5", d1: true}
    ]);

    record {|boolean d1; string e1;|}[]|CsvConversionError ct1br8 = parseStringToRecord(csvStringData1, {header: 1, customHeaders: ["e1", "d1"]});
    // TODO: Fix
    test:assertTrue(ct1br8 is CsvConversionError);
    test:assertEquals((<error>ct1br8).message(), generateErrorMessageForInvalidCast("string1", "boolean"));

    record {|boolean d1; string e1;|}[]|CsvConversionError ct1br9 = parseStringToRecord(csvStringData1, {header: 1, customHeaders: ["f1", "e1", "d1", "c1", "b1", "a1"]});
    test:assertEquals(ct1br9, [
        {e1: "string1", d1: true},
        {e1: "string2", d1: false},
        {e1: "string3", d1: false},
        {e1: "string4", d1: true},
        {e1: "string5", d1: true}
    ]);

    record {|boolean d1; string e1;|}[]|CsvConversionError ct1br10 = parseStringToRecord(csvStringData1, {header: 1, customHeaders: ["f1", "e1", "d1", "f1", "b1", "a1"]});
    test:assertEquals(ct1br10, [
        {e1: "string1", d1: true},
        {e1: "string2", d1: false},
        {e1: "string3", d1: false},
        {e1: "string4", d1: true},
        {e1: "string5", d1: true}
    ]);

    record {|boolean d1; string e1;|}[]|CsvConversionError ct1br11 = parseStringToRecord(csvStringData1, {header: 1, customHeaders: ["f1", "e1"]});
    test:assertTrue(ct1br11 is CsvConversionError);
    test:assertEquals((<error>ct1br11).message(), "Invalid length for the custom headers");

    record {|string d1; string e1;|}[]|CsvConversionError ct1br12 = parseStringToRecord(csvStringData1, {header: 1, customHeaders: ["f1", "e1", "d1", "c1", "b1", "a1"]});
    test:assertEquals(ct1br12, [
        {e1: "string1", d1: "true"},
        {e1: "string2", d1: "false"},
        {e1: "string3", d1: "0"},
        {e1: "string4", d1: "1"},
        {e1: "string5", d1: "true"}
    ]);

    record {|string d1; string e1;|}[]|CsvConversionError ct1br13 = parseStringToRecord(csvStringData1, {header: 1, customHeaders: ["f1", "e1", "dd1", "c1", "b1", "a1"]});
    test:assertTrue(ct1br13 is CsvConversionError);
    test:assertEquals((<error>ct1br13).message(), generateErrorMessageForMissingRequiredField("d1"));
}

@test:Config {enable}
function testTextQuotesWithParserOptions() {
    string csvValue1 = string `
        a, b, c
                                1, "2", "3"
                                "1", 2, 3
                                1, "2", 3
                                
                                "1", "2", "3"`;

    string csvValue2 = string `
        a, b, c
                        1, "2, 3", 3
                        1, "2, 3",3
                        4, 5, 6
            `;

    string csvValue3 = string `a, b, c
                            "1", ""2"", "3"
                            4, "5, 6"b" " a "", ""6""`;

    string csvValue4 = string `a, b, c
                            1, '2', 3
                            4, '5, '6'7', 8
                            4, "5", '4, '5"a", ,"," a '6'7'`;

    string csvValue5 = string `a, b, c
            1, "2", "3"
            1, 2, 3
            "1", "2", 3
            1, "2", "3"
        `;

    string csvValue6 = string `a, b, c
            1, "2 a ","", "3"
            1, 2, 3
            "1", "2", 3
            1, "2", "3"
        `;

    record {int a;}[]|CsvConversionError cn = parseStringToRecord(csvValue1, {header: 1});
    test:assertEquals(cn, [{"a": 1, "b": 2, "c": 3}, {"a": 1, "b": 2, "c": 3}, {"a": 1, "b": 2, "c": 3}, {"a": 1, "b": 2, "c": 3}]);

    record {|int c; string...;|}[]|CsvConversionError cn2 = parseStringToRecord(csvValue2, {header: 1});
    test:assertEquals(cn2, [{"a": "1", "b": "2, 3", "c": 3}, {"a": "1", "b": "2, 3", "c": 3}, {"a": "4", "b": "5", "c": 6}]);

    record {|string b; string c;|}[]|CsvConversionError cn3 = parseStringToRecord(csvValue3, {});
    test:assertEquals(cn3, [{"b": "\"2\"", "c": "3"}, {"b": "5, 6\"b\" \" a \"", c: "\"6\""}]);

    record {}[]|CsvConversionError cn4 = parseStringToRecord(csvValue4, {textEnclosure: "'"});
    test:assertEquals(cn4, [{"a": 1, "b": 2, "c": 3}, {"a": 4, b: "5, '6'7", c: 8}, {a: 4, b: "\"5\"", c: "4, '5\"a\", ,\",\" a '6'7"}]);

    anydata[][]|CsvConversionError cn4_2 = parseStringToList(csvValue4, {textEnclosure: "'"});
    test:assertEquals(cn4_2, [[1, 2, 3], [4, "5, '6'7", 8], [4, "\"5\"", "4, '5\"a\", ,\",\" a '6'7"]]);

    record {}[]|CsvConversionError cn5 = parseStringToRecord(csvValue5, {});
    test:assertEquals(cn5, [{a: 1, b: 2, c: 3}, {a: 1, b: 2, c: 3}, {a: 1, b: 2, c: 3}, {a: 1, b: 2, c: 3}]);

    record {}[]|CsvConversionError cn6 = parseStringToRecord(csvValue6, {});
    test:assertTrue(cn6 is CsvConversionError);
    test:assertEquals((<error>cn6).message(), "Invalid length for the custom headers");
}

@test:Config {enable}
function testHeaderQuotesWithParserOptions() {
    string csvValue1 = string `
        "a", b, c
                                1, "2", "3"
                                "1", 2, 3
                                1, "2", 3
                                
                                "1", "2", "3"`;

    string csvValue2 = string `
        "a, b, c", "b,c", "c,d"
                        1, "2, 3", 3
                        1, "2, 3",3
                        4, 5, 6
            `;

    string csvValue3 = string `'a '1'a5,6', 'b", " ","""', c
                    1, '2', 3
                    4, '5, '6'7', 8
                    4, "5", '4, '5"a", ,"," a '6'7'`;

    record {}[]|CsvConversionError cn = parseStringToRecord(csvValue1, {header: 1});
    test:assertEquals(cn, [{"a": 1, "b": 2, "c": 3}, {"a": 1, "b": 2, "c": 3}, {"a": 1, "b": 2, "c": 3}, {"a": 1, "b": 2, "c": 3}]);

    record {}[]|CsvConversionError cn2 = parseStringToRecord(csvValue2, {header: 1});
    test:assertEquals(cn2, [{"a, b, c": 1, "b,c": "2, 3", "c,d": 3}, {"a, b, c": 1, "b,c": "2, 3", "c,d": 3}, {"a, b, c": 4, "b,c": 5, "c,d": 6}]);

    anydata[][]|CsvConversionError cn2_2 = parseStringToList(csvValue2, {header: 1});
    test:assertEquals(cn2_2, [[1, "2, 3", 3], [1, "2, 3", 3], [4, 5, 6]]);

    record {}[]|CsvConversionError cn3 = parseStringToRecord(csvValue3, {textEnclosure: "'"});
    test:assertEquals(cn3, [{"a '1'a5,6": 1, "b\", \" \",\"\"\"": 2, "c": 3}, {"a '1'a5,6": 4, "b\", \" \",\"\"\"": "5, '6'7", c: 8}, {"a '1'a5,6": 4, "b\", \" \",\"\"\"": "\"5\"", c: "4, '5\"a\", ,\",\" a '6'7"}]);
}

@test:Config {enable}
function testEscapeCharactersWithParserOptions() {
    string csvValue1 = string `
    "a", b, c
                            1, "2a\t", "3b\n"
                            "1c\n", 2, 3
                            1, "2a\"", 3
                            
                            "1a\\", "2b\\"", "3"`;

    string csvValue2 = string `
    "a\"", "\tb\t\n", c
                            1, "2a\t", "3b\n"
                            "1c\n", "/2/", 3
                            1, "2a\"", "3"
                            
                            "1a\\", "2b\\"", "3"`;

    string csvValue3 = string `
        "a", b, c
                                1, "2\t", "3\n"
                                "1\n", 2, 3
                                1, "2\"", 3
                                
                                "1\\", "2\\"", "3"`;

    record {}[]|CsvConversionError cn = parseStringToRecord(csvValue1, {header: 1});
    test:assertEquals(cn, [{"a": 1, "b": "2a\t", "c": "3b\n"}, {"a": "1c\n", "b": 2, "c": 3}, {"a": 1, "b": "2a\"", "c": 3}, {"a": "1a\\", "b": "2b\\\"", "c": 3}]);

    record {}[]|CsvConversionError cn2 = parseStringToRecord(csvValue2, {header: 1});
    test:assertEquals(cn2, [{"a\"": 1, "\tb\t\n": "2a\t", "c": "3b\n"}, {"a\"": "1c\n", "\tb\t\n": "/2/", "c": 3}, {"a\"": 1, "\tb\t\n": "2a\"", "c": 3}, {"a\"": "1a\\", "\tb\t\n": "2b\\\"", "c": 3}]);

    record {}[]|CsvConversionError cn3 = parseStringToRecord(csvValue3, {header: 1});
    test:assertEquals(cn3, [{"a": 1, "b": 2.0, "c": 3.0}, {"a": 1.0, "b": 2, "c": 3}, {"a": 1, "b": "2\"", "c": 3}, {"a": "1\\", "b": "2\\\"", "c": 3}]);

    anydata[][]|CsvConversionError cn_2 = parseStringToList(csvValue1, {header: 1});
    test:assertEquals(cn_2, [[1, "2a\t", "3b\n"], ["1c\n", 2, 3], [1, "2a\"", 3], ["1a\\", "2b\\\"", 3]]);

    anydata[][]|CsvConversionError cn2_2 = parseStringToList(csvValue2, {header: 1});
    test:assertEquals(cn2_2, [[1, "2a\t", "3b\n"], ["1c\n", "/2/", 3], [1, "2a\"", 3], ["1a\\", "2b\\\"", 3]]);

    anydata[][]|CsvConversionError cn3_2 = parseStringToList(csvValue3, {header: 1});
    test:assertEquals(cn3_2, [[1, 2.0, 3.0], [1.0, 2, 3], [1, "2\"", 3], ["1\\", "2\\\"", 3]]);
}

@test:Config {enable}
function testDelimiterWithParserOptions() {
    record {}[]|CsvConversionError cn = parseStringToRecord(csvStringData7, {header: 1, delimiter: "@"});
    test:assertEquals(cn, [
        {a: 1, b: "string", c: true, d: 2.234, e: -3.21, f: ()},
        {a: 2, b: "s,tring", c: true, d: 2.234, e: -3.21, f: ()},
        {a: 3, b: "stri,ng", c: true, d: 2.234, e: -3.21, f: ()},
        {a: 4, b: "string", c: true, d: 2.234, e: -3.21, f: ()},
        {a: 5, b: "string", c: true, d: 2.234, e: -3.21, f: ()}
    ]);

    anydata[][]|CsvConversionError cn2 = parseStringToList(csvStringData7, {header: 1, delimiter: "@"});
    test:assertEquals(cn2, [
        [1, "string", true, 2.234, -3.21, ()],
        [2, "s,tring", true, 2.234, -3.21, ()],
        [3, "stri,ng", true, 2.234, -3.21, ()],
        [4, "string", true, 2.234, -3.21, ()],
        [5, "string", true, 2.234, -3.21, ()]
    ]);
}

@test:Config {enable}
function testLineTerminatorWithParserOptions() {
    string csvValue = string `a,b${"\n"} 1,"2\n3"`;

    record {}[]|CsvConversionError cn = parseStringToRecord(csvValue, {header: 0, lineTerminator: LF});
    test:assertEquals(cn, [{a: 1, b: "2\n3"}]);

    cn = parseStringToRecord(csvValue, {header: 0, lineTerminator: [LF]});
    test:assertEquals(cn, [{a: 1, b: "2\n3"}]);

    cn = parseStringToRecord(csvValue, {header: 0, lineTerminator: [CRLF, LF, CR]});
    test:assertEquals(cn, [{a: 1, b: "2\n3"}]);

    anydata[][]|CsvConversionError cn2 = parseStringToList(csvValue, {header: 0, lineTerminator: LF});
    test:assertEquals(cn2, [[1, "2\n3"]]);

    cn2 = parseStringToList(csvValue, {header: 0, lineTerminator: [LF]});
    test:assertEquals(cn2, [[1, "2\n3"]]);

    cn2 = parseStringToList(csvValue, {header: 0, lineTerminator: [CRLF, LF, CR]});
    test:assertEquals(cn2, [[1, "2\n3"]]);
}