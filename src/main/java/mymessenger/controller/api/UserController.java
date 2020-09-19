package mymessenger.controller.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import mymessenger.dto.JsonResult;
import mymessenger.security.Auth;
import mymessenger.security.AuthUser;
import mymessenger.service.ChatService;
import mymessenger.service.UserService;
import mymessenger.vo.UserVo;

@Controller("userAPIController")
@RequestMapping("/api/user")
public class UserController {
	@Autowired
	private ChatService chatService;
	@Autowired
	private UserService userService;
	
	@ResponseBody
	@Auth
	@RequestMapping("/chatUnread")
	public JsonResult chatUnread(@AuthUser UserVo authUser) {
			
		String userID = "";
		if(authUser.getUserID() != null)
			userID = authUser.getUserID();
		
		int num = chatService.getUnread(userID);
		return JsonResult.success(num);
	}
	
	@ResponseBody
	@RequestMapping("/UserCheck")
	public JsonResult UserCheck(
			@RequestParam(value="userID", required=true, defaultValue = "") String userID) {
		
		int num = userService.findByID(userID);
		return JsonResult.success(num);
	}
}
