<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>
<%@ include file="dbConnection.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%!
	static final String PACKAGE_NAME = "com.skp.launcher";

	static final String DEFUALT_PATH = "SmartUX\\logs\\"; //★

	static final String E2E_TABLE_NAME = "e2e";
	static final String AGING_TABLE_NAME = "aging";
	static final String UX_TABLE_NAME = "ux";
	
	public ArrayList<HashMap<String, String>> chartQuery(Connection conn, String tableName, ArrayList<HashMap<String, String>> arrName)
	{
		String query = "";
		Statement stmt = null;
		ResultSet rs = null;
		
		HashMap<String, String> tmpMap = null;
		
		try
		{
			stmt = conn.createStatement();
			
			if(tableName.equals(UX_TABLE_NAME))
			{
				query = "select build_number, log_path from "+tableName+" where build_number != '' order by date desc";
				rs = stmt.executeQuery(query);
				
				while(rs.next())
				{
					String log_Path = rs.getString("log_path");
					tmpMap = new HashMap<String, String>();
					tmpMap.put("build_number", rs.getString("build_number"));
					tmpMap.put("log_path", log_Path.substring(log_Path.lastIndexOf(DEFUALT_PATH)+DEFUALT_PATH.length(), log_Path.length()));
					arrName.add(tmpMap);
				}  
			}
			else
			{
				query = "select distinct(scenario) scenario, round(avg(value), 3) average, count(scenario) from "+tableName+" where package_name = '"+PACKAGE_NAME+"' and build_number != '' group by scenario order by count(scenario) desc";
				rs = stmt.executeQuery(query);
				
				while(rs.next())
				{
					tmpMap = new HashMap<String, String>();
					tmpMap.put("scenario", rs.getString("scenario"));
					tmpMap.put("average", "("+rs.getString("average")+")");
					arrName.add(tmpMap);
				}
			}
			
			if(stmt != null) stmt.close();
		}
		catch(SQLException e)
		{
			e.printStackTrace();
		}
		
		return arrName;
	}
%>
<%
	request.setCharacterEncoding("utf-8");
	String tableName = request.getParameter("tableName");

	//System.out.println("tableName : ["+tableName+"]");

	/* 응답시간 */
	ArrayList<HashMap<String, String>> e2eScenarioList = new ArrayList<HashMap<String, String>>();
	/* 메모리 */
	ArrayList<HashMap<String, String>> agingScenarioList = new ArrayList<HashMap<String, String>>();
	/* UI */
	ArrayList<HashMap<String, String>> buildNumberList = new ArrayList<HashMap<String, String>>();
	
	if(tableName == "" || tableName == null)
	{
		tableName = "e2e";
	}
	
	chartQuery(conn, E2E_TABLE_NAME, e2eScenarioList);
	chartQuery(conn, AGING_TABLE_NAME, agingScenarioList);
	chartQuery(conn, UX_TABLE_NAME, buildNumberList);
%>

<html> 

