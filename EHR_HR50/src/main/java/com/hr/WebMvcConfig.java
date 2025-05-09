package com.hr;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.hr.common.interceptor.Interceptor;
import com.hr.common.resolver.JstlCustomViewResolver;
import com.navercorp.lucy.security.xss.servletfilter.XssEscapeServletFilter;
import com.yettiesoft.vestweb.operation.VestWebFilter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.converter.json.Jackson2ObjectMapperBuilder;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.filter.CharacterEncodingFilter;
import org.springframework.web.filter.CorsFilter;
import org.springframework.web.servlet.LocaleResolver;
import org.springframework.web.servlet.config.annotation.*;
import org.springframework.web.servlet.i18n.SessionLocaleResolver;
import org.springframework.web.servlet.resource.PathResourceResolver;
import org.springframework.web.servlet.view.UrlBasedViewResolver;
import org.springframework.web.util.WebAppRootListener;

import javax.servlet.Filter;
import java.io.IOException;
import java.util.List;
import java.util.Locale;

@Configuration
@EnableWebMvc
@ComponentScan(basePackages = {"com.hr"})
public class WebMvcConfig implements WebMvcConfigurer {

    @Autowired
    private Interceptor interceptor;

    @Autowired
    @Qualifier("servletWrapperFilter")
    private Filter servletWrapperFilter;

    @Autowired
    @Qualifier("contentWrapperFilter")
    private Filter contentWrapperFilter;

    @Autowired
    @Qualifier("api50Filter")
    private Filter api50Filter;

    @Autowired
    @Qualifier("frontFilter")
    private Filter frontFilter;

    @Autowired
    @Qualifier("time")
    private Filter timerFilter;

    @Value("${isu.vestweb.config.path}")
    private String vestWebConfigPath;

    @Value("${vue.front.baseUrl}")
    private String frontUrl;

    @Bean WebAppRootListener webAppRootListener() {
        return new WebAppRootListener();
    }

    @Bean
    public FilterRegistrationBean<Filter> corsFilter() {
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        CorsConfiguration config = new CorsConfiguration();
        config.setAllowCredentials(true);
        config.addAllowedOriginPattern("*");
        config.addAllowedHeader("*");
        config.addAllowedMethod("*");
        source.registerCorsConfiguration("/**", config);

		FilterRegistrationBean<Filter> bean = new FilterRegistrationBean<>(new CorsFilter(source));
        bean.setOrder(1);
        return bean;
    }

    @Bean
    public UrlBasedViewResolver jstlViewResolver(){
        UrlBasedViewResolver urlBasedViewResolver = new UrlBasedViewResolver();
        urlBasedViewResolver.setViewClass(JstlCustomViewResolver.class);
        urlBasedViewResolver.setPrefix("/WEB-INF/jsp/");
        urlBasedViewResolver.setSuffix(".jsp");
        return urlBasedViewResolver;
    }

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(interceptor)
                .addPathPatterns("/**")
                .excludePathPatterns("/assets/**","/common/**","/hrfile/**","/html/**","/html-hr50/**","tags/**","/**.ico","/websocket","/websocket/**", "/yjungsan/**", "/isusys-chatbot-wrapper/**", "/*.txt","/guide/**")
                .excludePathPatterns("/notification/**")
                .excludePathPatterns("/searchEmp")
                .excludePathPatterns("/api/v5/**")
                .excludePathPatterns("/api/front/**")
                .excludePathPatterns("/vue-app", "/vue-app/", "/vue-app/**");
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // /vue-app/ 요청만 처리 (index.html 반환)
        registry.addResourceHandler("/vue-app/")
                .addResourceLocations("classpath:/static/vue-app/index.html");

        // Vue 애플리케이션의 SPA 라우팅 처리
        registry.addResourceHandler("/vue-app/**")
                .addResourceLocations("classpath:/static/vue-app/")
                .resourceChain(true)
                .addResolver(new PathResourceResolver() {
                    @Override
                    protected Resource getResource(String resourcePath, Resource location) throws IOException {
                        // 요청된 리소스가 존재하면 반환
                        Resource requestedResource = location.createRelative(resourcePath);
                        if (requestedResource.exists() && requestedResource.isReadable()) {
                            return requestedResource;
                        }

                        // 요청된 리소스가 없으면 index.html 반환 (Vue 라우터 처리)
                        return new ClassPathResource("/static/vue-app/index.html");
                    }
                });

