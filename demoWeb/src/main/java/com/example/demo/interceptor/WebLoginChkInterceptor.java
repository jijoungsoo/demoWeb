package com.example.demo.interceptor;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.example.demo.utils.SessionUtil;

import org.springframework.stereotype.Service;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

@Service
public class WebLoginChkInterceptor implements HandlerInterceptor {
    // https://www.leafcats.com/40
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {
        if (SessionUtil.isLogin(request) == true) {

            return true;
        } else {
            response.sendRedirect("/login");
            return false;
        }
    }

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
            ModelAndView modelAndView) throws Exception {
    }

    private void goLoginPage(HttpServletRequest request, HttpServletResponse response) {

        try {
            response.setContentType("text/html");
            response.getWriter().write(
                    "<script>if(this==top){ document.location.href='/login' } else { top.document.location.href='/login' }</script>");
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }

    }
}
