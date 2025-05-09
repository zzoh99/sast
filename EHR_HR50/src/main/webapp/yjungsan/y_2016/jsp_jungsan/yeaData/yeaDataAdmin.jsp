<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html> <html class="hidden"><head> <title>소득공제자료등록</title>
<%@ include file="../common/include/session.jsp"%>
<%
	authPg = "A";
%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var totPayViewYn = "N" ;
$(function() {
	//세액계산,결과 권한 조회
    var simYn = ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&searchStdCd=CPN_YEA_SIM_YN", "queryId=getSystemStdData",false).codeList;
    if(simYn[0].code_nm != "N") {
        $("#spanSimYn").show();
    } else {
        $("#spanSimYn").hide();
    }
});
</script>

</head>
<body class="bodywrap">
<div id="progressCover" style="display:none;position:absolute;top:0;bottom:0;left:0;right:0;background:url(<%=imagePath%>/common/process.png) no-repeat 50% 50%; z-index:99;"></div>
<div class="wrapper">
	<%@ include file="../common/include/employeeHeaderYtax.jsp"%>
	<div class="sheet_search outer" style="margin-top:8px; ">
	<form id="mainForm" name="mainForm">
		<input type="hidden" id="searchWorkYy" name="searchWorkYy" value="" />
		<input type="hidden" id="searchSabun" name="searchSabun" value="" />
		<input type="hidden" id="searchRegNo" name="searchRegNo" value="" />
		<div>
		<table>
		<tr>
			<td>
				<span class="left"><span name="spanYy" id="spanYy"></span>
				<select id="searchAdjustType" name ="searchAdjustType" onChange="javascript:showIframe();" class="box"></select>
				<span id="span_clearYnCheck" style="margin-left:10px;"></span>
				<a href="javascript:openUnusualPopup();" class="cute">특이사항</a>
				<span id="span_feedback" style="margin-left:2px;"></span>
				<a href="javascript:openFeedbackPopup();"	class="cute" style="background:rgb(58, 183, 198);">담당자 피드백</a>
			</td>
			<td>
				<div class="inner" id="div_button">
					<div class="sheet_title" style="white-space:nowrap;overflow:hidden;">
					<ul>
						<li class="right">
							<span id="spanMagam" style="display:none;"><a href="javascript:doAction('InputClose');"		class="basic" style="border:2px solid #FF8080;">담당자마감</a></span>
							<span id="spanMagamCancel" style="display:none;"><a href="javascript:doAction('CancelClose');"		class="basic">담당자마감취소</a></span>
							<span id="spanSimYn" style="display:none;">
								<a href="javascript:doAction('TaxCalc');"		class="basic">세액계산/결과보기</a>
							</span>
							<a href="javascript:openPrint();"		class="button">소득공제서</a>
							<a href="javascript:doReport('CARD');"		class="button">신용카드등</a>
							<a href="javascript:doReport('DONATION');"	class="button">기부금명세서</a>
							<a href="javascript:doReport('MEDICAL');"	class="button">의료비명세서</a>
							<a href="javascript:payViewYn();"		class="basic">총급여확인</a>
						</li>
					</ul>
					</div>
				</div>
			</td>
			<td><span id="totPay" name="totPay" style="display:none"></span></td>
		</tr>
		</table>
		</div>
	</form>
	</div>
	
	<div class="insa_tab" style="top:120px;" id="div_insa_tab">
		<div id="tabs" class="tab">
			<ul></ul>
		</div>
	</div>
	<span class="hide">
		<script type="text/javascript">createIBSheet("commonSheet", "100%", "100%"); </script>
	</span>
</div>

<div id="div_header_view" class="right" style="position:absolute; top:107px; width:100%;" >
	<a href="javascript:headerView('hide');">▲</a>		
 	<a href="javascript:headerView('show');">▼</a>		
</div>
</body>

