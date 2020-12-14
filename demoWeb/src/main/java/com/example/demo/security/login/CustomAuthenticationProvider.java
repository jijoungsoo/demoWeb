package com.example.demo.security.login;

import java.util.ArrayList;
import java.util.HashSet;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.InternalAuthenticationServiceException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Component;
import org.springframework.web.client.HttpServerErrorException;

import com.example.demo.user.domain.UserInfo;
import com.example.demo.user.domain.UserService;

@Component
public class CustomAuthenticationProvider implements AuthenticationProvider {
	/*  https://ayoteralab.tistory.com/entry/Spring-Boot-22-Spring-Security-3-Authorization?category=860804  */

	@Autowired
	UserService userService;
	
	@Override
	public Authentication authenticate(Authentication authentication) throws AuthenticationException {
		BCryptPasswordEncoder passEncoder = new BCryptPasswordEncoder();		
		String admin =passEncoder.encode("admin");
		
		String loginId = (String) authentication.getPrincipal();
		String loginPass = (String) authentication.getCredentials();
		
		System.out.println("aaaaa");
		System.out.println(admin);
		System.out.println("bbbb");
		
		System.out.println(loginId);
		System.out.println(loginPass);
		System.out.println(authentication);
		
		UserInfo ud = null;
		Boolean matchPass =null;
		try {
			ud = (UserInfo) userService.loadUserByUsername(loginId);
			
		} catch (Exception e) {
			e.printStackTrace();
			throw new InternalAuthenticationServiceException(e.getMessage());
		}
		if(ud == null) {
			throw new UsernameNotFoundException("사용자가 없거나 비밀번호가 다릅니다.[3]");  //사용자 없음
		}
		
		matchPass = passEncoder.matches(loginPass, ud.getPassword());
		
		if(!matchPass) {
			throw new UsernameNotFoundException("사용자가 없거나 비밀번호가 다릅니다.[4]");  //사용자 없음
		}
		//if(ud == null || !matchPass) return null;
		
		//권한 가져오는 로직
		HashSet<GrantedAuthority> authorities = (HashSet<GrantedAuthority>) ud.getAuthorities();
		//(principal, credentials, authorities)
		///id만 넘기면 거시기한데
		//여기에 객체를 넘기면  그걸 jsp에서 쓸수있다.
		return new UsernamePasswordAuthenticationToken(ud, loginPass, authorities);
	}

	@Override
	public boolean supports(Class<?> authentication) {
		return true;
	}
	
}