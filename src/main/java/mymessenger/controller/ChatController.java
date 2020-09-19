package mymessenger.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import mymessenger.security.Auth;
import mymessenger.service.ChatService;

@Controller
@RequestMapping("/chat")
public class ChatController {
	@Autowired
	private ChatService chatService;
	
	@Auth
	@RequestMapping(value="/chat")
	public String chat() {
		return "/chat/chat";
	}
	
	@Auth
	@RequestMapping(value="/box")
	public String box() {
		return "/chat/box";
	}
}