<script type="text/javascript">
	var waitFlag	= false;

	//기본자료 공통 쉬트
	function createCommonSheet() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",			Type:"<%=sNoTy%>",	Hidden:<%=sNoHdn%>,	Width:"<%=sNoWdt%>",	Align:"Center",	ColMerge:1,	SaveName:"sNo" },
			{Header:"삭제",			Type:"<%=sDelTy%>",	Hidden:<%=sDelHdn%>,Width:"<%=sDelWdt%>",	Align:"Center",	ColMerge:1,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",			Type:"<%=sSttTy%>",	Hidden:<%=sSttHdn%>,Width:"<%=sSttWdt%>",	Align:"Center",	ColMerge:1,	SaveName:"sStatus",	Sort:0 },
			{Header:"년도",			Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"work_yy",				KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4 },
			{Header:"정산구분",			Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"adjust_type",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"사번",			Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sabun",				KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"정산항목코드",		Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"adj_element_cd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"자료여부",			Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"data_yn",				KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			{Header:"자료금액",			Type:"Int",			Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"data_mon",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"자료인원",			Type:"Int",			Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"data_cnt",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"입력금액",			Type:"Int",			Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"input_mon",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"사업장코드",		Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"business_place_cd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 }
		]; IBS_InitSheet(commonSheet, initdata);commonSheet.SetEditable(false);commonSheet.SetVisible(false);commonSheet.SetCountPosition(4);
	}

	//기본공제,추가공제 조회
	function doSearchCommonSheet() {
		commonSheet.DoSearch( "<%=jspPath%>/yeaData/yeaDataRst.jsp?cmd=selectCommonSheetList", $("#mainForm").serialize() );
	}

	//기본공제,추가공제 추가
	function doInsertCommonSheet(elementCd, inputMonValue) {
		var elementCdIdx = commonSheet.FindText("adj_element_cd", elementCd);

		if(elementCdIdx == -1) {
			var newRow = commonSheet.DataInsert(0);
			commonSheet.SetCellValue( newRow, "adj_element_cd", elementCd ) ;
			commonSheet.SetCellValue( newRow, "work_yy", $("#searchWorkYy").val() ) ;
			commonSheet.SetCellValue( newRow, "adjust_type", $("#searchAdjustType").val() ) ;
			commonSheet.SetCellValue( newRow, "sabun", $("#searchSabun").val() ) ;
			commonSheet.SetCellValue( newRow, "input_mon", inputMonValue ) ;
		} else {
			commonSheet.SetCellValue(elementCdIdx,"input_mon", inputMonValue) ;
		}
	}

	//기본공제,추가공제 저장
	function doSaveCommonSheet() {
		if(!checkClose())return;

		commonSheet.DoSave( "<%=jspPath%>/yeaData/yeaDataRst.jsp?cmd=saveCommonSheet" );
	}

	//조회 후 에러 메시지
	function commonSheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);

			if(Code == 1) {
				getIframeContent(newIframe[0]).sheetSet();
			}
		} catch (ex) {
		}
	}

	//저장 후 메시지
	function commonSheet_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);
			getYearDefaultInfoObj();
			if(Code == 1) {
				doSearchCommonSheet();
			}
		} catch(ex) {
		}
	}

	function getIframeContent(ifrm) {
		return ifrm.contentWindow || ifrm.contentDocument;
	}
</script>

