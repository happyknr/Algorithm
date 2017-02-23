<!-- 2017.01.23 launcher --> 
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%@ page import="java.lang.String.*" %>
<%@ page import="java.util.Date" %>
<%@ include file="dbConnection.jsp" %>
<%
request.setCharacterEncoding("utf-8");
String packageName = "com.skp.launcher";
String psubMenu = request.getParameter("subMenu");
String pappVersion = request.getParameter("appVersion");
String sdate = request.getParameter("sdate");
String edate = request.getParameter("edate");
String tabName = request.getParameter("tabName");
String deviceInfo = null;

System.out.println("subMenu : [" + psubMenu + "] appversion : [" + pappVersion + "] sdate : ["+sdate+"] edate : ["+edate+"] tabName : ["+tabName+"]");


if(tabName == null || tabName == "")
{
	tabName = "E2E";
	
	if(!(tabName.equals("aging") || tabName.equals("AGING")))
	{
		if(psubMenu == null || psubMenu == "")
		{
			psubMenu = "all";
		}
	}
}

if(sdate == null || sdate == "")
{
	String lastMonth = "";
	Calendar cal = Calendar.getInstance();
	cal.add ( cal.MONTH, -1 );
	if(cal.get(cal.MONTH) < 10) 
	{
		if(cal.get(cal.DATE) < 10)
		{
			lastMonth = cal.get(cal.YEAR) + "-0" + (cal.get ( cal.MONTH )+1)  + "-0" + cal.get(cal.DATE);
		}
		else
		{
			lastMonth = cal.get(cal.YEAR) + "-0" + (cal.get ( cal.MONTH )+1)  + "-" + cal.get(cal.DATE);
		}
	} 
	else
	{
		if(cal.get(cal.DATE) < 10)
		{
			lastMonth = cal.get(cal.YEAR) + "-" + (cal.get ( cal.MONTH )+1)  + "-0" + cal.get(cal.DATE);
		}
		else
		{
			lastMonth = cal.get(cal.YEAR) + "-" + (cal.get ( cal.MONTH )+1)  + "-" + cal.get(cal.DATE);
		}
	}
	//System.out.println(lastMonth);
	sdate = lastMonth;
}

Statement stmt=null;
ResultSet rs1 = null, rs3 = null ;
String query=null;
ArrayList<HashMap<String, String>> subMenuArr = null;
HashMap<String, String> subMenuMap = null;
ArrayList<String> appVersionArr = null; /* app version */

