<%@page import="java.util.HashSet"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.LinkedHashMap"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.ArrayList"%>
<%@ include file="dbConnection.jsp" %>
<%@ page import="com.common.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%!
	static final String PACKAGE_NAME = "com.skp.launcher";

	static final String DEFUALT_PATH = "SmartUX\\logs\\"; //★

	static final String E2E_TABLE_NAME = "e2e";
	static final String AGING_TABLE_NAME = "aging";
	static final String UX_TABLE_NAME = "ux";
 	
%>
<%
	request.setCharacterEncoding("utf-8");
	String tableName = request.getParameter("tableName");
	String pullRequestId = request.getParameter("pull_request_id");
	String pBuildCount = request.getParameter("build_count");
	
	//System.out.println("buildNumber["+pBuildCount+"]");
	
	if(tableName == null || tableName == "")
	{
		tableName = E2E_TABLE_NAME;
	}
	
	DBUtils db = new DBUtils();

	//System.out.println("tableName : ["+tableName+"]");
	/* build */
 	ArrayList<HashMap<String, String>> exBuildInfoList = new ArrayList<HashMap<String, String>>();
	ArrayList<HashMap<String, String>> axBuildInfoList = new ArrayList<HashMap<String, String>>();
	ArrayList<HashMap<String, String>> uxBuildInfoList = new ArrayList<HashMap<String, String>>();
	
	db.SelectBuildInfo(conn, E2E_TABLE_NAME, PACKAGE_NAME, exBuildInfoList);
	db.SelectBuildInfo(conn, AGING_TABLE_NAME, PACKAGE_NAME, axBuildInfoList);
	db.SelectBuildInfo(conn, UX_TABLE_NAME, PACKAGE_NAME, uxBuildInfoList); 
	
	/* 응답시간 */
	ArrayList<HashMap<String, String>> e2eScenarioList = new ArrayList<HashMap<String, String>>();
	/* 메모리 */
	ArrayList<HashMap<String, String>> agingScenarioList = new ArrayList<HashMap<String, String>>();
	
	if(tableName == "" || tableName == null)
	{
		tableName = "e2e";
	}
	
	db.getScenario(conn, E2E_TABLE_NAME, PACKAGE_NAME, e2eScenarioList);
	db.getScenario(conn, AGING_TABLE_NAME, PACKAGE_NAME, agingScenarioList);
	
	ArrayList<String> e2eVersionArr = db.getBuildVersion(PACKAGE_NAME, E2E_TABLE_NAME);
	ArrayList<String> agingVersionArr =db.getBuildVersion(PACKAGE_NAME, AGING_TABLE_NAME);
	
%>

<html> 

<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="css/style.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="http://ajax.aspnetcdn.com/ajax/jQuery/jquery-1.6.4.min.js"></script>
<!-- <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script src="//code.jquery.com/jquery.min.js"></script> -->
<script src='//rawgit.com/tuupola/jquery_chained/master/jquery.chained.min.js'></script>

