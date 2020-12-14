package com.example.demo.user.domain;

import java.beans.ConstructorProperties;
import java.util.Collection;
import java.util.HashSet;
import java.util.Set;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import lombok.Builder;


@Builder
public class UserInfo implements UserDetails {
	/*
	private String password;

	private final String username;

	private final Set<GrantedAuthority> authorities;

	private final boolean accountNonExpired;

	private final boolean accountNonLocked;

	private final boolean credentialsNonExpired;

	private final boolean enabled;
	*/

/*  @Id  */
  private String userId;
  private String userPwd;
  private String auth;
  private String userNm;
  private String email;

  @Builder
  @ConstructorProperties({"userId", "userPwd", "auth" , "userNm" ,"email"})
  public UserInfo(String userId, String userPwd, String auth,String userNm,String email) {
    this.userId = userId;
    this.userPwd = userPwd;
    this.auth = auth;
    this.userNm =userNm;
    this.email =email;
  }
  
  public String getEmail() {
	  return email;
  }
  
  public void setEmail(String email) {
	  this.email=email;
  }
  
  public String getUserNm() {
	  return userNm;
  }
  
  public void setUserNm(String userNm) {
	  this.userNm=userNm;
  }


  // 사용자의 권한을 콜렉션 형태로 반환
  // 단, 클래스 자료형은 GrantedAuthority를 구현해야함
  @Override
  public Collection<? extends GrantedAuthority> getAuthorities() {
    Set<GrantedAuthority> roles = new HashSet<>();
    if(auth!=null) {
    	for (String role : auth.split(",")) {
    	      roles.add(new SimpleGrantedAuthority(role));
        }	
    }    
    return roles;
  }

  // 사용자의 id를 반환 (unique한 값)
  @Override
  public String getUsername() {
    return userId;
  }

  // 사용자의 password를 반환
  @Override
  public String getPassword() {
    return userPwd;
  }

  // 계정 만료 여부 반환
  @Override
  public boolean isAccountNonExpired() {
    // 만료되었는지 확인하는 로직
    return true; // true -> 만료되지 않았음
  }

  // 계정 잠금 여부 반환
  @Override
  public boolean isAccountNonLocked() {
    // 계정 잠금되었는지 확인하는 로직
    return true; // true -> 잠금되지 않았음
  }

  // 패스워드의 만료 여부 반환
  @Override
  public boolean isCredentialsNonExpired() {
    // 패스워드가 만료되었는지 확인하는 로직
    return true; // true -> 만료되지 않았음
  }

  // 계정 사용 가능 여부 반환
  @Override
  public boolean isEnabled() {
    // 계정이 사용 가능한지 확인하는 로직
    return true; // true -> 사용 가능
  }
}