<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="css/style.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="http://ajax.aspnetcdn.com/ajax/jQuery/jquery-1.6.4.min.js"></script>
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script type="text/javascript">
	var previousTab = "";
	
	/* 차트 관련 iframe에 파라메터 넘기는 함수 */
	function sendToChartViewer(frameName, tabName, scenario, sdate, edate)
	{
		var frm = document.chartForm;
		frm.tableName.value = tabName;
		frm.scenario.value = scenario;
		frm.sdate.value = sdate;
		frm.edate.value = edate;
		frm.target = frameName;//"exFrame";
		frm.submit();
	}
	
	/* 엑셀 결과 보고서 관련 iframe에 파라메터 넘기는 함수 */
	function sendToResultViewer(frameName, value)
	{
		var frm = document.resultForm;
		var valueArr = value.split("\\"); //★
		/* alert(valueArr[0]+":"+valueArr[1]+":"+valueArr[2]); */
		frm.packageName.value = valueArr[0];
		frm.testName.value = valueArr[1];
		frm.logFile.value = valueArr[2];
		/* frm.build_FilePath.value = value; */
		frm.target = frameName;
		frm.submit();
	}

	$(document).ready(function(){
		var tabName = "";
		
		sendToChartViewer('exFrame', 'e2e', $("#selE2eSubMenu option:selected").val(), $("input[name=sDate1]").val(), $("input[name=eDate1]").val());
		sendToChartViewer('axFrame', 'aging', $("#selAgingSubMenu option:selected").val(), $("input[name=sDate2]").val(), $("input[name=eDate2]").val());
		sendToResultViewer('uxFrame', $('#selBuildNumber option:selected').val());
		
		/* 응답시간탭 시나리오 클릭시 이벤트 */
		$("#selE2eSubMenu").change(function()
		{
			tabName = $(".active").children().attr("id");
			sendToChartViewer('exFrame', tabName, $("#selE2eSubMenu option:selected").val(), $("input[name=sDate1]").val(), $("input[name=eDate1]").val());
		});
		
		/* 메모리탭 시나리오 클릭시 이벤트 */
		$("#selAgingSubMenu").change(function()
		{
			tabName = $(".active").children().attr("id");
			sendToChartViewer('axFrame', tabName, $("#selAgingSubMenu option:selected").val(), $("input[name=sDate2]").val(), $("input[name=eDate2]").val());
		});
		
		/* 응답시간탭 시작일자 클릭시 이벤트 */
		$("input[name=sDate1]").change(function()
		{
			tabName = $(".active").children().attr("id");
			sendToChartViewer('exFrame', tabName, $("#selE2eSubMenu option:selected").val(), $("input[name=sDate1]").val(), $("input[name=eDate1]").val());
		});
		
		/* 메모리탭 시작일자 클릭시 이벤트 */
		$("input[name=sDate2]").change(function()
		{
			tabName = $(".active").children().attr("id");
			sendToChartViewer('axFrame', tabName, $("#selAgingSubMenu option:selected").val(), $("input[name=sDate2]").val(), $("input[name=eDate2]").val());
		});
		
		/* 응답시간탭 종료일자 클릭시 이벤트 */
		$("input[name=eDate1]").change(function()
		{
			tabName = $(".active").children().attr("id");
			sendToChartViewer('exFrame', tabName, $("#selE2eSubMenu option:selected").val(), $("input[name=sDate1]").val(), $("input[name=eDate1]").val());
		});
		
		/* 메모리탭 종료일자 클릭시 이벤트 */
		$("input[name=eDate2]").change(function()
		{
			tabName = $(".active").children().attr("id");
			sendToChartViewer('axFrame', tabName, $("#selAgingSubMenu option:selected").val(), $("input[name=sDate2]").val(), $("input[name=eDate2]").val());
		});
		
		/* UI탭 build number 클릭시 이벤트 */
		$("#selBuildNumber").change(function(){
			sendToResultViewer('uxFrame', $('#selBuildNumber option:selected').val());
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
        		$("#agingScenarioDiv").attr("style","display: none;");
        		$("#buildNumberDiv").attr("style","display: none;");
        		$("#e2eScenarioDiv").attr("style","");
        		
        		$("#agingDiv").attr("style","display: none;");
        		$("#uxDiv").attr("style","display: none;");
        		$("#e2eDiv").attr("style","");
        	}
            if(tabName == '<%=AGING_TABLE_NAME%>')
        	{
        		$("#e2eScenarioDiv").attr("style","display: none;");
        		$("#buildNumberDiv").attr("style","display: none;");
        		$("#agingScenarioDiv").attr("style","");
        		
        		$("#e2eDiv").attr("style","display: none;");
        		$("#uxDiv").attr("style","display: none;");
        		$("#agingDiv").attr("style","");
        	}
            if(tabName == '<%=UX_TABLE_NAME%>')
            {
            	$("#e2eScenarioDiv").attr("style","display: none;");
            	$("#agingScenarioDiv").attr("style","display: none;");
            	$("#buildNumberDiv").attr("style","");
            	
            	$("#e2eDiv").attr("style","display: none;");
        		$("#agingDiv").attr("style","display: none;");
        		$("#uxDiv").attr("style","");
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
<body>
	<!-- 차트 관련 form (응답시간, 메모리) -->
	<form name="chartForm" action="chartViewer.jsp" method="POST">
		<input type="hidden" name="tableName" value="">
		<input type="hidden" name="scenario" value="">
		<input type="hidden" name="sdate" value="">
		<input type="hidden" name="edate" value="">
	</form>
	
	<!-- 엑셀 결과 보고서 form (UI) -->
	<form name="resultForm" action="resultViewer.jsp" method="POST">
		<input type="hidden" name="packageName" value="">
		<input type="hidden" name="testName" value="">
		<input type="hidden" name="logFile" value="">
	</form>

<div id="selectBox" style="height: 60px;">
	<input type="button" value="back" onclick="location.href='launcher.jsp'" style="float: left; margin-right: 5px;">
	
	<!-- 응답시간 탭 - 시나리오, 시작일자, 종료일자 -->
	<div id="e2eScenarioDiv" style="">
		<!-- 시나리오 조회 -->
		<select name="e2eSubMenu" id="selE2eSubMenu" >
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
		
		<!-- 날짜 조회 -->
		<input type="date" name="sDate2" value="">~<input type="date" name="eDate2" value="">
	</div>
	
	<!-- UI탭 build number -->
	<div id="buildNumberDiv" style="display: none;">
		<!-- 필터 조회 -->
		<select name="buildNumber" id="selBuildNumber">
			<option disabled>BUILD NUMBER</option>
			<%
			for(int i = 0; i < buildNumberList.size(); i++)
			{
 				out.print("<option value='"+buildNumberList.get(i).get("log_path")+"'>"+buildNumberList.get(i).get("build_number")+"</option>");
			}
			%>
		</select>
	</div>
</div>

<div id="wrapper">    
    <!--탭 메뉴 영역 -->
    <ul class="tabs">
        <li><a id="e2e" href="#e2eDiv">응답시간</a></li>
        <li><a id="aging" href="#agingDiv">메모리</a></li>
        <li><a id="ux" href="#uxDiv">UI</a></li>
    </ul>
</div>

<!-- E2E 탭 -->  
<div id="e2eDiv">
	<iframe name="exFrame" width="100%" height="800" scroll="no" src="chartViewer.jsp" frameBorder="0"></iframe>
</div>

<!-- aging 탭 -->
<div id="agingDiv" style="display: none;">
	<iframe name="axFrame" width="100%" height="800" scroll="no" src="chartViewer.jsp" frameBorder="0"></iframe>
</div>

<!-- ux 탭 -->
<div id="uxDiv" style="display: none;">
	<iframe name="uxFrame" width="100%" height="800" scroll="no" src="resultViewer.jsp" frameBorder="0"></iframe>
</div>


</body>
</html>