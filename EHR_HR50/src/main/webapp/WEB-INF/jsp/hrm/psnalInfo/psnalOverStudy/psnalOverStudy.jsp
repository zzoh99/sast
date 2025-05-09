<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>인사기본(해외연수)</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<%@ include file="/WEB-INF/jsp/hrm/psnalInfo/psnalBasicInf/psnalBasicDefined.jsp"%>

<%-- ibSheet file 업로드용 --%>
<%@ include file="/WEB-INF/jsp/common/include/ibFileUpload.jsp"%>
<script type="text/javascript">
var gPRow = "";
var pGubun = "";

	$(function() {
		// 파일 업로드 초기 설정을 위한 함수 호출 initIbFileUpload(form object)
		initIbFileUpload($("#sendForm"));

		// 파일 목록 변수의 초기화 작업 시점 정의
		// clearBeforeFunc(function object)
		// 	-> 파일 목록 변수의 초기화 작업은 매개 변수로 넘긴 함수가 호출되기 전에 전처리 단계에서 수행
		//		ex. sheet1_OnSearchEnd 를 인자로 넘긴 경우, sheet1_OnSearchEnd 함수 호출 직전 파일 목록 변수 초기화
		//	기본적으로 [sheet]_OnSearchEnd, [sheet]_OnSaveEnd 에는 필수로 적용해 주어야 함.
		sheet1_OnSearchEnd = clearBeforeFunc(sheet1_OnSearchEnd);
		sheet1_OnSaveEnd = clearBeforeFunc(sheet1_OnSaveEnd)

		//사용자 정보 수정요청 시 필요한 SHEET 정보를 SET
		///WEB-INF/jsp/hrm/other/empInfoChangeMgr/empInfoChange.jsp 를 SCRIPT> 마지막에 꼭  INCLUDE 필요
		// BUTTON 을 싸고있는 LI (OR DIV)에 _테이블명 클래서를 정의해줌 예 : <li class='_thrm123'>
		// sheet 에 keyField 를 명확히 입력해야 그정보를 수정시 key로 사용함.
		EMP_INFO_CHANGE_TABLE_SHEET["thrm131"] = sheet1;

		$("input[type='text']").keydown(function(event){
			if(event.keyCode == 27){
				return false;
			}
		});

		$("#searchSdate").datepicker2({
			ymonly : true,
			onReturn:function(date){
				doAction1("Search");
			}
		});

		$("#searchSdate").datepicker2({
			onReturn:function(date){
				doAction1("Search");
			}
		});

		$("#searchSdate, #searchEdate").blur(function(){
			doAction1("Search");
		});

		$("#searchSdate, #searchEdate").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});

		$("#searchSdate").datepicker2({startdate:"searchEdate"});
		$("#searchEdate").datepicker2({enddate:"searchSdate"});

		var yyyymmLast = getMonthEndDate("${curSysYear}","${curSysMon}");

		$("#searchSdate").val("${curSysYyyyMMHyphen}"+"-01");
		$("#searchEdate").val("${curSysYyyyMMHyphen}"+"-"+yyyymmLast);

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"<sht:txt mid='appSabunV6' mdef='사원번호'/>",		Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:13 },
			{Header:"<sht:txt mid='eduSeqV8' mdef='순번'/>",			Type:"Int",			Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"seq",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='nationalCdV3' mdef='국가코드'/>",		Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"nationCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='sity ' mdef='도시'/>",			Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"cityNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:300 },
			{Header:"<sht:txt mid='eduSYmd' mdef='시작일'/>",			Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sdate",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='eYmdV1' mdef='종료일'/>",			Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"edate",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"연수목적",		Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"purpose",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:2000 },
			{Header:"연수내용",		Type:"Text",		Hidden:0,	Width:350,	Align:"LEft",	ColMerge:0,	SaveName:"note",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:2000 },
			{Header:"<sht:txt mid='btnFile' mdef='첨부파일'/>",		Type:"Html",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"btnFile",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"<sht:txt mid='fileSeq' mdef='첨부번호'/>",		Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"fileSeq",		KeyField:0,	Format:"",PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		$("#hdnSabun").val($("#searchUserId",parent.document).val());
		$("#hdnSabun").val($("#searchUserId",parent.document).val());
		$("#hdnEnterCd").val($("#searchUserEnterCd",parent.document).val());
		if('${ssnEnterCd}' != $("#hdnEnterCd").val()) {
			$(".enterAuthBtn").hide();
		}
		var enterCd = "&enterCd="+$("#hdnEnterCd").val();

		var userCd1 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList"+enterCd,"H20290"), " ");	//국가코드
		sheet1.SetColProperty("nationCd", 			{ComboText:"|"+userCd1[0], ComboCode:"|"+userCd1[1]} );

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");

	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
						clearFileListArr('sheet1'); // 파일 목록 변수의 초기화
						var param = "sabun="+$("#hdnSabun").val()+"&searchUserEnterCd="+$("#hdnEnterCd").val();
						sheet1.RemoveAll();
						sheet1.DoSearch( "${ctx}/PsnalOverStudy.do?cmd=getPsnalOverStudyList", param );
						break;
		case "Save":
						IBS_SaveName(document.sendForm,sheet1);
						sheet1.DoSave( "${ctx}/PsnalOverStudy.do?cmd=savePsnalOverStudy", $("#sendForm").serialize());
						break;
		case "Insert":
						var row = sheet1.DataInsert(0);
						sheet1.SetCellValue(row,"sabun",$("#hdnSabun").val());
						sheet1.SetCellValue(row, "btnFile", '<btn:a css="btn outline_gray thinner" mid='110922' mdef="첨부"/>');
						break;
		case "Copy":
						var row = sheet1.DataCopy();
						sheet1.SetCellValue(row, "btnFile", '<btn:a css="btn outline_gray thinner" mid='110922' mdef="첨부"/>');
						sheet1.SetCellValue(row, "fileSeq", '');
						break;
		case "Down2Excel":
						//var downcol = makeHiddenSkipCol(sheet1);
						var param  = {DownCols:"sNo|nationCd|cityNm|sdate|edate|purpose|note",SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
						sheet1.Down2Excel(param);

						break;
		case "LoadExcel":
						var params = {Mode:"HeaderMatch", WorkSheetNo:1};
						sheet1.LoadExcel(params);
						break;
		case "DownTemplate":
						sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"",ExcelFontSize:"9",ExcelRowHeight:"20"});
						break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			//파일 첨부 시작
			for(var i = sheet1.HeaderRows(); i<sheet1.RowCount()+sheet1.HeaderRows(); i++){

				if("${authPg}" == 'A' && '${ssnEnterCd}' == $("#hdnEnterCd").val()){
					if(sheet1.GetCellValue(i,"fileSeq") == ''){
						sheet1.SetCellValue(i, "btnFile", '<btn:a css="btn outline_gray thinner" mid='110922' mdef="첨부"/>');
						sheet1.SetCellValue(i, "sStatus", 'R');
					}else{
						sheet1.SetCellValue(i, "btnFile", '<btn:a css="btn outline_gray thinner" mid='110698' mdef="다운로드"/>');
						sheet1.SetCellValue(i, "sStatus", 'R');
					}
				}else{
					if(sheet1.GetCellValue(i,"fileSeq") != ''){
						sheet1.SetCellValue(i, "btnFile", '<btn:a css="btn outline_gray thinner" mid='110698' mdef="다운로드"/>');
						sheet1.SetCellValue(i, "sStatus", 'R');
					}
				}
			}

			sheetResize();

		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			doAction1("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	//파일 신청 시작
	function sheet1_OnClick(Row, Col, Value) {
		try{
			if(sheet1.ColSaveName(Col) == "btnFile" && Row >= sheet1.HeaderRows()){
				//var param = [];
				//param["fileSeq"] = sheet1.GetCellValue(Row,"fileSeq");
				var param = { "fileSeq": sheet1.GetCellValue(Row,"fileSeq")};
				if(sheet1.GetCellValue(Row,"btnFile") != ""){
					if(!isPopup()) {return;}

					gPRow = Row;
					pGubun = "fileMgrPopup";

					var authPgTemp="${authPg}";
					//var win = openPopup("/fileuploadJFileUpload.do?cmd=fileMgrPopup&authPg="+authPgTemp+"&uploadType=overStudy", param, "740","620");
					fileMgrPopup(Row, Col);
				}

			}
		}catch(ex){
			//alert("OnClick Event Error : " + ex);
			}
	}
	
    // 파일첨부/다운로드 팝입
    function fileMgrPopup(Row, Col) {

        let layerModal = new window.top.document.LayerModal({
              id : 'fileMgrLayer'
            , url : '/fileuploadJFileUpload.do?cmd=viewIbFileMgrLayer&authPg=${authPg}&uploadType=overStudy'
            , parameters : {
                fileSeq : sheet1.GetCellValue(Row,"fileSeq"),
				fileInfo: getFileList(sheet1.GetCellValue(Row,"fileSeq")) // 파일 목록 동기화 처리를 위함
              }
            , width : 740
            , height : 420
            , title : '파일 업로드'
            , trigger :[
                {
                      name : 'fileMgrTrigger'
                    , callback : function(result){
						addFileList(sheet1, Row, result); // 작업한 파일 목록 업데이트
                        if(result.fileCheck == "exist"){
                            sheet1.SetCellValue(gPRow, "btnFile", '<btn:a css="btn outline_gray thinner" mid='110698' mdef="다운로드"/>');
                            sheet1.SetCellValue(gPRow, "fileSeq", result.fileSeq);
                        }else{
                            sheet1.SetCellValue(gPRow, "btnFile", '<btn:a css="btn outline_gray thinner" mid='110922' mdef="첨부"/>');
                            sheet1.SetCellValue(gPRow, "fileSeq", "");
                        }
                    }
                }
            ]
        });
        layerModal.show();
    }
	// 입력시 조건 체크
	function checkList(){
		var ch = true;
		var exit = false;
		if(exit){return false;}
			// 화면의 개별 입력 부분 필수값 체크
		$(".required").each(function(index){
			if($(this).val() == null || $(this).val() == ""){
				alert($(this).parent().prepend().find("span:first-child").text()+"은(는) 필수값입니다.");
				$(this).focus();
				ch =  false;
				return false;
			}
		});
		return ch;
	}

	function getMonthEndDate(year, month) {
		var dt = new Date(year, month, 0);
		return dt.getDate();
	}

	function getReturnValue(returnValue) {

		var rv = $.parseJSON('{'+ returnValue+'}');

		if(pGubun == "fileMgrPopup") {
			if(rv["fileCheck"] == "exist"){
				sheet1.SetCellValue(gPRow, "btnFile", '<btn:a css="btn outline_gray thinner" mid='110698' mdef="다운로드"/>');
				sheet1.SetCellValue(gPRow, "fileSeq", rv["fileSeq"]);
			}else{
				sheet1.SetCellValue(gPRow, "btnFile", '<btn:a css="btn outline_gray thinner" mid='110922' mdef="첨부"/>');
				sheet1.SetCellValue(gPRow, "fileSeq", "");
			}
		}

	}
</script>
<%@ include file="/WEB-INF/jsp/hrm/other/empInfoChangeMgr/empInfoChange.jsp"%>
</head>
<body class="bodywrap">
<div class="wrapper">
<form name="sendForm" id="sendForm" method="post">
	<input id="hdnEnterCd" name="hdnEnterCd" type="hidden">
	<input id="hdnSabun" name="hdnSabun" type="hidden">
	<input id="hdnAuthPg" name="hdnAuthPg" type="hidden" value="${authPg}">
</form>
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt">해외연수</li>
			<li class="btn _thrm131">
				<a href="javascript:doAction1('Search');" 			class="btn dark authR"><tit:txt mid='104081' mdef='조회'/></a>
			<c:if test="${authPg == 'A'}">
				<a href="javascript:doAction1('Insert');" 			class="btn outline_gray authA enterAuthBtn"><tit:txt mid='104267' mdef='입력'/></a>
				<!-- <a href="javascript:doAction1('Copy');" 			class="basic authA"><tit:txt mid='104335' mdef='복사'/></a> -->
				<a href="javascript:doAction1('Save');" 			class="btn filled authA enterAuthBtn"><tit:txt mid='104476' mdef='저장'/></a>
			</c:if>
				<a href="javascript:doAction1('Down2Excel');" 		class="btn outline_gray authR"><tit:txt mid='download' mdef='다운로드'/></a>
			</li>
		</ul>
		</div>
	</div>

	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>
