package com.hr;

import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.context.annotation.Configuration;

@Configuration
public class ServletInitializer extends SpringBootServletInitializer {

	/*
    @Autowired
    @Qualifier("servletWrapperFilter")
    private Filter servletWrapperFilter;

    @Autowired
    @Qualifier("time")
    private Filter timerFilter;

    @Bean
    public FilterRegistrationBean<Filter> encodingFilterRegistrationBean() {
        FilterRegistrationBean<Filter> registrationBean = new FilterRegistrationBean<>(new CharacterEncodingFilter());
        registrationBean.addUrlPatterns("/*");
        registrationBean.addInitParameter("encoding", "utf-8");
        return registrationBean;
    }

    @Bean
    public FilterRegistrationBean<Filter> timeRegistrationBean() {
        FilterRegistrationBean<Filter> registrationBean = new FilterRegistrationBean<>(timerFilter);
        registrationBean.addUrlPatterns("/*");
        return registrationBean;
    }

//    @Bean
//    public FilterRegistrationBean<XssEscapeServletFilter> filterRegistrationBean() {
//        FilterRegistrationBean<XssEscapeServletFilter> filterRegistration = new FilterRegistrationBean<>();
//        filterRegistration.setFilter(new XssEscapeServletFilter());
//        filterRegistration.setOrder(1);
//        filterRegistration.addUrlPatterns("/*");
//        return filterRegistration;
//    }


    @Bean
    public FilterRegistrationBean<Filter> servletWrapperFilterRegistrationBean() {
        FilterRegistrationBean<Filter> registrationBean = new FilterRegistrationBean<>(servletWrapperFilter);
        registrationBean.addUrlPatterns("/*");
        return registrationBean;
    }
    */

    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {

        return application.sources(HrApplication.class);
    }

}
