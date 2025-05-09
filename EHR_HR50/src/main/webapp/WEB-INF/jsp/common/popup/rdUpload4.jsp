<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%
String baseIP 			= "http://61.111.129.108";
String basePort 		= ":8081";
String baseRdPath 		= "/html/report/" ;
String rdAgent 			= "/DataServer/rdagent.jsp" ;
%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='112051' mdef='테스트1'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	//첫번째저장방법
	//사번을 받아와서 하나씩 저장후 upload
	//=> 사번을 별도의  param 으로 받아와야함
	var p = eval("${popUpStatus}");
	var _tempSabun = "";
	var _tempLen   = 0;
	var _tempCount = 0;
	/*Sheet 기본 설정 */
	$(function() {
		var rdMrd = "";
		var rdParam = "";
		var rdSabun = "";

		var arg = p.window.dialogArguments;
		if( arg != undefined ) {
			rdMrd   = arg["rdMrd"];
			rdParam = arg["rdParam"];
			rdSabun = arg["rdSabun"];
		}

		$("#Mrd").val(rdMrd);
		$("#Param").val(rdParam);
		$("#Sabun").val(rdSabun);

        $("#btnJob1").click(function() {
	    	onenDownload();
	    });

        $("#btnJob2").click(function() {
        	onenUpload();
	    });


        $(".close").click(function() {
	    	p.self.close();
	    });
	});

	function onenDownload(){

		var mrd    = "";
		var param  = "/rmrrex /rfn [<%=baseIP%><%=basePort%><%=rdAgent%>] /rsn [pth] /rp ";

		reportFileNm = "${baseURL}<%=baseRdPath%>" + $("#Mrd").val();
		//reportFileNm = "${baseURL}<%=baseRdPath%>/cpn/payReport/aaa.mrd";
	    param        = param + $("#Param").val();
		mrd   		 = reportFileNm;

		alert(mrd);
	    Rdviewer.ApplyLicense("<%=baseIP%><%=basePort%><%=rdAgent%>");
	    Rdviewer.FileOpen(mrd, param+" ["+$("#Sabun").val()+"]");

	}
	function savetif_and_upload_clicked(){
		//_tempSabun = replaceAll(_tempSabun,"'","");
		//var success = Rdviewer.SaveAsPdfFile("D:\\"+_tempSabun +".pdf");
		var success = Rdviewer.SaveAsPdfFileUd("D:\\","","sabun"); //
	}


	function onenUpload(){

		var _uary  = $("#Sabun").val().split(",");
        var _ulen  = _uary.length;
        var _utemp = "";
        var _count =0;

        for( var i = 0 ; i < _ulen ; i++ ) {
        	_utemp = _uary[i];
        	_utemp = replaceAll(_utemp,"'","");
			var success = Rdviewer.UploadDataFileEx ("D:\\"+_utemp+"_001.pdf", "/"+_utemp+"_001.pdf", "<%=baseIP%><%=basePort%>/DataServer/uploadf.jsp");

			if (success==true){
				_count++;
			}
			else { //alert(i+"실패");
			}

        }
        if(_count !=0 && (_count ==_ulen))
				alert(_count+ "개의 파일이 업로드 되었습니다. ");

	}



	function ReportFinished() {
//리포트가 끝났을 때 실행되는 함수(크롬, 파이어폭스 등에서 사용)
	}

	function SaveFileFinished(szFileName, FileType) {
//export가 완료되면 실행되는 함수(크롬, 파이어폭스 등에서 사용)
	}


</script>

</head>
<body class="bodywrap">
	<form id="paramFrm" name="paramFrm" >
		<input type="hidden" id="Mrd">
		<input type="hidden" id="Param">
		<input type="text" 	 id="Sabun">

	</form>
    <div class="wrapper">
        <div class="popup_title">
            <ul>
                <li><tit:txt mid='112051' mdef='테스트1'/></li>
                <li class="close"></li>
            </ul>
        </div>
<OBJECT id=Rdviewer
   classid="clsid:04931AA4-5D13-442f-AEE8-0F1184002BDD" name=Rdviewer width=50% height=50%>
</OBJECT>

        <div class="popup_main">
			<div class="explain">
				<div class="title"><tit:txt mid='112694' mdef='테스트'/></div>
				<div class="txt">
				<ul>

					<li>
					<a href="javascript:" id="btnJob1" class="button"><tit:txt mid='104476' mdef='저장'/></a>
					<a href="javascript:" id="btnJob2" class="button"><tit:txt mid='104242' mdef='업로드'/></a>
					</li>
				</ul>
				</div>
			</div>




	        <div class="popup_button outer">
	            <ul>
	                <li>
	                    <a href="javascript:p.self.close();" class="gray large"><tit:txt mid='104157' mdef='닫기'/></a>
	                </li>
	            </ul>
	        </div>
        </div>
    </div>

<SCRIPT LANGUAGE=JavaScript FOR=Rdviewer EVENT="ReportFinished()">
<!--
	savetif_and_upload_clicked();
-->
</SCRIPT>
<SCRIPT LANGUAGE=JavaScript FOR=Rdviewer EVENT="SaveFileFinished(szFileName, FileType)">
<!--
   //saveEndEvent(szFileName, FileType);
-->
</SCRIPT>

</body>
</html>
