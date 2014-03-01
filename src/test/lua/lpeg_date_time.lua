-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.

require "string"

local dt = require("date_time")

local function test_valid(tc, grammar, tests, results)
    for i,v in ipairs(tests) do
        t = grammar:match(v)
        if not t then
            error(v)
        else
            ns = dt.time_to_ns(t)
            if ns ~= results[i] then
                error(string.format("tc: %d %s expected: %d received: %d", tc, v, results[i], ns))
            end
        end
    end
end

function process(tc)
    if tc == 0 then
        local tests = {"1999-05-05T23:23:59.217-07:00",
            "1985-04-12T23:20:50.52Z",
            "1996-12-19T16:39:57-08:00",
            "1990-12-31T23:59:60Z",
            "1990-12-31T15:59:60-08:00",
            "1937-01-01T12:00:27.87+00:20"}
        local results = {925971839217000064,
            482196050520000000,
            851042397000000000,
            662688000000000000,
            662688000000000000,
            -1041337172130000000}
        test_valid(tc, dt.rfc3339, tests, results)
    elseif tc == 1 then
        local tests = {"1985-04-12t23:20:50.52Z",
            "1985-04-12T23:20:50.52z",
            "1985-04-12",
            "1999-05-05T23:23:59.217-0700"}
        for i,v in ipairs(tests) do
            if dt.rfc3339:match(v) then
                error(v)
            end
        end
    elseif tc == 2 then
        local tests = {"10/Feb/2014:08:46:36 -0800"}
        local results = {1392050796000000000}
        test_valid(tc, dt.clf_timestamp, tests, results)
    elseif tc == 3 then
        local tests = {"Feb 10 16:46:36"}
        local results = {1392050796000000000}
        test_valid(tc, dt.rfc3164_timestamp, tests, results)
    elseif tc == 4 then
        local tests = {"20140210164636"}
        local results = {1392050796000000000}
        test_valid(tc, dt.mysql_timestamp, tests, results)
    elseif tc == 5 then
        local tests = {"2014-02-10 16:46:36"}
        local results = {1392050796000000000}
        test_valid(tc, dt.pgsql_timestamp, tests, results)
    end
    return 0
end
