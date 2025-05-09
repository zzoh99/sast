<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"
%><%@page import="com.ibleaders.ibsheetLoader.IBSheetLoad"
%><%@page import="java.util.ArrayList"
%><%@page import="java.util.List"
%><%@page import="java.io.*"
%><%@ page import="yjungsan.util.StringUtil"%>
<%

    out.clear();
    out = pageContext.pushBody();

    String browser     = "";
    String userAgent   = request.getHeader("User-Agent");
    String contentType = request.getContentType();

    if (userAgent.indexOf("Trident") > 0 || userAgent.indexOf("MSIE") > 0) {
         browser = "IE";
    }else if (userAgent.indexOf("Safari") > 0) {
        if (userAgent.indexOf("Chrome") > 0) {
            browser = "Chrome";
        } else {
            browser = "Safari";
        }
    }

    IBSheetLoad load = null;

    try {
        load = new IBSheetLoad();
        //====================================================================================================
        // [ 사용자 환경 설정 #0 ]
        //====================================================================================================
        // Html 페이지의 인코딩이 UTF-8 로 구성되어 있으면 "load.setEncoding("UTF-8");" 로 설정하십시오.
        // 한글 헤더가 있는 그리드에서 엑셀 로딩이 동작하지 않으면 이 값을 바꿔 보십시오.
        // Down2Excel.jsp 에서의 설정값과 동일하게 바꿔주십시오.
        // setService 전에 설정해야 합니다.
        //====================================================================================================
        load.setEncoding(StringUtil.getPropertiesValue("SYS.ENC"));
        //====================================================================================================
        // HttpServletRequest, HttpServletResponse를 IBSheet 서버모듈에 등록합니다.
        //====================================================================================================
        load.setService(request, response);

        if(browser.equals("IE")){
            //브라우저에 데이터를 전달하여 시트에 로드
            load.writeToBrowser();
        }else if(browser.equals("Chrome")){
        	if(contentType == null || "".equals(contentType)){

        	}else{
                //브라우저에 데이터를 전달하여 시트에 로드
                load.writeToBrowser();
        	}
        }

    } catch (Exception e) {
        out.println("<script>var targetWnd = null; if(opener!=null) {targetWnd = opener;} else {targetWnd = parent;} targetWnd.Grids[0].LoadExcelError(); </script>");
    } catch (Error e) {
        out.println("<script>var targetWnd = null; if(opener!=null) {targetWnd = opener;} else {targetWnd = parent;} targetWnd.Grids[0].LoadExcelError(); </script>");
    } finally {
        if (load != null) {
            load.close();
        }
        load = null;
    }
%>
