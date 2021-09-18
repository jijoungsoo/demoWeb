package com.example.demo.utils;

import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.Map;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class TokenUtil {
    private String KEY = "AABBCC";
    private static TokenUtil m;

    public static TokenUtil getInstance() {
        if (m == null) {
            m = new TokenUtil();
        }
        return m;
    }

    public String createToken(Map<String, Object> claims) throws UnsupportedEncodingException {
        Map<String, Object> headers = new HashMap<>();
        headers.put("typ", "JWT");
        headers.put("alg", "H256");

        Long expiredDuration = 1000 * 60 * 60 * 24 * 31L; // 토큰 유효시간 (24시간 *31일)

        java.util.Date expiredTime = new java.util.Date();
        expiredTime.setTime(expiredTime.getTime() + expiredDuration);

        String token = "";
        try {
            token = Jwts.builder().setHeader(headers).setClaims(claims).setSubject("auth").setExpiration(expiredTime)
                    .signWith(SignatureAlgorithm.HS256, KEY.getBytes("UTF-8")).compact();

        } catch (Exception e) {
            throw e;
        }
        log.info("@@@@@@@@@@@@@@@token@@@@@@@@@@@@@@@ " + token);
        return token;
    }

    public Claims verifyToken(String token) throws UnsupportedEncodingException {
        Claims claims = null;
        try {
            claims = Jwts.parser().setSigningKey(KEY.getBytes("UTF-8")).parseClaimsJws(token).getBody();
        } catch (ExpiredJwtException e) {
            throw e;
        }
        return claims;
    }

    public Map<String, Object> getClaims(String token) throws UnsupportedEncodingException {
        return this.verifyToken(token);
    }
}