<script type="text/javascript">
	var previousTab = "";
	
	/* 차트 관련 iframe에 파라메터 넘기는 함수 */
	function sendToChartViewer(frameName, tableName, scenario, version, sdate, edate, pullRequestId, buildCount)
	{
		//alert("frameName : " + frameName + "\n tableName : " + tableName + "\n scenario : " + scenario + "\n buildNumber : " + buildNumber);
		var frm = document.chartPageForm;
		frm.tableName.value = tableName;
		frm.scenario.value = scenario;
		frm.version.value = version;
		frm.sdate.value = sdate;
		frm.edate.value = edate;
		frm.pullRequestId.value = pullRequestId;
		frm.buildCount.value = buildCount;
		frm.target = frameName;//"exFrame";
		frm.submit();
	}
	
	/* 엑셀 결과 보고서 관련 iframe에 파라메터 넘기는 함수 */
	function sendToResultViewer(frameName, pLogPath, logFile)
	{
		//alert(frameName+", " + value);
		var frm = document.resultForm;
		frm.pLogPath.value = pLogPath;
		if(logFile != null)
		{
			frm.logFile.value = logFile.split("\\")[2];
		}
		/* var valueArr = value.split("\\"); //★
		//alert(valueArr[0]+":"+valueArr[1]+":"+valueArr[2]);
		frm.packageName.value = valueArr[0];
		frm.testName.value = valueArr[1];
		frm.logFile.value = valueArr[2]; */
		// frm.build_FilePath.value = value; 
		frm.target = frameName;
		frm.submit();
	}

	$(document).ready(function(){
		var tabName = "";
		
		$("#selUxBuildCount").find("option").filter(function(index) {
			return '<%=pBuildCount %>' == $(this).text();
			}).prop("selected", "selected");
		<%
		//if(pBuildNumber != null && pBuildNumber.length() > 0)
		//{
		%>
			<%-- sendToChartViewer('exFrame', 'e2e', $("#selE2eSubMenu option:selected").val(), $("input[name=sDate1]").val(), $("input[name=eDate1]").val(), '<%=pBuildNumber%>', null);
			/sendToChartViewer('axFrame', 'aging', $("#selAgingSubMenu option:selected").val(), $("input[name=sDate2]").val(), $("input[name=eDate2]").val(), '<%=pBuildNumber%>', null);
			sendToResultViewer('uxFrame', '<%=pBuildNumber%>'); --%>
		<%
		//}
		//else
		{
		%>
			sendToChartViewer('exFrame', 'e2e', $("#selE2eSubMenu option:selected").val(), $("#selE2eVersion option:selected").val(), $("input[name=sDate1]").val(), $("input[name=eDate1]").val(), $("#selExBuildNumber option:selected").val(), $("#selExBuildCount option:selected").val());
			sendToChartViewer('axFrame', 'aging', $("#selAgingSubMenu option:selected").val(), $("#selAgingVersion option:selected").val(), $("input[name=sDate2]").val(), $("input[name=eDate2]").val(), $("#selAxBuildNumber option:selected").val(), $("#selAxBuildCount option:selected").val());
			if('<%=pBuildCount%>' == null)
			{
				sendToResultViewer('uxFrame', $('#selUxBuildNumber option:selected').val(), null);
			}
			else
			{
				sendToResultViewer('uxFrame', $('#selUxBuildNumber option:selected').val(), $('#selUxBuildCount option:selected').val());
			}
		<%
		}
		%>
		// 응답시간탭 build_number 클릭시 이벤트
		$("#selExBuildNumber").change(function()
		{
			tabName = $(".active").children().attr("id");
			sendToChartViewer('exFrame', tabName, $("#selE2eSubMenu option:selected").val(), $("#selE2eVersion option:selected").val(), $("input[name=sDate1]").val(), $("input[name=eDate1]").val(), $("#selExBuildNumber option:selected").val(), $("#selExBuildCount option:selected").val());
		});
		
		// 응답시간탭 build_date 클릭시 이벤트
		$("#selExBuildCount").change(function()
		{
			tabName = $(".active").children().attr("id");
			sendToChartViewer('exFrame', tabName, $("#selE2eSubMenu option:selected").val(), $("#selE2eVersion option:selected").val(), $("input[name=sDate1]").val(), $("input[name=eDate1]").val(), $("#selExBuildNumber option:selected").val(), $("#selExBuildCount option:selected").val());
		});
		
		// 메모리탭 build_number 클릭시 이벤트
		$("#selAxBuildNumber").change(function()
		{
			tabName = $(".active").children().attr("id");
			sendToChartViewer('axFrame', tabName, $("#selAgingSubMenu option:selected").val(), $("#selAgingVersion option:selected").val(), $("input[name=sDate2]").val(), $("input[name=eDate2]").val(), $("#selAxBuildNumber option:selected").val(), $("#selAxBuildCount option:selected").val());
		});
		
		// 메모리탭 build_date 클릭시 이벤트
		$("#selAxBuildCount").change(function()
		{
			tabName = $(".active").children().attr("id");
			sendToChartViewer('axFrame', tabName, $("#selAgingSubMenu option:selected").val(), $("#selAgingVersion option:selected").val(), $("input[name=sDate2]").val(), $("input[name=eDate2]").val(), $("#selAxBuildNumber option:selected").val(), $("#selAxBuildCount option:selected").val());
		});
		
		// 응답시간탭 시나리오 클릭시 이벤트 
 		$("#selE2eSubMenu").change(function()
		{
			tabName = $(".active").children().attr("id");
			sendToChartViewer('exFrame', tabName, $("#selE2eSubMenu option:selected").val(), $("#selE2eVersion option:selected").val(), $("input[name=sDate1]").val(), $("input[name=eDate1]").val(), $("#selExBuildNumber option:selected").val(), $("#selExBuildCount option:selected").val());
		});
		
		// 메모리탭 시나리오 클릭시 이벤트 
		$("#selAgingSubMenu").change(function()
		{
			tabName = $(".active").children().attr("id");
			sendToChartViewer('axFrame', tabName, $("#selAgingSubMenu option:selected").val(), $("#selAgingVersion option:selected").val(), $("input[name=sDate2]").val(), $("input[name=eDate2]").val(), $("#selAxBuildNumber option:selected").val(), $("#selAxBuildCount option:selected").val());
		});
		
		// 응답시간탭 버전 클릭시 이벤트 
 		$("#selE2eVersion").change(function()
		{
			tabName = $(".active").children().attr("id");
			sendToChartViewer('exFrame', tabName, $("#selE2eSubMenu option:selected").val(), $("#selE2eVersion option:selected").val(), $("input[name=sDate1]").val(), $("input[name=eDate1]").val(), $("#selExBuildNumber option:selected").val(), $("#selExBuildCount option:selected").val());
		});
		
		// 메모리탭 버전 클릭시 이벤트 
		$("#selAgingVersion").change(function()
		{
			tabName = $(".active").children().attr("id");
			sendToChartViewer('axFrame', tabName, $("#selAgingSubMenu option:selected").val(), $("#selAgingVersion option:selected").val(), $("input[name=sDate2]").val(), $("input[name=eDate2]").val(), $("#selAxBuildNumber option:selected").val(), $("#selAxBuildCount option:selected").val());
		});
		
		// 응답시간탭 시작일자 클릭시 이벤트
		$("input[name=sDate1]").change(function()
		{
			tabName = $(".active").children().attr("id");
			sendToChartViewer('exFrame', tabName, $("#selE2eSubMenu option:selected").val(), $("#selE2eVersion option:selected").val(), $("input[name=sDate1]").val(), $("input[name=eDate1]").val(), $("#selExBuildNumber option:selected").val(), $("#selExBuildCount option:selected").val());
		});
		
		// 메모리탭 시작일자 클릭시 이벤트
		$("input[name=sDate2]").change(function()
		{
			tabName = $(".active").children().attr("id");
			sendToChartViewer('axFrame', tabName, $("#selAgingSubMenu option:selected").val(), $("#selAgingVersion option:selected").val(), $("input[name=sDate2]").val(), $("input[name=eDate2]").val(), $("#selAxBuildNumber option:selected").val(), $("#selAxBuildCount option:selected").val());
		});
		
		// 응답시간탭 종료일자 클릭시 이벤트
		$("input[name=eDate1]").change(function()
		{
			tabName = $(".active").children().attr("id");
			sendToChartViewer('exFrame', tabName, $("#selE2eSubMenu option:selected").val(), $("#selE2eVersion option:selected").val(), $("input[name=sDate1]").val(), $("input[name=eDate1]").val(), $("#selExBuildNumber option:selected").val(), $("#selExBuildCount option:selected").val());
		});
		
		// 메모리탭 종료일자 클릭시 이벤트
		$("input[name=eDate2]").change(function()
		{
			tabName = $(".active").children().attr("id");
			sendToChartViewer('axFrame', tabName, $("#selAgingSubMenu option:selected").val(), $("#selAgingVersion option:selected").val(), $("input[name=sDate2]").val(), $("input[name=eDate2]").val(), $("#selAxBuildNumber option:selected").val(), $("#selAxBuildCount option:selected").val());
		});
		
		// UI탭 build number 클릭시 이벤트 
		$("#selUxBuildNumber").change(function(){
			sendToResultViewer('uxFrame', $('#selUxBuildNumber option:selected').val(), null);
		});
		
		// UI탭 build count 클릭시 이벤트 
		$("#selUxBuildCount").change(function(){
			sendToResultViewer('uxFrame', $('#selUxBuildNumber option:selected').val(), $('#selUxBuildCount option:selected').val());
		});
 
		/* 탭 클릭시 이벤트처리 */
		$("ul.tabs li").click(function() 
        {
			$("ul.tabs li").removeClass("active");
			$(this).addClass("active"); 
			
            tabName = $(".active").children().attr("id");
            var tabHref = $(".active").children().attr("href");
           
            if(tabName == '<%=E2E_TABLE_NAME%>')
        	{
        		$("#axbuildNumberDiv").attr("style","display: none;");
        		$("#uxbuildNumberDiv").attr("style","display: none;");
        		$("#exbuildNumberDiv").attr("style","");
        		
        		$("#agingDiv").attr("style","display: none;");
        		$("#uxDiv").attr("style","display: none;");
        		$("#e2eDiv").attr("style","");
        		
        		$("#selectBox").attr("style","");
        		$("#agingScenarioDiv").attr("style","display: none;");
        		$("#e2eScenarioDiv").attr("style","");
        		
        		//sendToChartViewer('exFrame', 'e2e', $("#selExBuildNumber option:selected").val(), $("#selExBuildCount option:selected").val());
        	}
            if(tabName == '<%=AGING_TABLE_NAME%>')
        	{
        		$("#uxbuildNumberDiv").attr("style","display: none;");
        		$("#exbuildNumberDiv").attr("style","display: none;");
        		$("#axbuildNumberDiv").attr("style","");
        		
        		$("#e2eDiv").attr("style","display: none;");
        		$("#uxDiv").attr("style","display: none;");
        		$("#agingDiv").attr("style","");
        		
        		$("#selectBox").attr("style","");
        		$("#agingScenarioDiv").attr("style","");
        		$("#e2eScenarioDiv").attr("style","display: none;");
        	}
            if(tabName == '<%=UX_TABLE_NAME%>')
            {
            	$("#exbuildNumberDiv").attr("style","display: none;");
            	$("#axbuildNumberDiv").attr("style","display: none;");
            	$("#uxbuildNumberDiv").attr("style","");
            	
            	
            	$("#e2eDiv").attr("style","display: none;");
        		$("#agingDiv").attr("style","display: none;");
        		$("#uxDiv").attr("style","");
        		
        		$("#selectBox").attr("style","display: none;");
            }
            
            if(previousTab != "")
            {
				$(previousTab).attr("style","display: none;");
            }
			$(tabHref).attr("style","");
			previousTab = tabHref;
        });
		
		$("a[href=#<%=tableName%>Div]").parent().addClass("active");
		
		window.onload = function(){
			
		};
		
		
	});
