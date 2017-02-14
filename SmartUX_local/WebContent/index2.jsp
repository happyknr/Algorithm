<%@page import="java.util.Comparator"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.Collections"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.ArrayList" %>

<%!
public final int COMPARETYPE_NAME = 0;
public final int COMPARETYPE_DATE = 1;

/* 파일 정렬을 위한 메소드 */
public File[] sortFileList(File[] files, final int compareType) 
{
	Arrays.sort(files, new Comparator<Object>() 
	{
		public int compare(Object object1, Object object2) 
		{
			String s1 = "";
			String s2 = "";
			if (compareType == COMPARETYPE_NAME) 
			{
				s1 = ((File) object1).getName();
				s2 = ((File) object2).getName();
			} 
			else if (compareType == COMPARETYPE_DATE) 
			{
				s1 = ((File) object1).lastModified() + "";
				s2 = ((File) object2).lastModified() + "";
			}
			return s1.compareTo(s2);
		}
	});
	return files;
}
%>

<%

	String packageName = request.getParameter("packageName");
	String testName = request.getParameter("testName");
	String logFile = request.getParameter("logFile");
System.out.println("packageName : " + packageName + " testName : " + testName + " logFile : " + logFile);

	if(packageName == "" || packageName == null)
	{
		packageName = "com_skt_tlife";
	}

//	String logFilePath = "/app/apache-tomcat-8.0.28/svr_QATESTtx-web1/webapps/SmartUX/";
//	String logFilePath = "C:\\Users\\knr\\workspace\\.metadata\\.plugins\\org.eclipse.wst.server.core\\tmp4\\wtpwebapps\\SmartUX_local\\SmartUX\\logs\\";
	String logFilePath = "C:\\Users\\knr\\workspace\\SmartUX_local\\WebContent\\SmartUX\\logs\\";
//	/app/apache-tomcat-8.0.28/svr_QATESTtx-web1/webapps/SmartUX/logs/com_skt_skaf_l001mtm091/BAT

	File file = new File(logFilePath);
	File file2 = null;
	File file3 = null;
	
	
	File filetest = null;
	String[] testNameList = {};
	
	ArrayList<String> arrLogFileList = new ArrayList<String>();
	ArrayList<String> arrTestNameList = new ArrayList<String>();
	
	String[] packageList = {};
	String[] logFileList = {};
	
/* 	if(file.exists())
	{
		packageList = file.list();
		for(int i = 0 ; i < packageList.length; i++)
		{
			file2 = new File(logFilePath+"\\"+packageList[i]);
			if(file2.exists())
			{
				testNameList = file2.list();
				for(int j = 0 ; j < testNameList.length; j++)
				{
					file3 = new File(logFilePath+"\\"+packageList[i]+"\\"+testNameList[j]);
					if(file3.exists())
					{
						logFileList = file3.list();
						for(int z = 0; z < logFileList.length; z++)
						{
							System.out.println(">>> " + testNameList[j]+":"+logFileList[z]);
							arrLogFileList.add(j*z, logFileList[z]);
						}
					}
					arrTestNameList.addAll(i*j, arrLogFileList);
				}
			}
		}
	} */
	
	/* 상위 디렉토리명 넘기기 */
	String param = "";
	
	if(packageName != "" && packageName != null && packageName.length() > 0)
	{
		param = packageName;
		if(testName != "" && testName != null && testName.length() > 0)
		{
			param += "\\"+testName;
			
			if(logFile != "" && logFile != null && logFile.length() > 0)
			{
				param += "\\"+logFile;
			}
		}
	}
	
	
	System.out.println(param);
	
	if(packageName != "" && packageName != null && packageName.length() > 0)
	{
		if(testName != "" && testName != null && testName.length() > 0)
		{
			filetest = new File(logFilePath+"\\"+param);
			if(filetest.exists())
			{
				logFileList = filetest.list();
				System.out.println("-----------------------");
				for(int i = 0; i < logFileList.length; i++)
					System.out.println(logFileList[i]);
				System.out.println("-----------------------");
			}
		}
		else
		{
			filetest = new File(logFilePath+"\\"+param);
			if(filetest.exists())
			{
				testNameList = filetest.list();
				System.out.println("-----------------------");
				for(int i = 0; i < testNameList.length; i++)
					System.out.println(testNameList[i]);
				System.out.println("-----------------------");
			}
		}
	}
	

	/* System.out.println("====================================");
	for(int i = 0; i < arrTestNameList.size(); i++)
	{
		for(int j = 0; j < arrLogFileList.size(); j++)
		{
			System.out.println("--> "+arrTestNameList.get(i));
		}
	}
	System.out.println("===================================="); */
