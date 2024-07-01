import ballerina/test;

boolean enable = !true;

@test:Config {enable: !enable}
function debugTest() returns error? {
    TrA[] rec = [{id: 1, name: "name1", enable: true}, {id: 2, name: "name2", enable: false}];

    table<TrA> key (id)|CsvConversionError t3 = parseRecordAsRecordType(rec, {});
}

type TrA record {readonly int id; string name; boolean enable;};
type TrA2 record {|readonly int id; boolean enable;|};


@test:Config {enable}
function testTableExpectedTypes() returns error? {
    table<TrA> key(id) exp = table [
        {id: 1, name: "name1", enable: true},
        {id: 2, name: "name2", enable: false}
    ];

    table<TrA> key (id)|CsvConversionError t1 = parseStringToRecord(string `id, name, enable
                                            1, name1, true
                                            2, name2, false`);

    if (t1 is table<TrA> key (id)) {
        test:assertEquals(t1, exp);
    } else {
        test:assertFail(string `Test failure for table type conversions:- ${t1.message()}`);
    }

    table<TrA2> key(id) exp2 = table [
        {id: 1, enable: true},
        {id: 2, enable: false}
    ];

    table<TrA2> key (id)|CsvConversionError t2 = parseStringToRecord(string `id, name, enable
                                            1, name1, true
                                            2, name2, false`);

    if (t2 is table<TrA2> key (id)) {
        test:assertEquals(t2, exp2);
    } else {
        test:assertFail(string `Test failure for table type conversions:- ${t2.message()}`);
    }

    table<TrA> key(id) exp3 = table [
        {id: 1, name: "name1", enable: true},
        {id: 2, name: "name2", enable: false}
    ];

    TrA[] rec = [{id: 1, name: "name1", enable: true}, {id: 2, name: "name2", enable: false}];

    table<TrA> key (id)|CsvConversionError t3 = parseRecordAsRecordType(rec, {});

    if (t3 is table<TrA> key (id)) {
        test:assertEquals(t3, exp3);
    } else {
        test:assertFail(string `Test failure for table type conversions:- ${t3.message()}`);
    }

    table<TrA2> key(id) exp4 = table [
        {id: 1, enable: true},
        {id: 2, enable: false}
    ];

    table<TrA2> key (id)|CsvConversionError t4 = parseRecordAsRecordType(rec, {});

    if (t4 is table<TrA2> key (id)) {
        test:assertEquals(t4, exp4);
    } else {
        test:assertFail(string `Test failure for table type conversions:- ${t4.message()}`);
    }
}