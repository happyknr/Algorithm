<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%@ page import="java.lang.String.*" %>
<%@ page import="java.io.*"%>
<%@ page import="java.util.Date" %>
<%@ page import="com.sktechx.qadb.parser.*" %>

<%!
int i;
TestSuite ts = new TestSuite();

static final String SCRIPT_FOLDER = "/app/tomcat/svr_QATESTtx-web1/webapps/SmartUX/script/";
//static final String SCRIPT_FOLDER = "/Users/1003543/git/smartux/script/";
static final String[] EVENTS = { 
		"AppLaunch", 
		"AppClose",
		"ClickElement",
		"FindElement",
		"KeyPress",
		"InputString",
		"Delay",
		"LogMemInfo",
		"Voice",
		"CheckRunning",
		"FindElements",
		"NetworkStat",
		"ScriptEnd"
};

static final int EVENT_AppLaunch = 0;
static final int EVENT_AppClose = 1;
static final int EVENT_ClickElement = 2;
static final int EVENT_FindElement = 3;
static final int EVENT_KeyPress = 4;
static final int EVENT_InputString = 5;
static final int EVENT_Delay = 6;
static final int EVENT_LogMemInfo = 7;
static final int EVENT_Voice = 8;
static final int EVENT_CheckRunning = 9;
static final int EVENT_FindElements = 10;
static final int EVENT_NetworkStat = 11;
static final int EVENT_ScriptEnd = 12;

HashMap<String, String> packageMap = new HashMap<>();

public int getEventID(String event)
{
	switch(event)
	{
	case "AppLaunch":
		return EVENT_AppLaunch;
	case "AppClose":
		return EVENT_AppClose;
	case "ClickElement":
		return EVENT_ClickElement;
	case "FindElement":
		return EVENT_FindElement;
	case "InputString":
		return EVENT_InputString;
	case "Delay":
		return EVENT_Delay;
	case "LogMemInfo":
		return EVENT_LogMemInfo;
	case "Voice":
		return EVENT_Voice;
	case "CheckRunning":
		return EVENT_CheckRunning;
	case "FindElements":
		return EVENT_FindElements;
	case "NetworkStat":
		return EVENT_NetworkStat;
	case "ScriptEnd":
		return EVENT_ScriptEnd;
	default : return -1;
	}
}

public String printEvent(String[] events)
{
	String ret = "";

	ret += String.format("var events = [");
	for(i=0; i<events.length; i++)
	{
		ret += String.format("{ Name: \""+events[i]+"\", Id: "+getEventID(events[i])+"}");
		if(i<events.length-1)  ret += String.format(",");
	}
	ret += String.format("];");
	
	return ret;
}


