package mymessenger.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import mymessenger.security.Auth;
import mymessenger.service.UserService;
import mymessenger.vo.UserVo;

@Controller
@RequestMapping("/user")
public class UserController {
	@Autowired
	private UserService userService;
	
	@RequestMapping(value="/join")
	public String join() {
		return "user/join";
	}

	@RequestMapping(value="/join", method=RequestMethod.POST)
	public String join(UserVo userVo) {
		userService.join(userVo);
		return "redirect:/";
	}
	
	@RequestMapping(value="/login")
	public String login() {
		return "user/login";
	}
	
	@Auth
	@RequestMapping(value="/find")
	public String find() {
		return "user/find";
	}
}