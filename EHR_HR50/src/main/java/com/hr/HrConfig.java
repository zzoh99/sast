package com.hr;

import java.util.Properties;

import javax.sql.DataSource;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.hr.common.aop.FileUploadAspect;
import com.hr.common.aop.SabunAuthAspect;
import com.hr.common.language.HrMessageSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.converter.json.Jackson2ObjectMapperBuilder;
import org.springframework.web.servlet.view.BeanNameViewResolver;
import org.springframework.web.servlet.view.json.MappingJackson2JsonView;

import com.hr.common.aop.FileLoggingAspect;
import com.hr.common.aop.LoggingAspect;
import com.hr.common.exception.handler.HrExceptionResolver;

@Configuration
public class HrConfig {

    @Autowired
    private DataSource phrDataSource;

    @Bean
    public LoggingAspect logAspect(){
        return new LoggingAspect();
    }

    @Bean
    public FileLoggingAspect fileLogAspect(){
        return new FileLoggingAspect();
    }

    @Bean
    public SabunAuthAspect sabunAuthAspect(){
        return new SabunAuthAspect();
    }

    @Bean
    public FileUploadAspect fileUploadAspect(){
        return new FileUploadAspect();
    }

    @Bean
    public HrExceptionResolver exceptionResolver(){
        HrExceptionResolver hrExceptionResolver = new HrExceptionResolver();
        hrExceptionResolver.setDefaultErrorView("common/error/info");
        return hrExceptionResolver;
    }

    @Bean
    public BeanNameViewResolver beanNameResolver(){
        BeanNameViewResolver beanNameViewResolver = new BeanNameViewResolver();
        beanNameViewResolver.setOrder(0);
        return beanNameViewResolver;
    }
    
    @Bean
    public MappingJackson2JsonView jsonView(){
        MappingJackson2JsonView mappingJackson2JsonView = new MappingJackson2JsonView();
        mappingJackson2JsonView.setContentType("application/json; charset=UTF-8");
//        ObjectMapper objectMapper = Jackson2ObjectMapperBuilder.json().build();
//        objectMapper.getFactory().setCharacterEscapes(new HTMLCharacterEscapes());
//        mappingJackson2JsonView.setObjectMapper(objectMapper);
        return mappingJackson2JsonView;
    }

    @Bean
    public MappingJackson2JsonView xssSafeJsonView(){
        MappingJackson2JsonView mappingJackson2JsonView = new MappingJackson2JsonView();
        mappingJackson2JsonView.setContentType("application/json; charset=UTF-8");
        ObjectMapper objectMapper = Jackson2ObjectMapperBuilder.json().build();
        objectMapper.getFactory().setCharacterEscapes(new HTMLCharacterEscapes());
        mappingJackson2JsonView.setObjectMapper(objectMapper);
        return mappingJackson2JsonView;
    }
    

    @Bean
    public HrMessageSource messageSource(){
        HrMessageSource hrMessageSource = new HrMessageSource();
        hrMessageSource.setDataSource(phrDataSource);
        Properties properties = new Properties();
        properties.setProperty("table","TLAN_VIEW");
        properties.setProperty("key.level","KEY_LEVEL");
        properties.setProperty("key.column","KEY_ID");
        properties.setProperty("language.column","LANG_CD");
        properties.setProperty("country.column","COUNTRY_CD");
        properties.setProperty("text.column","KEY_TEXT");
        properties.setProperty("cache.column","KEY_READ");
        properties.setProperty("sql.condition","AND 1 = NVL(F_SYS_LOAD('multiLang'), 0) AND (ENTER_CD, LANG_CD, COUNTRY_CD ) IN (SELECT A.ENTER_CD, A.LANG_CD, B.COUNTRY_CD FROM TLAN101 A,TLAN100 B, TORG900 C WHERE 1 = 1 AND A.LANG_CD    = B.LANG_CD AND A.ENTER_CD  = C.ENTER_CD AND C.LANG_USE_YN = '1' AND A.USE_YN = '1')");
        hrMessageSource.setMessageTable(properties);

        hrMessageSource.setCacheConfiguration("classpath:/ehcache.xml");
        hrMessageSource.setLazyLoad(false);
        return hrMessageSource;
    }
}
