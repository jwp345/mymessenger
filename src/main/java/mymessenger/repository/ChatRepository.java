package mymessenger.repository;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class ChatRepository {

	@Autowired
	private SqlSession sqlSession;

	public int getAllUnreadByID(String userID) {
		int num = sqlSession.selectOne("chat.getAllUnreadByID", userID);
		return num;
	}
}
