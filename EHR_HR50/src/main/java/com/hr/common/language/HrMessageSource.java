package com.hr.common.language;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.MessageFormat;
import java.util.List;
import java.util.Locale;
import java.util.Properties;

import javax.sql.DataSource;

import net.sf.ehcache.Cache;
import net.sf.ehcache.CacheManager;
import net.sf.ehcache.Element;

import org.springframework.beans.factory.DisposableBean;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.context.ResourceLoaderAware;
import org.springframework.context.support.AbstractMessageSource;
import org.springframework.context.support.ResourceBundleMessageSource;
import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import com.pb.common.lang.JdbcMessageSource;

/**
 * {@link org.springframework.context.MessageSource} implementation that
 * accesses resource bundles in db using dataSource.
 * <p>
 * In contrast to {@link ResourceBundleMessageSource}, this class supports
 * reading resource bundles in a specified table. This class cache messages
 * loaded from the db through cache configuration using Ehcache.
 *
 * <p>
 * Note that the table must have key column(for message id), text column(for
 * message), language/country column (for locale). If this class can't find a
 * message, try to find a message with default locale.
 *
 * DatabaseMessageSource Configuration Example :
 *
 * <pre>
 * &lt;bean name="messageSource" class="org.anyframe.spring.message.DatabaseMessageSource"&gt;
 * 		&lt;property name="dataSource" ref="dataSource"/&gt;
 * 		&lt;property name="messageTable"&gt;
 * 			&lt;props&gt;
 * 			&lt;prop skey="table"&gt;SAMPLE_MESSAGE_SOURCE&lt;/prop&gt;
 * 		&lt;/props&gt;
 *      &lt;/property&gt;
 * 		&lt;property name="defaultLanguage" value="ko"/&gt;
 * 		&lt;property name="defaultCountry" value="KR"/&gt;
 * 		&lt;property name="cacheConfiguration" value="classpath:/spring/ehcache.xml"/&gt;
 * &lt;/bean&gt;
 * </pre>
 *
 * @author SoYon Lim
 */
public class HrMessageSource extends JdbcMessageSource {


	/**
	 * Oracle 버전의 키 컬럼 쿼리 문자열 반환
	 */
	@Override
	protected String getKeyColumnSqlString(String keyLevelColumnName, String keyColumnName, String delimiter) {
		return "ENTER_CD||'.'||" + keyLevelColumnName + "||'" + delimiter+"'||" + keyColumnName; 
	}
	
}
