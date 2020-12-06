package com.example.demo.security.login;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.builders.WebSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

import com.example.demo.user.domain.UserService;

import lombok.RequiredArgsConstructor;

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class WebSecurityConfiguration extends WebSecurityConfigurerAdapter {
	/*https://victorydntmd.tistory.com/328  spring security 좋은 내용  게시판 등록도 있고 참고하자 */
	/*https://xmfpes.github.io/spring/spring-security/  이것도
	 * 
	 *https://shinsunyoung.tistory.com/78   이거 대박
	 *  
	 *  */
	
	@Autowired
	private UserService userService;
	
    

 // AuthenticationSuccessHandler 등록
/*로그인 처리 json 응답을 위해서 
 * https://jungeunlee95.github.io/java/2019/07/18/8-Spring-Security-ajax-%EB%A1%9C%EA%B7%B8%EC%9D%B8%ED%9B%84-json%EC%9D%91%EB%8B%B5%EB%B0%9B%EA%B8%B0/
 * */
	@Autowired
	private AuthenticationSuccessHandler CustomUrlAuthenticationSuccessHandler;
	
	@Autowired
	private CustomAuthenticationFailureHandler  customAuthenticationFailureHandler;

	  @Bean 
	  public PasswordEncoder passwordEncoder() { // 4
	    return new BCryptPasswordEncoder();
	  }
	
	 @Override
	    public void configure(WebSecurity web) throws Exception
	    {
	        // static 디렉터리의 하위 파일 목록은 인증 무시 ( = 항상통과 )
	        //web.ignoring().antMatchers("/css/**", "/js/**", "/img/**", "/lib/**");
		 	web.ignoring().antMatchers("/src/**");
	    }

	    @Override
	    protected void configure(HttpSecurity http) throws Exception {
	    	/*
anyMatchers를 통해 경로 설정과 권한 설정이 가능합니다.
permitAll() : 누구나 접근이 가능
hasRole() : 특정 권한이 있는 사람만 접근 가능
authenticated() : 권한이 있으면 무조건 접근 가능
anyRequest는 anyMatchers에서 설정하지 않은 나머지 경로를 의미합니다.
	    	 * 
	    	 * */
	        http.authorizeRequests()
	                // 페이지 권한 설정
	                .antMatchers("/admin/**").hasRole("ADMIN")      /*해당주소는 Admin 관한이 있는 사람만 접근할수 있음*/
	                .antMatchers("/user/myinfo").hasRole("MEMBER")  /*해당주소는 MEMBER 관한이 있는 사람만 접근할수 있음*/
	                //.antMatchers("/**").permitAll()   /*나머지는 모두 허용 -- 좋아보이지 않는다.*/
	                .antMatchers("/login","/doLogin","/signup","/user").permitAll()  //누구나 접근 가능	                
	                .anyRequest().authenticated()    //*권한의 종료에 상관 없이 권한이 있어야 접근가능*//
	            .and() 
	              .formLogin() // 로그인 설정
	                .loginPage("/login")   /*로그인 페이지*/
	                .successHandler(CustomUrlAuthenticationSuccessHandler)
	                .failureHandler(customAuthenticationFailureHandler)
	                .loginProcessingUrl("/doLogin")   /*로그인을 처리할 페이지  ajax호출을 당할 주소  /login에서 사용  
	                    
	                    참고 
	                    https://jungeunlee95.github.io/java/2019/07/18/8-Spring-Security-ajax-%EB%A1%9C%EA%B7%B8%EC%9D%B8%ED%9B%84-json%EC%9D%91%EB%8B%B5%EB%B0%9B%EA%B8%B0/
	                 *
	                 */
	                .usernameParameter("userId")      /*파라미터 변경  username => userId로 받는다.*/
	                .passwordParameter("userPwd")      /*파라미터 변경  password => userPwd로 받는다.*/
	                //.defaultSuccessUrl("/user/login/result")  /*로그인 성공후 리다이렉트 주소 */
	                .permitAll()
	            .and() 
	              .logout() // 로그아웃 설정
	                .logoutRequestMatcher(new AntPathRequestMatcher("/user/logout"))  /*로그아웃 주소 */
	                .logoutSuccessUrl("/user/logout/result")  /*로그아웃 성공 후 리다이렉트 주소 */
	                .invalidateHttpSession(true)     /*로그아웃 성공시 세션 날리기 */
	            .and()
	                // 403 예외처리 핸들링
	                               .exceptionHandling().accessDeniedPage("/user/denied");
	    }

	    @Override
	    public void configure(AuthenticationManagerBuilder auth) throws Exception {
/*
로그인할 때 필요한 정보를 가져오는 곳입니다.
유저 정보를 가져오는 서비스를 userService (아직 만들어지지 않음)으로 지정합니다.
패스워드 인코더는 아까 빈으로 등록해놓은 passwordEncoder()를 사용합니다. (BCrypt)
	    	 * 
	    	 * */
/*JPA 모듈을 따로 만들었는데 로그인때문에 USER클래스는 여기서 세로 만들어야겠다.
 * CmUser
*/	    	
	        auth.userDetailsService(userService).passwordEncoder(passwordEncoder());
	        
	    }
}