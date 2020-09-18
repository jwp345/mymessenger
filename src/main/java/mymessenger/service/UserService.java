package mymessenger.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import mymessenger.repository.UserRepository;

import mymessenger.vo.UserVo;

@Service
public class UserService {

	@Autowired
	private UserRepository userRepository;
	
	public void join(UserVo userVo) {
		userRepository.register(userVo);
	}
	
	public UserVo getUser(UserVo vo) {
		return userRepository.findByID(vo);
	}

}
