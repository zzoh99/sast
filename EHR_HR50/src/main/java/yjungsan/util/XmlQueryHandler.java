package yjungsan.util;

import org.xml.sax.Attributes;  
import org.xml.sax.SAXException;  
import org.xml.sax.helpers.DefaultHandler;
import java.util.Map;
import java.util.HashMap;

/**
 * XML 쿼리 핸들러.
 * @author
 *
 */
public class XmlQueryHandler extends DefaultHandler {

	private String queryId = "";
	private String queryStr = "";
	private Map<String,String> queryMap;
	 
	public Map<String,String> getParsedData() {  
		return this.queryMap;  
	}
 
	@Override  
	public void startDocument() throws SAXException {  
		this.queryMap = new HashMap<String,String>();  
	}
 
	@Override  
	public void endDocument() throws SAXException {  
		// Nothing to do  
	}  
     
	@Override  
	public void startElement(String namespaceURI, String localName, String ndName, Attributes atts) throws SAXException {  
		if (ndName.equals("query")) {
			queryId = atts.getValue("id");
		}
    }  

	@Override  
	public void endElement(String namespaceURI, String localName, String qName)  throws SAXException {  
	    if (qName.equals("query")) {  
	    	queryMap.put(queryId, queryStr);
	    }
	    
	    queryId = "";
	    queryStr = "";
	}  
  
	@Override  
	public void characters(char ch[], int start, int length) {
		if(queryId != "" && queryId.length() > 0) {
			queryStr = queryStr+new String(ch, start, length);
		}
	}  
}