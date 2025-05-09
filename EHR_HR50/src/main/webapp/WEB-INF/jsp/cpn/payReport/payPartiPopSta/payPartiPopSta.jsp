<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script src="/assets/js/utility-script.js?ver=7"></script>
<script type="text/javascript">
var gPRow = "";
var pGubun = "";
	$(function() {
		//$("#searchSdate").datepicker2({ymdonly:true});

		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			  Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			  Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			  Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",      	  Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"name",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",      	  Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"sabun",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='orgNmV10' mdef='소속명'/>",      	  Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"orgNm",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='all' mdef='전체'/>",      	  Type:"CheckBox",  Hidden:0,  Width:80,  Align:"Center",  ColMerge:0,   SaveName:"checkBox",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:10, TrueValue:"Y", FalseValue:"N" },
			{Header:"<sht:txt mid='rk' mdef='rk'/>",                      Type:"Text",      Hidden:1,  Width:0,   Align:"Center",  ColMerge:0,   SaveName:"rk",           KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }
        ]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");

		var manageCd 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10030"), ("${ssnLocaleCd}" != "en_US" ? "<tit:txt mid='103895' mdef='전체'/>" : "All"));	//사원구분
		
		//사업장코드 관리자권한만 전체사업장 보이도록, 그외는 권한사업장만.
		var url     = "queryId=getBusinessPlaceCdList";
		var allFlag = true;
		if ("${ssnSearchType}" != "A"){
			url    += "&searchChkPlace=Y&sabun=${ssnSabun}&grpCd=${ssnGrpCd}";
			allFlag = false;
		}		
		var businessPlaceCd = "";
		if(allFlag) {
			businessPlaceCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList",url,false).codeList, ("${ssnLocaleCd}" != "en_US" ? "<tit:txt mid='103895' mdef='전체'/>" : "All"));	//사업장	
		} else {
			businessPlaceCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList",url,false).codeList, "");	//사업장
		}

		//sheet1.SetColProperty("mapTypeCd", 			{ComboText:orgMappingGbn[0], ComboCode:orgMappingGbn[1]} );	//소속맵핑구분

		$("#searchBusinessPlaceCd").html(businessPlaceCd[2]);
		$("#searchManageCd").html(manageCd[2]);



		$("#searchOrgNm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});
		var msg = {};
		setValidate($("#srchFrm"),msg);

		$(window).smartresize(sheetResize); sheetInit();
		getCpnLatestPaymentInfo();
		//doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	if( $("#searchPayActionCd").val() == "") { alert("<msg:txt mid='alertPayActionCdChk' mdef='급여일자는 필수항목 입니다.'/>") ; return ; }
							sheet1.DoSearch( "${ctx}/PayPartiPopSta.do?cmd=getPayPartiPopStaList", $("#srchFrm").serialize() ); break;
		case "Save":
							IBS_SaveName(document.srchFrm,sheet1);
							sheet1.DoSave( "${ctx}/PayPartiPopSta.do?cmd=savePayPartiPopSta", $("#srchFrm").serialize());
							break;
		case "Insert":		var Row = sheet1.DataInsert(0) ;
							break;
		case "Copy":		sheet1.DataCopy(); break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":
							var downcol = makeHiddenSkipCol(sheet1);
							var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
							sheet1.Down2Excel(param);
				
							break;
		case "DownTemplate":
			// 양식다운로드
			sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"3|4|5|6|7|8"});
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doAction("Insert");
			}
			//Delete KEY
			if (Shift == 1 && KeyCode == 46 && sheet1.GetCellValue(Row, "sStatus") == "I") {
				sheet1.SetCellValue(Row, "sStatus", "D");
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	// 팝업 클릭시 발생
	function sheet1_OnPopupClick(Row,Col) {
		try {

		} catch (ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try{

	  	}catch(ex){alert("OnClick Event Error : " + ex);}
	}

	//  소속 팝업
    function orgSearchPopup(){
        try{
        	if(!isPopup()) {return;}
        	gPRow = "";
        	pGubun = "orgBasicPopup";

			let layerModal = new window.top.document.LayerModal({
				id : 'orgLayer'
				, url : '/Popup.do?cmd=viewOrgBasicLayer&authPg=${authPg}'
				, parameters : {}
				, width : 740
				, height : 520
				, title : '<tit:txt mid='orgSchList' mdef='조직 리스트 조회'/>'
				, trigger :[
					{
						name : 'orgTrigger'
						, callback : function(result){
							if(!result.length) return;
							$("#searchOrgNm").val(result[0].orgNm);
							$("#searchOrgCd").val(result[0].orgCd);
						}
					}
				]
			});
			layerModal.show();
        }catch(ex){alert("Open Popup Event Error : " + ex);}
    }

	// 최근급여일자 조회
	function getCpnLatestPaymentInfo() {
		var procNm = "최근급여일자";
		// 급여구분(C00001-00001.급여)
		var paymentInfo = ajaxCall("${ctx}/PayPartiPopSta.do?cmd=getCpnQueryList", "queryId=getCpnLatestPaymentInfoMap&procNm="+procNm+"&runType=00001,", false);

		if (paymentInfo.DATA != null && paymentInfo.DATA != "" && typeof paymentInfo.DATA[0] != "undefined") {
			$("#searchPayActionCd").val(paymentInfo.DATA[0].payActionCd);
			$("#searchPayActionNm").val(paymentInfo.DATA[0].payActionNm);

			if ($("#searchPayActionCd").val() != null && $("#searchPayActionCd").val() != "") {
				doAction1("Search");
			}
		} else if (paymentInfo.Message != null && paymentInfo.Message != "") {
			alert(paymentInfo.Message);
		}
	}

 // 급여일자 검색 팝입
    function payActionSearchPopup() {
    	try{
    		if(!isPopup()) {return;}
    		gPRow = "";
    		pGubun = "payDayPopup";

			let layerModal = new window.top.document.LayerModal({
				id : 'payDayLayer'
				, url : '/PayDayPopup.do?cmd=viewPayDayLayer&authPg=R'
				, parameters : {
					runType : '00001,0002'
				}
				, width : 840
				, height : 520
				, title : '<tit:txt mid='payDayPop' mdef='급여일자 조회'/>'
				, trigger :[
					{
						name : 'payDayTrigger'
						, callback : function(result){
							$("#searchPayActionCd").val(result.payActionCd);
							$("#searchPayActionNm").val(result.payActionNm);

							if ($("#searchPayActionCd").val() != null && $("#searchPayActionNm").val() != "") {
								doAction1("Search");
							}
						}
					}
				]
			});
			layerModal.show();
    	}catch(ex){alert("Open Popup Event Error : " + ex);}
    }

    function getReturnValue(returnValue) {
    	var rv = returnValue;
    }
	//출력
	function print(gubun) {

	    var sabuns = "";
	    var checked = "";
	    var searchAllCheck = "";
	    var sabunCnt = 0;

	    if(sheet1.RowCount() != 0) {

	        for(i=1; i<=sheet1.LastRow(); i++) {

	            checked = sheet1.GetCellValue(i, "checkBox");

	            if (checked == "1" || checked == "Y") {
	                sabuns += "'"+sheet1.GetCellValue( i, "sabun" ) + "',";
	            }
	        }

	        sabuns = sabuns.substr(0,sabuns.length-1);
	        if (sabuns.length < 1) {
	            alert("<msg:txt mid='alertMonPayMailCre4' mdef='선택된 사원이 없습니다.'/>");
	            return;
	        }

	        if(gubun == "1"){
	            payPartiPopStaPopup(sabuns) ;
	        }
	        /*
	        else{
	        	//테스트 목적입니다.
		        //삭제해야 합니다
		        payPartiPopStaUpload(sabuns,gubun) ;
	        }*/

	    } else {

	        alert("<msg:txt mid='alertMonPayMailCre4' mdef='선택된 사원이 없습니다.'/>");
	        return;

	    }

	}
	/**
	 * 출력 window open event
	 * 레포트 공통에 맞춘 개발 코드 템플릿
	 * by JSG
	 */
	function payPartiPopStaPopup(param){
		if(!isPopup()) {return;}
		pGubun = "";

  		var w 		= 800;
		var h 		= 600;
		var url 	= "${ctx}/RdPopup.do";
		var args 	= new Array();
		// args의 Y/N 구분자는 없으면 N과 같음

		args["rdTitle"] = "<tit:txt mid='payPartiPopStaRdTitle' mdef='급상여명세서'/>"; //"급상여명세서" ;//rd Popup제목
		args["rdMrd"] = "cpn/payReport/PayAllowanceParticulars.mrd" ;//( 공통경로 /html/report/는 공통에서 처리)업무경로+rd파일명
		args["rdParam"] = "['${ssnEnterCd}'] ['"+$("#searchPayActionCd").val()+"'] ["+param+"] [${baseURL}] ";//rd파라매터
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
		args["rdHideItem"]  = "xls,doc,ppt,hwp";

		openPopup(url,args,w,h);//알디출력을 위한 팝업창
	}

	/**
	 * 출력 window open event
	 * 레포트 공통에 맞춘 개발 코드 템플릿
	 * by JSG
	 */
	function payPartiPopStaUpload(param,gubun){
  		var w 		= 800;
		var h 		= 600;
		var url 	= "${ctx}/RdUpload"+gubun+".do?v=1";
		var args 	= new Array();
		// args의 Y/N 구분자는 없으면 N과 같음

		args["rdTitle"] = "<tit:txt mid='payPartiPopStaRdTitle' mdef='급상여명세서'/>"; //"급상여명세서" ;//rd Popup제목
		args["rdMrd"] = "cpn/payReport/PayAllowanceParticulars.mrd" ;//( 공통경로 /html/report/는 공통에서 처리)업무경로+rd파일명
	  //args["rdParam"] = "['${ssnEnterCd}'] ['"+$("#searchPayActionCd").val()+"'] ['EHR_PTH'] ['"+$("#searchPayActionCd").val()+"'] ['"+$("#searchOrgCd").val()+"'] ["+param+"]" ;//rd파라매터
	    args["rdParam"] = "['${ssnEnterCd}'] ['"+$("#searchPayActionCd").val()+"'] ['EHR_PTH'] ['"+$("#searchPayActionCd").val()+"'] ['"+$("#searchOrgCd").val()+"'] " ;//rd파라매터
		args["rdParamGubun"] = "rp" ;//파라매터구분(rp/rv)
		args["rdSabun"] = param ;//사번

		var rv = openPopup(url,args,w,h);//알디출력을 위한 팝업창
		if(rv!=null){
			//return code is empty
		}
	}

	function showRd(){

		var checkedRowsCount = sheet1.CheckedRows('checkBox');
		if(checkedRowsCount === 0){
			alert('<msg:txt mid="alertMonPayMailCre4" mdef="선택된 사원이 없습니다." />');
			return;
		}

		var checkedRows = sheet1.FindCheckedRow('checkBox');
		let searchSabunList = [];
		let rkList = [];
		$(checkedRows.split("|")).each(function(index,value){
			searchSabunList.push('\'' + sheet1.GetCellValue(value, 'sabun') + '\'');
			rkList[index] = sheet1.GetCellValue(value, 'rk');
		});

		let parameters = Utils.encase('\'' + '${ssnEnterCd}' + '\'') + ' ';
		parameters += Utils.encase('\'' + $("#searchPayActionCd").val() + '\'') + ' ';
		parameters += Utils.encase(searchSabunList.join(',')) + ' ';
		parameters += Utils.encase('${imageBaseUrl}') + ' ';

		/*
		const data = {
			rdMrd : '/cpn/payReport/PayAllowanceParticulars.mrd'
			, parameterType : 'rp'//rp 또는 rv
			, parameters : parameters
		};*/
		//window.top.showRdLayer(data);
		
       const data = {
             rk : rkList
          };
       
       window.top.showRdLayer('/PayPartiPopSta.do?cmd=getEncryptRd', data);
	}

</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<input type="hidden" id="searchOrgCd" name="searchOrgCd" value =""/>
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='104477' mdef='급여일자'/></th>
						<td>
							<input type="hidden" id="searchPayActionCd" name="searchPayActionCd" value="" /><input type="hidden" id="sabun" name="sabun" class="text" value="" />
							<input type="text" id="searchPayActionNm" name="searchPayActionNm" class="text readonly" value="" validator="required" readonly style="width:150px" />
							<a onclick="javascript:payActionSearchPopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
						</td>
						<th><tit:txt mid='114399' mdef='사업장'/></th>
						<td>
							<select id="searchBusinessPlaceCd" name ="searchBusinessPlaceCd" onChange="javascript:doAction1('Search')" class="box"></select>
						</td>
					</tr>
					<tr>
						<th><tit:txt mid='104295' mdef='소속 '/></th>
						<td>
							<input id="searchOrgNm" name ="searchOrgNm" type="text" class="text readonly" readOnly style="width:148px"/>
							<a onclick="javascript:orgSearchPopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
							<a onclick="$('#searchOrgCd,#searchOrgNm').val('');" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
						</td>
						<th><tit:txt mid='103784' mdef='사원구분'/></th>
						<td>
							<select id="searchManageCd" name ="searchManageCd" onChange="javascript:doAction1('Search')" class="box"></select>
						</td>
						<td><btn:a href="javascript:doAction1('Search')" id="btnSearch" css="button" mid='110697' mdef="조회"/></td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<colgroup>
			<col width="*"/>
			<col width="252px"/>
		</colgroup>
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='payPartiPopSta' mdef='급/상여명세서'/></li>
							<li class="btn">
<%--								<btn:a href="javascript:print(1)" 	css="basic authA" mid='110727' mdef="출력"/>--%>
								<btn:a href="javascript:showRd()" 	css="basic authA" mid='110727' mdef="출력"/>
								<!--
								<a href="javascript:print(2)" 	class="basic authA">test1</a>
								<a href="javascript:print(3)" 	class="basic authA">test2</a>
								<a href="javascript:print(4)" 	class="basic authA">test3</a>
								-->
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
			</td>
			<td class="sheet_right">
			    <!-- 팁 시작 -->
			    <table>
			    <tr><td>&nbsp;</td></tr>
			    <tr><td>&nbsp;</td></tr>
			    <tr>
			    <td>
				    <div class="explain">
				    <dl>
				        <dd><tit:txt mid='113873' mdef='1. [급/상여명세서] 발행화면입니다.'/></dd>
				        <dd><tit:txt mid='113838' mdef='2. [전체]를 선택하면 선택된 사원에 관계없이'/><br/><span><tit:txt mid='112773' mdef='&nbsp;&nbsp;&nbsp;모든 사원에 대해 출력됩니다.'/></span></dd>
				        <dd><tit:txt mid='113842' mdef='3. 특정 사원에 대해서만 출력하려면,'/><br /><span><tit:txt mid='114193' mdef='&nbsp;&nbsp;&nbsp;[전체] 선택을 해지한 후,'/></span><br /><span><tit:txt mid='113843' mdef='&nbsp;&nbsp;&nbsp;원하는 사원을 선택하시면 됩니다.'/></span></dd>
				    </dl>
				    </div>
				</td>
				</tr>
				</table>
			    <!-- 팁 종료 -->
			</td>
		</tr>
	</table>
</div>
</body>
</html>
