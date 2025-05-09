package yjungsan.util;
import java.util.ArrayList;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class QueryBean {
	
	private static final Logger log = LoggerFactory.getLogger(QueryBean.class);
	
	private String orgQuery = "";
	private String convQuery = "";
	private String logQuery = "";
	private List paramName = new ArrayList();
	private List paramValue = new ArrayList();
	
	public QueryBean() {}

	public QueryBean(String orgQuery, String confQuery, String logQuery, List paramName, List paramValue) {
		this.orgQuery = orgQuery;
		this.convQuery = confQuery;
		this.logQuery = logQuery;
		this.paramName = paramName;
		this.paramValue = paramValue;
	}

	public String getOrgQuery() {
		return orgQuery;
	}

	public void setOrgQuery(String orgQuery) {
		this.orgQuery = orgQuery;
	}

	public String getConvQuery() {
		return convQuery;
	}

	public void setConvQuery(String convQuery) {
		this.convQuery = convQuery;
	}

	public String getLogQuery() {
		return logQuery;
	}

	public void setLogQuery(String logQuery) {
		this.logQuery = logQuery;
	}

	public List getParamName() {
		return paramName;
	}
	
	public String getParamName(int index) {
		return (String)paramName.get(index);
	}

	public void setParamName(List paramName) {
		this.paramName = paramName;
	}

	public List getParamValue() {
		return paramValue;
	}

	public void setParamValue(List paramValue) {
		this.paramValue = paramValue;
	}
	
	public String getParamValue(int index) {
		return (String)paramValue.get(index);
	}
}