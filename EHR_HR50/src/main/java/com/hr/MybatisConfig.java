package com.hr;

import org.apache.ibatis.session.ExecutorType;
import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import javax.sql.DataSource;

@Configuration
@EnableTransactionManagement
public class MybatisConfig {

    @Value("${mybatis.config-location}")
    private String mybatisConfig;

    @Value("${mybatis.mapper-locations}")
    private String mybatisMapper;

    @Autowired
    ApplicationContext applicationContext;

    @Autowired
    @Qualifier("phrDataSource")
    private DataSource phrDataSource;

    @Primary
    @Bean
    public SqlSessionFactory sqlSessionFactory() throws Exception {
        //final SqlSessionFactoryBean sessionFactory = new SqlSessionFactoryBean();
        final RefreshableSqlSessionFactoryBean sessionFactory = new RefreshableSqlSessionFactoryBean();
        sessionFactory.setDataSource(phrDataSource);
        //PathMatchingResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();
        sessionFactory.setMapperLocations(applicationContext.getResources(mybatisMapper));
        sessionFactory.setConfigLocation(applicationContext.getResource(mybatisConfig));
        sessionFactory.getObject().getConfiguration().setMapUnderscoreToCamelCase(true);
        return sessionFactory.getObject();
    }

    @Bean
    public SqlSessionTemplate sqlSession(SqlSessionFactory sqlSessionFactory) {
        return new SqlSessionTemplate(sqlSessionFactory);
    }

    // 배치용 SqlSessionTemplate 추가
    @Bean(name = "batchSqlSession")
    public SqlSessionTemplate batchSqlSession(SqlSessionFactory sqlSessionFactory) {
        return new SqlSessionTemplate(sqlSessionFactory, ExecutorType.BATCH);
    }

    /* Multi DB 용 샘플 코드 */
    /*
    @Autowired
    @Qualifier("subHrDataSource")
    private DataSource subHrDataSource;

    @Bean
    public SqlSessionFactory subHrSqlSessionFactory() throws Exception {
        RefreshableSqlSessionFactoryBean sessionFactory = new RefreshableSqlSessionFactoryBean();
        sessionFactory.setDataSource(subHrDataSource);
        sessionFactory.setMapperLocations(applicationContext.getResources(mybatisMapper));
        sessionFactory.setConfigLocation(applicationContext.getResource(mybatisConfig));
        sessionFactory.getObject().getConfiguration().setMapUnderscoreToCamelCase(true);
        return sessionFactory.getObject();
    }

    @Bean(name = "subHrSqlSession")
    public SqlSessionTemplate subHrSqlSession() throws Exception {
        return new SqlSessionTemplate(subHrSqlSessionFactory());
    }

    @Bean(name = "subHrBatchSqlSession")
    public SqlSessionTemplate subHrBatchSqlSession(SqlSessionFactory subHrSqlSessionFactory) {
        return new SqlSessionTemplate(subHrSqlSessionFactory, ExecutorType.BATCH);
    }*/

//    @Bean
//    public SqlSessionFactoryBean sqlSessionFactoryBean(){
//        SqlSessionFactoryBean sessionFactoryBean = new SqlSessionFactoryBean();
//        sessionFactoryBean.setDataSource(phrDataSource);
//        sessionFactoryBean.setMapperLocations(new ClassPathResource("/com/hr/**/*-sql-query.xml"));
//        sessionFactoryBean.setConfigLocation(new ClassPathResource("/mybatis-config.xml"));
//        return sessionFactoryBean;
//    }

}
