<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%@ page import="java.lang.String.*" %>
<%@ page import="java.util.Date" %>
<%@ include file="dbConnection.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
	ArrayList<HashMap<String, String>> packageNameList = new ArrayList<HashMap<String, String>>();
	HashMap<String, String> packageNameOption = new HashMap<String, String>();

	packageNameOption.put("com_skt_tlife","T life");
	packageNameOption.put("skplanet_musicmate","Musicmate");
	packageNameOption.put("com_skt_sh","Smart Home");
	packageNameOption.put("com_real_tcolorring","T colorring");
	packageNameOption.put("com_skt_skaf_l001mtm091","T map");
	packageNameOption.put("com_skplanet_tmaptaxi_android_passenger","T taxi");
	packageNameOption.put("com_skp_lbs_ptransit","T 대중교통");
	packageNameOption.put("com_skp_launcher_theme","T 배경화면");
	packageNameOption.put("com_skplanet_weatherpong_mobile","Weatherpong");
	packageNameOption.put("com_skp_tsearch","T 검색");
	packageNameOption.put("com_sktechx_volo","VOLO");
	packageNameOption.put("com_skt_prod_cloud","클라우드베리");
	packageNameOption.put("com_skp_launcher","런처플래닛");
	packageNameOption.put("com_sktechx_datasoda","데이터소다 ");
	
	packageNameList.add(packageNameOption);
	pageContext.setAttribute("test", packageNameList);
%>
<html>
<head>
</head>
<body>
	<c:forEach var="i" begin="1" end="10">
		<c:out value="${i}" />
	</c:forEach>
	
	<c:forEach items="${packageNameList }" value="test">
		<c:out value="${test.com_skt_tlife }" />
	</c:forEach>
</body>
</html>