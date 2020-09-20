package mymessenger.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import mymessenger.repository.ChatRepository;
import mymessenger.vo.ChatVo;

@Service
public class ChatService {

	@Autowired
	private ChatRepository chatRepository;

	public int getUnread(String userID) {
		return chatRepository.getAllUnreadByID(userID);
	}

	public List<ChatVo> getBox(String userID) {
		return chatRepository.getBox(userID);
	}

	public int getUnreadChat(String fromID, String userID) {
		return chatRepository.getUnreadChat(fromID, userID);
	}

	public int Submit(ChatVo vo) {
		return chatRepository.Submit(vo);
	}

	public List<ChatVo> getChatListByID(ChatVo vo) {
		return chatRepository.getChatListByID(vo);
	}

	public void readChat(ChatVo vo) {
		chatRepository.readChat(vo);
		return;
	}
	
	
}
