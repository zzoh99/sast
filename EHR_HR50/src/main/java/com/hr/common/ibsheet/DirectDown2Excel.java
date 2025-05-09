package com.hr.common.ibsheet;

import com.hr.common.logger.Log;
import com.ibleaders.ibsheet.IBSheetDown;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class DirectDown2Excel {

	/**
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	public void downExcel(
			MultipartHttpServletRequest request, HttpServletResponse response
	) throws Exception {
		Log.DebugStart();

		response.setContentType("application/octet-stream");
		response.setCharacterEncoding("UTF-8");
		response.setHeader("Content-Disposition", "");

		IBSheetDown down = null;

		try {
			down = new IBSheetDown();
			down.setLog(true);
			//====================================================================================================
			// [ 사용자 환경 설정 #0 ]
			//====================================================================================================
			// Html 페이지의 인코딩이 UTF-8 로 구성되어 있으면 "down.setEncoding("UTF-8");" 로 설정하십시오.
			// LoadExcel.jsp 도 동일한 값으로 바꿔 주십시오.
			// setService 전에 설정해야 합니다.
			//====================================================================================================
			down.setEncoding("UTF-8");

			//====================================================================================================
			// [ 사용자 환경 설정 #1 ]
			//====================================================================================================
			// 엑셀 전문의 MarkupTag Delimiter 사용자 정의 시 설정하세요.
			// 설정 값은 IBSheet7 환경설정(ibsheet.cfg)의 MarkupTagDelimiter 설정 값과 동일해야 합니다.
			//====================================================================================================
			down.setMarkupTagDelimiter("&lt;","&gt;","&lt;/","&gt;");

			// 시트 헤더정보 세팅
			String Data = request.getParameter("Data");
			down.setData(Data);

			//====================================================================================================
			// [ 사용자 환경 설정 #3 ]
			//====================================================================================================
			// HttpServletRequest, HttpServletResponse를 IBSheet 서버모듈에 등록합니다.
			//====================================================================================================
			down.setService(request, response);

			//====================================================================================================
			// [ 사용자 환경 설정 #4 ]
			//====================================================================================================
			// 다운로드 받을 문서의 타입을 설정하십시오.
			// xls   : xls 형식으로 다운로드
			// xlsx  : xlsx 형식으로 다운로드
			// excel : 시트에 FileName에 설정값으로 다운로드, 확장자가 없는 경우 기본 xls 형식으로 다운로드
			//====================================================================================================
			down.setFileType("excel");

			// 다운로드 Request에 SHEETDATA로 저장된 데이터를 시트에 포함
			down.setDirectRequestData();

			// 생성된 문서를 브라우저를 통해 다운로드
			down.downToBrowser();
		} catch (Exception | Error e) {
			response.setContentType("text/html;charset=UTF-8");
			response.setCharacterEncoding("UTF-8");
			response.setHeader("Content-Disposition", "");
			Log.Debug(e.toString());
		} finally {
			if (down != null) {
				try {
					down.close();
				} catch (Exception ex) {
					Log.Debug(ex.toString());
				}
			}
        }
		Log.DebugEnd();
	}
}