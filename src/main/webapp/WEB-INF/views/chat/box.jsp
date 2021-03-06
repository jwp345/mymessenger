<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" href="${pageContext.request.contextPath }/assets/css/bootstrap.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath }/assets/css/custom.css">
	<title>JSP Ajax 실시간 회원제 채팅 서비스</title>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="${pageContext.request.contextPath }/assets/js/bootstrap.js"></script>
	<script type="text/javascript">
		function getUnread() {
			$.ajax({
				type: "POST",
				url: "${pageContext.request.contextPath }/api/user/chatUnread",
				data: "",
				dataType: "json",
				success: function(response) {
					if(response.data > 0) {
						showUnread(response.data);
					} else {
						showUnread('');
					}
				}
			});
		}
		function getInfiniteUnread() {
			setInterval(function() {
				getUnread();
			}, 4000);
		}
		function showUnread(result) {
			$('#unread').html(result);
		}
		function chatBoxFunction() {
			$.ajax({
				type: "POST",
				url: "${pageContext.request.contextPath }/chat/chatBox",
				data: "",
				dataType: "json",
				success: function(data) {
					if(data == "") return;
					$('#boxTable').html('');
					var parsed = JSON.parse(data);
					var result = parsed.result;
					for(var i = 0; i < result.length; i++) {
						if(result[i][0].value == "${authUser.userID }") {
							result[i][0].value = result[i][1].value;
						} else {
							result[i][1].value = result[i][0].value;
						}
						addBox(result[i][0].value, result[i][1].value, result[i][2].value, result[i][3].value, result[i][4].value)
					}
				}
			});
		}
		function addBox(lastID, toID, chatContent, chatTime, unread) {
			$('#boxTable').append('<tr onclick="location.href=\'${pageContext.request.contextPath }/chat/chat?toID=' + toID + '\'">' +
				'<td style="width: 150px;"><h5>' + lastID + '</h5></td>' +
				'<td>' +
				'<h5>' + chatContent + 
				'<span class="label label-info">' + unread + '</span></h5>' +
				'<div class="pull-right">' + chatTime + '</div>' +
				'</td>' +
				'<tr>');
		}
		function getInfiniteBox() {
			setInterval(function() {
				chatBoxFunction();
			}, 3000);
		}
	</script>
</head>
<body>
	<nav class="navbar navbar-default">
		<c:import url="/WEB-INF/views/includes/header.jsp"/>
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li><a href="${pageContext.request.contextPath }">메인</a>
				<li><a href="${pageContext.request.contextPath }/user/find">친구찾기</a></li>
				<li class="active"><a href="${pageContext.request.contextPath }/chat/box">메시지함<span id="unread" class="label label-info"></span></a></li>
			</ul>
			<c:choose>
			<c:when test="${empty authUser }">
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">접속하기<span class="caret"></span>	
					</a>
					<ul class="dropdown-menu">
						<li><a href="${pageContext.request.contextPath }/user/login">로그인</a></li>
						<li><a href="${pageContext.request.contextPath }/user/join">회원가입</a></li>						
					</ul>
				</li>
			</ul>
			</c:when>
			<c:otherwise>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">회원관리<span class="caret"></span>
					</a>
					<ul class="dropdown-menu">
						<li><a href="${pageContext.request.contextPath }/user/logout">로그아웃</a></li>
					</ul>
				</li>
			</ul>
			</c:otherwise>
			</c:choose>	
		</div>
	</nav>
	<div class="container">
		<table class="table" style="margin: 0 auto;">
			<thead>
				<tr>
					<th><h4>주고받은 메시지 목록</h4></th>
				</tr>
			</thead>
			<div style="overflow-y: auto; width: 100%; max-height: 450px">
				<table class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd; margin: 0 auto;">
					<tbody id="boxTable">
					</tbody>
				</table>
			</div>
		</table>
	</div>
	
	<c:if test='${not empty result }'>
	<div class="modal fade" id="messageModal" tabindex="-1" role="dialog"
		aria-hidden="true">
		<div class="vertical-alignment-helper">
			<div class="modal-dialog vertical-align-center">
				<div class="modal-content 
				<c:choose>
				<c:when test='${result eq "fail" }'>
				 <p>
				 	panel-warning
				 </p>
				 </c:when>
				 <c:otherwise>
				  <p>panel-success</p>
				  </c:otherwise></c:choose>">
					<div class="modal-header panel-heading">
						<button type="button" class="close" data-dismiss="modal">
							<span aria-hidden="true">&times;</span> <span class="sr-only">Close</span>
						</button>
						<h4 class="modal-title">
							${result }
						</h4>
					</div>
					<div class="modal-body">
						${message }
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-primary" data-dismiss="modal">확인</button>
					</div>
				</div>
			</div>
		</div>
	</div>
	</c:if>
	<script>
		$('#messageModal').modal("show");
	</script>
	<c:if test="${not empty authUser }">
		<script type="text/javascript">
			$(document).ready(function() {
					getUnread();
					getInfiniteUnread();
					chatBoxFunction();
					getInfiniteBox();
				});
		</script>
	</c:if>
</body>
</html>