package com.hr.cpn.payCalculate.payTransFileCre;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.logger.Log;

/**
 * 은행이체자료다운 Controller
 *
 * @author EW
 *
 */
@Controller
@RequestMapping(value="/PayTransFileCre.do", method=RequestMethod.POST )
public class PayTransFileCreController {
	/**
	 * 은행이체자료다운 서비스
	 */
	@Inject
	@Named("PayTransFileCreService")
	private PayTransFileCreService payTransFileCreService;

	/**
	 * 은행이체자료다운 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPayTransFileCre", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPayTransFileCre() throws Exception {
		return "cpn/payCalculate/payTransFileCre/payTransFileCre";
	}

	/**
	 * 은행이체자료다운(세부내역) 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPayTransFileCrePop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPayTransFileCrePop() throws Exception {
		return "cpn/payCalculate/payTransFileCre/payTransFileCrePop";
	}

	/**
	 * 은행이체자료다운 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPayTransFileCreList", method = RequestMethod.POST )
	public ModelAndView getPayTransFileCreList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = payTransFileCreService.getPayTransFileCreList(paramMap);
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 은행이체자료다운상세 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPayTransFileCreListDetail", method = RequestMethod.POST )
	public ModelAndView getPayTransFileCreListDetail(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = payTransFileCreService.getPayTransFileCreListDetail(paramMap);
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/*@RequestMapping(params="cmd=fileCreate", method = RequestMethod.POST )
	public void fileCreate(HttpSession session,HttpServletRequest request,
			HttpServletResponse response,@RequestParam Map<String, Object> paramMap)throws Exception{
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		List<?> list  = new ArrayList<Object>();


		String enterCd = (String) session.getAttribute("ssnEnterCd");
		String payYmFile = (String)paramMap.get("paymentYmdFile");
		String payYm = payYmFile.substring(2,6);
		String fileName = enterCd + payYm + ".pay" ;

		FileUploadConfig fuConfig = new FileUploadConfig();
		String tempPath = fuConfig.getValue(FileUploadConfig.COMMON_TEMP_PATH);

		String fileNamePath = tempPath+"/"+fileName;

		File file = new File(fileNamePath);

		try{

			list = payTransFileCreService.getPayTransFileCreListFileDown(paramMap);

			if(file.exists()){
				file.delete();
			}
			FileWriter fw = new FileWriter(file, true);

			if ( list.size() > 0 ){
				for(int i = 0 ; i < list.size(); i++ ) {
					HashMap<String, String> map  =  (HashMap<String, String>)list.get(i);
					fw.write(map.get("headData")+"\r\n");
					Log.Debug( "headDate : " +  map.get("headData") );
				}
			}

			fw.flush();
			fw.close();
			download(request, response, fileNamePath);

		}catch(Exception e){

		}
	}*/

	public void download(HttpServletRequest request, HttpServletResponse response, String filePath) throws Exception {


		File downfile = new File(filePath);

		String browserName = getBrowser(request);

		if ("Opera".equals(browserName)){
			response.setHeader("Content-Type", "application/octet-stream;charset=UTF-8");
		} else {
			response.setHeader("Content-Type", "application/octet-stream");
		}

		if(!downfile.exists()) {
			throw new Exception("<script>alert('파일이 존재하지 않습니다');</script>");
		}

		OutputStream outStream = null;
		InputStream inputStream = null;

		try {
			inputStream = new FileInputStream(downfile);

			//Setting Resqponse Header
			response.reset() ;
			response.setContentType("application/octet-stream");
			response.setHeader("Content-Description", "JSP Generated Data");

			response.setHeader("Content-Disposition","attachment;filename=\""+downfile.getName()+"\"");

			byte b[] = new byte[1024];
			int numRead = 0;
			outStream = response.getOutputStream();
			while ((numRead = inputStream.read(b)) != -1) {
				outStream.write(b, 0, numRead);
			}
			inputStream.close();
			outStream.close();
		} catch (Exception e) {
			throw new IOException();
		} finally {
			if(inputStream != null) inputStream.close();
			if(outStream != null) outStream.close();
			downfile.deleteOnExit();
		}
	}

	private String getBrowser(HttpServletRequest request) {
		String header = request.getHeader("User-Agent");
		if (header.indexOf("MSIE") > -1) {
			return "MSIE";
		} else if (header.indexOf("Chrome") > -1) {
			return "Chrome";
		} else if (header.indexOf("Opera") > -1) {
			return "Opera";
		} else if (header.indexOf("Safari") > -1) {
			return "Safari";
		}
		return "Firefox";
	}
}

