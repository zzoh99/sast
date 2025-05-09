package com.hr;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.exception.ExceptionUtils;
import org.apache.commons.lang3.math.NumberUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import java.io.File;

/**
 * 내장 톰캣 이용 시 src/main/webapp/META-INF/context.xml 파일의 Context를 읽어 JNDI로 활용하기 위한 Util
 * 
 * @author mschoe
 *
 */
public class JndiContextUtil {

	private static final Logger LOGGER = LoggerFactory.getLogger(JndiContextUtil.class);

	/**
	 * Context 파일 경로
	 */
	private static final String CONTEXT_FILE_PATH = "src/main/webapp/META-INF/context.xml";

	//=========================================================================================================================
	// JNDI 속성
	//=========================================================================================================================
	private String name;
	private String driverClassName;
	private String url;
	private String username;
	private String password;
	private int maxTotal;
	private int maxIdle;
	private int minIdle;
	private long maxWaitMillis;
	private String validationQuery;
	private boolean testWhileIdle;
	private long timeBetweenEvictionRunsMillis;
	private long minEvictableIdleTimeMillis;

	// JNDI 이름을 파라미터로 받는 생성자만 사용
	public JndiContextUtil(String jndiName) {
		String sContextFilePath = CONTEXT_FILE_PATH;

		if (StringUtils.isEmpty(jndiName)) {
			throw new IllegalArgumentException("JNDI 이름은 반드시 입력해야 합니다.");
		}

		String sJndiName = jndiName.replace("java:/comp/env/", "").replace("java:comp/env", "");

		readJndiContext(sContextFilePath, sJndiName);
	}

	public String getName() {
		return name;
	}

	private void setName(String name) {
		this.name = name;
	}

	public String getDriverClassName() {
		return driverClassName;
	}

	private void setDriverClassName(String driverClassName) {
		this.driverClassName = driverClassName;
	}

	public String getUrl() {
		return url;
	}

	private void setUrl(String url) {
		this.url = url;
	}

	public String getUsername() {
		return username;
	}

	private void setUsername(String username) {
		this.username = username;
	}

	public String getPassword() {
		return password;
	}

	private void setPassword(String password) {
		this.password = password;
	}

	public int getMaxTotal() {
		return maxTotal;
	}

	private void setMaxTotal(int maxTotal) {
		this.maxTotal = maxTotal;
	}

	public int getMaxIdle() {
		return maxIdle;
	}

	private void setMaxIdle(int maxIdle) {
		this.maxIdle = maxIdle;
	}

	public int getMinIdle() {
		return minIdle;
	}

	private void setMinIdle(int minIdle) {
		this.minIdle = minIdle;
	}

	public long getMaxWaitMillis() {
		return maxWaitMillis;
	}

	private void setMaxWaitMillis(long maxWaitMillis) {
		this.maxWaitMillis = maxWaitMillis;
	}

	public String getValidationQuery() {
		return validationQuery;
	}

	private void setValidationQuery(String validationQuery) {
		this.validationQuery = validationQuery;
	}

	public boolean isTestWhileIdle() {
		return testWhileIdle;
	}

	private void setTestWhileIdle(boolean testWhileIdle) {
		this.testWhileIdle = testWhileIdle;
	}

	public long getTimeBetweenEvictionRunsMillis() {
		return timeBetweenEvictionRunsMillis;
	}

	private void setTimeBetweenEvictionRunsMillis(long timeBetweenEvictionRunsMillis) {
		this.timeBetweenEvictionRunsMillis = timeBetweenEvictionRunsMillis;
	}

	public long getMinEvictableIdleTimeMillis() {
		return minEvictableIdleTimeMillis;
	}

	private void setMinEvictableIdleTimeMillis(long minEvictableIdleTimeMillis) {
		this.minEvictableIdleTimeMillis = minEvictableIdleTimeMillis;
	}

	/**
	 * Context 파일을 읽어들여 JNDI 속성 값 추출
	 * 
	 * @param contextFilePath Context 파일 경로
	 * @param jndiName JNDI Name
	 */
	private void readJndiContext(String contextFilePath, String jndiName) {
		try {
			// XML 파일 경로
			LOGGER.debug("=========== contextFilePath : {}", contextFilePath);
			
			// DocumentBuilderFactory 및 DocumentBuilder 생성
			DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
			DocumentBuilder builder = factory.newDocumentBuilder();
			
			// XML 파일을 Document 객체로 파싱
			Document document = builder.parse(new File(contextFilePath));
			
			// 루트 엘리먼트 가져오기
			Element rootElement = document.getDocumentElement();
			
			// Resource 엘리먼트들 가져오기
			NodeList resourceNodes = rootElement.getElementsByTagName("Resource");
			
			// 선언된 Resource 수 만큼 확인
			for (int i = 0; i < resourceNodes.getLength(); i++) {
				// Resource 엘리먼트
				Element resourceElement = (Element) resourceNodes.item(i);
				
				// Resource 엘리먼트 내 name 속성
				String name = resourceElement.getAttribute("name");
				
				// 추출하고자 하는 JNDI Resource의 name이 아닐 경우 continue
				if (!name.equals(jndiName)) continue;
				
				// 필요한 속성 값 추출
				setName(jndiName);
				setDriverClassName(resourceElement.getAttribute("driverClassName"));
				setUrl(resourceElement.getAttribute("url"));
				setUsername(resourceElement.getAttribute("username"));
				setPassword(resourceElement.getAttribute("password"));
				setMaxTotal(NumberUtils.toInt(resourceElement.getAttribute("maxTotal")));
				setMaxIdle(NumberUtils.toInt(resourceElement.getAttribute("maxIdle")));
				setMinIdle(NumberUtils.toInt(resourceElement.getAttribute("minIdle")));
				setMaxWaitMillis(NumberUtils.toInt(resourceElement.getAttribute("maxWaitMillis")));
				setValidationQuery(resourceElement.getAttribute("validationQuery"));
				setTestWhileIdle(Boolean.parseBoolean(resourceElement.getAttribute("testWhileIdle")));
				setTimeBetweenEvictionRunsMillis(NumberUtils.toLong(resourceElement.getAttribute("timeBetweenEvictionRunsMillis")));
				setMinEvictableIdleTimeMillis(NumberUtils.toLong(resourceElement.getAttribute("minEvictableIdleTimeMillis")));
				
				// 추출하고자 하는 JNDI Resource를 찾았다면 빠져나감
				break;
			}
		} catch (Exception e) {
			LOGGER.debug(ExceptionUtils.getStackTrace(e));
		}
	}
}
