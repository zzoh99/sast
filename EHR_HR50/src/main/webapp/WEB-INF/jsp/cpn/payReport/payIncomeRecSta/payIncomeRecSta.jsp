<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> 
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var gPRow = "";
var pGubun = "";
	$(function() {	

		$("#year").mask("1111");

		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly}; 
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			  Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			  Type:"${sDelTy}",	Hidden:0,Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			  Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",      	  Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"sabun",       KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0 },
			{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",      	  Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"name",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1 },
			{Header:"<sht:txt mid='hochingNm' mdef='호칭'/>",      	  Type:"Text",      Hidden:Number("${aliasHdn}"),  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"alias",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0 },
			{Header:"<sht:txt mid='jikgubCd' mdef='직급'/>",      	  Type:"Text",      Hidden:Number("${jgHdn}"),  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"jikgubNm",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0 },
			{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",      	  Type:"Text",      Hidden:Number("${jwHdn}"),  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"jikweeNm",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0 },
			{Header:"<sht:txt mid='orgNmV10' mdef='소속명'/>",      	  Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"orgNm",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");

		
		$(window).smartresize(sheetResize); sheetInit();
		//doAction1("Search");
		

		// 이름 입력 시 자동완성
		$(sheet1).sheetAutocomplete({
			Columns: [
				{
					ColSaveName  : "name",
					CallbackFunc : function(returnValue){
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet1.SetCellValue(gPRow, "name", 		rv.name );
						sheet1.SetCellValue(gPRow, "alias",		rv.alias );
						sheet1.SetCellValue(gPRow, "jikgubNm",	rv.jikgubNm );
						sheet1.SetCellValue(gPRow, "jikweeNm",	rv.jikweeNm );
						sheet1.SetCellValue(gPRow, "sabun", 	rv.sabun );
						sheet1.SetCellValue(gPRow, "orgNm", 	rv.orgNm );
					}
				}
			]
		});	
        
		
	});
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	if( $("#searchPayActionCd").val() == "") { alert("<msg:txt mid='alertPayActionCdChk' mdef='급여일자는 필수항목 입니다.'/>") ; return ; }
							sheet1.DoSearch( "${ctx}/PayIncomeRecSta.do?cmd=getPayIncomeRecStaList", $("#srchFrm").serialize() ); break;
		case "Insert":
			var row = sheet1.DataInsert(0);
			break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "DownTemplate":
			// 양식다운로드
			sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"sabun"});
			break;
		case "LoadExcel":
			var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params);
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
// 				doAction("Insert");
			}
			//Delete KEY
			if (Shift == 1 && KeyCode == 46 && sheet1.GetCellValue(Row, "sStatus") == "I") {
				sheet1.SetCellValue(Row, "sStatus", "D");
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}
	
    function insaPrint() {

        if($("#year").val()=="") {
            alert("<msg:txt mid='110173' mdef='조회년도를 입력하여주십시요.'/>");
            return;
        } else if($("#purPose").val()=="") {
	        alert("<msg:txt mid='alertPayTaxCertiSta6' mdef='사용목적을 입력하여주십시요.'/>");
	        return;        
    	} else if($("#subMit").val()=="") {
	        alert("<msg:txt mid='alertPayTaxCertiSta7' mdef='제출처를 입력하여주십시요.'/>");
	        return;    
    	}

        var sabuns = "";
        if( sheet1.RowCount() != 0 ) {
            for(i=1; i<=sheet1.LastRow(); i++) {
                sabuns += "'"+sheet1.GetCellValue( i, "sabun" ) + "',";
            }
            sabuns = sabuns.substr(0,sabuns.length-1);

			showRd(sabuns);
        } else {
            alert("<msg:txt mid='109847' mdef='프린트할 대상을 입력하여주십시요!'/>");
        }
    }

	function showRd(param){
		let parameters = "[${ssnEnterCd}] ["+param+"] ["+$("#year").val()+"] ['"+$("#purPose").val()+"'] ['"+$("#subMit").val()+"']" ;//rd파라매터
		/*
		const data = {
			rdMrd : $("#language").val() == "E" ? '/cpn/payReport/WorkIncomeWithholdReceiptCalEng_view.mrd' : '/cpn/payReport/WorkIncomeWithholdReceiptCal_view.mrd'
			, parameterType : 'rp'//rp 또는 rv
			, parameters : parameters
		};
		
		window.top.showRdLayer(data);
		*/
        const data = {
				parameters : parameters
			,   language : $("#language").val()
        };
        window.top.showRdLayer('/PayIncomeRecSta.do?cmd=getEncryptRd', data);
		
	}

	function replace(str, s, d) {
		var i = 0;

		while (i > -1) {
			i = str.indexOf(s);
			str = str.substr(0, i) + d + str.substr(i + 1, str.length);
		}
		return str;
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<colgroup>
			<col width="*"/>
			<col width="460px"/>
		</colgroup>
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='payIncomeRecSta' mdef='소득세원천징수증명서'/></li>
							<li class="btn">
								<a href="javascript:doAction1('Insert')" 	class="btn outline_gray authA"><tit:txt mid='104267' mdef='입력'/></a>
								<a href="javascript:doAction1('DownTemplate')" 	class="btn outline_gray authR"><tit:txt mid='113684' mdef='양식다운로드'/></a>
								<a href="javascript:doAction1('LoadExcel')" 	class="btn outline_gray authA"><tit:txt mid='104242' mdef='업로드'/></a>
								<a href="javascript:insaPrint()" 	class="btn filled authA"><tit:txt mid='103799' mdef='출력'/></a>
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
								<colgroup>
									<col width="20%"/>
									<col width="30%"/>
									<col width="20%"/>
									<col width="30%"/>
								</colgroup>
								<tr>
									<th class="title"><tit:txt mid='114464' mdef='조회년도'/></th>
									<td>
										<input class="text" type="text" id="year" name="year" maxlength="4"  style="width:35px">
									</td>
									<th class="title"><tit:txt mid='103997' mdef='구분'/></th>
									<td>
										<select class="w100p" id="language" name="language" >
											<option value="K"> 국문 </option>
											<option value="E"> 영문 </option>
										</select>
									</td>
								</tr>
								<tr>
									<th><tit:txt mid='113485' mdef='사용목적'/></th>
									<td colspan="3">
										<input class="text" type="text" id="purPose" name="purPose" style="width:100% !important;" />
									</td>
								</tr>
								<tr>
									<th><tit:txt mid='104003' mdef='제출처'/></th>
									<td colspan="3">
										<input class="text" type="text" id="subMit" name="subMit" style="width:100% !important;" />
									</td>
								</tr>
							</table>
							<div class="explain">
							<dl>
								<dd>1. [입력] 버튼 클릭 후 성명 칸에 사번 또는 성명으로 대상자를 검색하여 [출력]하실 수 있습니다.</dd>
								<dd>2. 업로드는 대량출력을 하고자 할 경우 사용합니다. 양식다운로드 후 사용해주세요.</dd>
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
