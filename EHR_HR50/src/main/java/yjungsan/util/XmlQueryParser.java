package yjungsan.util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.xml.sax.InputSource;
import org.xml.sax.XMLReader;

import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;
import java.io.File;
import java.io.FileInputStream;
import java.util.Map;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class XmlQueryParser {

	private static final Logger log = LoggerFactory.getLogger(XmlQueryParser.class);

	private XmlQueryParser() {
		throw new IllegalStateException("XmlQueryParser class");
	}

	/* 호출부에서 try~catch 처리가 없는 경우가 있어서 throws Exception은 제거하고 Log만 기록. 20240822
    public static final Map<String,String> getQueryMap(String filePath) throws Exception { */
    public static final Map<String,String> getQueryMap(String filePath) {
    	Map<String,String> rtnMap = null;

    	// 시큐어코딩 조치
        String regex = ".*?yjungsan.*?xml_query.*?\\.xml$"; //정규식 체크
        Pattern pattern = Pattern.compile(regex);
        Matcher matcher = pattern.matcher(filePath);        
        if (!matcher.find()) {
    		log.error("[XmlQueryParser Exception] : execution error... " + filePath); // 패턴 매칭 여부 확인
    		/* 호출부에서 try~catch 처리가 없는 경우가 있어서 throws Exception은 제거하고 Log만 기록. 20240822
    	    throw new Exception("조회에 실패하였습니다."); */
        } else {        
			File file = new File(filePath);
	
			try(
				FileInputStream fis = new FileInputStream(file);
				) {
	
				log.debug("xml query 로딩...");
	
				SAXParserFactory spf = SAXParserFactory.newInstance();
																																						 // - DocumentBuilderFactory
				// - SAXParserFactory
				spf.setFeature("http://xml.org/sax/features/external-general-entities", false);
				spf.setFeature("http://xml.org/sax/features/external-parameter-entities", false);
	
				SAXParser sp = spf.newSAXParser();
				XMLReader xr = sp.getXMLReader();
				XmlQueryHandler handler = new XmlQueryHandler();
				xr.setContentHandler(handler);
	
				xr.parse(new InputSource(fis));
				rtnMap = handler.getParsedData();
				log.debug("xml query 로딩 종료..");
	    	} catch(Exception e) {
	    		log.error("[XmlQueryParser Exception] : " + e.getMessage());
	    		/* 호출부에서 try~catch 처리가 없는 경우가 있어서 throws Exception은 제거하고 Log만 기록. 20240822
	    	    throw new Exception("조회에 실패하였습니다."); */
	    	}
        }

		return rtnMap;

	}
}