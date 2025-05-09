<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>인사기본(해외연수)</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/ajax.jsp"%>

<%@ include file="/WEB-INF/jsp/hrm/psnalInfo/psnalBasicInf/psnalBasicDefined.jsp"%>

<script type="text/javascript">
var gPRow = "";
var pGubun = "";
var searchUserId = '';
var searchUserEnterCd = '';

	$(function() {
		createIBSheet3(document.getElementById('psnalOverStudyLayerSheet-wrap'), "psnalOverStudyLayerSheet", "100%", "100%", "${ssnLocaleCd}");

		const modal = window.top.document.LayerModalUtility.getModal('psnalOverStudyLayer');
		searchUserId = modal.parameters.userId || '';
		searchUserEnterCd = modal.parameters.userEnterCd || '';

		$("#hdnSabun").val(searchUserId);
		$("#hdnEnterCd").val(searchUserEnterCd);

		//사용자 정보 수정요청 시 필요한 SHEET 정보를 SET
		///WEB-INF/jsp/hrm/other/empInfoChangeMgr/empInfoChange.jsp 를 SCRIPT> 마지막에 꼭  INCLUDE 필요
		// BUTTON 을 싸고있는 LI (OR DIV)에 _테이블명 클래서를 정의해줌 예 : <li class='_thrm123'>
		// sheet 에 keyField 를 명확히 입력해야 그정보를 수정시 key로 사용함.
		EMP_INFO_CHANGE_TABLE_SHEET["thrm131"] = psnalOverStudyLayerSheet;

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
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly, AutoFitColWidth:'init|search|resize|rowtransaction'};
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
			{Header:"<sht:txt mid='fileSeq' mdef='첨부번호'/>",		Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"fileSeq",		KeyField:0,	Format:"Number",PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 }
		]; IBS_InitSheet(psnalOverStudyLayerSheet, initdata1);psnalOverStudyLayerSheet.SetEditable("${editable}");psnalOverStudyLayerSheet.SetVisible(true);psnalOverStudyLayerSheet.SetCountPosition(4);

		if('${ssnEnterCd}' != $("#hdnEnterCd").val()) {
			$(".enterAuthBtn").hide();
		}
		var enterCd = "&enterCd="+$("#hdnEnterCd").val();

		var userCd1 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList"+enterCd,"H20290"), " ");	//국가코드
		psnalOverStudyLayerSheet.SetColProperty("nationCd", 			{ComboText:"|"+userCd1[0], ComboCode:"|"+userCd1[1]} );

		doAction1("Search");

		let sheetHeight = $(".modal_body").height() - $(".sheet_title").height() - 2;
		psnalOverStudyLayerSheet.SetSheetHeight(sheetHeight);

	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
						var param = "sabun="+$("#hdnSabun").val()+"&searchUserEnterCd="+$("#hdnEnterCd").val();
						psnalOverStudyLayerSheet.RemoveAll();
						psnalOverStudyLayerSheet.DoSearch( "${ctx}/PsnalOverStudy.do?cmd=getPsnalOverStudyList", param );
						break;
		case "Save":
						IBS_SaveName(document.sendForm,psnalOverStudyLayerSheet);
						psnalOverStudyLayerSheet.DoSave( "${ctx}/PsnalOverStudy.do?cmd=savePsnalOverStudy", $("#sendForm").serialize());
						break;
		case "Insert":
						var row = psnalOverStudyLayerSheet.DataInsert(0);
						psnalOverStudyLayerSheet.SetCellValue(row,"sabun",$("#hdnSabun").val());
						psnalOverStudyLayerSheet.SetCellValue(row, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
						break;
		case "Copy":
						var row = psnalOverStudyLayerSheet.DataCopy();
						psnalOverStudyLayerSheet.SetCellValue(row, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
						psnalOverStudyLayerSheet.SetCellValue(row, "fileSeq", '');
						break;
		case "Down2Excel":
						//var downcol = makeHiddenSkipCol(psnalOverStudyLayerSheet);
						var param  = {DownCols:"sNo|nationCd|cityNm|sdate|edate|purpose|note",SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
						psnalOverStudyLayerSheet.Down2Excel(param);

						break;
		case "LoadExcel":
						var params = {Mode:"HeaderMatch", WorkSheetNo:1};
						psnalOverStudyLayerSheet.LoadExcel(params);
						break;
		case "DownTemplate":
						psnalOverStudyLayerSheet.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"",ExcelFontSize:"9",ExcelRowHeight:"20"});
						break;
		}
	}

	// 조회 후 에러 메시지
	function psnalOverStudyLayerSheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			//파일 첨부 시작
			for(var i = psnalOverStudyLayerSheet.HeaderRows(); i<psnalOverStudyLayerSheet.RowCount()+psnalOverStudyLayerSheet.HeaderRows(); i++){

				if("${authPg}" == 'A' && '${ssnEnterCd}' == $("#hdnEnterCd").val()){
					if(psnalOverStudyLayerSheet.GetCellValue(i,"fileSeq") == ''){
						psnalOverStudyLayerSheet.SetCellValue(i, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
						psnalOverStudyLayerSheet.SetCellValue(i, "sStatus", 'R');
					}else{
						psnalOverStudyLayerSheet.SetCellValue(i, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
						psnalOverStudyLayerSheet.SetCellValue(i, "sStatus", 'R');
					}
				}else{
					if(psnalOverStudyLayerSheet.GetCellValue(i,"fileSeq") != ''){
						psnalOverStudyLayerSheet.SetCellValue(i, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
						psnalOverStudyLayerSheet.SetCellValue(i, "sStatus", 'R');
					}
				}
			}

			sheetResize();

		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function psnalOverStudyLayerSheet_OnSaveEnd(Code, Msg, StCode, StMsg) {
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
	function psnalOverStudyLayerSheet_OnClick(Row, Col, Value) {
		try{
			if(psnalOverStudyLayerSheet.ColSaveName(Col) == "btnFile" && Row >= psnalOverStudyLayerSheet.HeaderRows()){
				//var param = [];
				//param["fileSeq"] = psnalOverStudyLayerSheet.GetCellValue(Row,"fileSeq");
				var param = { "fileSeq": psnalOverStudyLayerSheet.GetCellValue(Row,"fileSeq")};
				if(psnalOverStudyLayerSheet.GetCellValue(Row,"btnFile") != ""){
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
            , url : '/fileuploadJFileUpload.do?cmd=viewFileMgrLayer&authPg=${authPg}&uploadType=overStudy'
            , parameters : {
                fileSeq : psnalOverStudyLayerSheet.GetCellValue(Row,"fileSeq")
              }
            , width : 740
            , height : 420
            , title : '파일 업로드'
            , trigger :[
                {
                      name : 'fileMgrTrigger'
                    , callback : function(result){
                        if(result.fileCheck == "exist"){
                            psnalOverStudyLayerSheet.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
                            psnalOverStudyLayerSheet.SetCellValue(gPRow, "fileSeq", result.fileSeq);
                        }else{
                            psnalOverStudyLayerSheet.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
                            psnalOverStudyLayerSheet.SetCellValue(gPRow, "fileSeq", "");
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
				psnalOverStudyLayerSheet.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
				psnalOverStudyLayerSheet.SetCellValue(gPRow, "fileSeq", rv["fileSeq"]);
			}else{
				psnalOverStudyLayerSheet.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
				psnalOverStudyLayerSheet.SetCellValue(gPRow, "fileSeq", "");
			}
		}

	}
</script>
<%@ include file="/WEB-INF/jsp/hrm/other/empInfoChangeMgr/empInfoChange.jsp"%>
</head>
<body class="bodywrap">
<div class="wrapper modal_layer">
	<div class="modal_body">
		<form name="sendForm" id="sendForm" method="post">
			<input id="hdnEnterCd" name="hdnEnterCd" type="hidden">
			<input id="hdnSabun" name="hdnSabun" type="hidden">
			<input id="hdnAuthPg" name="hdnAuthPg" type="hidden" value="${authPg}">
		</form>
		<div class="inner">
			<div class="sheet_title">
				<ul>
					<li class="btn _thrm131">
						<a href="javascript:doAction1('Search');" 			class="basic authR"><tit:txt mid='104081' mdef='조회'/></a>
						<c:if test="${authPg == 'A'}">
							<a href="javascript:doAction1('Insert');" 			class="basic authA enterAuthBtn"><tit:txt mid='104267' mdef='입력'/></a>
							<!-- <a href="javascript:doAction1('Copy');" 			class="basic authA"><tit:txt mid='104335' mdef='복사'/></a> -->
							<a href="javascript:doAction1('Save');" 			class="basic authA enterAuthBtn"><tit:txt mid='104476' mdef='저장'/></a>
						</c:if>
						<a href="javascript:doAction1('Down2Excel');" 		class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
					</li>
				</ul>
			</div>
		</div>

		<div id="psnalOverStudyLayerSheet-wrap"></div>
		<%--	<script type="text/javascript"> createIBSheet("psnalOverStudyLayerSheet", "100%", "100%", "${ssnLocaleCd}"); </script>--%>
	</div>
</div>
</body>
</html>
