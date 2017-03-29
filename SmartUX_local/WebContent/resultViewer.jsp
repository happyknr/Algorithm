<%@page import="com.common.FileUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.LinkedHashMap"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Comparator"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.Collections"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.io.File"%>
<%@ page import="java.io.FileInputStream"%>
<%@ page import="org.apache.poi.xssf.usermodel.XSSFCell"%>
<%@ page import="org.apache.poi.xssf.usermodel.XSSFRow"%>
<%@ page import="org.apache.poi.xssf.usermodel.XSSFSheet"%>
<%@ page import="org.apache.poi.xssf.usermodel.XSSFWorkbook"%>
<%@ page import="com.common.Common" %>

<%! static final String DEFUALT_PATH = "SmartUX\\logs\\"; %>

<%
	request.setCharacterEncoding("utf-8");
	String packageName = "com_skp_launcher"; //request.getParameter("packageName");
	String testName = request.getParameter("testName");
	String logFile = request.getParameter("logFile");
	
	String pLogPath = request.getParameter("pLogPath");
	String logFiles[] = {};
	//System.out.println("pLogPath : " + pLogPath);
	//System.out.println("packageName : [" + packageName + "] testName : [" + testName + "] logFile : [" +logFile + "]");
	
	String logFilePath = "C:\\Users\\knr\\git\\SmartUX_local\\WebContent\\SmartUX\\logs\\"; //application.getRealPath("/")+"../"+request.getParameter("logFilePath"); //★
	String paramLogFilePath = "C:/Users/knr/git/SmartUX_local/WebContent/SmartUX/logs"; //로컬에서는 형태가 달라서 사용함. 운영에 필요없음
	//String logFilePath = application.getRealPath("/")+"SmartUX\\logs\\"; //+packageName+"\\"+testName+"\\"+logFile;
	//String[] logFileDepth = {};
	
	Common co = new Common();
	FileUtils fileUtil = new FileUtils();
	
	if(pLogPath != null && pLogPath.length() > 0)
	{
		String tmpArr[] = {};
		tmpArr = pLogPath.split(",");
		if(tmpArr != null && tmpArr.length > 0)
		{
			logFiles = new String[tmpArr.length];
			for(int i = 0; i < tmpArr.length; i++)
			{
				packageName = tmpArr[i].split("\\\\")[0];
				testName = tmpArr[i].split("\\\\")[1];
				if(logFile == null)
				{
					logFile = tmpArr[i].split("\\\\")[2];
				}
				logFiles[i] = tmpArr[i].split("\\\\")[2];
				//System.out.println("logFiles"+i+logFiles[i]);
			}
		}
		else
		{
			packageName = pLogPath.split("\\\\")[0];
			testName = pLogPath.split("\\\\")[1];
			logFile = pLogPath.split("\\\\")[2];
		}
	}
	
	if(packageName == null || packageName == "")
	{
		packageName = "com_skp_launcher";
	}
	
	HashMap<String, String> packageNameOption = co.getPackageName_UX();

 	File file = new File(logFilePath);
	File file2 = null;
	File[] file3 = null;
	
	String[] packageList = {};
	String[] testNameList = {};
	String[] logFileList = {};
		
	try
	{
		if(file.exists())
		{
			packageList = file.list();
			file2 = new File(logFilePath+File.separator+packageName);
			if(file2.exists())
			{
				testNameList = file2.list();
				if(testName != null && testName != "" && testName.length() > 0)
				{
					file3 = new File(logFilePath+File.separator+packageName+File.separator+testName).listFiles();
					//if(file3.exists())
					if(file3.length > 0)
					{
						//logFileList = file3.list();
						file3 = fileUtil.sortFileList_desc(file3);
						logFileList = new String[file3.length];
						for(int i = 0; i < file3.length; i++)
						{
							logFileList[i] = file3[i].getName();
							//System.out.println(logFileList[i]);
						}
					}
				}
			}
		}
	}
	catch(Exception e)
	{
		e.printStackTrace();
	} 
