<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>연말정산 PDF 업로드 테스트</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script language="JavaScript">
<!--
	var p = eval("<%=popUpStatus%>");
	var errorCnt = 0;
	var exeYn = "N"; //실행여부
	var limitFileSize = 0; //업로드 제한 파일 사이즈 크기

	$(function(){

		var arg = p.window.dialogArguments;

		var initdata = {};
        initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
        initdata.Cols = [
                        {Header:"No",       Type:"<%=sNoTy%>",  Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",    Align:"Center", ColMerge:0, SaveName:"sNo" },
                        {Header:"에러코드",    Type:"Text",            Hidden:1,  Width:40,     Align:"Center",    ColMerge:0,   SaveName:"error_code",   	KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"파일명",     Type:"Text",            Hidden:0,  Width:80,    Align:"Left",      ColMerge:0,   SaveName:"file_name",		KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"크기",      	Type:"Text",            Hidden:0,  Width:50,     Align:"Center",    ColMerge:0,   SaveName:"file_size",     KeyField:0,   CalcLogic:"",   Format:"",  		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"타입",      	Type:"Text",            Hidden:0,  Width:40,     Align:"Center",    ColMerge:0,   SaveName:"file_type",     KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"비고",    	Type:"Text",            Hidden:0,  Width:200,     Align:"Left",    ColMerge:0,   SaveName:"memo",   		KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }
        ]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

        $(window).smartresize(sheetResize); sheetInit();


        var searchWorkYy     	= "";
		var searchAdjustType	= "";
		var searchSabun      	= "";
		var searchSbNm       	= "";
		var searchFileType		= "";

		if( arg != undefined ) {
			searchWorkYy      	= arg["searchWorkYy"];
			searchAdjustType  	= arg["searchAdjustType"];
			searchSabun       	= arg["searchSabun"];
			searchSbNm			= arg["searchSbNm"];
			searchFileType      = arg["searchFileType"];
		}else{
			searchWorkYy      	= p.popDialogArgument("searchWorkYy");
			searchAdjustType  	= p.popDialogArgument("searchAdjustType");
			searchSabun       	= p.popDialogArgument("searchSabun");
			searchSbNm       	= p.popDialogArgument("searchSbNm");
			searchFileType     	= p.popDialogArgument("searchFileType");
		}

		$("#searchWorkYy").val(searchWorkYy);
		$("#searchAdjustType").val(searchAdjustType) ;
		$("#searchSabun").val(searchSabun) ;

		$("#popWorkYy").html(searchWorkYy) ;
		$("#popSabun").html(searchSabun) ;
		$("#popSbNm").html(searchSbNm) ;

		var adjustTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList", "C00303"), "전체" );
		var fileTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&useYn=Y", "YEA001"), "전체" );

		if(searchFileType == null || searchFileType == undefined || searchFileType.length == 0) {
			searchFileType = "10";
		}

		$("#popAdjustType").html(adjustTypeList[2]).val(searchAdjustType);
		$("#popFileType").html(fileTypeList[2]).val(searchFileType);

		$("#popFileType option").each(function(i,v){
			if($(this).val().length == 0) {
				$(this).remove();
			}
		});

		//업로드 파일사이즈 설정 조회
		limitFileSize = ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&searchStdCd=CPN_YEAREND_LIMIT_SIZE", 'queryId=getSystemStdData',false).codeList[0].code_nm;

		$("#inptUpload").on('change',function(){
			changeFile($(this));
		});
	});

	function sheet1_OnClick(Row, Col, Value) {
		try{
			if(sheet1.ColSaveName(Col) == "memo" ) {
				if(sheet1.GetCellValue(Row, "error_code") > 0) {
					alert(sheet1.GetCellValue(Row, "memo"));
				}
			}
		}catch(ex){
			alert("OnClick Event Error : " + ex);
		}
	}

	function goAction(){

		if(exeYn == 'N') {
			if($("#inptUpload").val() == "") {
				alert("업로드 파일을 선택해주세요.");
				return;
			}

			if(errorCnt > 0) {
				alert('업로드 할 수 없는 파일이 존재합니다.\n파일을 확인해 주세요');
				return;
			}

			exeYn = "Y";
			$("#progressCover").show();
			$("#searchFileType").val($("#popFileType").val()) ;
			$("#uploadForm").attr({"method":"POST","target":"ifrmFileUpload","action":"evidenceFileUploadRst.jsp"}).submit();
		} else {
			alert("처리중입니다. 잠시만 기다려 주세요.");
		}
	}

	function changeFile(obj){

		var ext = ""; //파일 확장자
		errorCnt = 0; //초기화

		sheet1.RenderSheet(0);

		if(sheet1.RowCount() > 0) {
			for(var j = sheet1.RowCount() ; j >= 1; j--){
				sheet1.RowDelete(j,0);
			}
		}

		for (var i = 0; i < obj[0].files.length; i++) {
			var file = obj[0].files[i];

			ext = file.name.split('.').pop().toLowerCase();

			sheet1.DataInsert();
			sheet1.SetCellValue(i+1, "file_name", file.name);
			sheet1.SetCellValue(i+1, "file_size", comma(file.size));
			sheet1.SetCellValue(i+1, "file_type", ext.toUpperCase());

			var adjustType = $("#searchAdjustType").val();

			if($.inArray(ext, ['pdf','hwp','txt','doc','docx','ppt','xls','xlsx','zip','rar','alz','egg','7z','jpg','jpeg','gif','png']) == -1) {
				//파일확장자 체크
				sheet1.SetRowBackColor(i+1, "#FAD5E6") ;
				sheet1.SetCellValue(i+1, "error_code", "1");
				sheet1.SetCellValue(i+1, "memo", "업로드 할 수 없는 파일 형식입니다.");
				errorCnt++;
			} else if(!(adjustType == '1' || adjustType == '3')) {
				//정산구분 체크
				sheet1.SetRowBackColor(i+1, "#FAD5E6") ;
				sheet1.SetCellValue(i+1, "error_code", "3");
				sheet1.SetCellValue(i+1, "memo", "정산구분을 확인해 주세요.(1-연말정산, 3-퇴직정산)");
				errorCnt++;
			} else if(file.size > limitFileSize) {
				//파일크기 체크
				sheet1.SetRowBackColor(i+1, "#FAD5E6") ;
				sheet1.SetCellValue(i+1, "error_code", "4");
				sheet1.SetCellValue(i+1, "memo", (limitFileSize/(1024*1024))+"MB 이하의 파일만 업로드 할수 있습니다.");
				errorCnt++;
			} else {
				sheet1.SetCellValue(i+1, "error_code", "0");
			}
		}

		sheet1.RenderSheet(1);

	}

	//콤마찍기
    function comma(str) {
        str = String(str);
        return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
    }

	function procYn(err,message,memo){
		$("#progressCover").hide();

		errorCnt = 0; //초기화
		exeYn = "N";

		var rv = $.parseJSON(memo);

		if(rv != null && rv.length > 0) {
			for (var i = 0;  i < rv.length; i++) {

				sheet1.SetCellValue(rv[i].fileIdx+1, "error_code", rv[i].errorCode);
				sheet1.SetCellValue(rv[i].fileIdx+1, "memo", rv[i].errorMessage);

				if(rv[i].errorCode > 0) {
					sheet1.SetRowBackColor(rv[i].fileIdx+1, "#FAD5E6") ;
					errorCnt++;
				} else {
					if(rv[i].errorMessage.length > 0) {
						sheet1.SetRowBackColor(rv[i].fileIdx+1, "#8FFF6E") ;
					}
				}
			}
		}

		if(err=="Y"){
			alert(message);
			if (p.window.opener) {
				p.window.opener.doAction1("Search");
				//p.window.close();
		    }
		} else {
			alert(message);
		}
	}
//-->
</script>
</head>
<body class="bodywrap">
	<div id="progressCover" style="display:none;position:absolute;top:0;bottom:0;left:0;right:0;background:url(<%=imagePath%>/common/process.png) no-repeat 50% 50%;"></div>
    <div class="wrapper">
        <div class="popup_title">
            <ul>
                <li>파일 업로드</li>
                <!--<li class="close"></li>-->
            </ul>
        </div>
        <div class="popup_main">
        <div style="margin-top: 8px;">
        	<table cellpadding="0" cellspacing="0" class="default outer">
				<colgroup>
					<col width="10%" />
					<col width="11%" />
					<col width="10%" />
					<col width="11%" />
					<col width="10%" />
					<col width="11%" />
					<col width="" />
				</colgroup>
				<tr>
					<th>성명</th>
					<td id="popSbNm"></td>
					<th>사번</th>
					<td id="popSabun"></td>
					<th>귀속년도</th>
					<td id="popWorkYy"></td>
				</tr>
				<tr>
					<th>정산구분</th>
					<td><select id="popAdjustType" name ="popAdjustType" class="box" disabled="disabled"></select></td>
					<th>파일구분</th>
					<td><select id="popFileType" name ="popFileType" class="box"></select></td>
					<th></th>
					<td></td>
				</tr>
			</table>
        </div>
		<form id="uploadForm" method="post" enctype="multipart/form-data">
		<input type="hidden" id="searchWorkYy" name="searchWorkYy" value="" />
		<input type="hidden" id="searchAdjustType" name="searchAdjustType" value="" />
		<input type="hidden" id="searchSabun" name="searchSabun" value="" />
		<input type="hidden" id="searchFileType" name="searchFileType" value="" />
		<div class="outer">
			<!-- PDF 등록 파일업로드 Start -->
			<table border="0" cellpadding="0" cellspacing="0" class="default outer" id="fileUpload">
			    <colgroup>
			        <col width="80%" />
			        <col width="20%" />
			    </colgroup>
			    <tr>
			        <th class="center">파일찾기</th>
			        <th class="center">업로드</th>
			    </tr>
			    <tr>
			        <td class="center">
			            <input type="file" multiple="multiple" id="inptUpload" name="upload" class="text" style="width:100%;">
			        </td>
			        <td class="center">
			        	<a href="javascript:goAction();" class="basic btn-upload" title="전자문서 제출">업로드</a>
			        </td>
			    </tr>
		    </table>
		    <!-- PDF 등록 파일업로드 End -->
		</div>
		</form>
		<script type="text/javascript">createIBSheet("sheet1", "100%", "200px"); </script>

		<iframe id="ifrmFileUpload" name="ifrmFileUpload" width="0" height="0" src="" border="0" frameborder="0" marginwidth="0" marginheight="0"></iframe>
        <div class="popup_button outer">
            <ul>
                <li>
                    <a href="javascript:p.self.close();" class="gray large">닫기</a>
                </li>
            </ul>
        </div>
        </div>
    </div>
</body>
</html>