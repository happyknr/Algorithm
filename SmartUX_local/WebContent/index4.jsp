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

	if(packageName == null || packageName == "")
	{
		packageName = "com_skt_skaf_l001mtm091";
	}

//	String logFilePath = "/app/apache-tomcat-8.0.28/svr_QATESTtx-web1/webapps/SmartUX/";
//	String logFilePath = "C:\\Users\\knr\\workspace\\.metadata\\.plugins\\org.eclipse.wst.server.core\\tmp4\\wtpwebapps\\SmartUX_local\\SmartUX\\logs\\";
	String logFilePath = "C:\\Users\\knr\\workspace\\SmartUX_local\\WebContent\\SmartUX\\logs\\";
//	/app/apache-tomcat-8.0.28/svr_QATESTtx-web1/webapps/SmartUX/logs/com_skt_skaf_l001mtm091/BAT

	File file = new File(logFilePath);
	File file2 = null;
	File file3 = null;
	
	
	File filetest = null;
	
	
	/* 이게 진짜 */
	ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
	HashMap<String, Object> map = null;
	HashMap<String, Object> hm = null;
	HashMap<String, Object> tmp = null;
	ArrayList<String> arrTestNameList = null;
	ArrayList<String> arrLogFileList = null;
	
	String[] packageList = {};
	String[] testNameList = {};
	String[] logFileList = {};
	
 	if(file.exists())
	{
		packageList = file.list();
		for(int i = 0 ; i < packageList.length; i++)
		{
			file2 = new File(logFilePath+"\\"+packageList[i]);
			if(file2.exists())
			{
				testNameList = file2.list();
				arrTestNameList = new ArrayList<String>();
				for(int j = 0 ; j < testNameList.length; j++)
				{
					file3 = new File(logFilePath+"\\"+packageList[i]+"\\"+testNameList[j]);
					if(file3.exists())
					{
						arrTestNameList.add(j, testNameList[j]);
						logFileList = file3.list();
						arrLogFileList = new ArrayList<String>();
						for(int z = 0; z < logFileList.length; z++)
						{
							//System.out.println(">>> " + testNameList[j]+":"+logFileList[z]);
							arrLogFileList.add(z, logFileList[z]);
							System.out.println("3depth] " + arrLogFileList.get(z));
						}
						map = new HashMap<String, Object>();
						map.put("parent", testNameList[j]);
						map.put("children", arrLogFileList);
						list.add(map);
						System.out.println("2depth] " + list.get(j));
						//arrLogFileList.clear();
					}
				}
				hm = new HashMap<String, Object>();
				hm.put("parent", packageList[i]);
				hm.put("children", arrTestNameList);
				list.add(hm);
				//arrTestNameList.clear();
				System.out.println("1depth] " + list.get(i));
			}
		}
	}
 	
 	for(int i = 0; i < list.size(); i++)
 	{
 		tmp = list.get(i);
 		if(tmp.get("parent").equals(packageName))
 		{
 			System.out.println("있다 : " + tmp.get("children"));
 		}
 		System.out.println("parent : " + list.get(i).get("parent"));
 		System.out.println("children : " + list.get(i).get("children"));
 	}
%>
<html>
<head>
<title>UX 자동화 Web UI</title>
<script type="text/javascript" src="http://ajax.aspnetcdn.com/ajax/jQuery/jquery-1.6.4.min.js"></script>
<script type="text/javascript">
8
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
			$("#packageNameForm").attr({action:'index4.jsp', method:'post'}).submit();
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
	<form id="testNameForm" style="float: left;">
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