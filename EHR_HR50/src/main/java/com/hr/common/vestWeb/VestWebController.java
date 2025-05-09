package com.hr.common.vestWeb;

import com.hr.common.logger.Log;
import com.yettiesoft.vestweb.capsule.VestSubmit;
import com.yettiesoft.vestweb.exception.VestWebException;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.PrintWriter;

@Controller
public class VestWebController {

    @RequestMapping(value="/vestsubmit", method= RequestMethod.GET )
    public void getVestsubmit(HttpServletRequest request, HttpServletResponse response) throws Exception {
        response.setContentType("text/html");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        try {
            VestSubmit.writeVestSubmit(/*request, */out);
        } catch (VestWebException e) {
            Log.Error("VestWebException: " + e.getLocalizedMessage());
        } catch (Exception e) {
            Log.Error("Exception: " + e.getLocalizedMessage());
        }
        out.close();
    }
}