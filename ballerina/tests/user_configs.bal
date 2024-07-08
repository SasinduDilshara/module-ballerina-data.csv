// Valid parser options
ParseOption option1 = {delimiter: "@", nilValue: "null", lineTerminator: [LF]};
ParseOption option2 = {nilValue: "N/A", lineTerminator: [CRLF, LF], comment: "/"};
ParseOption option3 = {nilValue: "()", header: 1, skipLines: [1, 2]};
ParseOption option4 = {nilValue: "", header: 4, skipLines: "1-5"};
ParseOption option5 = {nilValue: "", header: 4, skipLines: "1-1"};
ParseOption option6 = {nilValue: "()", header: false, skipLines: [1, 2]};

parseToRecordOption ptOption1 = {nilValue: "", header: 1, skipLines: [2, 4]};
parseToRecordOption ptOption2 = {nilValue: "", header: 1, skipLines: "2-4"};
parseToRecordOption ptOption3 = {nilValue: "", header: 4, skipLines: "1-5"};
parseToRecordOption ptOption4 = {nilValue: "", header: 4, skipLines: [-1, -2, 4, 2]};
parseToRecordOption ptOption5 = {header: false, skipLines: [-1, -2, 5, 3]};

// Invalid parser options
ParseOption invalidParserOptions1 = {header: 4};
ParseOption invalidParserOptions2 = {comment: "$"};
ParseOption invalidParserOptions3 = {lineTerminator: CRLF};
ParseOption invalidParserOptions4 = {skipLines: [1000, 1001]};
ParseOption invalidParserOptions5 = {skipLines: "a-b"};
ParseOption invalidParserOptions6 = {skipLines: "3-1"};
ParseOption invalidParserOptions7 = {skipLines: "a-5"};
ParseOption invalidParserOptions8 = {skipLines: "6-a"};
ParseOption invalidParserOptions9 = {skipLines: "a-5"};
ParseOption invalidParserOptions10 = {skipLines: "-1-6"};
ParseOption invalidParserOptions11 = {nilValue: "", header: 4, skipLines: "0-10"};
ParseOption invalidParserOptions12 = {skipLines: [1, 3, 4, -1]};
