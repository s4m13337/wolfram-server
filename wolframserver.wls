#!/usr/bin/env wolframscript
Print @ "Wolfram Expression Server 0.0.2 (alpha-s4m13337)";
Print @ "Usage: wolframserver.wls [address]";
Print @ "Exit with x -> Return";

address = If[ Length[$ScriptCommandLine] >= 2, Part[$ScriptCommandLine, 2], "127.0.0.1:5858" ];

Print["Address:       ", address];
Print["$ProcessID: ", $ProcessID];

ApacheDateString[] := With[{tz = StringReplace[DateString["ISOTimeZone"], ":" -> ""]},
  DateString[{"[", "Day", "/", "Month", "/", "Year", ":", "Hour", ":", "Minute", ":", "Second", " ", tz, "]"}]];

ApacheLog[ str_String ] := Module[{}, Print[ "127.0.0.1 - - " <> ApacheDateString[] <> " \"POST / HTTP/1.1\" 200 " <> StringTrim[str] ] ];

listener = SocketListen[
  address,
  Function[{assoc},
    With[{
      client = assoc["SourceSocket"],
      data = assoc["Data"]
    },
    request = ImportString[data, "HTTPRequest"];
    origin = Association[ request["Headers"] ]["origin"];
    If[ Head[origin]===Missing, origin="" ];
    result = ExportString[ ToExpression[ request["Body"], StandardForm ], "ExpressionJSON" ];
    response = ExportString[
      HTTPResponse[ result, <|
        "StatusCode" -> 200,
        "ContentType" -> "application/json",
        "Headers" -> { "Access-Control-Allow-Origin" -> origin }
      |>], "HTTPResponse"];
    WriteString[client, response];
    ApacheLog[ request["Body"] ];
    Close[client]
    ]
   ]
  ];

url = URLBuild[<|"Scheme" -> "http", "Domain" -> listener["Socket"]["DestinationIPAddress"], "Port" -> listener["Socket"]["DestinationPort"]|>];

Print["Listening:  ", url, "\n"];

While[True, If[InputString[] == "x", Print["Exiting..."]; Exit[]]]

