/**
 * Multi DB 용 샘플 코드
 */

//
//package com.hr;
//
//import com.hr.common.logger.Log;
//import org.apache.commons.dbcp2.BasicDataSource;
//import org.springframework.aop.Advisor;
//import org.springframework.aop.aspectj.AspectJExpressionPointcut;
//import org.springframework.aop.support.DefaultPointcutAdvisor;
//import org.springframework.beans.factory.annotation.Value;
//import org.springframework.boot.context.properties.EnableConfigurationProperties;
//import org.springframework.context.annotation.Bean;
//import org.springframework.context.annotation.Configuration;
//import org.springframework.context.annotation.Primary;
//import org.springframework.core.annotation.Order;
//import org.springframework.jdbc.datasource.DataSourceTransactionManager;
//import org.springframework.jdbc.datasource.lookup.JndiDataSourceLookup;
//import org.springframework.jndi.JndiObjectFactoryBean;
//import org.springframework.transaction.PlatformTransactionManager;
//import org.springframework.transaction.annotation.EnableTransactionManagement;
//import org.springframework.transaction.annotation.Isolation;
//import org.springframework.transaction.annotation.Propagation;
//import org.springframework.transaction.interceptor.MatchAlwaysTransactionAttributeSource;
//import org.springframework.transaction.interceptor.RollbackRuleAttribute;
//import org.springframework.transaction.interceptor.RuleBasedTransactionAttribute;
//import org.springframework.transaction.interceptor.TransactionInterceptor;
//
//import javax.sql.DataSource;
//import java.util.Collections;
//import java.util.List;
//
//@Configuration
//@EnableTransactionManagement
//@EnableConfigurationProperties
//public class SubDataSourceConfiguration {
//
//    @Value("${spring.datasource.hr.sec.jndi-name}")
//    private String subJndiName;
//
//    private final String SUB_JNDI_NAME = "jdbc/ehr2";
//
//    /**
//     * Boot 내장 톰캣 사용 여부
//     *
//     * <pre>
//     *     Spring Boot 내장 톰캣 사용 시 : true
//     *     외장 WAS 사용 시 : false
//     *
//     *     만약 내장 톰캣을 사용하는 경우 opti.properties의 embedded.tomcat.useYn 값을 true로 세팅된다. (미 선언시, 값 default false)
//     *     참고로 현재 bEmbeddedTomcatUseYn 값이 true인 경우에도 spring profile이 local인 경우에만 내장 톰캣을 사용하도록 되어있다.
//     * </pre>
//     */
//    private final boolean bEmbeddedTomcatUseYn;
//
//    @Value("${profile.name}")
//    private String profileName;
//
//    private final String EXECUTION ="execution(* *..*Service.*(..))";
//
//    /**
//     * 내장 톰캣 이용 시 src/main/webapp/META-INF/context.xml 파일의 Context를 읽어 JNDI로 활용하기 위한 Util
//     */
//    private JndiContextUtil jndiContextUtil = null;
//
//
//    public SubDataSourceConfiguration(@Value("${embedded.tomcat.useYn:#{false}}") boolean bEmbeddedTomcatUseYn) {
//        this.bEmbeddedTomcatUseYn = bEmbeddedTomcatUseYn;
//        if(bEmbeddedTomcatUseYn) {
//            jndiContextUtil = new JndiContextUtil(SUB_JNDI_NAME);
//            Log.Debug("=========== 내장 톰캣 사용 ===========");
//        } else {
//            Log.Debug("=========== 외장 WAS 사용 ===========");
//        }
//    }
//
//    /**
//     * 현재 profile 확인 및 properties 세팅 값 확인
//     */
//    private void checkSettings() {
//        Log.Debug("=========== active profile name : {}", profileName);
//    }
//
//    /**
//     * DataSource 취득
//     * <pre>
//     *     Boot 내장 톰캣 사용 여부에 따라 DataSource 취득 방식이 다르다.
//     *     외장 WAS 사용 시 DataSource 취득 방식은 해당 WAS의 특성에 맞는 것을 사용하도록 변경해야 한다.
//     *     -> JndiDataSourceLookup OR JndiDataFactoryBean 사용
//     * </pre>
//     *
//     *  @param sJndiName JNDI Name
//     *  @return DataSource
//     */
//    private DataSource getDataSource(String sJndiName) {
//        DataSource dataSource;
//
//        if(bEmbeddedTomcatUseYn && "local".equals(profileName)) {
//            dataSource = getEmbeddedTomcatDataSource();
//        } else {
//            dataSource = getExternalWasDataSourceByLookup(sJndiName);
//        }
//
//        return dataSource;
//    }
//
//    /**
//     * 내장 톰캣 사용 시 DataSource 취득
//     *
//     * @return 내장 톰캣 사용 시 DataSource
//     */
//    private DataSource getEmbeddedTomcatDataSource() {
//        if(jndiContextUtil == null) {return null;}
//
//        BasicDataSource dataSource = new BasicDataSource();
//        dataSource.setDriverClassName(jndiContextUtil.getDriverClassName());
//        dataSource.setUrl(jndiContextUtil.getUrl());
//        dataSource.setUsername(jndiContextUtil.getUsername());
//        dataSource.setPassword(jndiContextUtil.getPassword());
//        dataSource.setMaxTotal(jndiContextUtil.getMaxTotal());
//        dataSource.setMaxIdle(jndiContextUtil.getMaxIdle());
//        dataSource.setMinIdle(jndiContextUtil.getMinIdle());
//        dataSource.setMaxWaitMillis(jndiContextUtil.getMaxWaitMillis());
//        dataSource.setValidationQuery(jndiContextUtil.getValidationQuery());
//        dataSource.setTestWhileIdle(jndiContextUtil.isTestWhileIdle());
//        dataSource.setTimeBetweenEvictionRunsMillis(jndiContextUtil.getTimeBetweenEvictionRunsMillis());
//        dataSource.setMinEvictableIdleTimeMillis(jndiContextUtil.getMinEvictableIdleTimeMillis());
//
//        return dataSource;
//    }
//
//    /**
//     * 외장 WAS 사용 시 DataSource 취득 (JndiDataSourceLookup 사용)
//     * <pre>
//     *     일반적인 외장 WAS 사용 시 이용
//     * </pre>
//     *
//     * @return 외장 WAS 사용 시 DataSource
//     */
//    private DataSource getExternalWasDataSourceByLookup(String sJndiName) {
//        DataSource dataSource;
//
//        JndiDataSourceLookup jndiDataSourceLookup = new JndiDataSourceLookup();
//        dataSource = jndiDataSourceLookup.getDataSource(sJndiName);
//
//        return dataSource;
//    }
//
//    /**
//     * 외장 WAS 사용 시 DataSource 취득 (JndiDataFactoryBean 사용)
//     * <pre>
//     *     일반적인 외장 WAS 사용 시 이용
//     * </pre>
//     *
//     * @return 외장 WAS 사용 시 DataSource
//     */
//    private DataSource getExternalWasDataSourceByFactoryBean(String sJndiName) {
//        JndiObjectFactoryBean bean = new JndiObjectFactoryBean();
//        bean.setJndiName(sJndiName);
//        bean.setProxyInterface(DataSource.class);
//        bean.setLookupOnStartup(false);
//        try {
//            bean.afterPropertiesSet();
//        } catch (Exception e) {
//            Log.Debug(e.getLocalizedMessage());
//        }
//
//        return (DataSource) bean.getObject();
//    }
//
//
//    @Bean(name = "subHrDataSource")
//    public DataSource subHrDataSource() {
//        checkSettings();
//        return getDataSource(subJndiName);
//    }
//
//    @Bean(name = "subHrTransactionManager")
//    PlatformTransactionManager subHrTransactionManager() {
//        DataSourceTransactionManager jndiTransactionManager = new DataSourceTransactionManager();
//        jndiTransactionManager.setDataSource(subHrDataSource());
//
//        return jndiTransactionManager;
//    }
//
//    @Bean
//    public TransactionInterceptor subHrTxAdvice(){
//        List<RollbackRuleAttribute> rollbackRules = Collections.singletonList(new RollbackRuleAttribute(Exception.class));
//
//        RuleBasedTransactionAttribute transactionAttribute = new RuleBasedTransactionAttribute();
//        transactionAttribute.setRollbackRules(rollbackRules);
//        transactionAttribute.setName("*");
//        transactionAttribute.setTimeout(1000);
//        transactionAttribute.setIsolationLevel(Isolation.DEFAULT.value());
//        transactionAttribute.setPropagationBehavior(Propagation.REQUIRED.value());
//
//        MatchAlwaysTransactionAttributeSource attributeSource = new MatchAlwaysTransactionAttributeSource();
//        attributeSource.setTransactionAttribute(transactionAttribute);
//
//        TransactionInterceptor interceptor = new TransactionInterceptor();
//        interceptor.setTransactionManager(subHrTransactionManager());
//        interceptor.setTransactionAttributeSource(attributeSource);
//
//        return interceptor;
//    }
//
//    @Order(4)
//    @Bean
//    public Advisor subHrTxAdvisor(){
//        AspectJExpressionPointcut pointcut = new AspectJExpressionPointcut();
//        pointcut.setExpression(EXECUTION);
//        return new DefaultPointcutAdvisor(pointcut, subHrTxAdvice());
//    }
//}
