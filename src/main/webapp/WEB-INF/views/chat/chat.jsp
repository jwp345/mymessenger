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
			function autoClosingAlert(selector, delay){
				var alert = $(selector).alert();
				alert.show();
				window.setTimeout(function() { alert.hide() }, delay);
			}
			function submitFunction() {
				var chatContent = $('#chatContent').val();
				if(chatContent == ""){
					return;
				}
				$.ajax({
					type: "POST",
					url: '${pageContext.request.contextPath }/chat/Submit?toID=' + "${toID }" ,
					data: {chatContent : chatContent},
					dataType: "json",
					success: function(result) {
						if(result == 1){
							autoClosingAlert('#successMessage', 2000);
						} else if (result == 0) {
							autoClosingAlert('#dangerMessage', 2000);
						} else {
							autoClosingAlert('#warningMessage', 2000);
						}
					}
				});
				$('#chatContent').val('');	
			}
			var lastID = 0;
			
			function chatListFunction(type) { // type 파라미터가 의미하는것?
				$.ajax({
					type : "POST",
					url : "${pageContext.request.contextPath }/chat/chatList?toID=" + "${toID }",
					data: {listType : type}, 
					dataType: "json",
					success : function(data) {
						if (data == "") return;
						var parsed = JSON.parse(data);
						var result = parsed.result;
						for (var i = 0; i < result.length; i++) {
							if(result[i][0].value == "${authUser.userID }") {
								result[i][0].value = '나';
							}
							addChat(result[i][0].value, result[i][2].value, result[i][3].value);
						}
						lastID = Number(parsed.last);
					}
				});
			}
			
			function addChat(chatName, chatContent, chatTime){
				$('#chatList').append('<div class ="row">' +
						'<div class="col-lg-12">' + 
						'<div class="media">' +
						'<a class="pull-left" href="#">' +
						'<img class="media-object img-circle" style="width:30px;height:30px" src="${pageContext.servletContext.contextPath }/assets/images/icon.png" alt="">' +
						'</a>' +
						'<div class="media-body">' +
						'<h4 class="media-heading">' +
						chatName +
						'<span class="small pull-right">' +
						chatTime +
						'</span>' +
						'</h4>' +
						'<p>' +
						chatContent +
						'</p>' +
						'</div>' +
						'</div>' +
						'</div>' +
						'</div>' +
						'<hr>');
				$('#chatList').scrollTop($('#chatList')[0].scrollHeight);
			}
			function getInfiniteChat() {
				setInterval(function() {
					chatListFunction(lastID);
				}, 3000);
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
		<div class="collapse navbar-collapse"
			id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li><a href="${pageContext.request.contextPath }">메인</a>
				<li><a href="${pageContext.request.contextPath }/user/find">친구찾기</a></li>
				<li><a href="${pageContext.request.contextPath }/chat/box">메시지함<span id="unread" class="label label-info"></span></a></li>			
			</ul>
			<c:if test='${not empty authUser }'>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown"><a href="#" class="dropdown-toggle"
					data-toggle="dropdown" role="button" aria-haspopup="true"
					aria-expanded="false">회원관리<span class="caret"></span>
				</a>
					<ul class="dropdown-menu">
						<li><a href="${pageContext.request.contextPath }/user/logout">로그아웃</a></li>
					</ul></li>
			</ul>
		</c:if>
		</div>
	</nav>
	<div class="container bootstrap snippet">
		<div class="row">
			<div class="col-xs-12">
				<div class="portlet portlet-default">
					<div class="portlet-heading">
						<div class="portlet-title">
							<h4><i class="fa fa-circle text-green"></i>실시간 채팅창</h4>
						</div>
						<div class="clearfix"></div>
					</div>
					<div id="chat" class="panel-collapse collapse in">
						<div id="chatList" class="portlet-body chat-widget"
							style="overflow-y: auto; width: auto; height: 600px"></div>
						<div class="portlet-footer">
							<div class="row" style="height: 90px;">
								<div class="form-group col-xs-10">
									<textarea style="height: 80px;" id="chatContent"
										class="form-control" placeholder="메시지를 입력하세요." maxlength="100"></textarea>
								</div>
								<div class="form-group col-xs-2">
									<button type="button" class="btn btn-default pull-right"
										onclick="submitFunction();">전송</button>
									<div class="clearfix">
									</div>
								</div>
							</div>
						</div>
					</div>

				</div>
			</div>
		</div>
	</div>
	<div class="alert alert-success" id="successMessage"
		style="display: none;">
		<strong>메시지 전송에 성공했습니다.</strong>
	</div>
	<div class="alert alert-danger" id="dangerMessage"
		style="display: none;">
		<strong>이름과 내용을 모두 입력해주세요.</strong>
	</div>
	<div class="alert alert-warning" id="warningMessage"
		style="display: none;">
		<strong>데이터베이스 오류가 발생했습니다.</strong>
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
	<script type="text/javascript">
	$(document).ready(function(){
		getUnread();
		chatListFunction('0'); 
		getInfiniteChat();
		getInfiniteUnread();
	});
	</script>
</body>
</html>