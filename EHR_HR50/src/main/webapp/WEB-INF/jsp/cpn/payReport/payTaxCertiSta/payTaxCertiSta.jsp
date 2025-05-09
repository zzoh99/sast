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
		$("#ymStart").mask("1111-11");
		$("#ymEnd").mask("1111-11");
		$("#ymStart").datepicker2({ymonly:true});
		$("#ymEnd").datepicker2({ymonly:true});


		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly}; 
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			  Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			  Type:"${sDelTy}",	Hidden:0,Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			  Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",      	  Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"sabun",       KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0 },
			{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",      	  Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"name",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1 },
			{Header:"<sht:txt mid='hochingNm' mdef='호칭'/>",      	  Type:"Text",      Hidden:Number("${aliasHdn}"),  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"alias",       KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0 },
			{Header:"<sht:txt mid='jikgubCd' mdef='직급'/>",      	  Type:"Text",      Hidden:Number("${jgHdn}"),  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"jikgubNm",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0 },
			{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",      	  Type:"Text",      Hidden:Number("${jwHdn}"),  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"jikweeNm",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0 },
			{Header:"<sht:txt mid='orgNmV10' mdef='소속명'/>",      	  Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"orgNm",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		
		$("#paymentDate").bind("keyup",function(event){
			makeNumber(this,"A");
		});

		//Autocomplete
		$(sheet1).sheetAutocomplete({
			Columns: [
				{
					ColSaveName  : "name",
					CallbackFunc : function(returnValue){
						const rv = $.parseJSON('{' + returnValue+ '}');
						sheet1.SetCellValue(gPRow, "sabun",		rv["sabun"]);
						sheet1.SetCellValue(gPRow, "name",		rv["name"]);
						sheet1.SetCellValue(gPRow, "alias",		rv["alias"]);
						sheet1.SetCellValue(gPRow, "orgNm",		rv["orgNm"]);
						sheet1.SetCellValue(gPRow, "jikgubNm",	rv["jikgubNm"]);
						sheet1.SetCellValue(gPRow, "jikweeNm",	rv["jikweeNm"]);
					}
				}
			]
		});
		
		$(window).smartresize(sheetResize); sheetInit();
		//doAction1("Search");
	});
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	if( $("#searchPayActionCd").val() == "") { alert("<msg:txt mid='alertPayActionCdChk' mdef='급여일자는 필수항목 입니다.'/>") ; return ; }
							sheet1.DoSearch( "${ctx}/PayTaxCertiSta.do?cmd=getPayTaxCertiStaList", $("#srchFrm").serialize() ); break;
		case "Insert":		var Row = sheet1.DataInsert(0) ;
							break;
		case "Copy":		sheet1.DataCopy(); break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":	sheet1.Down2Excel(); break;
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

    function print() {

        var searchSabun =  "" ;  //"88007";
        var sabuns = "";
        var sYm;
        var eYm;
        var pDate;
        var pPose;
        var sMit;

        if( sheet1.RowCount() != 0 ) {
			if($("#ymStart").val()!="" && $("#ymEnd").val()!="") {
				changeMonth() ;//납부년월 개월범위 가져옴 by JSG
			}
				
            if($("#ymStart").val()=="") {
                alert("<msg:txt mid='alertPayTaxCertiSta1' mdef='납부시작년월을 입력하여주십시요.'/>");
                return;
            } else if($("#ymEnd").val()=="") {
                alert("<msg:txt mid='alertPayTaxCertiSta2' mdef='납부종료년월을 입력하여주십시요.'/>");
                return;        
            } else if($("#ymStart").val() > $("#ymEnd").val()) {
                alert("<msg:txt mid='alertPayTaxCertiSta3' mdef='시작년월을 종료년월보다 작은 일자로 입력하여주십시요.'/>");
                return;
            } else if($("#monthCnt").val() > 12 ) {
                alert("<msg:txt mid='alertPayTaxCertiSta4' mdef='납부년월의 범위가 12개월을 초과할수 없습니다.'/>");
                return;
            } else if($("#paymentDate").val()=="") {
                alert("<msg:txt mid='alertPayTaxCertiSta5' mdef='납부일자를 입력하여주십시요.'/>");
                return;        
            } else if($("#purPose").val()=="") {
                alert("<msg:txt mid='alertPayTaxCertiSta6' mdef='사용목적을 입력하여주십시요.'/>");
                return;        
            } else if($("#subMit").val()=="") {
                alert("<msg:txt mid='alertPayTaxCertiSta7' mdef='제출처를 입력하여주십시요.'/>");
                return;        
            }  else if($("#monthCnt").val() > 12 ) {
                alert("<msg:txt mid='alertPayTaxCertiSta4' mdef='납부년월의 범위가 12개월을 초과할수 없습니다.'/>");
                return;
            } else {

                    for(i=1; i<=sheet1.LastRow(); i++) {
                        sabuns += "'"+sheet1.GetCellValue( i, "sabun" ) + "',";
                    }
                    sabuns = sabuns.substr(0,sabuns.length-1);

                    
                    sYm        = replace($("#ymStart").val(),"-","");
                    eYm        = replace($("#ymEnd").val(),"-","");

                    pDate    = $("#paymentDate").val() ;
                    pPose    = $("#purPose").val() ;
                    sMit    = $("#subMit").val() ;

				showRd(sabuns);
            }

        } else {
            alert("<msg:txt mid='109847' mdef='프린트할 대상을 입력하여주십시요!'/>");
        }

    }
	function replace(str, s, d) {
		var i = 0;

		while (i > -1) {
			i = str.indexOf(s);
			str = str.substr(0, i) + d + str.substr(i + 1, str.length);
		}
		return str;
	}

	function showRd(param){
		var imgPath = " " ;
		let parameters = "[${ssnEnterCd}] ["+replace($("#ymStart").val(),"-","")+"] ["+replace($("#ymEnd").val(),"-","")+"] ["+param+"] ["+$("#paymentDate").val()+"] ["+$("#purPose").val()+"] ["+$("#subMit").val()+"] ["+imgPath+"]" ;//rd파라매터

		/*
		const data = {
			rdMrd : '/cpn/payReport/TaxClearanceCertificate.mrd'
			, parameterType : 'rp'//rp 또는 rv
			, parameters : parameters
		};
		window.top.showRdLayer(data);*/
        const data = {
                parameters : parameters
        };
        window.top.showRdLayer('/PayTaxCertiSta.do?cmd=getEncryptRd', data);
	}

	function changeMonth(){

		var data = ajaxCall("/PayTaxCertiSta.do?cmd=getPayTaxCertiStaIfrm", $("#srchFrm").serialize(), false).DATA;
		if(data == null) {
			alert("<msg:txt mid='alertPayTaxCertiSta11' mdef='발령항목이 정의되지 않았습니다.'/>");
			return;
		} else {
			$("#monthCnt").val(data.cnt) ;
		}
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
	<input type="hidden" id="monthCnt" name="monthCnt">
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<colgroup>
			<col width="*"/>
			<col width="394.5px" />
		</colgroup>
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='payTaxCertiSta' mdef='납세필증명서'/></li>
							<li class="btn">
								<a href="javascript:doAction1('Insert')" 	class="btn outline_gray authA"><tit:txt mid='104267' mdef='입력'/></a>
								<a href="javascript:print(1)" 	class="btn filled authA"><tit:txt mid='103799' mdef='출력'/></a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","${ssnLocaleCd}"); </script>
			</td>
			<td class="sheet_right">
			    <!-- 팁 시작 -->
			    <table style="margin-top: 57px;">
					<tr>
						<td>
							<table class="table">
								<tr>
									<th class="title"><tit:txt mid='113484' mdef='납부년월'/></th>
									<td class="">
										<input class="text" type="text" id="ymStart" name="ymStart" size="6" maxlength="7" style="width:50px"> ~
										<input class="text" type="text" id="ymEnd" name="ymEnd" size="6" maxlength="7" style="width:50px">
										<input class="text" type="hidden" name="monthCnt">
									</td>
								</tr>
								<tr>
									<th class="title"><tit:txt mid='112771' mdef='납부일자'/></th>
									<td class="">
										<input class="text" type="text" id="paymentDate" name="paymentDate" size="3" maxlength="2"  style="width:30px!important;padding:3px 6px;"> 일
									</td>
								</tr>
								<tr>
									<th class=""><tit:txt mid='113485' mdef='사용목적'/></th>
									<td class="">
										<input class="text" type="text" id="purPose" name="purPose" style="width:100%" >
									</td>
								</tr>
								<tr>
									<th class=""><tit:txt mid='104003' mdef='제출처'/></th>
									<td class="">
										<input class="text" type="text" id="subMit" name="subMit" style="width:100%" >
									</td>
								</tr>
							</table>
							<div class="explain">
								<dl>
									<dd>1. [납세필증명서] 발행화면입니다.</dd>
									<dd>2. [입력] 버튼 클릭 후 성명 칸에 사번 또는 성명으로 대상자를 검색하여 [출력]하실 수 있습니다.</dd>
									<!-- 2번부터 기존설명이 적절치 않다는 판단, 문구 변경 - 20130626 조선구
									<dd>2. [전체]를 선택하면 선택된 사원에 관계없이</dd>
									<dd>&nbsp;&nbsp;&nbsp;모든 사원에 대해 출력됩니다.</dd>
									<dd>3. 특정 사원에 대해서만 출력하려면, [전체] 선택을</dd>
									<dd>&nbsp;&nbsp;&nbsp; 해지한 후, 원하는 사원을 선택하시면 됩니다.</dd>
									-->
								</dl>
							</div>
						</td>
					</tr>
				</table>
			    <!-- 팁 종료 -->
			</td>
		</tr>
	</table>
	</form>
</div>
<span style="display:none">
	<iframe name="hidden_ifrmsrc" id="hidden_ifrmsrc" frameborder='0' class='tab_iframes'></iframe>
</span>
</body>
</html>