public String printTestCaseTable()
{
	
	String ret = "";
	ret += String.format("$(\"#TestCase\").jsGrid({");
	ret += String.format("%s", "width: \"100%\",\n");
	ret += String.format("height: \"auto\",\n");
 
    ret += String.format("inserting: true,\n");
    ret += String.format("editing: true,\n");
    ret += String.format("sorting: false,\n");
    ret += String.format("paging: true,\n");
    ret += String.format("data: testCaseInfo,\n");
    ret += String.format("fields: [\n");
    ret += String.format("{ name: \"Type\", type: \"text\", width: 30, validate: \"required\" },\n");
    ret += String.format("{ name: \"Description\", type: \"text\", width: 80 },\n");
    ret += String.format("{ name: \"Event\", type: \"select\", items: events, valueField: \"Id\", textField: \"Name\", width: 50 },\n");
    ret += String.format("{ name: \"Value\", type: \"text\", width: 80 },\n");
    ret += String.format("{ name: \"Node-Index\", type: \"text\", width: 20 },\n");
    ret += String.format("{ name: \"Node-Text\", type: \"text\", width: 80 },\n");
    ret += String.format("{ name: \"Node-Resource ID\", type: \"text\", width: 200 },\n");
    ret += String.format("{ name: \"Node-Content Desc\", type: \"text\" },\n");
    ret += String.format("{ type: \"control\", width: 30 }\n");
    ret += String.format("]\n");
    
    ret += String.format("});");
    return ret;
}
%>
<%
packageMap.put("T life", "com.skt.tlife");
packageMap.put("Musicmate", "skplanet.musicmate");
packageMap.put("Smarthome", "com.skt.sh");
packageMap.put("T colorring", "com.real.tcolorring");
packageMap.put("T map", "com.skt.skaf.l001mtm091");
packageMap.put("T taxi", "com.skplanet.tmaptaxi.android.passenger");
packageMap.put("T 대중교통", "com.skp.lbs.ptransit");
packageMap.put("T 배경화면", "com.skp.launcher.theme");
packageMap.put("Weatherpong", "com.skplanet.weatherpong.mobile");
packageMap.put("T 검색", "com.skp.tsearch");
packageMap.put("VOLO", "com.sktechx.volo");
packageMap.put("클라우드베리", "com.skt.prod.cloud");
packageMap.put("런처플래닛", "com.skp.launcher");
packageMap.put("데이터소다", "com.sktechx.datasoda");
%>
<html>
<head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
<link type="text/css" rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jsgrid/1.5.3/jsgrid.min.css" />
<link type="text/css" rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jsgrid/1.5.3/jsgrid-theme.min.css" />
</head>
<body>
<form action="script.jsp" method="post">

<select name="scriptFile" onchange="this.form.submit()">
<%
// FILE LIST
String scriptFile = request.getParameter("scriptFile");
if(scriptFile == null) scriptFile = new String("no");

File folder = new File(SCRIPT_FOLDER);

File[] scriptFiles = folder.listFiles();
String name="";

for (File file : scriptFiles) 
{
	
    if (file.isFile()) 
    {
    	name = file.getName();
    	String[] tempName = name.split("\\.");
    	if(tempName.length != 2 || !tempName[1].equals("xlsx")) continue;
    	out.print("<option value='"+file.getName()+"'");
    	if(scriptFile.equals(name)) out.print(" selected");
    	out.println(">"+file.getName()+"</option>");
    }  
}
%>
</select>
<%
if(!scriptFile.equals("no"))
{
	ExcelScriptParser parser = new ExcelScriptParser();
	ts = parser.scriptExcelParser(SCRIPT_FOLDER+scriptFile);
}
%>

<h1>Test Suite Information</h1>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jsgrid/1.5.3/jsgrid.min.js"></script>
<div id="TestSuite"></div>
<script>
var testSuiteInfo = [
    { "Test Name": "<%=ts.getTestName()%>", "Log Folder": "<%=ts.getLogFolder()%>", "Package Name": "<%=ts.getPackageName()%>", "Author": "<%=ts.getAuthor()%>", "Note": "<%=ts.getDescription()%>" }
];

var packages = [
	<%
	Iterator<String> keys = packageMap.keySet().iterator();

	for(i=0; keys.hasNext(); i++)
	{
	    String key = keys.next();
	    out.println("{ Name: \""+key+" - "+packageMap.get(key)+"\", Id: \""+packageMap.get(key)+"\"}");
	    if(keys.hasNext())
	    {
	    	out.println(",");
	    }
	}
	%>
	];
	
$("#TestSuite").jsGrid({
    width: "100%",
    height: "auto",

    inserting: false,
    editing: true,
    sorting: false,
    paging: true,

    data: testSuiteInfo,

    fields: [
        { name: "Test Name", type: "text", width: 100, validate: "required" },
        { name: "Log Folder", type: "text", width: 100 },
        { name: "Package Name", type: "select", items: packages, valueField: "Id", textField: "Name" },
        { name: "Author", type: "text", width: 100 },
        { name: "Note", type: "text", sorting: false },
        { type: "control" }
    ]
});
</script>
<br/>
<select name="selTestCase" onchange="this.form.submit()">
<%
// TEST CASE
String selTestCase = request.getParameter("selTestCase");
if(selTestCase == null) 
{
	if(ts.isParse())
		selTestCase = Integer.toString(ts.getTestCase().get(0).getId());
	else
		selTestCase = new String("no");
}

