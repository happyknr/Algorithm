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
System.out.println("packageName : " + packageName);

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
	String[][][] list = {};
	
 	if(file.exists())
	{
		packageList = file.list();
		list = new String[packageList.length][][];
		for(int i = 0 ; i < packageList.length; i++)
		{
			file2 = new File(logFilePath+"\\"+packageList[i]);
			if(file2.exists())
			{
				testNameList = file2.list();
				list[i] = new String[testNameList.length][];
				for(int j = 0 ; j < testNameList.length; j++)
				{
					file3 = new File(logFilePath+"\\"+packageList[i]+"\\"+testNameList[j]);
					if(file3.exists())
					{
						logFileList = file3.list();
						list[i][j] = new String[logFileList.length];
						for(int z = 0; z < logFileList.length; z++)
						{
							//System.out.println(">>> " + testNameList[j]+":"+logFileList[z]);
							list[i][j][z] = logFileList[z];
							System.out.println(list[i][j][z]);
						}
					}
					//list[i][j] = testNameList[i][0];
				}
			}
			//list[i][0][0] = packageList[i];
		}
	}
 	
/*  	for(int i = 0; i < packageList.length; i++)
 	{
 		System.out.println(list[i]);
 		for(int j = 0 ; j < testNameList.length; j++)
 		{
	 		System.out.println(list[i][j]);
 			for(int z = 0; z < logFileList.length; z++)
 			{
 				System.out.println(list[i][j][z]);
 			}
 		}
 	} */
	/* 상위 디렉토리명 넘기기 */
/* 	filetest = new File(logFilePath+"\\"+packageName);
	if(filetest.exists())
	{
		testNameList = filetest.list();
		System.out.println("-----------------------");
		for(int i = 0; i < testNameList.length; i++)
			System.out.println(testNameList[i]);
		System.out.println("-----------------------");
	} */
	
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
		
		$("#selPackageName").change(function()
		{
			var selectedPackageName = $("#selPackageName").val();
			$("#packageNameForm input[name='packageName']").attr("value",selectedPackageName);
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
	<form id="testNameForm" action="">
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
	<select id="selLogFile">
<%
	for(int i = 0; i < arrLogFileList.size(); i++)
	{
%>
		<option value="<%=arrLogFileList.get(i)%>"><%=arrLogFileList.get(i)%></option>
<%
	}
%>		
	</select>
</body>
</html>