%>
<html>
<head>
<title>UX 자동화 Web UI</title>
<script type="text/javascript" src="http://ajax.aspnetcdn.com/ajax/jQuery/jquery-1.6.4.min.js"></script>
<script type="text/javascript">

	function logFileSearch()
	{
		var selectedPackageName = $("#selPackageName").val();
		var selectedTestName = $("#selTestName").val();
		var selectedLogFile = $("#selLogFile").val();
<%
		if(testName == "" || testName == null)
		{
			if(testNameList.length > 0 )
			{
%>
				$("#packageNameForm input[name='packageName']").attr("value","<%=packageName%>");
				$("#packageNameForm input[name='testName']").attr("value","<%=testNameList[0]%>");
			<%
				if(pLogPath != null && pLogPath.length() > 0)
				{
			%>
					$("#packageNameForm input[name='pLogPath']").attr("value","<%=pLogPath.replace("\\", "\\\\")%>");
<%				}
			}
		}
		else
		{
%>
			$("#packageNameForm input[name='packageName']").attr("value",selectedPackageName);
			$("#packageNameForm input[name='testName']").attr("value",selectedTestName);
			$("#packageNameForm input[name='logFile']").attr("value",selectedLogFile);
			<%
			if(pLogPath != null && pLogPath.length() > 0)
			{
			%>
				$("#packageNameForm input[name='pLogPath']").attr("value","<%=pLogPath.replace("\\", "\\\\")%>");
<%			}
		}
%>
		$("#packageNameForm").attr({action:'resultViewer.jsp', method:'post'}).submit();
	}

	$(document).ready(function()
	{
<%
		if(testName == null)
		{
%>
			logFileSearch();
<%
		}
%>		 
		$("#selPackageName").val("<%=packageName%>").attr("selected", "selected");
		$("#selTestName").val("<%=testName%>").attr("selected", "selected");
<%
		if(testName != "" && logFile == "" && logFileList.length > 0)
		{
%>
		$("#selLogFile").val("<%=logFileList[0]%>").attr("selected", "selected");
		logFileSearch();
<%
		}
		else
		{
%>
		$("#selLogFile").val("<%=logFile%>").attr("selected", "selected");
<%
		}

		if(logFile != "" && logFile != null && logFile.length() > 0 )
		{
%>
			var param = "<%=paramLogFilePath%>/<%=packageName%>/<%=testName%>/<%=logFile%>/";
			document.parentFrameForm.filePath.value = param;
			document.parentFrameForm.target = "fileReader";
			document.parentFrameForm.submit();
<%
		}
%>
		$("#selPackageName").change(function()
		{
			var selectedPackageName = $("#selPackageName").val();
			$("#packageNameForm input[name='packageName']").attr("value",selectedPackageName);
			$("#packageNameForm").attr({action:'resultViewer.jsp', method:'post'}).submit();
		});
		
		$("#selTestName").change(function()
		{
			var selectedPackageName = $("#selPackageName").val();
			var selectedTestName = $("#selTestName").val();
			$("#packageNameForm input[name='packageName']").attr("value",selectedPackageName);
			$("#packageNameForm input[name='testName']").attr("value",selectedTestName);
			<%
			if(pLogPath != null && pLogPath.length() > 0)
			{
			%>
				$("#packageNameForm input[name='pLogPath']").attr("value","<%=pLogPath.replace("\\", "\\\\")%>");
			<%
			}%>
			$("#packageNameForm").attr({action:'resultViewer.jsp', method:'post'}).submit();
		});
		
		$("#selLogFile").change(function()
		{
			logFileSearch();
		});
		
	});
	
	window.onload = function()
	{
<%
		if(!(testNameList.length > 0))
		{
%>
			document.getElementById("selTestName").disabled = 1;
<%
		}
		else 
		{
%>			 
			document.getElementById("selTestName").options[0].disabled = 1; 
<%			
		}
		if(!(logFileList.length > 0))
		{
%>
			document.getElementById("selLogFile").disabled = 1;
<%
		}
		else
		{
%>
			document.getElementById("selLogFile").options[0].disabled = 1;
			document.getElementById("frameDiv").style.display = "";
<%
		}
%>
	};
</script>
</head>
<body>
<div id="selectBoxDiv" style="height: 60px;">
	<!-- <h1>UX 자동화 Web UI</h1> -->
	<br/>
	<!-- service select box -->
	<form id="packageNameForm" style="float: left;">
		<input type="hidden" name="packageName" value="">
		<input type="hidden" name="testName" value="">
		<input type="hidden" name="logFile" value="">
		<input type="hidden" name="pLogPath" value="">
		<select id="selPackageName">
			<option value="<%=packageName %>" selected disabled><%=packageNameOption.get(packageName) %></option>
		</select>
	</form>
	<!-- test name select box -->
	<form id="testNameForm" style="float: left;">
		<select id="selTestName">
		<option selected>Choose Test Name</option>
<%
	if(testNameList.length > 0)
	{
		for(int i = 0; i < testNameList.length; i++)
		{
			out.print("<option value='"+testNameList[i]+"'>"+testNameList[i]+"</option>");
		}
	}
%>
		</select>
	</form>
	<!-- log file select box -->
	<select id="selLogFile">
	<option selected>Choose Log File</option> 
<%
	if(logFileList.length > 0)
	{
		for(int i = 0; i < logFileList.length; i++)
		{
			for(int j = 0; j < logFiles.length; j++)
			{
				if(logFileList[i].equals(logFiles[j]))
				{
					if(logFileList[i].equals(logFile))
					{
						out.print("<option value='"+logFileList[i]+"' selected>"+logFileList[i]+"</option>");
					}
					else
					{
						out.print("<option value='"+logFileList[i]+"'>"+logFileList[i]+"</option>");
					}
				}
			}
		}
	}
%>		
	</select>
</div>
<div id="frameDiv" style="display: none;">
	<form name="parentFrameForm" action="xlsxFileReader.jsp" method="POST">
		<input type="hidden" name="filePath" value="">
	</form>
	<iframe name="fileReader" width="100%" height="700" scroll="no" src="xlsxFileReader.jsp" frameBorder="0"></iframe>
</div>
</body>
</html>