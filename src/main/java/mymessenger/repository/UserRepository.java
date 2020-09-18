package mymessenger.repository;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import mymessenger.vo.UserVo;

@Repository
public class UserRepository {
	@Autowired
	private SqlSession sqlSession;
	
	public boolean register(UserVo vo) {
		int count = sqlSession.insert("user.register", vo);
		return count == 1;
	}	

	public boolean update(UserVo vo) {
		int count = sqlSession.update("user.update", vo);
		return count == 1;
	}

	public UserVo getUser(UserVo vo) {
		return sqlSession.selectOne("user.getUser", vo);
	}

	public int findByID(String userID) {
		int num = sqlSession.selectOne("user.findByID", userID);
		return num;
	}
}