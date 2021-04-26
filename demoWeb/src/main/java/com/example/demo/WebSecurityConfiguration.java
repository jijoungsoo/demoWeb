package com.example.demo;

import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

import com.example.demo.security.login.CustomAuthenticationFailureHandler;
import com.example.demo.security.login.CustomAuthenticationProvider;
import com.example.demo.security.login.CustomAuthenticationSuccessHandler;
import com.example.demo.security.login.CustomLogoutSuccessHandler;
import com.example.demo.security.oauth2.CustomOAuth2Provider;
import com.example.demo.security.oauth2.CustomOAuth2UserService;
import com.example.demo.security.oauth2.SocialType;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.security.oauth2.client.OAuth2ClientProperties;
import org.springframework.boot.web.servlet.ServletListenerRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.builders.WebSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.config.oauth2.client.CommonOAuth2Provider;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.oauth2.client.registration.ClientRegistration;
import org.springframework.security.oauth2.client.registration.ClientRegistrationRepository;
import org.springframework.security.oauth2.client.registration.InMemoryClientRegistrationRepository;
import org.springframework.security.web.session.HttpSessionEventPublisher;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

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
	

 // AuthenticationSuccessHandler 등록
/*로그인 처리 json 응답을 위해서 
 * https://jungeunlee95.github.io/java/2019/07/18/8-Spring-Security-ajax-%EB%A1%9C%EA%B7%B8%EC%9D%B8%ED%9B%84-json%EC%9D%91%EB%8B%B5%EB%B0%9B%EA%B8%B0/
 * */
	@Autowired
	private CustomAuthenticationSuccessHandler customUrlAuthenticationSuccessHandler;
	
	@Autowired
	private CustomAuthenticationFailureHandler  customAuthenticationFailureHandler;
	
	@Autowired
	private CustomLogoutSuccessHandler  customLogoutSuccessHandler;

	
	@Autowired   /*인증모듈 비교*/
	CustomAuthenticationProvider customAuthenticationProvider;

	  @Bean 
	  public PasswordEncoder passwordEncoder() { // 4
	    return new BCryptPasswordEncoder();
	  }
	
	 @Override
	    public void configure(WebSecurity web) throws Exception
	    {
	        // static 디렉터리의 하위 파일 목록은 인증 무시 ( = 항상통과 )
	        //web.ignoring().antMatchers("/css/**", "/js/**", "/img/**", "/lib/**");
		 	web.ignoring().antMatchers("/src/**")
		 	.antMatchers("/webjars/**")
			.antMatchers("/ACTOR_IDX_PF_IMG/**");	//첨부파일 인증무시
		 	
		 	
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
	                .antMatchers("/login","/doLogin","/signup","/user"
					, "/oauth2/**"
					,"/login/oauth2/**"
					,"/login/oauth2/code/naver"
					
					
					).permitAll()  //누구나 접근 가능
					.antMatchers("/facebook").hasAuthority(SocialType.FACEBOOK.getRoleType()) 
					.antMatchers("/google").hasAuthority(SocialType.GOOGLE.getRoleType()) 
					.antMatchers("/kakao").hasAuthority(SocialType.KAKAO.getRoleType()) 
					.antMatchers("/naver").hasAuthority(SocialType.NAVER.getRoleType())
	                .anyRequest().authenticated()    //*권한의 종료에 상관 없이 권한이 있어야 접근가능*//
	            .and() 
	              .formLogin() // 로그인 설정
	                .loginPage("/login")   /*로그인 페이지*/
	                .successHandler(customUrlAuthenticationSuccessHandler)
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
	                .logoutSuccessHandler(customLogoutSuccessHandler)  /*로그아웃 핸들러 !! */
	                //.logoutSuccessUrl("/user/logout/result")  /*로그아웃 성공 후 리다이렉트 주소 */
	                .invalidateHttpSession(true)     /*로그아웃 성공시 세션 날리기 */
	            .and()
	                // 403 예외처리 핸들링
	                .exceptionHandling().accessDeniedPage("/user/denied")
				.and() 
					.oauth2Login()
					.loginPage("/login")
					.defaultSuccessUrl("/")
					.failureUrl("/gogo")
					.userInfoEndpoint()
					.userService(new CustomOAuth2UserService())
					;
//                .and()
//	            	.csrf().disable();  /*csrf꺼보자.  -- 이거끄면 post 전송이 잘된다. html 응답받는 !! */
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

	        //auth.userDetailsService(userService).passwordEncoder(passwordEncoder());
	    	auth.authenticationProvider(customAuthenticationProvider);
			/* formLogin의 경우만 생각했는데 
			   소셜인증일때 어떻게 구분지을수있을까?
				소셜일때 안타는데...
			
			*/
	    	
	        
	    }

		
		@Bean
		public ClientRegistrationRepository clientRegistrationRepository(
				OAuth2ClientProperties oAuth2ClientProperties,
				@Value("${custom.oauth2.kakao.client-id}") String kakaoClientId,
				@Value("${custom.oauth2.kakao.client-secret}") String kakaoClientSecret,
				@Value("${custom.oauth2.naver.client-id}") String naverClientId,
				@Value("${custom.oauth2.naver.client-secret}") String naverClientSecret) {
			List<ClientRegistration> registrations = oAuth2ClientProperties
					.getRegistration().keySet().stream()
					.map(client -> getRegistration(oAuth2ClientProperties, client))
					.filter(Objects::nonNull)
					.collect(Collectors.toList());
	
			registrations.add(CustomOAuth2Provider.KAKAO.getBuilder("kakao")
						.clientId(kakaoClientId)
						.clientSecret(kakaoClientSecret)
						.jwkSetUri("temp")
						.build());
	
			registrations.add(CustomOAuth2Provider.NAVER.getBuilder("naver")
					.clientId(naverClientId)
					.clientSecret(naverClientSecret)
					.jwkSetUri("temp")
					.build());
			return new InMemoryClientRegistrationRepository(registrations);
		}
	
		private ClientRegistration getRegistration(OAuth2ClientProperties clientProperties, String client) {
			if("google".equals(client)) {
				OAuth2ClientProperties.Registration registration = clientProperties.getRegistration().get("google");
				return CommonOAuth2Provider.GOOGLE.getBuilder(client)
						.clientId(registration.getClientId())
						.clientSecret(registration.getClientSecret())
						.scope("email", "profile")
						.build();
			}
	
			if("facebook".equals(client)) {
				OAuth2ClientProperties.Registration registration = clientProperties.getRegistration().get("facebook");
				return CommonOAuth2Provider.FACEBOOK.getBuilder(client)
						.clientId(registration.getClientId())
						.clientSecret(registration.getClientSecret())
						.userInfoUri("https://graph.facebook.com/me?fields=id,name,email,link")
						.scope("email")
						.build();
			}
	
			return null;
		}

		//http://dveamer.github.io/backend/PreventDuplicatedLogin.html
		/*
		<listener>
		<listener-class>org.springframework.security.web.session.HttpSessionEventPublisher</listener-class>
		</listener>
		SessionCreateListener.java
		SessionDestoryListener.java
		가 구동되려면 아래 것을 적어줘야한다.
		*/
		@Bean
		public ServletListenerRegistrationBean<HttpSessionEventPublisher> httpSessionEventPublisher() {
			return new ServletListenerRegistrationBean<HttpSessionEventPublisher>(new HttpSessionEventPublisher());
		}
}