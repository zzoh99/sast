<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='empCardPrt' mdef='인사카드출력'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script src="/assets/js/utility-script.js?ver=7"></script>
<script type="text/javascript">
	var gPRow = "";

	// 공통코드
	var enterCdList;
	var jikweeCdList;
	var jobCdList;
	var statusCdList;

	$(function() {
		enterCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getAuthEnterCdList&searchGrpCd=${ssnGrpCd}",false).codeList, "<tit:txt mid='103895' mdef='전체'/>");
		jikweeCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20030"), "<tit:txt mid='103895' mdef='전체'/>");
		jikgubCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20010"), "<tit:txt mid='103895' mdef='전체'/>");
		jobCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getJobCdList",false).codeList, "<tit:txt mid='103895' mdef='전체'/>");	//직무코드
		statusCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10010"), "<tit:txt mid='103895' mdef='전체'/>");
	});

	$(function() {
		/*
		$('input:checkbox[name="rdViewType"]').each(function(){
		     if(this.value == "2" || this.value == "4" || this.value == "5"){
		        this.checked = true;
		     }
		});
		*/

		$("#searchRetSYmd").datepicker2({startdate:"searchRetEYmd"});
		$("#searchRetEYmd").datepicker2({enddate:"searchRetSYmd"});


		$("#searchJikweeCd, #searchJobCd").bind("change",function(event){
			doAction1("Search");
		});
		
		$(".rdViewType2").change(function(){
			if( $(this).val() == "1" ) {
				$(".rd_summary.viewType1").removeClass("hide");
				$(".rd_summary.viewType3").addClass("hide");
			} else {
				$(".rd_summary.viewType3").removeClass("hide");
				$(".rd_summary.viewType1").addClass("hide");
			}
		});

		/*
		 * [2020.11.05] 요약본 출력 시 이벤트 추가
		 * 우측영역에 출력되는 항목 출력 시 좌측 영역에 출력되는 항목이 미출력 설정된 경우 mrd에서 출력되지 않는 현상으로 인해
		 * 우측영역에 출력되는 항목 출력 설정 지 좌측 영역에 출력되는 항목도 같이 체크되도록 이벤트 설정 추가함.
		 */
		$(".rd_summary.viewType1 input[type=checkbox]").change(function(){
			if( $(this).attr("together-item") != undefined && $(this).attr("together-item") != null && $(this).attr("together-item") != "" ) {
				// 체크된 경우 together-item에 설정된 체크박스도 체크 처리함.
				if( $(this).is(":checked") ) {
					$("." + $(this).attr("together-item")).attr("checked", true);
				}
			} else {
				var nextObj = $($(this).next());
				if( $(this).hasClass(nextObj.attr("together-item")) ) {
					nextObj.attr("checked", !nextObj.is(":checked"));
				}
			}
		});
		
		$("input[name='searchStatusCd']").bind("click",function(event){
			// if($(this).val() == "RA") {
			//	$("#hdnYmd").hide();
			// } else {
			//	$("#hdnYmd").show();
			// }
			if($(this).val() == "RA") {
				$(".hdnYmd").hide();
			} else {
				$(".hdnYmd").show();
			}
		});

		$("#searchName, #searchOrgNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});

		$("#searchEnterCd").html(enterCdList[2]);
		$("#searchJikweeCd").html(jikweeCdList[2]);
		$("#searchJobCd").html(jobCdList[2]);

		initSheet1();
		initSheet2();

		doAction("Search");

	});

	function doAction(sAction) {
		switch (sAction) {
		case "Search":		doAction1("Search"); break;
		case "Add":		//추가
			var chk = "";

			var arrRow = sheet1.FindCheckedRow("chk").split("|");

			for(var i=0; i < arrRow.length; i++) {
				var Row = arrRow[i];
				if( Row == "" ) continue;
				chk = "Y";

				//sheet1.SetCellValue(Row, "chk",	"0");

				// 이미 추가된 값이 있으면 continue
				var findText = sheet1.GetCellValue(Row, "enterCd") +"_"+ sheet1.GetCellValue(Row, "sabun");
				if ( sheet2.FindText("findText",findText) != -1 ) continue;

				// 행 추가
				var AddRow = sheet2.DataInsert(-1);

				sheet2.SetCellValue(AddRow, "chk",	"1");
				sheet2.SetCellValue(AddRow, "enterCd",		sheet1.GetCellValue(Row, "enterCd"));
				sheet2.SetCellValue(AddRow, "orgNm",		sheet1.GetCellValue(Row, "orgNm"));
				sheet2.SetCellValue(AddRow, "sabun",		sheet1.GetCellValue(Row, "sabun"));
				sheet2.SetCellValue(AddRow, "name",			sheet1.GetCellValue(Row, "name"));
				sheet2.SetCellValue(AddRow, "alias",		sheet1.GetCellValue(Row, "alias"));
				sheet2.SetCellValue(AddRow, "jikgubCd",		sheet1.GetCellValue(Row, "jikgubCd"));
				sheet2.SetCellValue(AddRow, "jikweeCd",		sheet1.GetCellText(Row, "jikweeCd"));
				sheet2.SetCellValue(AddRow, "findText",		findText );
				sheet2.SetCellValue(AddRow, "rk",           sheet1.GetCellText(Row, "rk"));
			}

			if(chk == ""){
				alert("<msg:txt mid='109714' mdef='선택된 대상자가 없습니다. 대상자를 선택해 주십시요'/>");
				return;
			}

			break;

		case "Del":		//삭제
			var chk = "";

			var arrRow = sheet2.FindCheckedRow("chk").split("|");
			for(var i = arrRow.length -1 ; 0 <= i ; i--) {
				var Row = arrRow[i];
				if( Row == "" ) continue;
				chk = "Y";

				sheet2.SetCellValue(Row, "sDelete", "1");
			}

			if(chk == ""){
				alert("<msg:txt mid='109714' mdef='선택된 대상자가 없습니다. 대상자를 선택해 주십시요'/>");
				return;
			}

			break;
		}
	}

	// 소속 팝업
	function showOrgPopup() {
		if(!isPopup()) {return;}

		openPopup("/Popup.do?cmd=orgBasicPopup&authPg=R", "", "740","520");
	}
	function afterShowOrgPopup(rv) {
		$("#searchOrgCd").val(rv["orgCd"]);
		$("#searchOrgNm").val(rv["orgNm"]);
	}

	/**
	 * 출력 window open event
	 * 레포트 공통에 맞춘 개발 코드 템플릿
	 * by JSG
	 */
	function rdPopup(){
		if(!isPopup()) {return;}

		var enterCdSabun = "";
		var searchSabun = "";
		var sRow = sheet2.FindCheckedRow("chk");
		$(sRow.split("|")).each(function(index,value){
			enterCdSabun += ",('" + sheet2.GetCellValue(value,"enterCd") +"','" + sheet2.GetCellValue(value,"sabun") + "')";
			searchSabun  += "," + sheet2.GetCellValue(value,"sabun");
		});

		if( enterCdSabun == "" ){
			alert("<msg:txt mid='109876' mdef='대상자를 선택하세요'/>");
			return;
		}

		var viewYn1  = "Y";
		var viewYn2  = "Y";
		var viewYn3  = "Y";
		var viewYn4  = "Y";
		var viewYn5  = "N";
		var viewYn6  = "N";//타부서발령여부
		
		var viewYn7  = "N";//연락처
		var viewYn8  = "N";//병역
		var viewYn9  = "N";//학력
		var viewYn10 = "N";//경력
		var viewYn11 = "N";//포상
		var viewYn12 = "N";//징계
		var viewYn13 = "N";//자격
		var viewYn14 = "N";//어학
		var viewYn15 = "N";//가족
		var viewYn16 = "N";//발령
		var viewYn17 = "N";//직무
		var fullApp  = "Y";
		var app      = "";
		var rdMrd    = "";

		$(".rdViewType2").each(function(index){
			if( $(this).is(":checked") ) {
				if($(this).val() == "1")	{fullApp = "";	rdMrd = "hrm/empcard/PersonInfoCardType1_HR.mrd";}
				if($(this).val() == "3")	{fullApp = "Y";	rdMrd = "hrm/empcard/PersonInfoCardType2_HR.mrd";}
			}
		});
		
		var itemTypeClass = ".viewType1";
		if( fullApp == "Y" ) {
			itemTypeClass = ".viewType3";
		}
		
		//연락처
		if( $(".rdViewType3", itemTypeClass).is(":checked") ) {
			viewYn7 = "Y";
		}
		//병역
		if( $(".rdViewType4", itemTypeClass).is(":checked") ) {
			viewYn8 = "Y";
		}
		//학력
		if( $(".rdViewType5", itemTypeClass).is(":checked") ) {
			viewYn9 = "Y";
		}
		//평가
		if( $(".rdViewType6", itemTypeClass).is(":checked") ) {
			viewYn5 = "Y";
		}
		//경력
		if( $(".rdViewType7", itemTypeClass).is(":checked") ) {
			viewYn10 = "Y";
		}
		//포상
		if( $(".rdViewType8", itemTypeClass).is(":checked") ) {
			viewYn11 = "Y";
		}
		//징계
		if( $(".rdViewType9", itemTypeClass).is(":checked") ) {
			viewYn12 = "Y";
		}
		//자격
		if( $(".rdViewType10", itemTypeClass).is(":checked") ) {
			viewYn13 = "Y";
		}
		//어학
		if( $(".rdViewType11", itemTypeClass).is(":checked") ) {
			viewYn14 = "Y";
		}
		//가족
		if( $(".rdViewType12", itemTypeClass).is(":checked") ) {
			viewYn15 = "Y";
		}
		//발령
		if( $(".rdViewType13", itemTypeClass).is(":checked") ) {
			viewYn16 = "Y";
		}
		
		//타부서발령여부
		if( $(".rdViewType", itemTypeClass).is(":checked") ) {
			viewYn6 = "Y";
		}
		
		//직무
		if( fullApp == "Y" ) {
			if( $(".rdViewType14", itemTypeClass).is(":checked") ) {
				viewYn17 = "Y";
			}
		}

		var rdTitle = "";
		var rdParam = "";

		var mask = "Y";
		if("${authPg}" == "A") {
			mask = "N";
		}

		rdTitle = "<tit:txt mid='empCard' mdef='인사카드'/>";

		rdParam += "["+ enterCdSabun +"] "; //회사코드, 사번
		rdParam += "[${baseURL}] ";//이미지위치---3
		rdParam += "[" + mask + "] "; //개인정보 마스킹
		rdParam += "["+ viewYn1 +"] "; //인사기본1
		rdParam += "["+ viewYn2 +"] "; //인사기본2
		rdParam += "["+ viewYn3 +"] "; //발령사항
		rdParam += "["+ viewYn4 +"] "; //교육사항
		rdParam += "["+ fullApp +"] "; // 전체발령체크
		rdParam += "[${ssnEnterCd}] ";
		rdParam += "[ '${ssnSabun}' ] ";//rdParam  += "["+searchSabun+"]"; // 사번list->세션사번으로 변경(2016.04.14)
		rdParam += "[${ssnLocaleCd}] ";	// 10.다국어코드
		rdParam += "['"+ searchSabun +"'] "; //사번
		rdParam += "["+ viewYn5 +"] "; //평가
		rdParam += "["+ viewYn6 +"] "; //타부서발령포함

		//신규 화면 제어 파라미터들
		rdParam += "["+ viewYn7 +"] "; //연락처
		rdParam += "["+ viewYn8 +"] "; //병역
		rdParam += "["+ viewYn9 +"] "; //학력
		rdParam += "["+ viewYn10 +"] "; //경력
		rdParam += "["+ viewYn11 +"] "; //포상
		rdParam += "["+ viewYn12 +"] "; //징계
		rdParam += "["+ viewYn13 +"] "; //자격
		rdParam += "["+ viewYn14 +"] "; //어학
		rdParam += "["+ viewYn15 +"] "; //가족
		rdParam += "["+ viewYn16 +"] "; //발령
		rdParam += "["+ viewYn17 +"] "; //직무

		var w		= 900;
		var h		= 1000;
		var url		= "${ctx}/RdPopup.do";
		var args	= new Array();

		args["rdTitle"] = rdTitle ;	//rd Popup제목
		args["rdMrd"] =  rdMrd;		//( 공통경로 /html/report/는 공통에서 처리)업무경로+rd파일명
		args["rdParam"] = rdParam;	//rd파라매터
		args["rdParamGubun"] = "rp";//파라매터구분(rp/rv)
		args["rdToolBarYn"] = "Y" ;	//툴바여부
		args["rdZoomRatio"] = "100";//확대축소비율

		args["rdSaveYn"]	= "Y" ;//기능컨트롤_저장
		args["rdPrintYn"]	= "Y" ;//기능컨트롤_인쇄
		args["rdExcelYn"]	= "Y" ;//기능컨트롤_엑셀
		args["rdWordYn"]	= "Y" ;//기능컨트롤_워드
		args["rdPptYn"]		= "Y" ;//기능컨트롤_파워포인트
		args["rdHwpYn"]		= "Y" ;//기능컨트롤_한글
		args["rdPdfYn"]		= "Y" ;//기능컨트롤_PDF

		pGubun = "rdPopup";
		var win = openPopup(url,args,w,h);//알디출력을 위한 팝업창
	}

	function hideToolbarItem(viewer) {
		const saveValue     = $("#saveYn", parent.document).val();//기능컨트롤_저장
		const printValue    = $("#printYn", parent.document).val();//기능컨트롤_인쇄
		const excelValue    = $("#excelYn", parent.document).val();//기능컨트롤_엑셀
		const wordValue     = $("#wordYn", parent.document).val();//기능컨트롤_워드
		const pptValue      = $("#pptYn", parent.document).val();//기능컨트롤_파워포인트
		const hwpValue      = $("#hwpYn", parent.document).val();//기능컨트롤_한글
		const pdfValue      = $("#pdfYn", parent.document).val();//기능컨트롤_PDF

		if(saveValue !== 'Y') viewer.hideToolbarItem(['ratio', 'save']);
		if(printValue !== 'Y'){
			viewer.hideToolbarItem(['ratio', 'print']);
			viewer.hideToolbarItem(['ratio', 'print_pdf']);
		}
		if(excelValue !== 'Y') viewer.hideToolbarItem(['ratio', 'xls']);
		if(wordValue !== 'Y') viewer.hideToolbarItem(['ratio', 'doc']);
		if(pptValue !== 'Y') viewer.hideToolbarItem(['ratio', 'ppt']);
		if(hwpValue !== 'Y') viewer.hideToolbarItem(['ratio', 'hwp']);
		if(pdfValue !== 'Y') viewer.hideToolbarItem(['ratio', 'pdf']);
	}

	// /**
	//  * 레포트 iframe 레이어 열기
	//  */
	// function rdLayer(){
	// 	const args = createRdData();
	// 	window.top.openLayer(
	// 		'/EmpCardPrt2.do?cmd=viewRdLayer'
	// 		, args, 900, 800, 'initLayer'
	// 	);
	// }

	/**
	 * 레포트 열기
	 */
	function showRd(){

		let checkedRowsCount = sheet2.CheckedRows('chk');
		if(checkedRowsCount === 0){
			alert('<msg:txt mid="109876" mdef="대상자를 선택하세요" />');
			return;
		}

		let searchEnterCdSabunStr = '';
		let searchSabunStr = '';
	    let rkList = [];
		let checkedRows = sheet2.FindCheckedRow('chk');
		$(checkedRows.split("|")).each(function(index,value){
			searchEnterCdSabunStr += ',(\'' + sheet2.GetCellValue(value, 'enterCd') + '\',\'' + sheet2.GetCellValue(value, 'sabun') + '\')';
			searchSabunStr += ',' + sheet2.GetCellValue(value, 'sabun');
			rkList[index] = sheet2.GetCellValue(value, 'rk');
		});

		let itemType = '2';
		let itemTypeClass = '.viewType1';
		$(".rdViewType2").each(function(index){
			if(!$(this).is(":checked")) return;
			if($(this).val() === '3'){//전체
				itemType = '1';
				itemTypeClass = '.viewType3';
			}else{//요약
				itemType = '2';
				itemTypeClass = '.viewType1';
			}
		});

		let parameters = Utils.encase(searchEnterCdSabunStr) + ' ';
		parameters += Utils.encase('${imageBaseUrl}') + ' ';//image base url
		parameters += Utils.encase(('${authPg}' === 'A') ? 'N' : 'Y') + ' ';//마스킹 여부
		parameters += Utils.encase('Y') + ' ';//hrbasic1
		parameters += Utils.encase('Y') + ' ';//hrbasic2
		parameters += Utils.encase('Y') + ' ';//발령사항
		parameters += Utils.encase('Y') + ' ';//교육사항
		parameters += Utils.encase((itemType === '1') ? 'Y' : '') + ' ';//전체발령표시여부
		parameters += Utils.encase('${ssnEnterCd}') + ' ';
		parameters += Utils.encase(' \'' + '${ssnSabun}' + '\' ') + ' ';
		parameters += Utils.encase('${ssnLocaleCd}') + ' ';
		parameters += Utils.encase('\'' + searchSabunStr + '\'') + ' ';
		parameters += Utils.encase(($(".rdViewType6", itemTypeClass).is(":checked")) ? 'Y' : 'N') + ' ';//평가
		parameters += Utils.encase(($(".rdViewType", itemTypeClass).is(":checked")) ? 'Y' : 'N') + ' ';//타부서발령여부
		parameters += Utils.encase(($(".rdViewType3", itemTypeClass).is(":checked")) ? 'Y' : 'N') + ' ';//연락처
		parameters += Utils.encase(($(".rdViewType4", itemTypeClass).is(":checked")) ? 'Y' : 'N') + ' ';//병역
		parameters += Utils.encase(($(".rdViewType5", itemTypeClass).is(":checked")) ? 'Y' : 'N') + ' ';//학력
		parameters += Utils.encase(($(".rdViewType7", itemTypeClass).is(":checked")) ? 'Y' : 'N') + ' ';//경력
		parameters += Utils.encase(($(".rdViewType8", itemTypeClass).is(":checked")) ? 'Y' : 'N') + ' ';//포상
		parameters += Utils.encase(($(".rdViewType9", itemTypeClass).is(":checked")) ? 'Y' : 'N') + ' ';//징계
		parameters += Utils.encase(($(".rdViewType10", itemTypeClass).is(":checked")) ? 'Y' : 'N') + ' ';//자격
		parameters += Utils.encase(($(".rdViewType11", itemTypeClass).is(":checked")) ? 'Y' : 'N') + ' ';//어학
		parameters += Utils.encase(($(".rdViewType12", itemTypeClass).is(":checked")) ? 'Y' : 'N') + ' ';//가족
		parameters += Utils.encase(($(".rdViewType13", itemTypeClass).is(":checked")) ? 'Y' : 'N') + ' ';//발령
		parameters += Utils.encase((itemType === '1' && $(".rdViewType14", itemTypeClass).is(":checked")) ? 'Y' : 'N') + ' ';//경력
		
		//showRdLayer 암호화로 인해 새로 파라미터 받기 
		let param = null;
		
        var maskingYn = ('${authPg}' === 'A') ? 'N' : 'Y';
        var hrAppt    =   (itemType === '1') ? 'Y' : '';
        var rdViewType6  = (($(".rdViewType6", itemTypeClass).is(":checked")) ? 'Y'  : 'N') ;
        var rdViewType   = (($(".rdViewType", itemTypeClass).is(":checked")) ? 'Y'   : 'N') ;
        var rdViewType3  = (($(".rdViewType3", itemTypeClass).is(":checked")) ? 'Y'  : 'N') ;
        var rdViewType4  = (($(".rdViewType4", itemTypeClass).is(":checked")) ? 'Y'  : 'N') ;
        var rdViewType5  = (($(".rdViewType5", itemTypeClass).is(":checked")) ? 'Y'  : 'N') ;
        var rdViewType7  = (($(".rdViewType7", itemTypeClass).is(":checked")) ? 'Y'  : 'N') ;
        var rdViewType8  = (($(".rdViewType8", itemTypeClass).is(":checked")) ? 'Y'  : 'N') ;
        var rdViewType9  = (($(".rdViewType9", itemTypeClass).is(":checked")) ? 'Y'  : 'N') ;
        var rdViewType10 = (($(".rdViewType10", itemTypeClass).is(":checked")) ? 'Y' : 'N') ;
        var rdViewType11 = (($(".rdViewType11", itemTypeClass).is(":checked")) ? 'Y' : 'N') ;
        var rdViewType12 = (($(".rdViewType12", itemTypeClass).is(":checked")) ? 'Y' : 'N') ;
        var rdViewType13 = (($(".rdViewType13", itemTypeClass).is(":checked")) ? 'Y' : 'N') ;
        var rdViewType14 = ((itemType === '1' && $(".rdViewType14", itemTypeClass).is(":checked")) ? 'Y' : 'N') ;
		
		
		//암호화 할 데이터 생성
		const data = {
				  rk : rkList
	            , maskingYn : maskingYn
	            , hrAppt : hrAppt 
	            , rdViewType6  : rdViewType6 
	            , rdViewType   : rdViewType  
	            , rdViewType3  : rdViewType3 
	            , rdViewType4  : rdViewType4 
	            , rdViewType5  : rdViewType5 
	            , rdViewType7  : rdViewType7 
	            , rdViewType8  : rdViewType8 
	            , rdViewType9  : rdViewType9 
	            , rdViewType10 : rdViewType10
	            , rdViewType11 : rdViewType11
	            , rdViewType12 : rdViewType12
	            , rdViewType13 : rdViewType13
	            , rdViewType14 : rdViewType14
		};

		window.top.showRdLayer('/EmpCardPrt2.do?cmd=getEncryptRd', data, null, "인사카드");
		
		/*
		const result = ajaxTypeJson('/EmpCardPrt2.do?cmd=getEncryptRd', data, false);
		console.log(result.DATA.path); 
		console.log(result.DATA.encryptParameter);
		*/
	}

</script>

<!-- sheet1 -->
<script type="text/javascript">
	function initSheet1() {try{
		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center", ColMerge:0,	SaveName:"sNo" },

			{Header:"<sht:txt mid='check' mdef='선택'/>",		Type:"DummyCheck",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"chk",			KeyField:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='appEnterCdV1' mdef='회사'/>",		Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"enterCd",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='appOrgNmV5' mdef='소속'/>",			Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",	Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='hochingNm' mdef='호칭'/>",		Type:"Text",		Hidden:Number("${aliasHdn}"),	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"alias",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='jikgubCd' mdef='직급'/>",		Type:"Combo",		Hidden:Number("${jgHdn}"),	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"jikgubCd",	KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",		Type:"Combo",		Hidden:Number("${jwHdn}"),	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"jikweeCd",	KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='jobCd' mdef='직무'/>",	 		Type:"Combo",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"jobCd",	KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='statusCdV5' mdef='재직상태'/>",	Type:"Combo",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"statusCd",	KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='rk' mdef='rk'/>",                Type:"Text",       Hidden:1,   Width:0,   Align:"Center", ColMerge:0, SaveName:"rk",           KeyField:0, UpdateEdit:0,   InsertEdit:0,   EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetCountPosition(4); sheet1.SetUnicodeByte(3);

		sheet1.SetColProperty("enterCd",	{ComboText:"|"+enterCdList[0], ComboCode:"|"+enterCdList[1]} );
		sheet1.SetColProperty("jikgubCd",	{ComboText:"|"+jikgubCdList[0], ComboCode:"|"+jikgubCdList[1]} );
		sheet1.SetColProperty("jikweeCd",	{ComboText:"|"+jikweeCdList[0], ComboCode:"|"+jikweeCdList[1]} );
		//sheet1.SetColProperty("jobCd",	{ComboText:"|"+jobCdList[0], ComboCode:"|"+jobCdList[1]} );
		sheet1.SetColProperty("statusCd",	{ComboText:"|"+statusCdList[0], ComboCode:"|"+statusCdList[1]} );

		$(window).smartresize(sheetResize); sheetInit();
	}catch(e){alert("initSheet1::" + e)}}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":

			if($('#searchType').val() == "O") {
				sheet1.DoSearch( "${ctx}/EmpCardPrt2.do?cmd=getEmpCardPrt2AuthList", $("#sheetForm").serialize() );
			} else {
				sheet1.DoSearch( "${ctx}/EmpCardPrt2.do?cmd=getEmpCardPrt2List", $("#sheetForm").serialize() );
			}
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
</script>

<!-- sheet2 -->
<script type="text/javascript">
	function initSheet2() {try{
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center", ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"<sht:txt mid='check' mdef='선택'/>",		Type:"DummyCheck",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"chk",			KeyField:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='appEnterCdV1' mdef='회사'/>",		Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"enterCd",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='appOrgNmV5' mdef='소속'/>",			Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",	Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",		Type:"Combo",		Hidden:Number("${jwHdn}"),	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"jikweeCd",	KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='jikgubCd' mdef='직급'/>",		Type:"Combo",		Hidden:Number("${jgHdn}"),	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"jikgubCd",	KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"",			Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"findText",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1000 },
			{Header:"<sht:txt mid='rk' mdef='rk'/>",                Type:"Text",       Hidden:1,   Width:0,   Align:"Center", ColMerge:0, SaveName:"rk",           KeyField:0, UpdateEdit:0,   InsertEdit:0,   EditLen:100 }
		]; IBS_InitSheet(sheet2, initdata);sheet2.SetEditable("${editable}");sheet2.SetCountPosition(4); sheet2.SetUnicodeByte(3);

		sheet2.SetColProperty("enterCd",	{ComboText:""+enterCdList[0], ComboCode:""+enterCdList[1]} );
		sheet2.SetColProperty("jikgubCd",	{ComboText:"|"+jikgubCdList[0], ComboCode:"|"+jikgubCdList[1]} );
		sheet2.SetColProperty("jikweeCd",	{ComboText:"|"+jikweeCdList[0], ComboCode:"|"+jikweeCdList[1]} );
		
		//Autocomplete
		$(sheet2).sheetAutocomplete({
			Columns: [
				{
					ColSaveName  : "name",
					CallbackFunc : function(returnValue){
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet2.SetCellValue(gPRow, "enterCd",	rv["enterCd"]);
						sheet2.SetCellValue(gPRow, "sabun",		rv["sabun"]);
						sheet2.SetCellValue(gPRow, "name",		rv["name"]);
						sheet2.SetCellValue(gPRow, "orgNm",		rv["orgNm"]);
						sheet2.SetCellValue(gPRow, "jikweeCd",	rv["jikweeCd"]);
						sheet2.SetCellValue(gPRow, "jikgubCd",	rv["jikgubCd"]);
						sheet2.SetCellValue(gPRow, "jikweeCd",	rv["jikweeCd"]);
						// rd key

						var data = ajaxCall("/EmpCardPrt2.do?cmd=getEmpCardPrtRk", rv, false);
						if ( data != null && data.DATA != null ){
							sheet2.SetCellValue(gPRow, "rk",	data.DATA.rk);
						}
					}
				}
			]
		});

		$(window).smartresize(sheetResize); sheetInit();
	}catch(e){alert("initSheet2::" + e)}}

	//Sheet Action
	function doAction2(sAction) {
		//var searchEnterCd = (sheet1.GetSelectRow() < 0)? "" : sheet1.GetCellValue(sheet1.GetSelectRow(), "enterCd");
		var searchSabun = (sheet1.GetSelectRow() < 0)? "" : sheet1.GetCellValue(sheet1.GetSelectRow(), "sabun");

		switch (sAction) {
		case "Insert":
			var Row = sheet2.DataInsert(0);
			sheet2.SelectCell(Row, "name");
			break;
		case "Clear":		sheet2.RemoveAll(); break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet2);
			var param	= {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet2.Down2Excel(param); break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet2.LoadExcel(params); break;
		case "DownTemplate":
			// 양식다운로드
			sheet2.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"4|6"});
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") { alert(Msg); }
			if (Code != "-1") { doAction2("Search"); }
		} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet2_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			if (Shift == 1 && KeyCode == 45) { doAction2("Insert"); }	// Insert KEY
			if (Shift == 1 && KeyCode == 46 && sheet2.GetCellValue(Row, "sStatus") == "I") { sheet2.SetCellValue(Row, "sStatus", "D"); }	//Delete KEY
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	function sheet2_OnLoadExcel(result) {
		try {
			if (!result) {
				alert("엑셀 로딩중 오류가 발생하였습니다.");
				return;
			}
			for (var i = sheet2.HeaderRows(); i < sheet2.RowCount() + sheet2.HeaderRows(); i++) {
				const param = {
					"enterCd" : sheet2.GetCellValue(i, 'enterCd'),
					"sabun" : sheet2.GetCellValue(i, 'sabun')
				};
				const data = ajaxCall("/EmpCardPrt2.do?cmd=getEmpCardPrtRk", param, false);
				if ( data != null && data.DATA != null ){
					sheet2.SetCellValue(i, "rk", data.DATA.rk);
				}

			}
		} catch (ex) {
			alert("sheet2_OnLoadExcel Event Error : " + ex);
		}
	}

	function orgSearchPopup(){
		try{
			var args = new Array();
			args["searchJobType"] = "10030";
			let layerModal = new window.top.document.LayerModal({
				id : 'jobSchemeLayer'
				, url : '/Popup.do?cmd=viewJobSchemeLayer&authPg=R'
				, parameters : {
					searchJobType : '10030'
				}
				, width : 800
				, height : 520
				, title : '직무분류표 조회'
				, trigger :[
					{
						name : 'jobSchemeTrigger'
						, callback : function(result){
							$("#searchJobCd").val(result.jobCd);
							$("#searchJobNm").val(result.jobNm);
						}
					}
				]
			});
			layerModal.show();

		}catch(ex){alert("Open Popup Event Error : " + ex);}
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">

	<form id="sheetForm" name="sheetForm" >
		<input id="searchType" name="searchType" type="hidden" value="${ssnSearchType}">

		<div class="sheet_search outer">
			<div>
			<table>
			<tr>
			<%--
				<td> <span><tit:txt mid='114232' mdef='회사'/></span> <select id="searchEnterCd" name="searchEnterCd" class="w150"></select> </td>

				<td>
					<span><tit:txt mid='104279' mdef='소속'/></span>
					<input id="searchOrgCd" name ="searchOrgCd" type="hidden" class="text w100"  />
					<input id="searchOrgNm" name ="searchOrgNm" type="text" class="text w100" readonly />
					<a onclick="javascript:showOrgPopup();return false;" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
					<a onclick="$('#searchOrgCd,#searchOrgNm').val('');return false;" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
				</td>
				--%>
				<th><tit:txt mid='114232' mdef='회사'/></th>
				<td>  <select id="searchEnterCd" name="searchEnterCd" class="w150"></select> </td>
				<th><tit:txt mid='104279' mdef='소속'/></th>
				<td>  <input type="text" id="searchOrgNm" name="searchOrgNm" class="text"/></td>
				<th><tit:txt mid='104330' mdef='사번/성명'/></th>
				<td>  <input id="searchName" name="searchName" type="text" class="text"/> </td>
				<td>
			<c:choose>
				<c:when test="${ssnSearchType == 'O'}">
					<input id="searchAdminYn" name="searchAdminYn" type="hidden" value="O">
					<input id="searchStatusCd" name="searchStatusCd" type="hidden" value="RA">
				</c:when>
				<c:otherwise>
					<input id="searchAdminYn" name="searchAdminYn" type="hidden" value="A">
					<input id="searchStatusCd" name="searchStatusCd" type="radio" value="RA" checked><font style="vertical-align:middle;">&nbsp;<tit:txt mid='113521' mdef='퇴직자 제외'/>&nbsp;&nbsp;</font>
					<input id="searchStatusCd" name="searchStatusCd" type="radio" value="" ><font style="vertical-align:middle;">&nbsp;<tit:txt mid='114221' mdef='퇴직자 포함'/></font>
				</c:otherwise>
			</c:choose>
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='104104' mdef='직위'/></th>
				<td>  <select id="searchJikweeCd" name="searchJikweeCd" class="w150"></select> </td>
				<th><tit:txt mid='103973' mdef='직무'/></th>
				<td>
					<input type="hidden" id="searchJobCd" name="searchJobCd" class="text" value="" />
					<input type="text" id="searchJobNm" name="searchJobNm" class="text" value="" readonly="readonly" style="width:120px" />
					<a onclick="javascript:orgSearchPopup();return false;" class="button6"><img src="/common/${theme}/images/btn_search2.gif" /></a>
					<a onclick="$('#searchJobCd,#searchJobNm').val('');return false;" class="button7"><img src="/common/${theme}/images/icon_undo.gif" /></a>
				</td>
				<th class="hdnYmd" style="display:none;"><tit:txt mid='113397' mdef='퇴직일자'/></th>
				<td class="hdnYmd" style="display:none;">
					<input id="searchRetSYmd" name="searchRetSYmd" type="text" class="date2" style="width:60px"> ~
					<input id="searchRetEYmd" name="searchRetEYmd" type="text" class="date2" style="width:60px">
				</td>
				<td>
					<btn:a href="javascript:doAction('Search');" css="btn dark" mid='110697' mdef="조회"/>
				</td>
			</tr>
			<tr>
				<td colspan="4">
					<%--
					<span><tit:txt mid='113910' mdef='개인정보 마스킹'/></span><input id="regPrintYn" name="regPrintYn" type="checkbox" class="checkbox" checked/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<span><tit:txt mid='113911' mdef='기본사항Ⅰ'/></span><input id="prntOptn1" name="prntOptn1" type="checkbox" class="checkbox" checked/>&nbsp;&nbsp;
					<span><tit:txt mid='112152' mdef='기본사항Ⅱ'/></span><input id="prntOptn2" name="prntOptn2" type="checkbox" class="checkbox" checked/>&nbsp;&nbsp;
					<span><tit:txt mid='112796' mdef='발령사항'/></span><input id="prntOptn3" name="prntOptn3" type="checkbox" class="checkbox" checked/>&nbsp;&nbsp;
					--%>
					<input name="rdViewType2" type="radio" value="3" class="rdViewType2" checked/><font style="vertical-align:middle;">&nbsp;전체</font>
					&nbsp;&nbsp;
					<input name="rdViewType2" type="radio" value="1" class="rdViewType2"/><font style="vertical-align:middle;">&nbsp;요약</font>
					<span class="rd_summary viewType3">
						<input name="rdViewType3"  type="checkbox" class="rdViewType3"  style="vertical-align: middle; margin-left: 3px;" checked="checked" /> 연락처
						<input name="rdViewType5"  type="checkbox" class="rdViewType5"  style="vertical-align: middle; margin-left: 3px;" checked="checked" /> 학력
						<input name="rdViewType6"  type="checkbox" class="rdViewType6"  style="vertical-align: middle; margin-left: 3px;" checked="checked" /> 평가
						<input name="rdViewType14" type="checkbox" class="rdViewType14" style="vertical-align: middle; margin-left: 3px;" checked="checked" /> 직무
						<input name="rdViewType7"  type="checkbox" class="rdViewType7"  style="vertical-align: middle; margin-left: 3px;" checked="checked" /> 경력
						<input name="rdViewType8"  type="checkbox" class="rdViewType8"  style="vertical-align: middle; margin-left: 3px;" checked="checked" /> 포상
						<input name="rdViewType9"  type="checkbox" class="rdViewType9"  style="vertical-align: middle; margin-left: 3px;" checked="checked" /> 징계
						<input name="rdViewType10" type="checkbox" class="rdViewType10" style="vertical-align: middle; margin-left: 3px;" checked="checked" /> 자격
						<input name="rdViewType11" type="checkbox" class="rdViewType11" style="vertical-align: middle; margin-left: 3px;" checked="checked" /> 어학
						<input name="rdViewType12" type="checkbox" class="rdViewType12" style="vertical-align: middle; margin-left: 3px;" checked="checked" /> 가족
						<input name="rdViewType13" type="checkbox" class="rdViewType13" style="vertical-align: middle; margin-left: 3px;" checked="checked" /> 발령
						<!-- 
						<input name="rdViewType4"  type="checkbox" class="rdViewType4"  style="vertical-align: middle; margin-left: 3px;" checked="checked" /> 병역
						<input name="rdViewType"   type="checkbox" class="rdViewType"   style="vertical-align: middle; margin-left: 3px;" value="1" /> 타사발령포함
						-->
					</span>
					<span class="rd_summary viewType1 hide">
						[
						<input name="rdViewType3"  type="checkbox" class="rdViewType3"  style="vertical-align: middle; margin-left: 3px;" checked="checked" together-item="" /> 연락처
						<input name="rdViewType5"  type="checkbox" class="rdViewType5"  style="vertical-align: middle; margin-left: 3px;" checked="checked" together-item="rdViewType3" /> 학력
						]
						&nbsp;&nbsp;
						[
						<input name="rdViewType12" type="checkbox" class="rdViewType12" style="vertical-align: middle; margin-left: 3px;" checked="checked" together-item="" /> 가족
						<input name="rdViewType7"  type="checkbox" class="rdViewType7"  style="vertical-align: middle; margin-left: 3px;" checked="checked" together-item="rdViewType12" /> 경력
						]
						&nbsp;&nbsp;
						[
						<input name="rdViewType10" type="checkbox" class="rdViewType10" style="vertical-align: middle; margin-left: 3px;" checked="checked" together-item="" /> 자격
						<input name="rdViewType8"  type="checkbox" class="rdViewType8"  style="vertical-align: middle; margin-left: 3px;" checked="checked" together-item="rdViewType10" /> 포상
						]
						&nbsp;&nbsp;
						[
						<input name="rdViewType11" type="checkbox" class="rdViewType11" style="vertical-align: middle; margin-left: 3px;" checked="checked" together-item="" /> 어학
						<input name="rdViewType9"  type="checkbox" class="rdViewType9"  style="vertical-align: middle; margin-left: 3px;" checked="checked" together-item="rdViewType11" /> 징계
						]
						&nbsp;&nbsp;
						[
						<input name="rdViewType6"  type="checkbox" class="rdViewType6"  style="vertical-align: middle; margin-left: 3px;" checked="checked" together-item="" /> 평가
						]
						&nbsp;&nbsp;
						[
						<input name="rdViewType13" type="checkbox" class="rdViewType13" style="vertical-align: middle; margin-left: 3px;" checked="checked" together-item="" /> 발령
						]
						<!-- 
						<input name="rdViewType4"  type="checkbox" class="rdViewType4"  style="vertical-align: middle; margin-left: 3px;" checked="checked" /> 병역
						<input name="rdViewType"   type="checkbox" class="rdViewType"   style="vertical-align: middle; margin-left: 3px;" value="1" /> 타사발령포함
						-->
					</span>
				</td>
			</tr>
			</table>
			</div>
		</div>
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<colgroup>
			<col width="50%" />
			<col width="35px" />
			<col width="%" />
		</colgroup>
		<tr>
			<td class="">
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='113529' mdef='조회결과'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction1('Down2Excel')"	css="btn outline_gray authR" mid='110698' mdef="다운로드"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
			</td>
			<td class="sheet_arrow text-center">
				<a href="javascript:doAction('Add');" class="btn outline_gray icon authA"><i class="mdi-ico">chevron_right</i></a>
				<a href="javascript:doAction('Del');" class="btn outline_gray icon authA"><i class="mdi-ico">chevron_left</i></a>
			</td>
			<td class="sheet_right">
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='113182' mdef='출력대상자'/></li>
							<li class="btn">

								<btn:a href="javascript:doAction2('DownTemplate')" 	css="btn outline_gray authA" mid='110702' mdef="양식다운로드"/>								
								<btn:a href="javascript:doAction2('LoadExcel')"		css="btn outline_gray authA" mid='110703' mdef="업로드"/>
								<btn:a href="javascript:doAction2('Insert')" 		css="btn outline_gray authA" mid='110700' mdef="입력"/>
								<btn:a href="javascript:doAction2('Clear')" 		css="btn outline_gray authA" mid='110754' mdef="초기화"/>
<%--								<btn:a href="javascript:rdPopup()"					css="basic authA" mid='111360' mdef="인사카드출력"/>--%>
<%--								<btn:a href="javascript:rdLayer()"					css="basic authA" mid='111360' mdef="인사카드출력"/>--%>
								<btn:a href="javascript:showRd()"					css="btn outline_gray authA" mid='111360' mdef="인사카드출력"/>
								<btn:a href="javascript:doAction2('Down2Excel')"	css="btn outline_gray authR" mid='110698' mdef="다운로드"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet2", "100%", "100%","${ssnLocaleCd}"); </script>
			</td>

		</tr>
	</table>

</div>
</body>
</html>
