package com.hr.tus;


import com.hr.common.com.ComController;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping(value="/Tus.do", method= RequestMethod.POST )
public class TusViewController extends ComController  {

    /**
     * 샘플 화면
     *
     * @return String
     * @throws Exception
     */
    @RequestMapping(params="cmd=viewTusFileUpload", method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewMain() throws Exception {
        return "tus/tusFileUpload";
    }

    @RequestMapping(params="cmd=viewTusFileUploadPopup", method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewUploadPopup() throws Exception {
        return "tus/tusFileUploadPopup";
    }

    @RequestMapping(params="cmd=viewTusFileUploadLayer", method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewTusFileUploadLayer() throws Exception {
        return "tus/tusFileUploadLayer";
    }
    
    @RequestMapping(params="cmd=viewSunEditor", method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewSunEditor() throws Exception {
    	return "tus/test";
    }
}