try
{
	stmt = conn.createStatement();
	
	/* 시나리오 조회 쿼리 */
	query = "SELECT DISTINCT(SCENARIO) AS SUBMENU \n";
	query += "		, ROUND(AVG(VALUE), 3) AS AVG \n";
	query += " 		, COUNT(SCENARIO) CNT \n";
	query += "	FROM "+tabName+" WHERE PACKAGE_NAME = '"+packageName+"'";
	query += "			AND value != 0 \n";
	query += "			AND pull_request_id is null \n";
	if(pappVersion != null && pappVersion != "" && !pappVersion.equals("all"))
	{
		query += "	 	AND VERSION = '" +pappVersion+"'  \n";
	}
	if(sdate != null && sdate != "")
	{
		query += "		AND DATE_FORMAT(date, '%Y-%m-%d') >= DATE_FORMAT('"+sdate+"', '%Y-%m-%d') \n";
	}
	if(edate != null && edate != "")
	{
		query += "		AND DATE_FORMAT(date, '%Y-%m-%d') <= DATE_FORMAT('"+edate+"', '%Y-%m-%d') \n";
	}
	query += " 	GROUP BY SCENARIO \n";
	query += "  ORDER BY CNT DESC \n";
	//System.out.println("SCENARIO QUERY : " + query);
	rs3 = stmt.executeQuery(query);
	
	subMenuArr = new ArrayList<HashMap<String, String>>();
	
	while(rs3.next())
	{
		if(rs3.getString("SUBMENU") != null && rs3.getString("SUBMENU").length() > 0)
		{
			subMenuMap = new HashMap<String, String>();
			subMenuMap.put("SCENARIO", rs3.getString("SUBMENU"));
			subMenuMap.put("AVERAGE", rs3.getString("AVG"));
			subMenuArr.add(subMenuMap);
		}
	}
	
	/* 앱 버전 조회 쿼리 */
	query = "SELECT DISTINCT(VERSION) AS VERSION FROM "+tabName+" WHERE PACKAGE_NAME='"+packageName+"' AND pull_request_id is null \n"; // AND type = '"+REAL_TIME+"'";
	//System.out.println("VERSION QUERY : " + query);
	
	rs3 = stmt.executeQuery(query);
	
	appVersionArr = new ArrayList<String>();
	
	while(rs3.next())
	{
		if(rs3.getString("VERSION") != null && rs3.getString("VERSION").length() > 0)
		{
			appVersionArr.add(rs3.getString("VERSION"));
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
<style type="text/css">
	
	body {
            font-family:"Malgun Gothic";
            font-size: 0.8em;
			margin: 20px;
        }
        /*TAB CSS*/

        ul.tabs {
            margin: 0;
            padding: 0;
            float: left;
            list-style: none;
            height: 32px; /*--Set height of tabs--*/
            border-bottom: 1px solid #999;
            border-left: 1px solid #999;
            width: 90%;
        }
        ul.tabs li {
            float: left;
            margin: 0;
            padding: 0;
            height: 31px; /*--Subtract 1px from the height of the unordered list--*/
            line-height: 31px; /*--Vertically aligns the text within the tab--*/
            border: 1px solid #999;
            border-left: none;
            margin-bottom: -1px; /*--Pull the list item down 1px--*/
            overflow: hidden;
            position: relative;
            background: #e0e0e0;
        }
        ul.tabs li a {
            text-decoration: none;
            color: #000;
            display: block;
            font-size: 1.2em;
            padding: 0 20px;
            /*--Gives the bevel look with a 1px white border inside the list item--*/
            border: 1px solid #fff; 
            outline: none;
        }
        ul.tabs li a:hover {
            background: #ccc;
        }
        html ul.tabs li.active, html ul.tabs li.active a:hover  {
             /*--Makes sure that the active tab does not listen to the hover properties--*/
            background: #fff;
            /*--Makes the active tab look like it's connected with its content--*/
            border-bottom: 1px solid #fff; 
        }

        /* .tab_content {
            padding: 20px;
            font-size: 1.2em;
        } */
</style>
<script type="text/javascript" src="http://ajax.aspnetcdn.com/ajax/jQuery/jquery-1.6.4.min.js"></script>
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script type="text/javascript">
var subMenu = '';
var appMenu = '';

	function search()
	{
		var sdate = $("input[name=sDate]").attr("value");
		var edate = $("input[name=eDate]").attr("value");
		var tabName = $(".active").children().attr("id");
		subMenu = $("#selSubMenu option:selected").text();
		appVersion = $("#selAppVersion option:selected").text();
		
		if(sdate == "")
		{
			sdate = "1970-01-01";
		}
		
		$("#selForm").children().first().attr("value", subMenu);
		$("#selForm").children().eq(1).attr("value", appVersion);
		$("#selForm").children().eq(2).attr("value", sdate);
		$("#selForm").children().eq(3).attr("value", edate);
		$("#selForm").children().eq(4).attr("value", tabName);
		$("#selForm").attr({action:'realtimePage.jsp', method:'post'}).submit();
	}

	$(document).ready(function()
	{
        $("ul.tabs li").click(function() 
        {

            $("ul.tabs li").removeClass("active");
            $(this).addClass("active"); 
           
			var tabName = $(".active").children().attr("id");
			$("#selForm").children().first().attr("value", "all");
			$("#selForm").children().eq(1).attr("value", "all");
			$("#selForm").children().eq(2).attr("value", "");
			$("#selForm").children().eq(3).attr("value", "");
			$("#selForm").children().eq(4).attr("value", tabName);
			$("#selForm").attr({action:'realtimePage.jsp', method:'post'}).submit();
            
            return false;
        });
        //--------------------------------------------------------------------------------------
		$("#selPackName").val("<%=packageName%>").attr("selected", "selected");
		$("#selSubMenu").val("<%=psubMenu%>").attr("selected", "selected");
		$("#selAppVersion").val("<%=pappVersion%>").attr("selected", "selected");
		if("<%=sdate%>" == "1970-01-01")
		{
			$("input[name=sDate]").attr("value", "");
		}
		else
		{
			$("input[name=sDate]").attr("value", "<%=sdate%>");
		}
		$("input[name=eDate]").attr("value", "<%=edate%>");
		$("a[href=#<%=tabName%>]").parent().addClass("active");
		
		/* 패키지명 선택창 변경시 */
		$("#selPackName").change(function()
		{
			subMenu = null;
			if($("#selPackName").val() == "com.skp.launcher")
			{
				subMenu = "all";
			} 
			$("#selForm").children().first().attr("value", subMenu);
			$("#selForm").attr({action:'realtimePage.jsp', method:'post'}).submit();
		});

		/* 시나리오 선택창 변경시 */
		$("#selSubMenu").change(function()
		{
			search();
		});
		
		/* app version 선택창 변경시 */
		$("#selAppVersion").change(function(){
			search();
		});
		
		/* 시작날짜 선택창 변경시 */
		$("input[name=sDate]").change(function(){
			var sdate = $("input[name=sDate]").attr("value");
			var edate = $("input[name=eDate]").attr("value");
			if(edate != null && edate != "")
			{
				if(sdate > edate)
				{
					alert("종료날짜 보다 이전 날짜 선택");
					$("input[name=sDate]").attr("value", "");
				}
				else
				{
					search();
				}
			}
			else
			{
				search();
			}
		});
		
		/* 종료날짜 선택창 변경시 */
		$("input[name=eDate]").change(function(){
			var sdate = $("input[name=sDate]").attr("value");
			var edate = $("input[name=eDate]").attr("value");
			if(sdate != null)
			{
				if(sdate > edate)
				{
					alert("시작날짜 보다 이후 날짜 선택");
					$("input[name=eDate]").attr("value", "");
				}
				else
				{
					search();
				}
			}
			else
			{
				search();
			}
		});
	});
	
	/* 그래프 툴팁 (X축 index순으로 변경으로 인해 툴팁 커스텀) */
	function tooltipContents(date, value)
	{
		return '<div style="padding:5px 5px 5px 5px;"><b>'+date+'</b><br/><b>'+value.toFixed(3)+'</b></div>';
	}
	
    google.charts.load('current', {packages: ['corechart', 'line']});
    google.charts.setOnLoadCallback(drawChart);

    function drawChart()
    {
		var data = new google.visualization.DataTable();
//      data.addColumn('date', 'Date');
//		data.addColumn('datetime', 'Date');
		
<%
	if(psubMenu != null && psubMenu.length() > 0 && psubMenu != "" && psubMenu.equals("all"))
	{
%>
		data.addColumn('number', 'index');
<%
		for(int i = 0; i < subMenuArr.size(); i++)
		{
%>
      		data.addColumn('number', '<%=subMenuArr.get(i).get("SCENARIO")+" ("+subMenuArr.get(i).get("AVERAGE")+")"%>');
            data.addColumn({type:'string', role:'annotation'});
            data.addColumn({type:'string', role:'annotation'});
			data.addColumn({type:'string', role:'tooltip', 'p':{'html':true}});
<%
		}
	}
	else
	{
		if(psubMenu != null && psubMenu.length() > 0 && psubMenu != "")
		{
%>			
			data.addColumn('datetime', 'Date');
<%		}
		else
		{
%>			
			data.addColumn('number', 'index');
<%		}
		
		if(subMenuArr.size() > 0)
		{
%>
			data.addColumn('number', '<%=subMenuArr.get(0).get("SCENARIO")+" ("+subMenuArr.get(0).get("AVERAGE")+")"%>');
<%
		}
		else
		{
%>
			data.addColumn('number', '<%=packageName%>');
<%
		}
%>
		data.addColumn({type:'string', role:'annotation'});
		data.addColumn({type:'string', role:'annotation'});
		data.addColumn({type:'string', role:'tooltip', 'p':{'html':true}});
<%
	}
%>
      // var formatter = new google.visualization.NumberFormat({
      //   pattern: '#.###'
      // });
      // formatter.format(data, 2);

      data.addRows([
<%

try
{
	String preVersion = null;
	String preVersionArr[] = null;


	stmt = conn.createStatement();
	if( psubMenu != null && psubMenu.length() != 0 && psubMenu != "" )
	{
		if( psubMenu.equals("all") )
		{
		   int on = 1;
		   /* 그래프 데이터 조회 쿼리(시나리오 전체) */
		   query = " SELECT TBL0.ROWNUM AS ROWNUM                                   \n";
			for(int i = 0; i < subMenuArr.size(); i++)
			{	
				query += "		 , TBL"+i+".device_info AS device_info     \n";
				query += "		 , TBL"+i+".value AS VALUE"+i+"     \n";
				query += "     , TBL"+i+".date AS date"+i+"         \n";
				query += "     , TBL"+i+".VERSION AS VERSION"+i+"           \n";
				query += "     , ( SELECT MAX(value) FROM "+tabName+"			\n";
				query += "			WHERE PACKAGE_NAME = '"+packageName+"'	\n";
				query += "			AND SCENARIO = '"+subMenuArr.get(i).get("SCENARIO")+"'	\n";
				query += "			AND pull_request_id is null \n";
				if(pappVersion != null && pappVersion != "" && !pappVersion.equals("all"))
				{
					query += "	 				AND VERSION = '" +pappVersion+"'  \n";
				}
				if(sdate != null && sdate != "")
				{
					query += "					AND DATE_FORMAT(date, '%Y-%m-%d') >= DATE_FORMAT('"+sdate+"', '%Y-%m-%d') \n";
				}
				if(edate != null && edate != "")
				{
					query += "					AND DATE_FORMAT(date, '%Y-%m-%d') <= DATE_FORMAT('"+edate+"', '%Y-%m-%d') \n";
				}
				query += "		)"+i+"_MAX    								\n";
				query += "     , ( SELECT MIN(value) FROM "+tabName+" 			\n";
				query += "			WHERE PACKAGE_NAME = '"+packageName+"' 	\n";
				query += "			AND SCENARIO = '"+subMenuArr.get(i).get("SCENARIO")+"' 	\n";
				query += "			AND pull_request_id is null \n";
				if(pappVersion != null && pappVersion != "" && !pappVersion.equals("all"))
				{
					query += "	 				AND VERSION = '" +pappVersion+"'  \n";
				}
				if(sdate != null && sdate != "")
				{
					query += "					AND DATE_FORMAT(date, '%Y-%m-%d') >= DATE_FORMAT('"+sdate+"', '%Y-%m-%d') \n";
				}
				if(edate != null && edate != "")
				{
					query += "					AND DATE_FORMAT(date, '%Y-%m-%d') <= DATE_FORMAT('"+edate+"', '%Y-%m-%d') \n";
				}
				query += "			AND value != 0 						\n";
				query += "		) "+i+"_MIN    								\n";
			}
			query += "	FROM                                              	\n";
			for(int i = 0; i < subMenuArr.size(); i++)
			{
				query += "	(                                               \n";
				query += "		SELECT @ROWNUM"+i+" := @ROWNUM"+i+" +1 AS ROWNUM	\n";
				query += "			  , device_info                               	\n";
				query += "			  , value                               	\n";
				query += "			  , date                                	\n";
				query += "			  , VERSION                                 	\n";
				query += "			FROM "+tabName+", (SELECT @ROWNUM"+i+" := 0) R      	\n";
				query += "			WHERE PACKAGE_NAME = '"+packageName+"'      	\n";
				query += "				AND SCENARIO = '"+subMenuArr.get(i).get("SCENARIO")+"'     	\n";
				query += "			AND pull_request_id is null \n";
				if(pappVersion != null && pappVersion != "" && !pappVersion.equals("all"))
				{
					query += "	 				AND VERSION = '" +pappVersion+"'  \n";
				}
				if(sdate != null && sdate != "")
				{
					query += "					AND DATE_FORMAT(date, '%Y-%m-%d') >= DATE_FORMAT('"+sdate+"', '%Y-%m-%d') \n";
				}
				if(edate != null && edate != "")
				{
					query += "					AND DATE_FORMAT(date, '%Y-%m-%d') <= DATE_FORMAT('"+edate+"', '%Y-%m-%d') \n";
				}
				query += "			AND value != 0 						\n";
				query += "	) TBL"+i+"                                      \n";
				if(on == i)
				{
					query += "	ON	TBL"+(i-1)+".ROWNUM = TBL"+i+".ROWNUM      \n";
					on++;
				}
				if(i < subMenuArr.size()-1)
				{
					query += " LEFT JOIN 											\n";
				}
			}
			
			//System.out.println("all query : " + query);
		}
		else
		{
			/* 그래프 데이터 조회 쿼리(시나리오) */
			query = "SELECT @ROWNUM := @ROWNUM +1 AS ROWNUM \n";
			query += "		 , "+tabName+".*  \n";
			query += "		 , ( SELECT MAX(value) FROM "+tabName+"  \n";
			query += "		 			WHERE PACKAGE_NAME='"+packageName+"' \n"; 
			query += "		 				AND SCENARIO = '"+psubMenu+"' \n";
			query += "			AND pull_request_id is null \n";
			if(pappVersion != null && pappVersion != "" && !pappVersion.equals("all"))
			{
				query += "	 				AND VERSION = '" +pappVersion+"'  \n";
			}
			if(sdate != null && sdate != "")
			{
				query += "					AND DATE_FORMAT(date, '%Y-%m-%d') >= DATE_FORMAT('"+sdate+"', '%Y-%m-%d') \n";
			}
			if(edate != null && edate != "")
			{
				query += "					AND DATE_FORMAT(date, '%Y-%m-%d') <= DATE_FORMAT('"+edate+"', '%Y-%m-%d') \n";
			}
			query += "		 ) MAX_ \n";
			query += "		 , ( SELECT MIN(value) FROM "+tabName+"  \n";
			query += "		 			WHERE PACKAGE_NAME='"+packageName+"'   \n";
			query += "		 				AND SCENARIO = '"+psubMenu+"'  \n";
			query += "			AND pull_request_id is null \n";
			if(pappVersion != null && pappVersion != "" && !pappVersion.equals("all"))
			{
				query += "	 				AND VERSION = '" +pappVersion+"'  \n";
			}
			if(sdate != null && sdate != "")
			{
				query += "					AND DATE_FORMAT(date, '%Y-%m-%d') >= DATE_FORMAT('"+sdate+"', '%Y-%m-%d') \n";
			}
			if(edate != null && edate != "")
			{
				query += "					AND DATE_FORMAT(date, '%Y-%m-%d') <= DATE_FORMAT('"+edate+"', '%Y-%m-%d') \n";
			}
			query += "		 				AND value != 0  \n";
			query += "		 ) MIN_  \n";
			query += "	FROM "+tabName+" \n";
			query += "		, (SELECT @ROWNUM := 0) R  \n";
			query += "	WHERE PACKAGE_NAME='"+packageName+"'  \n";
			query += "		AND SCENARIO = '"+ psubMenu +"'  \n";
			query += "			AND pull_request_id is null \n";
			if(pappVersion != null && pappVersion != "" && !pappVersion.equals("all"))
			{
				query += "	 				AND VERSION = '" +pappVersion+"'  \n";
			}
			if(sdate != null && sdate != "")
			{
				query += "					AND DATE_FORMAT(date, '%Y-%m-%d') >= DATE_FORMAT('"+sdate+"', '%Y-%m-%d') \n";
			}
			if(edate != null && edate != "")
			{
				query += "					AND DATE_FORMAT(date, '%Y-%m-%d') <= DATE_FORMAT('"+edate+"', '%Y-%m-%d') \n";
			}
			query += "		AND value != 0  \n";
			query += "	ORDER BY date ASC \n";
		}
	}
	else /* 조건 검색(패키지명O, 시나리오X, 앱 버전O, 날짜O) */
	{
		/* 그래프 데이터 조회 쿼리(시나리오 제외 조건 검색) */
		query = "SELECT @ROWNUM := @ROWNUM +1 AS ROWNUM, "+tabName+".* \n";
		query += "		, ( SELECT MAX(value) FROM "+tabName+" WHERE PACKAGE_NAME='"+packageName+"' \n";
		query += "			AND pull_request_id is null \n";
		if(pappVersion != null && pappVersion != "" && !pappVersion.equals("all"))
		{
			query += "	 				AND VERSION = '" +pappVersion+"'  \n";
		}
		if(sdate != null && sdate != "")
		{
			query += "					AND DATE_FORMAT(date, '%Y-%m-%d') >= DATE_FORMAT('"+sdate+"', '%Y-%m-%d') \n";
		}
		if(edate != null && edate != "")
		{
			query += "					AND DATE_FORMAT(date, '%Y-%m-%d') <= DATE_FORMAT('"+edate+"', '%Y-%m-%d') \n";
		}
		query += "		) MAX_   \n";
		query += "		, ( SELECT MIN(value) FROM "+tabName+" WHERE PACKAGE_NAME='"+packageName+"' \n";
		query += "			AND pull_request_id is null \n";
		if(pappVersion != null && pappVersion != "" && !pappVersion.equals("all"))
		{
			query += "					AND VERSION = '" +pappVersion+"' \n";
		}
		if(sdate != null && sdate != "")
		{
			query += "					AND DATE_FORMAT(date, '%Y-%m-%d') >= DATE_FORMAT('"+sdate+"', '%Y-%m-%d')\n"; 
		}
		if(edate != null && edate != "")
		{
			query += "					AND DATE_FORMAT(date, '%Y-%m-%d') <= DATE_FORMAT('"+edate+"', '%Y-%m-%d')\n"; 
		}
		query += "					AND value != 0  \n";
		query += "		) MIN_  \n";
		query += "	FROM "+tabName+", (SELECT @ROWNUM := 0) R \n";
		query += "	WHERE package_name='"+packageName+"' \n";
		query += " AND value != 0  \n";
		query += "			AND pull_request_id is null \n";
		if(pappVersion != null && pappVersion != "" && !pappVersion.equals("all"))
		{
			query += " AND VERSION = '" +pappVersion+"' \n";
		}
		if(sdate != null && sdate != "")
		{
			query += " AND DATE_FORMAT(date, '%Y-%m-%d') >= DATE_FORMAT('"+sdate+"', '%Y-%m-%d') \n";
		}
		if(edate != null && edate != "")
		{
			query += " AND DATE_FORMAT(date, '%Y-%m-%d') <= DATE_FORMAT('"+edate+"', '%Y-%m-%d') \n";
		}
		query += " ORDER BY date ASC ";
		
// 		System.out.println(" ========================================== all query ================================================= ");
// 		System.out.println(query);
// 		System.out.println(" ========================================== all query ================================================= ");
	}
	rs1 = stmt.executeQuery(query);

	preVersionArr = new String[subMenuArr.size()];
	
	while ( rs1.next() )
	{
		String idx = rs1.getString("ROWNUM");
		deviceInfo = rs1.getString("device_info");
		/* SimpleDateFormat tform = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.0");
		java.util.Date date = tform.parse(dateF);
		
		Calendar c = Calendar.getInstance();
		c.setTime(date); */
    
		if( ( psubMenu != null && psubMenu.length() != 0 ) && psubMenu.equals("all") )
		{
			String version = null;
		
			out.print("["+idx+", ");
			for(int i = 0 ; i < subMenuArr.size(); i++)
			{
				if( rs1.getString("value"+i) != null )
				{
					version = rs1.getString("VERSION"+i);
				}
				
				if( version != null ) //해당 시나리오 값 존재, 버전 존재...........
				{
					if( version.equals(preVersionArr[i]) ) //버전이 이전 버전과 같음. 표출하면 안돼
					{
						if(rs1.getString("value"+i).equals(rs1.getString(i+"_MAX")) )
						{
							out.print(rs1.getString("value"+i)+ ", " + null + ", 'MAX', tooltipContents('" + rs1.getString("date"+i) + "', " + rs1.getString("value"+i)+")");
						}
						else if(rs1.getString("value"+i).equals(rs1.getString(i+"_MIN")) )
						{
							out.print(rs1.getString("value"+i)+ ", " + null + ", 'MIN', tooltipContents('" + rs1.getString("date"+i) + "', " + rs1.getString("value"+i)+")");
						}
						else
						{
							out.print( rs1.getDouble("value"+i) + ", " + null + ", " + null + ", tooltipContents('" + rs1.getString("date"+i) + "', " + rs1.getString("value"+i)+")");
						} 
					}
					else //버전이 존재하지만, 이전 버전과 다름. 표출해야 돼
					{
						if(rs1.getString("value"+i).equals(rs1.getString(i+"_MAX")) )
						{
							out.print(rs1.getString("value"+i)+ ", '" + version + "', 'MAX', tooltipContents('" + rs1.getString("date"+i) + "', " + rs1.getString("value"+i)+")");
						}
						else if(rs1.getString("value"+i).equals(rs1.getString(i+"_MIN")) )
						{
							out.print(rs1.getString("value"+i)+ ", '" + version + "', 'MIN', tooltipContents('" + rs1.getString("date"+i) + "', " + rs1.getString("value"+i)+")");
						}
						else
						{
							out.print( rs1.getDouble("value"+i) + ", '" + version + "', " + null + ", tooltipContents('" + rs1.getString("date"+i) + "', " + rs1.getString("value"+i)+")");
						}  
		  			
						preVersionArr[i] = version;
					}
				}
				else // 해당 시나리오 값 없음, 버전 없음
				{
					out.print(null + ", " + null + ", " + null + "," + null);
				}

				if(i < subMenuArr.size()-1)
				{
					out.print(",");
				}
				version = null;
			
			}
			out.print("]");

		}
		else
		{
			String x_val = "";
			String value = rs1.getString("value");
			String dateF = rs1.getString("date");
			String max = rs1.getString("MAX_");
			String min = rs1.getString("MIN_");
			String version = rs1.getString("version");
			
			SimpleDateFormat tform = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.0");
			java.util.Date date = tform.parse(dateF);
			
			Calendar c = Calendar.getInstance();
			c.setTime(date);
			
			if(psubMenu != null && psubMenu.length() != 0 )
			{
				x_val = "new Date("+c.get(Calendar.YEAR)+","+c.get(Calendar.MONTH)+","+c.get(Calendar.DAY_OF_MONTH)+","+c.get(Calendar.HOUR_OF_DAY)+","+c.get(Calendar.MINUTE)+","+c.get(Calendar.SECOND)+")";
			}
			else
			{
				x_val = idx;
			}
	    
			if(version.equals(preVersion))
			{
				if(value.equals(max))
				{
					out.print("["+x_val+", "+Double.parseDouble(value)+", 'MAX', "+null+", tooltipContents('"+dateF + "', "+ Double.parseDouble(value)+")]");
				}
				else if(value.equals(min))
			    {
			    	out.print("["+x_val+", "+Double.parseDouble(value)+", 'MIN', "+null+", tooltipContents('"+dateF + "', "+ Double.parseDouble(value)+")]");
			    }
				else if(value.equals("0"))
				{
					out.print("["+x_val+", "+null+", "+null+", "+null+", tooltipContents('"+dateF + "', "+ Double.parseDouble(value)+")]");
				}
			    else
			    {
			    	out.print("["+x_val+", "+Double.parseDouble(value)+", "+null+", "+null+", tooltipContents('"+dateF + "', "+ Double.parseDouble(value)+")]");
			    }
			}
			else
			{
				if(value.equals(max))
				{
					out.print("["+x_val+", "+Double.parseDouble(value)+", 'MAX', '"+version+"', tooltipContents('"+dateF + "', "+ Double.parseDouble(value)+")]");
				}
				else if(value.equals(min))
				{
					out.print("["+x_val+", "+Double.parseDouble(value)+", 'MIN', '"+version+"', tooltipContents('"+dateF + "', "+ Double.parseDouble(value)+")]");
				}
				else if(value.equals("0"))
				{
					out.print("["+x_val+", "+null+", "+null+", '"+version+"', tooltipContents('"+dateF + "', "+ Double.parseDouble(value)+")]");
				}
				else
				{
					out.print("["+x_val+", "+Double.parseDouble(value)+", "+null+", '"+version+"', tooltipContents('"+dateF + "', " + Double.parseDouble(value)+")]");
				}
				preVersion = version;
			} 
		}
    
		if(!rs1.isLast())
		{
			out.println(",");
		}
	}
}
catch(Exception e)
{
	e.printStackTrace();
	System.out.println("not connected");
}
finally
{
	if(rs1!=null)
    	rs1.close();
	if(stmt!=null)
		stmt.close();
}
%>
	]);
      
	var formatter = new google.visualization.DateFormat({pattern: 'yyyy-MM-dd HH:mm:ss'});
	formatter.format(data, 0);
	
	var maxY = 10.0;
	var interpolateNullsOption = false;
	var cnt = 0;
	var title = '런처플래닛 ';
	
<%	if(psubMenu != null && psubMenu.length() > 0 && psubMenu != "")
	{
		if(psubMenu.equals("all"))
		{
%>
			maxY = 20.0;
			interpolateNullsOption = true;
<%		}
		else
		{
%>			
			cnt = "";
<%		}
	}

	if(packageName != null && packageName.equals("com.skp.launcher"))
	{
		if(tabName.equals("aging"))
		{
%>
			maxY = 500;
<%
		}
		else
		{
%>
			maxY = 20.0;
<%
		}
	}
	
	if(deviceInfo != "" && deviceInfo != null && deviceInfo.length() > 0)
	{
%>
		title = title+' <%=deviceInfo%>';	
<%	
	}
%>
	var options =
	{
		title: title,
		titleTextStyle:
		{
			fontSize: 30
		},
		interpolateNulls: interpolateNullsOption,
		legend: {position: 'right'},
		width: 1400, /*'100%'*/
		height: 600,
		fontSize: 12,
		tooltip: {isHtml: true},
		hAxis:
		{
			/* format: 'MMM.d h:mm', */
			format: "''yy M.d",
			gridlines: {count:cnt}
		},
		vAxis:
		{
			viewWindowMode : 'explicit',
			viewWindow :
			{
				min : 0.0,
				max : maxY
			}
		}
	};
      
	var chart = new google.visualization.LineChart(document.getElementById('linechart'));
	chart.draw(data, options);
}
    
</script>
</head>
<body>
<div style="height: 20px;">
	<input type="button" value="back" onclick="location.href='launcher.jsp'">

	<form id="selForm" method="post" style="float: left;">
		<input type="hidden" name="subMenu" value="">
		<input type="hidden" name="appVersion" value="">
		<input type="hidden" name="sdate" value="">
		<input type="hidden" name="edate" value="">
		<input type="hidden" name="tabName" value="">
	</form>
<%
	/* 시나리오 선택창 */
	if(subMenuArr.size() > 1)
	{
%>  
	<select name="subMenu" id="selSubMenu">
		<option value="all" selected="selected">all</option>
<%
		for(int i = 0 ; i < subMenuArr.size(); i++)
		{
%>  	
			<option value="<%=subMenuArr.get(i).get("SCENARIO") %>"><%=subMenuArr.get(i).get("SCENARIO") %></option>
<%
		}
%>
 
	</select>
<%
	}
%>
	<!-- app version 선택창 -->
	<select name="appVersion" id="selAppVersion">
		<option selected disabled>Choose app version</option>
		<option value="all">all</option>
<%
		for(int i = 0; i < appVersionArr.size(); i++)
		{
%>
			<option value="<%=appVersionArr.get(i) %>"><%=appVersionArr.get(i) %></option>
<%			
		}
%>	
	</select>

<!-- 조회 기간 입력창 -->
<!-- <input placeholder="시작일" type="text" onfocus="this.type='date'; this.setAttribute('onfocus','');this.blur();this.focus();">
<input placeholder="종료일" type="text" onfocus="this.type='date'; this.setAttribute('onfocus','');this.blur();this.focus();"> -->
<input type="date" name="sDate" value="">~
<input type="date" name="eDate" value="">
  
</div>
<br/>
<br/>

<div id="wrapper">    
    <!--탭 메뉴 영역 -->
    <ul class="tabs">
        <li><a id="E2E" href="#E2E">응답시간</a></li>
        <li><a id="aging" href="#aging">메모리</a></li>
    </ul>
</div>
  
<!-- E2E 탭 -->  
<div id="E2E">
</div>

<!-- aging 탭 -->
<div id="aging">

</div>

<div id="linechart" style="height: 500px; width: 80%; float: left;"></div>
  
</body>
</html>
