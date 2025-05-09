<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.UUID"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.List"%>
<%@ page import="java.io.*" %>
<%
String param5 = "".equals(request.getParameter("p")) ? "hrfile": request.getParameter("p");
String paths       = "/"+ param5 +"/"+session.getAttribute("ssnEnterCd") +"/kms/"+ session.getAttribute("ssnBaseDate");
String imockdata     = "";

if (ServletFileUpload.isMultipartContent(request)){
    ServletFileUpload uploadHandler = new ServletFileUpload(new DiskFileItemFactory());

    //UTF-8 인코딩 설정
    uploadHandler.setHeaderEncoding("UTF-8");
    uploadHandler.setSizeMax(1024*1024);
    List<FileItem> items = uploadHandler.parseRequest(request);
    String realname = "";

    String path     = "";
    String param1   = ""; //너비
    String param2   = ""; //높이
    String param3   = ""; //설명
    String param4   = ""; //정렬

    Long size = 0L;
    //각 필드태그들을 FOR문을 이용하여 비교를 합니다.
    for (FileItem item : items) {
        //image.html 에서 file 태그의 name 명을 "filename"로 지정해 주었으므로
        if(item.getFieldName().equals("filename")) {
            if(item.getSize() > 0) {
                String ext = item.getName().substring(item.getName().lastIndexOf(".")+1);
                //파일 기본경로
                String defaultPath = request.getServletContext().getRealPath("/");
                //파일 기본경로 _ 상세경로
                path = defaultPath + paths + File.separator;

                File file = new File(path);

                //디렉토리 존재하지 않을경우 디렉토리 생성
                if(!file.exists()) {
                    file.mkdirs();
                }
                
                //서버에 업로드 할 파일명(한글문제로 인해 원본파일은 올리지 않는것이 좋음)
                realname = UUID.randomUUID().toString() + "." + ext;
                size = item.getSize();
                ///////////////// 서버에 파일쓰기 /////////////////
                InputStream is = item.getInputStream();
                OutputStream os= new FileOutputStream(path + realname);
                int numRead;
                byte b[] = new byte[(int)item.getSize()];
                try{
                    while((numRead = is.read(b,0,b.length)) != -1){
                        os.write(b,0,numRead);
                    }
                }finally {

                    try{
                        if(is != null)  is.close();
                    }catch (IOException ie){
                        //FileInputStream ERR
                    }
                    os.flush();
                    try{
                        os.close();
                    }catch (IOException ie){
                        //FileInputStream ERR
                    }
                }
                ///////////////// 서버에 파일쓰기 /////////////////
            }
        }
        else if(item.getFieldName().equals("param1")){
        	param1 = item.getString("UTF-8" );
        }
        else if(item.getFieldName().equals("param2")){
        	param2 = item.getString("UTF-8" );
        }
        else if(item.getFieldName().equals("param3")){
        	param3 = item.getString("UTF-8" );
        }
        else if(item.getFieldName().equals("param4")){
        	param4 = item.getString("UTF-8" );
        }

    }
	imockdata    = 				  "'imageurl': '"+ paths +"/"+ realname +"',";
	imockdata    = imockdata    + "'filename': '"+ realname +"',";
	imockdata    = imockdata    + "'filesize': currentFileSize,";
	imockdata    = imockdata    + "'imagealign':'"+ param4 +"',";
	imockdata    = imockdata    + "'originalurl': '"+ realname  +"',";
	imockdata    = imockdata    + "'thumburl': '"+ realname  +"',";
	imockdata    = imockdata    + "'width': '"+ param1 +"',";
	imockdata    = imockdata    + "'height': '"+ param2 +"',";
	imockdata    = imockdata    + "'alt': '"+param3 +"'";
	//System.out.println(imockdata);

}

%>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <script src="/common/plugin/Editor/js/popup.js" type="text/javascript" charset="utf-8"></script>
    <script type="text/javascript">
// <![CDATA[

    function initUploader(){
        var _opener = PopupUtil.getOpener();
        if (!_opener) {
            alert('잘못된 경로로 접근하셨습니다.');
            return;
        }

        var _attacher = getAttacher('image', _opener);
        registerAction(_attacher);


        if (typeof(execAttach) == 'undefined') { //Virtual Function
            return;
        }

        var currentFileSize = 640;

        var _mockdata = {
        		<%=imockdata%>
            };

        execAttach(_mockdata);
        closeWindow();
    }
// ]]>
</script>
</head>
<body onload="initUploader();">
</body>
</html>