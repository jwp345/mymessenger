package mymessenger.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import mymessenger.repository.ChatRepository;

@Service
public class ChatService {

	@Autowired
	private ChatRepository chatRepository;

	public int getUnread(String userID) {
		return chatRepository.getAllUnreadByID(userID);
	}
	
	
}