        // 일반적인 정적 리소스 처리 (기본 설정)
        registry.addResourceHandler("/**")
                .addResourceLocations("classpath:/static/");
    }

    @Bean(name="VestWebFilterRegistration")
    public FilterRegistrationBean VestWebFilterRegistration() {

        FilterRegistrationBean<VestWebFilter> registration = new FilterRegistrationBean<>();

        registration.setFilter(new VestWebFilter());
        registration.addUrlPatterns("*.do", "/yjungsan/*");

        // config 경로가 세팅되지 않은 경우, /WEB-INF/config/vestweb_conf.xml 파일을 자동으로 바라봄.
        if (vestWebConfigPath != null && !"".equals(vestWebConfigPath)) {
            registration.addInitParameter("config", vestWebConfigPath);
        }
        //registration.addInitParameter("pregen", securiptPath); // 위변조 기능
        registration.setName("VestWebFilter");
        registration.setOrder(0);
        return registration;
    }

    @Bean
    public FilterRegistrationBean<Filter> encodingFilterRegistrationBean() {
        FilterRegistrationBean<Filter> registrationBean = new FilterRegistrationBean<>(new CharacterEncodingFilter());
        registrationBean.addUrlPatterns("/*");
        registrationBean.addInitParameter("encoding", "utf-8");
        registrationBean.setOrder(2);
        return registrationBean;
    }

    @Bean
    public FilterRegistrationBean<Filter> timeRegistrationBean() {
        FilterRegistrationBean<Filter> registrationBean = new FilterRegistrationBean<>(timerFilter);
        registrationBean.addUrlPatterns("/*");
        registrationBean.setOrder(3);
        return registrationBean;
    }

    @Bean
    public FilterRegistrationBean<XssEscapeServletFilter> filterRegistrationBean() {
        FilterRegistrationBean<XssEscapeServletFilter> filterRegistration = new FilterRegistrationBean<>();
        filterRegistration.setFilter(new XssEscapeServletFilter());
        filterRegistration.setOrder(6);
        filterRegistration.addUrlPatterns("*.do");
        return filterRegistration;
    }


    @Bean
    public FilterRegistrationBean<Filter> servletWrapperFilterRegistrationBean() {
        FilterRegistrationBean<Filter> registrationBean = new FilterRegistrationBean<>(servletWrapperFilter);
        registrationBean.addUrlPatterns("*.do");
        registrationBean.setOrder(4);
        return registrationBean;
    }


    @Bean
    public FilterRegistrationBean<Filter> contentWrapperFilterRegistrationBean() {
        FilterRegistrationBean<Filter> registrationBean = new FilterRegistrationBean<>(contentWrapperFilter);
        registrationBean.addUrlPatterns("*.do");
        registrationBean.setOrder(5);
        return registrationBean;
    }

    @Bean
    public FilterRegistrationBean<Filter> api50FilterRegistrationBean() {
        FilterRegistrationBean<Filter> registrationBean = new FilterRegistrationBean<>(api50Filter);
        registrationBean.addUrlPatterns("/api/v5/*");
        registrationBean.setOrder(7);
        return registrationBean;
    }

    @Bean
    public FilterRegistrationBean<Filter> frontFilterRegistrationBean() {
        FilterRegistrationBean<Filter> registrationBean = new FilterRegistrationBean<>(frontFilter);
        registrationBean.addUrlPatterns("/api/front/*");
        registrationBean.setOrder(1);
        return registrationBean;
    }

    @Bean
    public MappingJackson2HttpMessageConverter jsonEscapeConverter() {
        // MappingJackson2HttpMessageConverter Default ObjectMapper 설정 및 ObjectMapper Config 설정
        ObjectMapper objectMapper = Jackson2ObjectMapperBuilder.json().build();
        objectMapper.getFactory().setCharacterEscapes(new HTMLCharacterEscapes());
        return new MappingJackson2HttpMessageConverter(objectMapper);
    }

    @Bean(name = "customLocaleResolver")
    public LocaleResolver localeResolver() {
        SessionLocaleResolver sessionLocaleResolver = new SessionLocaleResolver();
        sessionLocaleResolver.setDefaultLocale(Locale.KOREA); // 기본 로케일 설정
        return sessionLocaleResolver;
    }

    @Override
    public void configureMessageConverters(List<HttpMessageConverter<?>> converters) {
        WebMvcConfigurer.super.configureMessageConverters(converters);

        // 5. WebMvcConfigurerAdapter에 MessageConverter 추가
        converters.add(htmlEscapingConveter());
    }

    private HttpMessageConverter<?> htmlEscapingConveter() {
        ObjectMapper objectMapper = new ObjectMapper();
        // 3. ObjectMapper에 특수 문자 처리 기능 적용
        objectMapper.getFactory().setCharacterEscapes(new HTMLCharacterEscapes());

        // 4. MessageConverter에 ObjectMapper 설정
        MappingJackson2HttpMessageConverter htmlEscapingConverter =
                new MappingJackson2HttpMessageConverter();
        htmlEscapingConverter.setObjectMapper(objectMapper);

        return htmlEscapingConverter;
    }


    ///////////////////////////////////////
    ///// Vue 테스트용임!! 커밋하면 안돼! /////
    //////////////////////////////////////
    @Override
    public void addCorsMappings(CorsRegistry registry) {
        if (frontUrl != null && !frontUrl.isEmpty()) {
            registry.addMapping("/**")
                    .allowedOrigins(frontUrl)
                    .exposedHeaders("X-Theme")    // X-Theme 헤더는 Vue 앱에만 노출
                    .allowCredentials(true);
        }
    }
}
