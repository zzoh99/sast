package com.hr.main.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;

import com.hr.common.logger.Log;
import org.springframework.stereotype.Component;


/**
 * Created by i on 2017. 6. 9
 */
@Component("time")
public class TimerFilter implements Filter {
    //private FilterConfig config;
	//private static final Logger Log = Logger.getLogger(TimerFilter.class);
	
	public void init(FilterConfig config) throws ServletException {
        //this.config = config;
        
    }

    public void doFilter(ServletRequest req, ServletResponse resp,
            FilterChain chain) throws IOException, ServletException {
        //request 필터
        long start = System.currentTimeMillis();

        //다음필터 또는 필터의 마지막이면 서블릿(JSP)실행
        chain.doFilter(req, resp);

        //response 필터
        long end = System.currentTimeMillis();
        String uri;
        if(req instanceof HttpServletRequest) {
            HttpServletRequest request = (HttpServletRequest)req;
            uri = request.getRequestURI();

            //ServletContext context = config.getServletContext();
            //context.log(uri + " 실행시간:" + (end-start)+"ms 시간이 소요됨");
            //Log.Debug(uri + " 실행시간:" + (end-start)+"ms 시간이 소요됨");
        }
    }
    public void destroy(){}
}
