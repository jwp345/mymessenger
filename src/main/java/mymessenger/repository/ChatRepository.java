package mymessenger.repository;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import mymessenger.vo.ChatVo;

@Repository
public class ChatRepository {

	@Autowired
	private SqlSession sqlSession;

	public int getAllUnreadByID(String userID) {
		int num = sqlSession.selectOne("chat.getAllUnreadByID", userID);
		return num;
	}

	public List<ChatVo> getBox(String userID) {
		return sqlSession.selectList("chat.getBox", userID);
	}

	public int getUnreadChat(String fromID, String userID) {
		ChatVo vo = new ChatVo();
		vo.setFromID(fromID);
		vo.setToID(userID);
		return sqlSession.selectOne("chat.getUnreadChat", vo);
	}
}
