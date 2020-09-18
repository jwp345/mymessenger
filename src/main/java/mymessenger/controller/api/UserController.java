package mymessenger.controller.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import mymessenger.dto.JsonResult;
import mymessenger.security.Auth;
import mymessenger.security.AuthUser;
import mymessenger.service.ChatService;
import mymessenger.vo.UserVo;

@Controller("userAPIController")
@RequestMapping("/api/user")
public class UserController {
	@Autowired
	private ChatService chatService;
	
	@ResponseBody
	@Auth
	@RequestMapping("/chatUnread")
	public JsonResult checkUnread(@AuthUser UserVo authUser) {
			
		String userID = "";
		if(authUser.getUserID() != null)
			userID = authUser.getUserID();
		
		int num = chatService.getUnread(userID);
		return JsonResult.success(num);
	}
}
