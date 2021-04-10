package com.example.demo;

import org.apache.catalina.Wrapper;
import org.apache.tomcat.util.descriptor.web.SecurityCollection;
import org.apache.tomcat.util.descriptor.web.SecurityConstraint;
import org.springframework.boot.web.embedded.tomcat.TomcatContextCustomizer;
import org.springframework.boot.web.embedded.tomcat.TomcatServletWebServerFactory;
import org.springframework.boot.web.server.WebServerFactoryCustomizer;
import org.springframework.context.annotation.Configuration;

//tomcat war 배포시 초기 jsp 로딩에 4초이상 걸리는 현상 해결
//https://javacan.tistory.com/entry/Turn-off-JSP-modification-check-of-embedded-tomcat-in-executable-war-of-spring-boot

//위에 것은 spring boot 1.0이고 아래가 spring boot 2.0이다.
//https://leehyunguu.github.io/2020/09/04/spring_boot_embedded_tomcat_config/


@Configuration
public class EmbeddedTomcatConfig implements WebServerFactoryCustomizer<TomcatServletWebServerFactory> {

    @Override
    public void customize(TomcatServletWebServerFactory factory) {
        TomcatContextCustomizer tomcatContextCustomizer = context -> {
            SecurityConstraint securityConstraint = new SecurityConstraint();
            securityConstraint.setDisplayName("Forbidden");
            securityConstraint.setAuthConstraint(true);
            SecurityCollection securityCollection = new SecurityCollection();
            securityCollection.addPattern("/*");
            securityCollection.addMethod("PUT");
            securityCollection.addMethod("DELETE");
            securityCollection.addMethod("TRACE");
            securityCollection.addMethod("OPTIONS");
            securityCollection.setName("Forbidden");
            securityConstraint.addCollection(securityCollection);
            context.addConstraint(securityConstraint);

            //Wrapper defaultServlet = (Wrapper) context.findChild("default");
            //defaultServlet.addInitParameter("readonly", "true");

            Wrapper jsp = (Wrapper) context.findChild("jsp");
            jsp.addInitParameter("development", "false");   //이거 해보자.  개발에서는 true로  실서버에서는 false로 해야한다는 이야기가 있다. 그런데 개발은 4초 안걸리는데??  
                                                            //일단 false로 하고 나중에 확실해지면 application.yaml로 빼자
        };
        factory.addContextCustomizers(tomcatContextCustomizer);
    }
}