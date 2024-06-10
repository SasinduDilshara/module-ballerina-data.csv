public type CsvConversionError error;

public type Options record {
   record {
       # If `true`, nil values will be considered as optional fields in the projection.
       boolean nilAsOptionalField = false;
       # If `true`, absent fields will be considered as nilable types in the projection.
       boolean absentAsNilableType = false;
   }|false allowDataProjection = {};
   int[]|string skipLines = [];
};

public type ParseOption record {|
  *Options;
  string:Char delimiter = ",";
  string encoding = "UTF-8";
  string locale = "en_US";
//  TODO: Add " for Strings"
  string:Char textEnclosure = "\"";
  string:Char escapeChar = "\\";
  LineTerminator|LineTerminator[] lineTerminator = [CR, LF, CRLF];
  NilValue? nilValue = ();
  // string commentStartingSequence = "#";
  string:Char comment = "#";
  false|int:Unsigned32 header = 0;
|};

public type parseToRecordOption record {|
  *ParseOption;

  // if header = false and this value is null, Then compiler time error.
  string[]? customHeaders = ();
|};

public type ToRecordOptions record {
   *Options;

   // if source is array and this field is null => compile time error
   string[]? customHeaders = ();
};

public enum LineTerminator {
  CR = "\r",
  LF = "\n",
  CRLF = "\r\n"
};

public enum NilValue {
  NULL = "null",
  EMPTY_STRING = "",
  NOT_APPLICABLE = "N/A",
  BAL_NULL = "()"
};