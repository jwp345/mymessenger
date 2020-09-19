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
		function findFunction() {
			var userID = $('#findID').val();
			$.ajax({
				type: "GET",
				url: '${pageContext.request.contextPath }/api/user/UserCheck?userID=' + userID,
				data: "",
				dataType: "json",
				success: function(response) {
					if(response.data == 1){
						$('#checkMessage').html('친구찾기에 성공했습니다.');
						$('#checkType').attr('class', 'modal-content panel-success');
						getFriend(userID);
					} else {
						$('#checkMessage').html('친구를 찾을 수 없습니다.');
						$('#checkType').attr('class', 'modal-content panel-warning');
						failFriend();
					}
					$('#checkModal').modal("show");
				}
			});
		}
		function getFriend(findID) {
			$('#friendResult').html('<thead>' +
					'<tr>' +
					'<th><h4>검색 결과</h4></th>' +
					'</tr>' +
					'</thead>' +
					'<tbody>' +
					'<tr>' +
					'<td style="text-align: center;"><h3>' + findID + '</h3><a href="{pageContext.request.contextPath }/chat/chat?toID=' + encodeURIComponent(findID) + '" class="btn btn-primary pull-right">' + '메시지 보내기</a></td>' + 
					'</tr>' +
					'</tbody>');
		}
		function failFriend() {
			$('#friendResult').html('');
		}
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
	</script>
</head>
<body>
	<nav class="navbar navbar-default">
		<c:import url="/WEB-INF/views/includes/header.jsp"/>
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li class="active"><a href="${pageContext.request.contextPath }">메인</a>
				<li><a href="${pageContext.request.contextPath }/user/find">친구찾기</a></li>
				<li><a href="${pageContext.request.contextPath }/chat/box">메시지함<span id="unread" class="label label-info"></span></a></li>
			</ul>
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
		</div>
	</nav>
	<div class="container">
		<table class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd">
			<thead>
				<tr>
					<th colspan="2"><h4>검색으로 친구찾기</h4></th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td style="width: 110px;"><h5>친구 아이디</h5></td>
					<td><input class="form-control" type="text" id="findID" maxlength="20" placeholder="찾을 아이디를 입력하세요."></td>
				</tr>
				<tr>
					<td colspan="2"><button class="btn btn-primary pull-right" onclick="findFunction();">검색</button>
				</tr>
			</tbody>
		</table>
	</div>
	<div class="container">
		<table id="friendResult" class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd;">
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
	<div class="modal fade" id="checkModal" tabindex="-1" role="dialog" aria-hidden="true">
		<div class="vertical-alignment-helper">
			<div class="modal-dialog vertical-align-center">
				<div id="checkType" class="modal-content panel-info">
					<div class="modal-header panel-heading">
						<button type="button" class="close" data-dismiss="modal">
							<span aria-hidden="true">&times;</span> <span class="sr-only">Close</span>
						</button>
						<h4 class="modal-title">확인 메시지</h4>
					</div>
					<div id="checkMessage" class="modal-body">
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-primary" data-dismiss="modal">확인</button>
					</div>
				</div>
			</div>
		</div>
	</div>
	<c:if test="${not empty authUser }">
		<script type="text/javascript">
			$(document).ready(function() {
					getUnread();
					getInfiniteUnread();
				});
		</script>
	</c:if>
</body>
</html>