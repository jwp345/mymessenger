<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
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
</head>
<body>
	<nav class="navbar navbar-default">
		<c:import url="/WEB-INF/views/includes/header.jsp"/>
		<div class="collapse navbar-collapse"
			id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li><a href="${pageContext.request.contextPath }/user/index">메인</a>
				<li><a href="${pageContext.request.contextPath }/user/find">친구찾기</a></li>	
			</ul>
			<c:if test='${result eq "fail" }'>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown"><a href="#" class="dropdown-toggle"
					data-toggle="dropdown" role="button" aria-haspopup="true"
					aria-expanded="false">접속하기<span class="caret"></span>
				</a>
					<ul class="dropdown-menu">
						<li class="active"><a href="${pageContext.request.contextPath }/user/login">로그인</a></li>
						<li><a href="${pageContext.request.contextPath }/user/join">회원가입</a></li>
					</ul></li>
			</ul>
			</c:if>
		</div>
	</nav>
	<div class="container">
		<form method="post" action="${pageContext.request.contextPath }/user/auth">
			<table class="table table-boarded table-hover" style="text-align: center; border: 1px solid #dddddd">
				<thead>
					<tr>
						<th colspan="2"><h4>로그인 양식</h4></th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td style="width: 110px;"><h5>아이디</h5></td>
						<td><input class="form-control" type="text" name="userID" maxlength="20" placeholder="아이디를 입력하세요."></td>
					</tr>
					<tr>
						<td style="width: 110px;"><h5>비밀번호</h5></td>
						<td><input class="form-control" type="password" name="userPassword" maxlength="20" placeholder="비밀번호를 입력하세요."></td>
					</tr>
					<tr>
						<td style="text-align: left;" colspan="2"><input class="btn btn-primary pull-right" type="submit" value="로그인"> 
					</tr>
				</tbody>
			</table>
		</form>
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
</body>
</html>