<script type="text/javascript">

	var newIframe;
	var oldIframe;
	var iframeIdx;
	var tabObj;

	$(function() {
		$("#searchSabun").val( $("#searchUserId").val() ) ;
		$("#searchRegNo").val( $("#searchRegNo_").val() ) ;

		//기준년도 조회
		//var baseYear = ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&searchStdCd=CPN_YEAREND_YY", "queryId=getSystemStdData",false).codeList;
		//$("#searchWorkYy").val(baseYear[0].code_nm) ;
		$("#searchWorkYy").val("<%=yeaYear%>") ;

		$("#spanYy").text( $("#searchWorkYy").val() ) ;

		var adjustTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00303"), "");
		$("#searchAdjustType").html(adjustTypeList[2]);

		tabObj = $( "#tabs" ).tabs({
			beforeActivate: function(event, ui) {
				if( -1 < ui.oldTab.index() ) {
					try{
						if( $(ui.oldPanel).find('iframe')[0].contentWindow.sheetChangeCheck() ) {
							if ( !confirm("현재 화면에서 저장되지 않은 내역이 있습니다.\n\n무시하고 이동하시겠습니까? ") ) {
								return false;
							}
						}
					} catch(e) {}
				}

				iframeIdx = ui.newTab.index();
				newIframe = $(ui.newPanel).find('iframe');
				oldIframe = $(ui.oldPanel).find('iframe');
				showIframe();
			}
		});

		createCommonSheet();
		createTabFrame();

	});
	
	function payViewYn() {
		if(totPayViewYn == "Y") { $("#totPay").hide() ; totPayViewYn = "N" } 
		else { $("#totPay").show() ; totPayViewYn = "Y" }
	}
	
	function getTotPay() {//총급여 조회
	    var param2 = "searchWorkYy="+$("#searchWorkYy").val();
	    param2 += "&searchAdjustType="+$("#searchAdjustType").val();
	    param2 += "&searchSabun="+$("#searchSabun").val();
	    param2 += "&queryId=getYeaDataPayTotMon";
	    var result2 = ajaxCall("<%=jspPath%>/common/commonSelect.jsp?cmd=commonSelectMap",param2+"&searchNumber=1",false);
	    var paytotMonStr = nvl(result2.Data.paytot_mon,"");
	    $("#totPay").html("<font color='red'> [ " + paytotMonStr + "원 ]</font>") ;
	}

	// 탭 생성
	function createTabFrame() {

		tabObj.find(".ui-tabs-nav")
		.append("<li><a href='#tabs-1' id='tabs1'>기본_주소사항</a></li>")
		.append("<li><a href='#tabs-2' id='tabs2'>인적공제</a></li>")
		.append("<li><a href='#tabs-3' id='tabs3'>PDF등록</a></li>")
		.append("<li><a href='#tabs-4' id='tabs4'>보험료</a></li>")
		.append("<li><a href='#tabs-5' id='tabs5'>주택자금</a></li>")
		.append("<li class='hide'><a href='#tabs-6' id='tabs6'>주택자금2</a></li>")
		.append("<li><a href='#tabs-7' id='tabs7'>저축</a></li>")
		.append("<li><a href='#tabs-8' id='tabs8'>신용카드</a></li>")
		.append("<li><a href='#tabs-9' id='tabs9'>기타소득공제</a></li>")
		.append("<li><a href='#tabs-10' id='tabs10'>연금계좌</a></li>")
		.append("<li><a href='#tabs-11' id='tabs11'>의료비</a></li>")
		.append("<li><a href='#tabs-12' id='tabs12'>교육비</a></li>")
		.append("<li><a href='#tabs-13' id='tabs13'>기부금</a></li>")
		.append("<li><a href='#tabs-14' id='tabs14'>세액감면/기타세액공제</a></li>")
		.append("<li><a href='#tabs-15' id='tabs15'>연간소득</a></li>")
		.append("<li><a href='#tabs-16' id='tabs16'>종전근무지</a></li>")
		;
		
		tabObj
		.append("<div id='tabs-1'><div class='layout_tabs'><iframe src='<%=jspPath%>/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe></div></div>")
		.append("<div id='tabs-2'><div class='layout_tabs'><iframe src='<%=jspPath%>/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe></div></div>")
		.append("<div id='tabs-3'><div class='layout_tabs'><iframe src='<%=jspPath%>/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe></div></div>")
		.append("<div id='tabs-4'><div class='layout_tabs'><iframe src='<%=jspPath%>/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe></div></div>")
		.append("<div id='tabs-5'><div class='layout_tabs'><iframe src='<%=jspPath%>/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe></div></div>")
		.append("<div id='tabs-6'><div class='layout_tabs'><iframe src='<%=jspPath%>/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe></div></div>")
		.append("<div id='tabs-7'><div class='layout_tabs'><iframe src='<%=jspPath%>/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe></div></div>")
		.append("<div id='tabs-8'><div class='layout_tabs'><iframe src='<%=jspPath%>/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe></div></div>")
		.append("<div id='tabs-9'><div class='layout_tabs'><iframe src='<%=jspPath%>/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe></div></div>")
		.append("<div id='tabs-10'><div class='layout_tabs'><iframe src='<%=jspPath%>/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe></div></div>")
		.append("<div id='tabs-11'><div class='layout_tabs'><iframe src='<%=jspPath%>/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe></div></div>")
		.append("<div id='tabs-12'><div class='layout_tabs'><iframe src='<%=jspPath%>/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe></div></div>")
		.append("<div id='tabs-13'><div class='layout_tabs'><iframe src='<%=jspPath%>/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe></div></div>")
		.append("<div id='tabs-14'><div class='layout_tabs'><iframe src='<%=jspPath%>/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe></div></div>")
		.append("<div id='tabs-15'><div class='layout_tabs'><iframe src='<%=jspPath%>/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe></div></div>")
		.append("<div id='tabs-16'><div class='layout_tabs'><iframe src='<%=jspPath%>/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe></div></div>");

		newIframe = $('#tabs-1 iframe');
		iframeIdx = 0;

		tabObj.tabs( "refresh" );
		tabObj.tabs( "option", "active", 0 );
	}

	//탭로딩
	function showIframe() {
		if(typeof oldIframe != 'undefined') {
			oldIframe.attr("src","<%=jspPath%>/common/hidden.jsp");
		}

		if(checkClearYn()) {
			//마감체크하여 마감되었으면 권한을 R로 넘겨서 수정 못하게 막음
			var authPg = (getYeaCloseYn()=="Y")?"R":"A";
			//원래권한으로 이페이지는 항상 관리자용으로 A이다.
			var orgAuthPg = "<%=authPg%>";
			
			if(iframeIdx == 0) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataAddr.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
			} else if(iframeIdx == 1) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataPer.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
			} else if(iframeIdx == 2) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataPdf.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
			} else if(iframeIdx == 3) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataIns.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
			} else if(iframeIdx == 4) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataHou.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
			} else if(iframeIdx == 5) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataHou2.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
			} else if(iframeIdx == 6) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataHouSav.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
			} else if(iframeIdx == 7) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataCards.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
			} else if(iframeIdx == 8) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataEtc.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
			} else if(iframeIdx == 9) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataPen.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
			} else if(iframeIdx == 10) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataMed.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
			} else if(iframeIdx == 11) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataEdu.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
			} else if(iframeIdx == 12) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataDon.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
			} else if(iframeIdx == 13) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataTax.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
			} else if(iframeIdx == 14) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataIncomeEach.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
			} else if(iframeIdx == 15) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataBefCom.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
			}
		}
		
		feedbackImg();
	}

	//성명 바뀌면 호출
	function setEmpPage() {
		$("#searchSabun").val( $("#searchUserId").val() ) ;
		$("#searchRegNo").val( $("#searchRegNo_").val() ) ;
		if(iframeIdx == 0) {
			showIframe();
		} else {
			tabObj.tabs( "option", "active", 0 );
		}
	}

	
	//기본정보 조회
	function getYearDefaultInfoObj() {
		/*Tab별로 카운트 표시
		tabs-1 : 주소사항
		tabs-2 : 인적공제
		tabs-3 : PDF등록
		tabs-4 : 연 금
		tabs-5 : 보험료
		tabs-6 : 주택자금1 
		tabs-7 : 주택자금2 
		tabs-8 : 저축
		tabs-9 : 카드등 
		tabs-10 : 기타공제
		tabs-11 : 의료비
		tabs-12 : 교육비
		tabs-13 : 기부금
		tabs-14 : 세액감면/기타세액공제*/
		
		var param = "searchWorkYy="+$("#searchWorkYy").val() + "&searchAdjustType="+$("#searchAdjustType").val() + "&searchSabun="+$("#searchSabun").val() ;
		var result = ajaxCall("<%=jspPath%>/yeaData/yeaDataRst.jsp?cmd=selectTabCnt", param,false);
		if(result.Result.Code == 1) {
			
			if(result.Data.cnt2 > 0) result.Data.cnt2 = "<font color='red'>"+result.Data.cnt2+"</font>";
			if(result.Data.cnt3 > 0) result.Data.cnt3 = "<font color='red'>"+result.Data.cnt3+"</font>";
			if(result.Data.cnt4 > 0) result.Data.cnt4 = "<font color='red'>"+result.Data.cnt4+"</font>";
			if(result.Data.cnt5 > 0) result.Data.cnt5 = "<font color='red'>"+result.Data.cnt5+"</font>";
			if(result.Data.cnt6 > 0) result.Data.cnt6 = "<font color='red'>"+result.Data.cnt6+"</font>";
			if(result.Data.cnt7 > 0) result.Data.cnt7 = "<font color='red'>"+result.Data.cnt7+"</font>";
			if(result.Data.cnt8 > 0) result.Data.cnt8 = "<font color='red'>"+result.Data.cnt8+"</font>";
			if(result.Data.cnt9 > 0) result.Data.cnt9 = "<font color='red'>"+result.Data.cnt9+"</font>";
			if(result.Data.cnt10 > 0) result.Data.cnt10 = "<font color='red'>"+result.Data.cnt10+"</font>";
			if(result.Data.cnt11> 0) result.Data.cnt11 = "<font color='red'>"+result.Data.cnt11+"</font>";
			if(result.Data.cnt12> 0) result.Data.cnt12 = "<font color='red'>"+result.Data.cnt12+"</font>";
			if(result.Data.cnt13> 0) result.Data.cnt13 = "<font color='red'>"+result.Data.cnt13+"</font>";
			if(result.Data.cnt14> 0) result.Data.cnt14 = "<font color='red'>"+result.Data.cnt14+"</font>";
			if(result.Data.cnt16> 0) result.Data.cnt16 = "<font color='red'>"+result.Data.cnt16+"</font>";
			
			//$("#tabs1").html("주소사항("+result.Data.cnt1+")");
			$("#tabs2").html("인적공제("+result.Data.cnt2+")");
			$("#tabs3").html("PDF등록("+result.Data.cnt3+")");
			$("#tabs4").html("보험료("+result.Data.cnt5+")");
			$("#tabs5").html("주택자금("+result.Data.cnt6+")");
			$("#tabs6").html("주택자금2("+result.Data.cnt7+")");
			$("#tabs7").html("저축("+result.Data.cnt8+")");
			$("#tabs8").html("신용카드("+result.Data.cnt9+")");
			$("#tabs9").html("기타소득공제("+result.Data.cnt10+")");
			$("#tabs10").html("연금계좌("+result.Data.cnt4+")");
			$("#tabs11").html("의료비("+result.Data.cnt11+")");
			$("#tabs12").html("교육비("+result.Data.cnt12+")");
			$("#tabs13").html("기부금("+result.Data.cnt13+")");
			$("#tabs14").html("세액감면/기타세액공제("+result.Data.cnt14+")");
			$("#tabs16").html("종전근무지("+result.Data.cnt16+")");
		}	
		return ajaxCall("<%=jspPath%>/yeaData/yeaDataRst.jsp?cmd=selectYeaDataDefaultInfo", $("#mainForm").serialize(),false);
	}

	//마감정보 조회
	function getYeaCloseYn() {
		var closeYn = "N";
		var yeaCloseInfo = getYearDefaultInfoObj();

		$("#spanMagam").hide();
		$("#spanMagamCancel").hide();

		if(yeaCloseInfo.Result.Code == 1) {
			if(typeof yeaCloseInfo.Data.sabun == "undefined") {
				closeYn = "Y";
				$("#tdStatusView").html("<font size=2><b>[<font color=red>대상자가 아닙니다.</font>]</b></font>");
			} else if(yeaCloseInfo.Data.final_close_yn == "Y" || yeaCloseInfo.Data.apprv_yn == "Y"|| yeaCloseInfo.Data.input_close_yn == "Y") {
				if(yeaCloseInfo.Data.final_close_yn == "Y"){
					closeYn = "Y";
					$("#tdStatusView").html("<font size=2><b>[현재 <font color=red>최종마감</font> 상태입니다.]</b></font>");
				} else if(yeaCloseInfo.Data.apprv_yn == "Y"){
					closeYn = "N";
					$("#tdStatusView").html("<font size=2><b>[현재 <font color=red>담당자마감</font> 상태입니다.]</b></font>");
					$("#spanMagamCancel").show();
				} else if(yeaCloseInfo.Data.input_close_yn == "Y"){
					closeYn = "N";
					$("#tdStatusView").html("<font size=2><b>[현재 <font color=red>본인마감</font> 상태입니다.]</b></font>");
					$("#spanMagam").show();
				}
			} else {
				closeYn = "N";
				$("#tdStatusView").html("<font size=2><b>[현재 <font color=red>본인 마감전</font> 상태입니다.]</b></font>");
				$("#spanMagam").show();
			}
		}
		return closeYn;
	}

	//각 업무단에 대상자 및 마감된 자료인지 체크
	function checkClose(){
		var yeaCloseInfo = getYearDefaultInfoObj();

		if(yeaCloseInfo.Result.Code == 1) {
			if(typeof yeaCloseInfo.Data.sabun == "undefined") {
				alert("대상자가 아닙니다.");
				return false;
			} else if(yeaCloseInfo.Data.final_close_yn == "Y") {
				alert("최종 마감된 자료입니다.\n저장 할 수 없습니다.");
				return false;
			}
		}

		return true;
	}

	//각 업무단에 대상자 체크
	function checkPeopleSet(){
		var yeaCloseInfo = getYearDefaultInfoObj();

		if(yeaCloseInfo.Result.Code == 1) {
			if(typeof yeaCloseInfo.Data.sabun == "undefined") {
				alert("대상자가 아닙니다.");
				return false;
			}
		}

		return true;
	}

	//특이사항 표시
	function checkClearYn() {

		var result = ajaxCall("<%=jspPath%>/yeaData/yeaDataRst.jsp?cmd=selectCheckClearYn", $("#mainForm").serialize(),false);
		if(result.Result.Code == 1) {
			var temp = nvl(result.Data.clear_yn_str,"1");

			if(temp == "3") {
				$("#span_clearYnCheck").html("<img src='<%=imagePath%>/icon/ic_st03.gif'  border='0' style='vertical-align:middle;'>") ;
			} else if(temp == "2") {
				$("#span_clearYnCheck").html("<img src='<%=imagePath%>/icon/ic_st02.gif'  border='0' style='vertical-align:middle;'>") ;
			} else if(temp == "1") {
				$("#span_clearYnCheck").html("<img src='<%=imagePath%>/icon/ic_st01.gif'  border='0' style='vertical-align:middle;'>") ;
			}

			return true;
		}

		return false;
	}
	
	var pGubun = "";
	
	//특이사항 팝업
	function openUnusualPopup() {
		
	 	var w 		=  700 ;
		var h 		=  300 ;
		var url 	= "<%=jspPath%>/yeaData/yeaDataUnusualPopup.jsp?&authPg=A";

		var args 	= new Array();

		args["searchWorkYy"]		= $("#searchWorkYy").val() ;
		args["searchAdjustType"]	= $("#searchAdjustType").val() ;
		args["searchSabun"]			= $("#searchSabun").val() ;
		
		if(!isPopup()) {return;}
		pGubun = "yeaDataUnusualPopup";
		var rv = openPopup(url,args,w,h);
		/*
		if(rv!=null){
			showIframe();
		}
		*/
	}
	
	function getReturnValue(returnValue) {

		var rv = $.parseJSON('{'+ returnValue+'}');

		if ( pGubun == "yeaDataUnusualPopup" ){
			showIframe();
		}
		
		if ( pGubun == "yeaFeedbackPopup" ){
			feedbackImg();
		}
	}

	// Feedback 팝업
	function openFeedbackPopup() {
		pGubun = "yeaFeedbackPopup";
		
		var $form = $('<form></form>');
		$form.attr('method', 'post');
		$form.appendTo('body');
		
		var w 		= 1000;
		var h 		= 700;
	
		var workYy = $('<input name="workYy" type="hidden" value="'+ $("#searchWorkYy").val() +'">');
		var adjustType = $('<input name="adjustType" type="hidden" value="'+ $("#searchAdjustType").val() +'">');
		var sabun = $('<input name="sabun" type="hidden" value="'+ $("#searchSabun").val() +'">');
		var authPg = $('<input name="authPg" type="hidden" value="A">');
		$form.append(workYy).append(adjustType).append(sabun).append(authPg);
		
		$form.attr('target', 'feedbackPopup');
		$form.attr('action', '<%=jspPath%>/yeaData/yeaFeedbackPopup.jsp');
		
		var top = 10;
		var left = 10;
		var Popup = window.open("", "feedbackPopup", "width="+ w +",height="+ h +",scrollbars=yes,resizable=yes, top="+ top +", left="+ left +"");
		Popup.focus();
		
		$form.submit();
	}
	
	//action
	function doAction(sAction) {
		switch (sAction) {
		case "InputClose":
			var yeaDefaultInfo = getYearDefaultInfoObj();

			if(typeof yeaDefaultInfo.Data.sabun  == "undefined") {
				alert("대상자가 아닙니다.");
				return;
			}
			if(yeaDefaultInfo.Data.final_close_yn == "Y") {
				alert('최종 마감이 완료된 상태 입니다.');
				return;
			}
			if(yeaDefaultInfo.Data.apprv_yn == "Y") {
				alert('이미 담당자 마감이 완료된 상태 입니다.');
				return;
			}

			if(confirm("입력 마감을 진행하시겠습니까?")) {
				var param = "searchPayActionCd="+yeaDefaultInfo.Data.pay_action_cd
				param += "&searchWorkYy="+yeaDefaultInfo.Data.work_yy
				param += "&searchAdjustType="+yeaDefaultInfo.Data.adjust_type
				param += "&searchSabun="+yeaDefaultInfo.Data.sabun;

				var data = ajaxCall("<%=jspPath%>/yeaData/yeaDataRst.jsp?cmd=prcYeaMgrClose",param,false);
				if(data.Result.Code == 1) {
					showIframe() ;
				}
			}

	 	   	break;
		case "CancelClose":
			var yeaDefaultInfo = getYearDefaultInfoObj();

			if(typeof yeaDefaultInfo.Data.sabun  == "undefined") {
				alert("대상자가 아닙니다.");
				return;
			}
			if(yeaDefaultInfo.Data.final_close_yn == "Y") {
				alert('최종 마감이 완료된 상태 입니다.');
				return;
			}
			if(yeaDefaultInfo.Data.apprv_yn == "N") {
				alert('마감작업을 진행하지 않았습니다.');
				return;
			}

			if(confirm("마감취소를 진행하시겠습니까?")) {
				var param = "searchPayActionCd="+yeaDefaultInfo.Data.pay_action_cd
				param += "&searchWorkYy="+yeaDefaultInfo.Data.work_yy
				param += "&searchAdjustType="+yeaDefaultInfo.Data.adjust_type
				param += "&searchSabun="+yeaDefaultInfo.Data.sabun;

				var data = ajaxCall("<%=jspPath%>/yeaData/yeaDataRst.jsp?cmd=prcYeaMgrCloseCancel",param,false);
				if(data.Result.Code == 1) {
					showIframe();
				}
			}

	 	   	break;
		case "TaxCalc":
			if(waitFlag) return;

			var yeaDefaultInfo = getYearDefaultInfoObj();

			if(typeof yeaDefaultInfo.Data.sabun  == "undefined") {
				alert("대상자가 아닙니다.");
				return;
			}
			if(yeaDefaultInfo.Data.final_close_yn == "Y") {
				alert('최종마감된 자료는 세액계산을 할 수 없습니다.');
				return;
			}
			if(yeaDefaultInfo.Data.apprv_yn == "Y") {
				alert('담당자확인된 자료는 세액계산을 할 수 없습니다.');
				return;
			}
			if(yeaDefaultInfo.Data.input_close_yn == "Y") {
				alert('입력마감된 자료는 담당자가 서류검토를 진행하여 데이터를 조정할 수 있으니 결과를 확인할 수 없습니다.');
				return;
			}

			if(confirm("세액계산을 진행하시겠습니까?\n(환경에 따라 1~2분까지 소요될 수 있습니다.)")) {
				var param = "searchPayActionCd="+yeaDefaultInfo.Data.pay_action_cd
				param += "&searchWorkYy="+yeaDefaultInfo.Data.work_yy
				param += "&searchAdjustType="+yeaDefaultInfo.Data.adjust_type
				param += "&searchSabun="+yeaDefaultInfo.Data.sabun;

				var data = ajaxCall("<%=jspPath%>/yeaData/yeaDataRst.jsp?cmd=prcYeaCalc",param,true
						,function(){
							waitFlag = true;
							$("#progressCover").show();
						}
						,function(){
							waitFlag = false;
							$("#progressCover").hide();
							doAction('ResultView');
						}
				);
			}

			break;
		case "ResultView":
			var yeaDefaultInfo = getYearDefaultInfoObj();

			if(typeof yeaDefaultInfo.Data.sabun  == "undefined") {
				alert("대상자가 아닙니다.");
				return;
			}
			if(yeaDefaultInfo.Data.final_close_yn == "Y") {
				alert('최종마감된 자료는 결과보기를 할 수 없습니다.');
				return;
			}
			if(yeaDefaultInfo.Data.input_close_yn == "Y") {
				alert('입력마감된 자료는 결과보기를 할 수 없습니다.');
				return;
			}

			var args = [];
			args["searchWorkYy"]		= $("#searchWorkYy").val() ;
			args["searchAdjustType"]	= $("#searchAdjustType").val() ;
			args["searchSabun"]			= $("#searchSabun").val() ;
			args["searchGubun"]			= "1";
			
			if(!isPopup()) {return;}
			var rv = openPopup("<%=jspPath%>/yeaData/yeaDataResultPopup.jsp",args,"1000","750");

			break;
		}
	}

	/**
	 * 소득공제서 출력 window open event
	 * 레포트 공통에 맞춘 개발 코드 템플릿
	 * by JSG
	 */
	function openPrint(){
		if(!checkPeopleSet()) return;
		//rd call info init
		var rdFileNm = "" ;
		var popupTitle = "소득공제서" ;

		if( ($("#searchWorkYy").val()*1) >= 2007 ) {
			rdFileNm = "EmpIncomeDeductionDeclaration_" + $("#searchWorkYy").val() + ".mrd" ;
		} else {
			rdFileNm = "EmpIncomeDeductionDeclaration.mrd" ;
		}

		//rd option and params setting
		var w 		= 800;
		var h 		= 600;
		var url 	= "<%=jspPath%>/common/rdPopup.jsp";
		var args 	= new Array();
		// args의 Y/N 구분자는 없으면 N과 같음
		var baseDate = "<%=curSysYyyyMMdd%>";
		var imgPath = " " ;
		args["rdTitle"] = popupTitle ;//rd Popup제목
		args["rdMrd"] = "<%=cpnYearEndPath%>/"+rdFileNm;//( 공통경로 /html/report/는 공통에서 처리)업무경로+rd파일명
		args["rdParam"] = "[<%=removeXSS(session.getAttribute("ssnEnterCd"), "1")%>] ["+$("#searchWorkYy").val()+"] ["+$("#searchAdjustType").val()+"]" +
		                  "['"+$("#searchSabun").val()+"'] ["+baseDate+"] " +
		                  "[4] ["+$("#searchSabun").val()+"] [1] ["+baseDate+"]";//rd파라매터
		args["rdParamGubun"] = "rp" ;//파라매터구분(rp/rv)
		args["rdToolBarYn"] = "Y" ;//툴바여부
		args["rdZoomRatio"] = "100" ;//확대축소비율

		args["rdSaveYn"] 	= "Y" ;//기능컨트롤_저장
		args["rdPrintYn"] 	= "Y" ;//기능컨트롤_인쇄
		args["rdExcelYn"] 	= "Y" ;//기능컨트롤_엑셀
		args["rdWordYn"] 	= "Y" ;//기능컨트롤_워드
		args["rdPptYn"] 	= "Y" ;//기능컨트롤_파워포인트
		args["rdHwpYn"] 	= "Y" ;//기능컨트롤_한글
		args["rdPdfYn"] 	= "Y" ;//기능컨트롤_PDF
		
		if(!isPopup()) {return;}
		var rv = openPopup(url,args,w,h);//알디출력을 위한 팝업창
		//if(rv!=null){
			//return code is empty
		//}
	}

	/**
	 * 기부금명세서 / 신용카드 등 소득공제 신청서 / 교육비명세서(양식) / 의료비지급명세서 출력
	 * 레포트 공통에 맞춘 개발 코드 템플릿
	 * by JSG
	 */
	function doReport(report_type){
		if(!checkPeopleSet()) return;
		//rd call info init
		var rdFileNm = "" ;
		var popupTitle = "" ;

		if(report_type == "DONATION") {
			popupTitle = "기부금명세서" ;
			if( ($("#searchWorkYy").val()*1) > 2006 ) {
				rdFileNm = "DonationPaymentDescription_" + $("#searchWorkYy").val() + ".mrd" ;
			} else {
				rdFileNm = "DonationPaymentDescription.mrd" ;
			}
		} else if(report_type == "CARD") {
			popupTitle = "신용카드 등 소득공제 신청서" ;
			rdFileNm = "CardPaymentDescription_" + $("#searchWorkYy").val() + ".mrd" ;
		} else if(report_type == "EDUCATION") {
			popupTitle = "교육비명세서(양식)" ;
			rdFileNm = "EducationPaymentDescription_" + $("#searchWorkYy").val() + ".mrd" ;
		} else {
			popupTitle = "의료비지급명세서" ;
			rdFileNm = "MedicalPaymentDescription_" + $("#searchWorkYy").val() + ".mrd" ;
		}

		//rd option and params setting
		var w 		= 800;
		var h 		= 600;
		var url 	= "<%=jspPath%>/common/rdPopup.jsp";
		var args 	= new Array();
		var baseDate = "<%=curSysYyyyMMdd%>";
		
		// args의 Y/N 구분자는 없으면 N과 같음
		args["rdTitle"] = popupTitle ;//rd Popup제목
		args["rdMrd"] = "<%=cpnYearEndPath%>/"+rdFileNm;//( 공통경로 /html/report/는 공통에서 처리)업무경로+rd파일명
		args["rdParam"] = "[<%=session.getAttribute("ssnEnterCd")%>] ["+$("#searchWorkYy").val()+"] ["+$("#searchAdjustType").val()+"] "+
		                  "['"+$("#searchSabun").val()+"'] [00000] [ALL] "+
		                  "[4] ["+$("#searchSabun").val()+"] [1] ["+baseDate+"]";//rd파라매터
		args["rdParamGubun"] = "rp" ;//파라매터구분(rp/rv)
		args["rdToolBarYn"] = "Y" ;//툴바여부
		args["rdZoomRatio"] = "100" ;//확대축소비율

		args["rdSaveYn"] 	= "Y" ;//기능컨트롤_저장
		args["rdPrintYn"] 	= "Y" ;//기능컨트롤_인쇄
		args["rdExcelYn"] 	= "Y" ;//기능컨트롤_엑셀
		args["rdWordYn"] 	= "Y" ;//기능컨트롤_워드
		args["rdPptYn"] 	= "Y" ;//기능컨트롤_파워포인트
		args["rdHwpYn"] 	= "Y" ;//기능컨트롤_한글
		args["rdPdfYn"] 	= "Y" ;//기능컨트롤_PDF

		if(!isPopup()) {return;}
		var rv = openPopup(url,args,w,h);//알디출력을 위한 팝업창
		//if(rv!=null){
			//return code is empty
		//}
	}

	function headerView(type) {
		if ( type == "hide" ) {
			$('#emplyeeHeader, .sheet_search').hide();
			$('#div_header_view').attr('style', 'position:absolute; top:-5px; width:100%;');
			$('#div_insa_tab').attr('style', 'top:8px;');
		} else {
			$('#emplyeeHeader, .sheet_search').show();
			$('#div_header_view').attr('style', 'position:absolute; top:107px; width:100%;');
			$('#div_insa_tab').attr('style', 'top:120px;');
		}
	}
	
	function feedbackImg() {
		// 담당자 피드백에 직원 피드백은 있고 담당자는 피드백내용 없는게 한개라도 있는 경우
		var result = ajaxCall("<%=jspPath%>/yeaData/yeaDataRst.jsp?cmd=selectFeedbackYn", $("#mainForm").serialize(),false);
		if(result.Result.Code == 1) {
			var temp = nvl(result.Data.yn,"N");
			if(temp == "Y") {
				$("#span_feedback").html("<img src='<%=imagePath%>/icon/ic_st02.gif'  border='0' style='vertical-align:middle;'>") ;
			} else {
				$("#span_feedback").html("<img src='<%=imagePath%>/icon/ic_st01.gif'  border='0' style='vertical-align:middle;'>") ;
			}
		}
	}
</script>
</html>