%>
<html>
<head>
<title>UX 자동화 Web UI</title>
<script type="text/javascript" src="http://ajax.aspnetcdn.com/ajax/jQuery/jquery-1.6.4.min.js"></script>
<script type="text/javascript">

	$(document).ready(function()
	{
		/* $("#selTestName, #selLogFile").find("option").each(function()
		{
			$(this).remove();
		});
		
		$("#selTestName").append("<option value=''>Choose Test Name</option");
		$("#selLogFile").append("<option value=''>Choose Log File</option");
		 */
		$("#selPackageName").val("<%=packageName%>").attr("selected", "selected");
		$("#selTestName").val("<%=testName%>").attr("selected", "selected");
		$("#selLogFile").val("<%=logFile%>").attr("selected", "selected");
		
		$("#selPackageName").change(function()
		{
			var selectedPackageName = $("#selPackageName").val();
			$("#packageNameForm input[name='packageName']").attr("value",selectedPackageName);
			
			//$("#selTestName").append("<option value='1'>1</option>");
			
			
			$("#packageNameForm").attr({action:'index2.jsp', method:'post'}).submit();
		});
		
		$("#selTestName").change(function(){
			var selectedPackageName = $("#selPackageName").val();
			var selectedTestName = $("#selTestName").val();
			$("#packageNameForm input[name='packageName']").attr("value",selectedPackageName);
			$("#packageNameForm input[name='testName']").attr("value",selectedTestName);
			$("#packageNameForm").attr({action:'index2.jsp', method:'post'}).submit();
		});
		
		$("#selLogFile").change(function(){
			var selectedPackageName = $("#selPackageName").val();
			var selectedTestName = $("#selTestName").val();
			var selectedLogFile = $("#selLogFile").val();
			$("#packageNameForm input[name='packageName']").attr("value",selectedPackageName);
			$("#packageNameForm input[name='testName']").attr("value",selectedTestName);
			$("#packageNameForm input[name='testName']").attr("value",selectedLogFile);
			$("#packageNameForm").attr({action:'index2.jsp', method:'post'}).submit();
		});
	})
</script>
</head>
<body>
	<!-- <h1>UX 자동화 Web UI</h1> -->
	<br/>
	<!-- service select box -->
	<form id="packageNameForm" style="float: left;">
		<input type="hidden" name="packageName" value="">
		<input type="hidden" name="testName" value="">
		<input type="hidden" name="logFile" value="">
		<select id="selPackageName">
			<option selected disabled>Choose Service Name</option>
			<option value="com_skt_tlife">T life</option>
			<option value="skplanet_musicmate">Musicmate</option>
			<option value="com_skt_sh">Smart Home</option>
			<option value="com_real_tcolorring">T colorring</option>
			<option value="com_skt_skaf_l001mtm091">T map</option>
			<option value="com_skplanet_tmaptaxi_android_passenger">T taxi</option>
			<option value="com_skp_lbs_ptransit">T 대중교통</option>
			<option value="com_skp_launcher_theme">T 배경화면</option>
			<option value="com_skplanet_weatherpong_mobile">Weatherpong</option>
			<option value="com_skp_tsearch">T 검색</option>
			<option value="com_skt_tbagplus">T cloud</option>
			<option value="com_sktechx_volo">VOLO</option>
			<option value="com_skt_prod_cloud">클라우드베리</option>
			<option value="com_skp_launcher">런처플래닛</option>
			<option value="com_sktechx_datasoda">데이터소다 </option>
		</select>
	</form>
	<!-- test name select box -->
	<form id="testNameForm" action="" style="float: left;">
		<select id="selTestName">
<%
	for(int i = 0; i < testNameList.length; i++)
	{
%>
			<option value="<%=testNameList[i]%>"><%=testNameList[i]%></option>
<%
	}
%>
		</select>
	</form>
	
	<!-- log file select box -->
	<form id="logFileForm" action="">
		<select id="selLogFile">
<%
	for(int i = 0; i < logFileList.length; i++)
	{
%>
			<option value="<%=logFileList[i]%>"><%=logFileList[i]%></option>
<%
	}
%>		
		</select>
	</form>
</body>
</html>