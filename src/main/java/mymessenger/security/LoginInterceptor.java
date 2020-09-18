package mymessenger.security;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import mymessenger.service.UserService;
import mymessenger.vo.UserVo;

public class LoginInterceptor extends HandlerInterceptorAdapter {

	@Autowired
	private UserService userService;
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		
		String userID = request.getParameter("userID");
		String password = request.getParameter("userPassword");
		
		UserVo vo = new UserVo();
		vo.setUserID(userID);
		vo.setUserPassword(password);
	
		UserVo authUser = userService.getUser(vo);
		if(authUser == null) {
			request.setAttribute("result", "fail");
			request.setAttribute("message", "아이디나 비밀번호가 다릅니다.");
			request.getRequestDispatcher("/WEB-INF/views/user/login.jsp").forward(request, response);
			return false;
		}
		
		else {
			request.setAttribute("result", "success");
			request.setAttribute("message", "로그인에 성공했습니다.");
		}
		// session 처리
		HttpSession session =request.getSession(true);
		session.setAttribute("authUser", authUser);
		
		response.sendRedirect(request.getContextPath());
		return false;
	}

}
