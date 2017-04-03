<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>jenkins trigger test</title>

<%
	request.setCharacterEncoding("utf-8");
	String status = request.getParameter("result");
%>
<style type="text/css">
body {
	padding-top: 240px; 
	padding-left: 650px;
}
</style>
<script type="text/javascript" src="http://ajax.aspnetcdn.com/ajax/jQuery/jquery-1.6.4.min.js"></script>
<script src='//rawgit.com/tuupola/jquery_chained/master/jquery.chained.min.js'></script>
<script type="text/javascript">
	function sendToJenkins()
	{
		if($("#showStatus").find("text").css("color")=="rgb(255, 0, 0)") //building
		{
			alert("현재 빌드중입니다.");
		}
		else
		{
			var frm = document.paramsForm;
			var menu = $("#selMenu option:selected").text();
			var state = $("#selServerState option:selected").text();
			frm.params.value = "?menu="+menu+"&state="+state;
			
			$.ajax({
				type: 'post' , 
				url: 'startToBuild.jsp' ,
				data: {params:encodeURI(frm.params.value)} ,
				dataType : 'text' , 
				success: function(data) {
					//ajaxAction(); //$("#showStatus").html(data);
					alert(menu+":"+state+" 빌드 시작");
				}
			});
			
			$("#button").attr("disabled",true);
			setTimeout(function(){
				$("#button").attr("disabled", false);
			}, 15000);
		}
	}
	
	function ajaxAction()
	{
		$.ajax({
			type: 'post' , 
			url: 'startToBuild.jsp' , 
			dataType : 'html' , 
			success: function(data) {
				$("#showStatus").html(data); 
			} 
		});
	}
	
	$(document).ready(function()
	{
		ajaxAction();
		setInterval("ajaxAction()", 10000);
	});
	
	/* window.onload = function() 
	{
		ajaxAction();
		setInterval("ajaxAction()", 10000);
	}; */
</script>
</head>
<body>
	<form name="paramsForm">
		<input type="hidden" name="params" value="">
	</form>
	<div>
		<h1 style="padding-left: 68px;">Jenkins Trigger</h1>
	</div>
	<div id="selectboxDiv" style="float: left; margin: 5px;">
		<select name="selMenu" id="selMenu" style="width: 110px; height: 30px;">
			<option value="API">API 자동화</option>
			<option value="UI">UI 자동화</option>
		</select>
		<select name="selServerState" id="selServerState" style="width: 110px; height: 30px;">
			<option class="API" value="상용">상용 서버</option>
			<option class="API" value="준상용">준상용 서버</option>
			<option class="UI" value="준상용">상용 빌드</option>
			<option class="UI" value="준상용">개발 빌드</option>
		</select>
		
		<input type="button" id="button" value="RUN" onclick="javascript:sendToJenkins();" style="margin: 15px; width: 110px; height: 30px;">
	</div>
<!-- 	<input type="button" value="RUN" onclick="javascript:sendToJenkins()" style="float: left; margin-right: 5px;"> -->
	
	<br/>
	<br/>
	<br/>
	<div id="showStatus" style="width: 280px; height: 60px; margin: 25px; align: center;">
	
	</div>
	
	
<script type="text/javascript">
	$("#selServerState").chained("#selMenu");
</script>
</body>
</html>