</script>
</head>
<body oncontextmenu="return false" >
	<form name="chartPageForm" action="chartViewer.jsp" method="POST">
		<input type="hidden" name="tableName" value="">
		<input type="hidden" name="scenario" value="">
		<input type="hidden" name="version" value="">
		<input type="hidden" name="sdate" value="">
		<input type="hidden" name="edate" value="">
		<input type="hidden" name="pullRequestId" value="">
		<input type="hidden" name="buildCount" value="">
	</form>
	
	<!-- 엑셀 결과 보고서 form (UI) -->
	<form name="resultForm" action="resultViewer.jsp" method="POST">
		<input type="hidden" name="pLogPath" value="">
		<input type="hidden" name="pLogPathCount" value="">
		<input type="hidden" name="logFile" value="">
		<!-- <input type="hidden" name="packageName" value="">
		<input type="hidden" name="testName" value="">
		 -->
	</form>

<div id="selBuildInfoDiv" style="height: 60px;">
	<input type="button" value="BACK" onclick="location.href='launcher.jsp'" style="float: left; margin-right: 5px;">
	
	<!-- EX build number -->
	<div id="exbuildNumberDiv" style="">
		<!-- 필터 조회 -->
		<select name="selExBuildNumber" id="selExBuildNumber">
			<option disabled>PULL_REQUEST_ID</option>
			<%
			String prevNumber = "";
			for(int i = 0; i < exBuildInfoList.size(); i++)
			{
				if(!prevNumber.equals(exBuildInfoList.get(i).get("pull_request_id")))
				{
					if(pullRequestId != null && pullRequestId.length() > 0 && pullRequestId.equals(exBuildInfoList.get(i).get("pull_request_id")))
					{
						out.print("<option value='"+exBuildInfoList.get(i).get("pull_request_id")+"' selected>"+exBuildInfoList.get(i).get("pull_request_id")+"</option>");
					}
					else
					{
 						out.print("<option value='"+exBuildInfoList.get(i).get("pull_request_id")+"'>"+exBuildInfoList.get(i).get("pull_request_id")+"</option>");
					}
				}
				prevNumber = exBuildInfoList.get(i).get("pull_request_id");
			}
			%>
		</select>
		<select name="selExBuildCount" id="selExBuildCount">
			<option value="" disabled>BUILD COUNT</option>
			<%
			for(int i = 0; i < exBuildInfoList.size(); i++)
			{
				if(pBuildCount != null && pBuildCount.length() > 0 && pBuildCount.equals(exBuildInfoList.get(i).get("build_count")))
				{
					out.print("<option class='"+exBuildInfoList.get(i).get("pull_request_id")+"' value='"+exBuildInfoList.get(i).get("build_count")+"' selected>"+exBuildInfoList.get(i).get("build_count")+"</option>");
				}
				else
				{
 					out.print("<option class='"+exBuildInfoList.get(i).get("pull_request_id")+"' value='"+exBuildInfoList.get(i).get("build_count")+"'>"+exBuildInfoList.get(i).get("build_count")+"</option>");
				}
			}
			%>
		</select>
	</div>
	
	<!-- AX build number -->
 	<div id="axbuildNumberDiv" style="display: none;">
		<!-- 필터 조회 -->
		<select name="selAxBuildNumber" id="selAxBuildNumber">
			<option disabled>PULL_REQUEST_ID</option>
			<%
			prevNumber = "";
			for(int i = 0; i < axBuildInfoList.size(); i++)
			{
				if(!prevNumber.equals(axBuildInfoList.get(i).get("pull_request_id")))
				{
					if(pullRequestId != null && pullRequestId.length() > 0 && pullRequestId.equals(axBuildInfoList.get(i).get("pull_request_id")))
					{
						out.print("<option value='"+axBuildInfoList.get(i).get("pull_request_id")+"' selected>"+axBuildInfoList.get(i).get("pull_request_id")+"</option>");
					}
					else
					{
 						out.print("<option value='"+axBuildInfoList.get(i).get("pull_request_id")+"'>"+axBuildInfoList.get(i).get("pull_request_id")+"</option>");
					}				
				}
				prevNumber = axBuildInfoList.get(i).get("pull_request_id");
			}
			%>
		</select>
		<select name="selAxBuildCount" id="selAxBuildCount">
			<option value="" disabled>BUILD COUNT</option>
			<%
			for(int i = 0; i < axBuildInfoList.size(); i++)
			{
				if(pBuildCount != null && pBuildCount.length() > 0 && pBuildCount.equals(axBuildInfoList.get(i).get("build_count")))
				{
					out.print("<option class='"+axBuildInfoList.get(i).get("pull_request_id")+"' value='"+axBuildInfoList.get(i).get("build_count")+"' selected>"+axBuildInfoList.get(i).get("build_count")+"</option>");
				}
				else
				{
 					out.print("<option class='"+axBuildInfoList.get(i).get("pull_request_id")+"' value='"+axBuildInfoList.get(i).get("build_count")+"'>"+axBuildInfoList.get(i).get("build_count")+"</option>");
				}
			}
			%>
		</select>
	</div>
	
	<!-- UI탭 build number -->
	<div id="uxbuildNumberDiv" style="display: none;">
		<!-- 필터 조회 -->
		<select name="selUxBuildNumber" id="selUxBuildNumber">
			<option disabled>PULL_REQUEST_ID</option>
			<%
			prevNumber = "";
			String[] allLogPath = new String[uxBuildInfoList.size()];
			String pull_request_id = "";
			if(uxBuildInfoList != null && uxBuildInfoList.size() > 0)
			{
				uxBuildInfoList.get(0).get("pull_request_id");
			}
			for(int i = 0; i < uxBuildInfoList.size(); i++)
			{
				allLogPath[i] = "";
				pull_request_id = uxBuildInfoList.get(i).get("pull_request_id");
				
				for(int j = 0; j < uxBuildInfoList.size(); j++)
				{
					if(pull_request_id.equals(uxBuildInfoList.get(j).get("pull_request_id")))
					{
						allLogPath[i] += uxBuildInfoList.get(j).get("log_path")+",";
					}
					
					pull_request_id = uxBuildInfoList.get(i).get("pull_request_id");
				}
				//System.out.println(allLogPath[i]);
			}
			
			prevNumber = "";
			for(int i = 0; i < uxBuildInfoList.size(); i++)
			{
				if(!prevNumber.equals(uxBuildInfoList.get(i).get("pull_request_id")))
				{
					if(pullRequestId != null && pullRequestId.length() > 0 && pullRequestId.equals(uxBuildInfoList.get(i).get("pull_request_id")))
					{
						out.print("<option value='"+allLogPath[i]+"' selected>"+uxBuildInfoList.get(i).get("pull_request_id")+"</option>");
/* 						out.print("<option value='"+uxBuildInfoList.get(i).get("log_path")+"' selected>"+uxBuildInfoList.get(i).get("pull_request_id")+"</option>"); */
					}
					else
					{
	 					out.print("<option value='"+allLogPath[i]+"'>"+uxBuildInfoList.get(i).get("pull_request_id")+"</option>");
/* 	 					out.print("<option value='"+uxBuildInfoList.get(i).get("log_path")+"'>"+uxBuildInfoList.get(i).get("pull_request_id")+"</option>"); */
					}
				}	
				prevNumber = uxBuildInfoList.get(i).get("pull_request_id");
	 			/* System.out.println("====================================");
 				System.out.println(uxBuildInfoList.get(i).get("log_path"));
 				System.out.println("===================================="); */
			}
			%>
		</select>
		<select name="selUxBuildCount" id="selUxBuildCount">
			<option value="" disabled>BUILD COUNT</option>
			<%
			for(int i = 0; i < uxBuildInfoList.size(); i++)
			{
				/* if(pBuildCount != null && pBuildCount.length() > 0 && pBuildCount.equals(uxBuildInfoList.get(i).get("build_count")))
				{
					out.print("<option class='"+allLogPath[i]+"' value='"+uxBuildInfoList.get(i).get("log_path")+"' selected>"+uxBuildInfoList.get(i).get("build_count")+"</option>");	
// 					out.print("<option class='"+uxBuildInfoList.get(i).get("log_path")+"' value='"+uxBuildInfoList.get(i).get("build_count")+"' selected>"+uxBuildInfoList.get(i).get("build_count")+"</option>");	 
				}
				else */
				{
 					out.print("<option class='"+allLogPath[i]+"' value='"+uxBuildInfoList.get(i).get("log_path")+"'>"+uxBuildInfoList.get(i).get("build_count")+"</option>");
// 					out.print("<option class='"+uxBuildInfoList.get(i).get("log_path")+"' value='"+uxBuildInfoList.get(i).get("build_count")+"'>"+uxBuildInfoList.get(i).get("build_count")+"</option>"); 
				}
			}
			%>
		</select>
	</div>
