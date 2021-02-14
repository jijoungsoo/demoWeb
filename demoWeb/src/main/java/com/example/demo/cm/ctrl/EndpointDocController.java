package com.example.demo.cm.ctrl;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Description;
import org.springframework.core.MethodParameter;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.ObjectUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.mvc.method.RequestMappingInfo;
import org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerMapping;

@Controller
public class EndpointDocController {
	/*https://since.tistory.com/23      controller에 맴핑된주소 가져오기 펌*/
	@Autowired

	private RequestMappingHandlerMapping requestMappingHandlerMapping;
	@RequestMapping(value = "/endPoints")
	public String getEndPointsInView(Model model) {
		List<Map<String, String>> pages = new ArrayList<Map<String, String>>();
		Map<RequestMappingInfo, HandlerMethod> map = requestMappingHandlerMapping.getHandlerMethods();
		for (Entry<RequestMappingInfo, HandlerMethod> elem : map.entrySet()) {
			RequestMappingInfo key = elem.getKey();
			HandlerMethod method = elem.getValue();
			Map<String, String> item = new HashMap<String, String>();
			if( !ObjectUtils.isEmpty(key.getPatternsCondition().getPatterns().toArray()[0])) {
				item.put("path",(key.getPatternsCondition().getPatterns().toArray()[0]).toString() );	
			}
			item.put("http_method", key.getMethodsCondition().toString());
			item.put("consumes", key.getConsumesCondition().toString());
			item.put("produces", key.getProducesCondition().toString());
			item.put("cls", method.getMethod().getDeclaringClass().getSimpleName());
			item.put("method", method.getMethod().getName());
			Description desc = method.getMethodAnnotation(Description.class);
			if (desc != null) {
				item.put("desc", desc.value());
			}
			StringBuffer sb = new StringBuffer();
			for (MethodParameter param : method.getMethodParameters()) {
				sb.append(param.getParameterType().getSimpleName()).append(", ");
			}
			if (sb.toString().length() > 0) {
				item.put("param", sb.toString().substring(0, sb.toString().length() - 2));
			} else {
				item.put("param", "");
			}
			if(method.getMethod().getReturnType().getSimpleName() !=null ) {
				item.put("rtn", method.getMethod().getReturnType().getSimpleName());
			}

			pages.add(item);
		}
		model.addAttribute("pages", pages);
		return "/endPoints";
	}
}