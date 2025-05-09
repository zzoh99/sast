<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*,java.io.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>PDF 팝업</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<%@ page import="com.hr.common.logger.Log" %>
</head>
<%
String filePath = request.getParameter("filePath");
FileInputStream ifo = null;
ByteArrayOutputStream baos = null;
OutputStream resOut = null;

try {
	//File imgFile =  new  File("/tyerp/attach/ehr/YEA_PDF/TY/2018/SUM/2404-M3197.pdf");
	//filePath = removeXSS(filePath, "1");

	if (filePath != null) {
		int S = filePath.lastIndexOf("/"); //UNIX계열
		if (S < 0) S = filePath.lastIndexOf("\\"); //WINDOW계열
		int E = filePath.length();

		String pathName = removeXSS(filePath.substring(0, S+1),"filePath");
		String fileName = removeXSS(filePath.substring(S+1,E), "fileName");

		filePath = 	pathName + fileName;
	}

	File imgFile =  new  File(filePath);
	ifo = new FileInputStream(imgFile);
	baos = new ByteArrayOutputStream();

	byte[] buf = new byte[1024];
	int readlength = 0;
	while( (readlength =ifo.read(buf)) != -1 )
	{
		baos.write(buf,0,readlength);
	}
	byte[] pdfbuf = null;
	pdfbuf = baos.toByteArray();

	int length = pdfbuf.length;

    response.setContentType("application/pdf");
    response.setHeader("Content-Description", "JSP Generated Data");

    out.clear();
    out=pageContext.pushBody();
    
	resOut = response.getOutputStream();
	resOut.write(pdfbuf , 0, length);
} catch (Exception e) {
    response.setContentType("text/html;charset=euc-kr");
    out.println("<script language='javascript'>");
    out.println("alert('파일 오픈 중 오류가 발생하였습니다.');");
    out.println("</script>");
    Log.Error("[pdfViewPop]: " + e.getMessage());
} finally{
    try{
        if(ifo != null) ifo.close();
        if(baos != null) baos.close();
        if(resOut != null) resOut.close();

    } catch(IOException e){
        Log.Error("[pdfViewPop]:" + e.getMessage());
    }
}

%>
</html>