if(ts.isParse())
{
	ArrayList<TestCase> testCases = ts.getTestCase();
	for(TestCase testCase : testCases)
	{
		String testCaseName = testCase.getName();
		int testCaseId = testCase.getId();
		
		out.print("<option value='"+testCaseId+"'");
		if(Integer.toString(testCase.getId()).equals(selTestCase)) out.print(" selected");
		out.println(">"+testCaseName+"</option>");
	}
}
%>
</select>
</form>

<h1>Test Case Information</h1>
<div id="TestCase"></div>
<script>
<%
for(TestCase testCase : ts.getTestCase())
{
	if(!Integer.toString(testCase.getId()).equals(selTestCase))
		continue;
	
	out.println("var testCaseInfo = [");
	for(TestStep testStep : testCase.getTestSteps())
	{
		out.println("{");
		out.println("\"Type\" : \""+testStep.getType()+"\",");
		out.println("\"Description\" : \""+testStep.getDescription()+"\",");
		out.println("\"Event\" : "+getEventID(testStep.getEvent())+",");
		out.println("\"Value\" : \""+testStep.getValue()+"\",");
		out.println("\"Node-Index\" : \""+testStep.index+"\",");
		out.println("\"Node-Text\" : \""+testStep.text+"\",");
		out.println("\"Node-Resource ID\" : \""+testStep.resourceId+"\",");
		out.println("\"Node-Content Desc\" : \""+testStep.contentDesc+"\"");
		out.println("}");
		if(!testStep.getEvent().equals("ScriptEnd"))
		{
			out.println(",");
		}
	}
	out.println("];");
	
	//out.println(printTestCaseTable());
	break;
}
out.println(printEvent(EVENTS));

%>

var types = [
	{ Name: "Pre" },
	{ Name: "Test" },
	{ Name: "Post" },
];

$("#TestCase").jsGrid({
	width: "100%",
	height: "auto",
	inserting: true,
	editing: true,
	sorting: false,
	paging: true,
		
	/* controller: 
	{
	    insertItem: $.noop,
	    updateItem: 
		    function(item) 
		    {
	    		alert(item["Type"]);
		        var d = $.Deferred();
		        $.ajax().done(
		        		function(updatedItem) 
		        		{
		        			alert(updatedItem["Type"]);
		           			d.resolve();
		        		}
		        	);
		        return d.promise();
		    },
	    deleteItem: $.noop
	},  */
	data: testCaseInfo,
	fields: [
		{ name: "Type", type: "select", items: types, valueField: "Name", textField: "Name", width: 30 },
		{ name: "Description", type: "text", width: 80 },
		{ name: "Event", type: "select", items: events, valueField: "Id", textField: "Name", width: 50 },
		{ name: "Value", type: "text", width: 80 },
		{ name: "Node-Index", type: "text", width: 20 },
		{ name: "Node-Text", type: "text", width: 80 },
		{ name: "Node-Resource ID", type: "text", width: 200 },
		{ name: "Node-Content Desc", type: "text" },
		{ type: "control", width: 30 }
	]
});

var showDetailsDialog = function(client) {
    //$("#Type").val(client.Type);
    //$("#Description").val(client.Description);
	alert($("#Type"));

};

function myFunction()
{
	$(document).ready(function()
			{
			     
			   $.ajaxSettings.traditional = true;
			    
			   $.ajax({
			       method      : 'POST',
			       url         : 'saveScript.jsp',
			       dataType:"json",
			       data        : {json: JSON.stringify(testCaseInfo)},
			       success     : function(msg) {
			           alert(msg);        
			       }

			   });
			});
}
</script>
<button onclick="myFunction()">Click me</button>
</body>
</html>
