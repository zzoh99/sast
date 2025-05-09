package com.hr.common.dao;

import com.hr.common.logger.Log;
import com.nhncorp.lucy.security.xss.XssPreventer;
import org.jsoup.Jsoup;
import org.jsoup.safety.Safelist;

import java.sql.Clob;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class MapDto extends HashMap<Object, Object> {

	private static final long serialVersionUID = -1;

	@Override
    public Object put(Object key, Object value) {
		boolean isClob = false;
		if (value instanceof Clob) {
			isClob = true;
			Clob clob = (Clob) value;
			try {
				value = clob == null ? null : clob.getSubString(1, (int) clob.length());
			} catch (SQLException e) {
				Log.Debug(e.getLocalizedMessage());
			}
		}

		value = value == null ? "" : value;
		if (value instanceof String)
			value = XssPreventer.unescape((String) value);

		if(isClob && key.toString().equalsIgnoreCase("contents")) {
			value = XssPreventer.unescape((String) value);
			// Clob 형식의 contents 항목에 대해 HTML태그를 제외한 XSS 공격 가능한 태그를 다시 escape 처리.
			// lucy filter는 unclosed tag가 포함된 코드에는 제대로 적용되지 않아 Jsoup 사용함.
			// Safelist를 사용하여 텍스트와 모든 HTML 태그만 허용한다.
			// Safelist 설정: base64 인코딩된 이미지 src 와 style 속성 허용
			// 만약 추가할 태그나 속성이 있으면 아래에 추가하도록 한다.
			Safelist safelist = Safelist.relaxed()
					.addTags("figcaption")
					.addAttributes(":all", "class", "style") // 모든 태그에 class 및 style 속성 허용
					.addAttributes("figure", "style") // figure 태그의 style 속성 허용
					.addAttributes("img", "src", "alt", "style", "height", "width") // img 태그의 src, alt, style, height, width 속성 허용
					.addAttributes("a", "target") // a 태그의 target 속성 허용
					.addAttributes("ol", "reversed") // ol 태그의 reversed 속성 허용
					.addAttributes("label", "class") // label 태그의 class 속성 허용
					.addAttributes("input", "type", "checked") // input 태그의 type, checked 속성 허용
					.addProtocols("img", "src", "http", "https", "data"); // img 태그의 src 속성에 대해 data 프로토콜 허용

			value = Jsoup.clean(value.toString(), safelist);
		} else if(isClob && key.toString().equalsIgnoreCase("configInfo")) {
			value = XssPreventer.unescape((String) value);
		}

		if(key != null && !key.equals(""))
            return super.put(toCamelCase(key.toString()), value);
        else
            return super.put(key, value);
    }

    static String toCamelCase(String s) {
    	String camelCasePattern = "([a-z]+[A-Z]+\\w+)+";
    	if (!s.matches(camelCasePattern)) {
    		s = s.toLowerCase();
    		Matcher m = Pattern.compile("[_|-](\\w)").matcher(s);
            StringBuffer sb = new StringBuffer();
            while (m.find()) {
                m.appendReplacement(sb, m.group(1).toUpperCase());
            }
            s = m.appendTail(sb).toString();
    	} 
    	return s;
    }

}
