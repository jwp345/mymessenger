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
		return "redirect:/";
	}
	
	@Auth
	@RequestMapping(value="/chat", method=RequestMethod.GET)
	public String chat(@AuthUser UserVo authUser,
			@RequestParam(value="toID", required=true, defaultValue = "") String toID, Model model) {
		
		if (toID.equals("")) {
//			model.addAttribute("result", "fail");
//			model.addAttribute("message", "대화 상대가 지정 되지 않았습니다.");
			return "redirect:/";
		} // 수정해야할 부분 redirect 처리 어케할지
		if(authUser.getUserID().equals(toID)) {
//			model.addAttribute("result", "fail");
//			model.addAttribute("message", "자기 자신에게는 쪽지를 보낼 수 없습니다.");
			return "redirect:/";
		} // 수정해야할 부분
		
		model.addAttribute("toID", toID);
		return "/chat/chat";
	}
	
	@Auth
	@RequestMapping(value="/box")
	public String box() {
		return "/chat/box";
	}

	@Auth
	@ResponseBody
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
	
	@Auth
	@ResponseBody
	@RequestMapping(value="/Submit")
	public int Submit(@AuthUser UserVo authUser,
			@RequestParam(value="toID", required=true, defaultValue = "") String toID,
			@RequestParam(value="chatContent", required=true) String chatContent) {
		
		String fromID = authUser.getUserID();
		
		ChatVo vo = new ChatVo();
		vo.setToID(toID);
		vo.setFromID(fromID);
		vo.setChatContent(chatContent);
		
		return chatService.Submit(vo);
	}
	
	@Auth
	@ResponseBody
	@RequestMapping(value="/chatList", method=RequestMethod.POST)
	public String chatList(@AuthUser UserVo authUser,
			@RequestParam(value="toID", required=true, defaultValue = "") String toID,
			@RequestParam(value="listType", required=true) String chatID) {
		String fromID = authUser.getUserID();
		
		StringBuffer result = new StringBuffer("");
		result.append("{\"result\":[");
		ChatVo vo = new ChatVo();
		vo.setChatID(Integer.valueOf(chatID));
		vo.setFromID(fromID);
		vo.setToID(toID);
		List<ChatVo> chatList = chatService.getChatListByID(vo);
		if(chatList.size() == 0) return "";
		
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
			result.append("[{\"value\": \"" + chatList.get(i).getFromID() + "\"},");
			result.append("{\"value\": \"" + chatList.get(i).getToID() + "\"},");
			result.append("{\"value\": \"" + chatList.get(i).getChatContent() + "\"},");
			result.append("{\"value\": \"" + chatList.get(i).getChatTime() + "\"}]");
			if(i != chatList.size() -1) result.append(",");
		}
		result.append("], \"last\":\"" + chatList.get(chatList.size() - 1).getChatID() + "\"}");
		chatService.readChat(vo);
		return result.toString();
	}
}
