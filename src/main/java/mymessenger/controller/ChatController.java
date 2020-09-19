package mymessenger.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import mymessenger.security.Auth;
import mymessenger.security.AuthUser;
import mymessenger.service.ChatService;
import mymessenger.vo.ChatVo;
import mymessenger.vo.UserVo;

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
	@RequestMapping(value="/chat", method=RequestMethod.GET)
	public String chat(
			@RequestParam(value="toID", required=true, defaultValue = "") String toID, Model model) {
		
		model.addAttribute(toID);
		return "/chat/chat";
	}
	
	@Auth
	@RequestMapping(value="/box")
	public String box() {
		return "/chat/box";
	}
	
	@ResponseBody
	@Auth
	@RequestMapping("/chatBox")
	public String chatBox(@AuthUser UserVo authUser) {
		
		String userID = authUser.getUserID();

		StringBuffer result = new StringBuffer("");
		result.append("{\"result\":[");

		List<ChatVo> chatList = chatService.getBox(userID);
		if(chatList.isEmpty()) return "";
		
		int size = chatList.size();
		for(int i = 0; i<size; i++)
		{
			ChatVo chat = new ChatVo();
			chat.setChatID(chatList.get(0).getChatID());
			chat.setFromID(chatList.get(0).getFromID().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
			chat.setToID(chatList.get(0).getToID().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
			chat.setChatContent(chatList.get(0).getChatContent().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
			int chatTime = Integer.parseInt(chatList.get(0).getChatTime().substring(11, 13));
			String timeType = "오전";
			if(chatTime > 12) {
				timeType = "오후";
				chatTime -= 12;
			}
			chat.setChatTime(chatList.get(0).getChatTime().substring(0, 11) + " " + timeType + " " + chatTime + ":" + chatList.get(0).getChatTime().substring(14, 16) + "");
			chatList.add(chat);
			chatList.remove(0);
		}
		for(int i = 0; i < chatList.size(); i++) {
			ChatVo x = chatList.get(i);
			for(int j =0; j < chatList.size(); j++) {
				ChatVo y = chatList.get(j);
				if(x.getFromID().equals(y.getToID()) && x.getToID().equals(y.getFromID())) {
					if(x.getChatID() < y.getChatID()) {
						chatList.remove(x);
						i--;
						break;
					} else {
						chatList.remove(y);
						j--;
					}
				}
			}
		}
		for(int i = chatList.size() - 1; i >= 0; i--) {
			String unread ="";
			if(userID.equals(chatList.get(i).getToID())) {
				unread = chatService.getUnreadChat(chatList.get(i).getFromID(), userID) + "";
				if(unread.equals("0")) unread = "";
			}
			result.append("[{\"value\": \"" + chatList.get(i).getFromID() + "\"},");
			result.append("{\"value\": \"" + chatList.get(i).getToID() + "\"},");
			result.append("{\"value\": \"" + chatList.get(i).getChatContent() + "\"},");
			result.append("{\"value\": \"" + chatList.get(i).getChatTime() + "\"},");
			result.append("{\"value\": \"" + unread + "\"}]");
			if(i != 0) result.append(",");
		}
		result.append("], \"last\":\"" + chatList.get(chatList.size() - 1).getChatID() + "\"}");
		return result.toString();
	}
}
