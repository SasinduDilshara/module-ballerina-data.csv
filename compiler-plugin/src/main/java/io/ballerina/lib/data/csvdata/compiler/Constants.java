/*
 * Copyright (c) 2024, WSO2 LLC. (https://www.wso2.com).
 *
 * WSO2 LLC. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package io.ballerina.lib.data.csvdata.compiler;

/**
 * Constants for CsvData's compiler plugin.
 *
 * @since 0.1.0
 */
public final class Constants {
    static final String PARSE_STRING = "parseString";
    static final String PARSE_BYTES = "parseBytes";
    static final String PARSE_STREAM = "parseStream";
    static final String TRANSFORM = "transform";
    static final String PARSE_LISTS = "parseLists";
    static final String NAME = "Name";
    static final String CSVDATA = "csv";
    static final String BALLERINA = "ballerina";
    static final String DATA_CSVDATA = "data.csv";

    private Constants() {
    }
}