</div>

<div id="wrapper">    
    <!-- 탭 메뉴 영역 -->
    <ul class="tabs">
        <li><a id="e2e" href="#e2eDiv">응답시간</a></li>
        <li><a id="aging" href="#agingDiv">메모리</a></li>
        <li><a id="ux" href="#uxDiv">UI</a></li>
    </ul>
</div>
<br/>
<br/>
<div id="mainDiv">
	<div id="selectBox" style="top: 10px; height: 60px;">
	<br/>
		<!-- 응답시간 탭 - 시나리오, 시작일자, 종료일자 -->
		<div id="e2eScenarioDiv" style="">
			<!-- 시나리오 조회 -->
			<select name="e2eSubMenu" id="selE2eSubMenu">
				<option value="" disabled>SCENARIO</option>
				<%
				String all = "";
				for(int i = 0; i < e2eScenarioList.size(); i++)
				{
					all += e2eScenarioList.get(i).get("scenario")+e2eScenarioList.get(i).get("average");
					if(!(i == e2eScenarioList.size()-1))
					{
						all += ",";
					}
				}
				//System.out.println("all : " + all);
				
				out.print("<option value='all,"+all+"' selected>all</option>");
				
				if(tableName.equals(E2E_TABLE_NAME))
				{
					for(int i = 0; i < e2eScenarioList.size(); i++)
					{
						out.print("<option value='"+e2eScenarioList.get(i).get("scenario")+e2eScenarioList.get(i).get("average")+"'>"+e2eScenarioList.get(i).get("scenario")+"</option>");
					}
				}
				%>
			</select>
			
			<!-- version 조회 -->
			<select name="e2eVersion" id="selE2eVersion">
				<option value="" disabled>APP VERSION</option>
				<option value="" >all</option>
				<%
				for(int i = 0; i < e2eVersionArr.size(); i++)
				{
					out.print("<option value='"+e2eVersionArr.get(i)+"'>"+e2eVersionArr.get(i)+"</option>");
				}
				%>
			</select>
			
			<!-- 날짜 조회 -->
			<input type="date" name="sDate1" value="">~<input type="date" name="eDate1" value="">
		</div>
		
		<!-- 메모리 탭 - 시나리오, 시작일자, 종료일자 -->
		<div id="agingScenarioDiv" style="display: none;">
			<!-- 시나리오 조회 -->
			<select name="agingSubMenu" id="selAgingSubMenu">
				<option value="" disabled>SCENARIO</option>
				<%
				all = "";
				for(int i = 0; i < agingScenarioList.size(); i++)
				{
					all += agingScenarioList.get(i).get("scenario")+agingScenarioList.get(i).get("average");
					if(!(i == agingScenarioList.size()-1))
					{
						all += ",";
					}
				}
				//System.out.println(all);
				out.print("<option value='all,"+all+"' selected>all</option>");
				if(tableName.equals(E2E_TABLE_NAME))
				{
					for(int i = 0; i < agingScenarioList.size(); i++)
					{
						out.print("<option value='"+agingScenarioList.get(i).get("scenario")+agingScenarioList.get(i).get("average")+"'>"+agingScenarioList.get(i).get("scenario")+"</option>");
					}
				}
				%>
			</select>
			
			<!-- version 조회 -->
			<select name="agingVersion" id="selAgingVersion">
				<option value="" disabled>APP VERSION</option>
				<option value="" >all</option>
				<%
				for(int i = 0; i < agingVersionArr.size(); i++)
				{
					out.print("<option value='"+agingVersionArr.get(i)+"'>"+agingVersionArr.get(i)+"</option>");
				}
				%>
			</select>
			
			<!-- 날짜 조회 -->
			<input type="date" name="sDate2" value="">~<input type="date" name="eDate2" value="">
		</div>
		
	</div>
	
	<!-- E2E 탭   -->
	<div id="e2eDiv">
		<iframe name="exFrame" width="100%" height="700" scroll="no" src="chartViewer.jsp" frameBorder="0"></iframe>
	</div>
	
	<!-- aging 탭 -->
	<div id="agingDiv" style="display: none;">
		<iframe name="axFrame" width="100%" height="700" scroll="no" src="chartViewer.jsp" frameBorder="0"></iframe>
	</div>
	
	<!-- ux 탭 -->
	<div id="uxDiv" style="display: none;">
		<iframe name="uxFrame" width="100%" height="800" scroll="no" src="resultViewer.jsp" frameBorder="0"></iframe>
	</div>
</div>
<script type="text/javascript">
$("#selExBuildCount").chained("#selExBuildNumber");
$("#selAxBuildCount").chained("#selAxBuildNumber");
$("#selUxBuildCount").chained("#selUxBuildNumber");
</script>
</body>
</html>