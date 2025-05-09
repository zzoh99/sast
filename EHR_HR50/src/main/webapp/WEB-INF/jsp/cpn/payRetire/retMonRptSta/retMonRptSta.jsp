<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script src="/assets/js/utility-script.js?ver=7"></script>
<script type="text/javascript">
	$(function() {
		$("#searchSYm").datepicker2({ymonly:true});
		$("#searchSYm").val("${curSysYyyyMMHyphen}");
		$("#searchEYm").datepicker2({ymonly:true});
		$("#searchEYm").val("${curSysYyyyMMHyphen}");

		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			  Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			  Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			  Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='paymentYmdV6' mdef='퇴직계산일자'/>",	  Type:"Date",      Hidden:0,  Width:100,	Align:"Center",  ColMerge:0,   SaveName:"paymentYmd",	KeyField:0,   CalcLogic:"",   Format:"Ymd",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='bizCdV2' mdef='구분'/>",      	  Type:"Text",      Hidden:0,  Width:100,	Align:"Center",  ColMerge:0,   SaveName:"payNm",		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='payActionCd' mdef='급여일자'/>",      	  Type:"Text",      Hidden:1,  Width:100,	Align:"Center",  ColMerge:0,   SaveName:"payActionCd",  KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",      	  Type:"Text",      Hidden:0,  Width:90,	Align:"Center",  ColMerge:0,   SaveName:"sabun",       	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",      	  Type:"Text",      Hidden:0,  Width:80,	Align:"Center",  ColMerge:0,   SaveName:"name",       	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='hochingNm' mdef='호칭'/>",      	  Type:"Text",      Hidden:Number("${aliasHdn}"),  Width:80,	Align:"Center",  ColMerge:0,   SaveName:"alias",       	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='jikgubCd' mdef='직급'/>",      	  Type:"Text",      Hidden:Number("${jgHdn}"),  Width:80,	Align:"Center",  ColMerge:0,   SaveName:"jikgubNm",       	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",      	  Type:"Text",      Hidden:Number("${jwHdn}"),  Width:80,	Align:"Center",  ColMerge:0,   SaveName:"jikweeNm",       	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='orgNmV10' mdef='소속명'/>",      	  Type:"Text",      Hidden:0,  Width:120,	Align:"Center",  ColMerge:0,   SaveName:"orgNm",       	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='all' mdef='전체'/>",      	  Type:"CheckBox",  Hidden:0,  Width:40,	Align:"Center",  ColMerge:0,   SaveName:"checked",     	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:10, TrueValue:"Y", FalseValue:"N" },
			{Header:"<sht:txt mid='rk' mdef='rk'/>",                 Type:"Text",      Hidden:1,  Width:0,   Align:"Center",  ColMerge:0,   SaveName:"rk",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }
        ]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");

		//sheet1.SetColProperty("mapTypeCd", 			{ComboText:orgMappingGbn[0], ComboCode:orgMappingGbn[1]} );	//소속맵핑구분
		 // 조회조건
		var searchPayCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getCpnPayCdList&searchRunType=00004,",false).codeList, "<tit:txt mid='103895' mdef='전체'/>");
		$("#searchPayCd").html(searchPayCdList[2]);

		$("#searchText, #searchSYm, #searchEYm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});

		var msg = {};
		setValidate($("#srchFrm"),msg);

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
							sheet1.DoSearch( "${ctx}/RetMonRptSta.do?cmd=getRetMonRptStaList", $("#srchFrm").serialize() ); break;
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

//  사원 조회
	function openEmployeePopup(Row){
	    try{
	     var args    = new Array();
	     var rv = openPopup("/Popup.do?cmd=employeePopup&authPg=${authPg}", args, "840","520");
	        if(rv!=null){
				sheet1.SetCellValue(Row, "name", 		rv["name"] );
				sheet1.SetCellValue(Row, "sabun", 		rv["sabun"] );
				sheet1.SetCellValue(Row, "jikgubNm", 	rv["jikgubNm"] );
				sheet1.SetCellValue(Row, "jikweeNm", 	rv["jikweeNm"] );
				sheet1.SetCellValue(Row, "orgNm", 		rv["orgNm"] );
				sheet1.SetCellValue(Row, "statusNm", 	rv["statusNm"] );
	        }
	    }catch(ex){alert("Open Popup Event Error : " + ex);}
	}

//  소속 팝입
    function orgSearchPopup(){
        try{

         var args    = new Array();
         var rv = openPopup("/Popup.do?cmd=orgBasicPopup", args, "740","520");
            if(rv!=null){

             $("#searchOrgCd").val(rv["orgCd"]);
             $("#searchOrgNm").val(rv["orgNm"]);

            }
        }catch(ex){alert("Open Popup Event Error : " + ex);}
    }


	//출력
	function print(gubun) {

	    var sabuns = "";
	    var payActionCds = "";
	    var checked = "";
	    var searchAllCheck = "";
	    var sabunCnt = 0;

	    if(sheet1.RowCount() != 0) {

	        for(i=1; i<=sheet1.LastRow(); i++) {

	            checked = sheet1.GetCellValue(i, "checked");

	            if (checked == "1" || checked == "Y") {
	                sabuns += "'"+sheet1.GetCellValue( i, "sabun" ) + "',";
	                payActionCds += "'"+sheet1.GetCellValue( i, "payActionCd" ) + "',";
	            }
	        }

	        sabuns = sabuns.substr(0,sabuns.length-1);
	        payActionCds = payActionCds.substr(0,payActionCds.length-1);
	        if (sabuns.length < 1) {
	        	alert("<msg:txt mid='alertMonPayMailCre4' mdef='선택된 사원이 없습니다.'/>");
	            return;
	        }

	        if(gubun == "1"){
	            // retMonRptStaPopup(sabuns, payActionCds) ;
				showRd(sabuns, payActionCds);
	        }

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
	function retMonRptStaPopup(sabuns, payActionCds){
		if(!isPopup()) {return;}

  		var w 		= 800;
		var h 		= 600;
		var url 	= "${ctx}/RdPopup.do";
		var args 	= new Array();
		// args의 Y/N 구분자는 없으면 N과 같음

		args["rdTitle"] = "<tit:txt mid='113139' mdef='퇴직금계산서'/>" ;//rd Popup제목
		args["rdMrd"] = "cpn/payRetire/RetirementPayAccount3.mrd" ;//( 공통경로 /html/report/는 공통에서 처리)업무경로+rd파일명
		args["rdParam"] = "['${ssnEnterCd}'] ["+payActionCds+"] ["+sabuns+"]" ;//rd파라매터
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

		openPopup(url,args,w,h);//알디출력을 위한 팝업창

	}

	function showRd(sabuns, payActionCds){
		let parameters = Utils.encase('\'' + '${ssnEnterCd}' + '\'') + ' ';
		parameters += Utils.encase(payActionCds) + ' ';
		parameters += Utils.encase(sabuns) + ' ';

		/*
		const data2 = {
			rdMrd : '/cpn/payRetire/RetirementPayAccount3.mrd'
			, parameterType : 'rp'//rp 또는 rv
			, parameters : parameters
		};
		window.top.showRdLayer(data);
		 */
		 
        //출력 대상자 rk 추출
        let rkList = [];
        let checkedRows = sheet1.FindCheckedRow('checked');
        $(checkedRows.split("|")).each(function(index,value){
            rkList[index] = sheet1.GetCellValue(value, 'rk');
        });
        
        const data = {
            rk : rkList
        };
        window.top.showRdLayer('/RetMonRptSta.do?cmd=getEncryptRd', data);
		
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
						<th><tit:txt mid='114444' mdef='대상년월'/></th>
						<td>
							<input type="text" id="searchSYm" name="searchSYm" class="date2"/> ~
							<input type="text" id="searchEYm" name="searchEYm" class="date2"/>
						</td>
						<th><tit:txt mid='114519' mdef='급여구분 '/></th>
	                    <td><select id="searchPayCd" name="searchPayCd"></select></td>
	                    <th><tit:txt mid='104330' mdef='사번/성명'/></th>
						<td>
							<input type="text" id="searchText" name ="searchText" onChange="javascript:doAction1('Search')" class="text">
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
							<li id="txt" class="txt"><tit:txt mid='113139' mdef='퇴직금계산서'/></li>
							<li class="btn">
								<btn:a href="javascript:print(1)" 	css="basic authA" mid='110727' mdef="출력"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","${ssnLocaleCd}"); </script>
			</td>
			<td class="sheet_right">
			    <!-- 팁 시작 -->
			    <table>
			    <tr><td>&nbsp;</td></tr>
			    <tr><td>&nbsp;</td></tr>
			    <tr>
			    <td>
				    <div class="explain w100p">
				    <dl>
				        <dd><tit:txt mid='113141' mdef='1. [퇴직금계산서] 발행화면입니다.'/></dd>
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
