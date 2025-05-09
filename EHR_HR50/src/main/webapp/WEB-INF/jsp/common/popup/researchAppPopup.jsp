<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='searchResearchNmPopup' mdef='설문 리스트 조회'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
// 	var srchBizCd = null;
// 	var srchTypeCd = null;
	var p = eval("${popUpStatus}");

	var gPRow = "";
	var pGubun = "";

	$(function() {

		var arg = p.popDialogArgumentAll();
		if( arg != undefined ) {
			$("#searchEduOrgNm").val( arg["searchEduOrgNm"]);
		}

		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>", Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
            {Header:"<sht:txt mid='researchAppSeqV1' mdef='설문순서'/>", Type:"Text", Hidden:1,  Width:150,  Align:"Left", ColMerge:0,   SaveName:"code", KeyField:0,   CalcLogic:"", Format:"", PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:1000},
            {Header:"<sht:txt mid='researchAppNmV1' mdef='설문명'/>", Type:"Text", Hidden:0,  Width:150,  Align:"Left", ColMerge:0,   SaveName:"codeNm", KeyField:0,   CalcLogic:"", Format:"", PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:1000}
        ]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");

		$("#searchResearchAppNm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});

		sheet1.SetDataLinkMouse("detail", 1);
		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");

		//Cancel 버튼 처리
		$(".close").click(function(){
			p.self.close();
		});
	});

	/**
	 * Sheet 각종 처리
	 */
	function doAction1(sAction){
	    switch(sAction){
	        case "Search":      //조회

	        	sheet1.DoSearch( "${ctx}/ResearchResultLst.do?cmd=getResearchResultLstResearchList", $("#sheet1Form").serialize() );
	            break;

	        case "Insert":      //입력

	            //var Row = sheet1.DataInsert(0);
	            //sheet1.SetCellValue(Row, "nationalCd","001");
	            eduInstiMgrDetPopup("", "A") ;
	            break;

	        case "Down2Excel":  //엑셀내려받기

	            sheet1.Down2Excel();
	            break;

	        case "LoadExcel":   //엑셀업로드

				var params = {Mode:"HeaderMatch", WorkSheetNo:1};
				sheet1.LoadExcel(params);
	            break;

	    }
	}
	</script>

	<!-- 조회 후 에러 메시지 -->
	<script language="javascript">
	  function sheet1_OnSearchEnd(Code, ErrMsg, StCode, StMsg){
	  try{
	    if (ErrMsg != ""){
	        alert(ErrMsg);
	    }
	    //setSheetSize(this);
	  }catch(ex){alert("OnSearchEnd Event Error : " + ex);}
	}
	</script>

	<script language="javascript">
	  function sheet1_OnClick(Row, Col, Value){
	  try{

	    if(Row > 0 && sheet1.ColSaveName(Col) == "detail"){
	    	eduInstiMgrDetPopup(Row, "R") ;
	    }

	  }catch(ex){alert("OnClick Event Error : " + ex);}
	}
	</script>

	<script>

	/**
	 * 상세내역 window open event
	 */
	function eduInstiMgrDetPopup(Row, authPg){
		if(!isPopup()) {return;}

		var w 		= 860;
		var h 		= 800;
		var url 	= "${ctx}/EduInstiMgr.do?cmd=viewEduInstiMgrDetPopup&authPg=" + authPg;
		var args 	= new Array();

		gPRow = Row;
		pGubun = "viewEduInstiMgrDetPopup";

		if ( Row != "" ){

				args["eduOrgCd"]         =   sheet1.GetCellValue(Row, "eduOrgCd"         );
				args["eduOrgNm"]         =   sheet1.GetCellValue(Row, "eduOrgNm"         );
				args["mainEduOrgYn"]     =   sheet1.GetCellValue(Row, "mainEduOrgYn"     );
				args["nationalCd"]       =   sheet1.GetCellValue(Row, "nationalCd"       );
				args["zip"]              =   sheet1.GetCellValue(Row, "zip"              );
				args["curAddr1"]         =   sheet1.GetCellValue(Row, "curAddr1"         );
				args["curAddr2"]         =   sheet1.GetCellValue(Row, "curAddr2"         );
				args["bigo"]             =   sheet1.GetCellValue(Row, "bigo"             );
				args["chargeName"]       =   sheet1.GetCellValue(Row, "chargeName"       );
				args["orgNm"]            =   sheet1.GetCellValue(Row, "orgNm"            );
				args["jikweeNm"]         =   sheet1.GetCellValue(Row, "jikweeNm"         );
				args["telNo"]            =   sheet1.GetCellValue(Row, "telNo"            );
				args["telHp"]            =   sheet1.GetCellValue(Row, "telHp"            );
				args["faxNo"]            =   sheet1.GetCellValue(Row, "faxNo"            );
				args["email"]            =   sheet1.GetCellValue(Row, "email"            );
				args["companyNum"]       =   sheet1.GetCellValue(Row, "companyNum"       );
				args["companyHead"]      =   sheet1.GetCellValue(Row, "companyHead"      );
				args["businessPart"]     =   sheet1.GetCellValue(Row, "businessPart"     );
				args["businessType"]     =   sheet1.GetCellValue(Row, "businessType"     );
				args["bankNum"]          =   sheet1.GetCellValue(Row, "bankNum"          );
				args["bankCd"]           =   sheet1.GetCellValue(Row, "bankCd"           );
				args["mainEduOrgYn_STR"] =   sheet1.GetCellValue(Row, "mainEduOrgYn_STR" );
		}
		openPopup(url,args,w,h);
	}

	function sheet1_OnDblClick(Row, Col){
		var rv = new Array(5);
		rv["code"]	= sheet1.GetCellValue(Row, "code");
		rv["codeNm"] = sheet1.GetCellValue(Row, "codeNm");
		
		p.popReturnValue(rv);
		p.window.close();
	}

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

		if(pGubun == "viewEduInstiMgrDetPopup"){
			doAction1("Search");
		}

	}

</script>


</head>
<body class="bodywrap">

	<div class="wrapper">
		<div class="popup_title">
			<ul>
				<li><tit:txt mid='researchAppPop' mdef='설문 리스트 조회'/></li>
				<li class="close"></li>
			</ul>
		</div>
        <div class="popup_main">
		<form id="sheet1Form" name="sheet1Form" tabindex="1">
            <input type="hidden" id="searchEnterCd" name="searchEnterCd" />
            <input type="hidden" id="chkVisualYn" name="chkVisualYn" value="Y" />
			<div class="sheet_search outer">
				<div>
					<table>
						<tr>
	                		<th><tit:txt mid='112690' mdef='설문명'/></th>
		                	<td> 
		                        <input type="text" id="searchResearchAppNm" name="searchResearchAppNm" class="text w300 left" value="" />
								<btn:a href="javascript:doAction1('Search')" id="btnSearch" css="button" mid='110697' mdef="조회"/>
		                    </td>
						</tr>
					</table>
				</div>
			</div>
		</form>

		<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
			<tr>
				<td>
				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li id="txt" class="txt"><tit:txt mid='researchAppPopV1' mdef='설문'/></li>
						<li class="btn">
							<btn:a href="javascript:doAction1('Insert')" css="basic authA" mid='110700' mdef="입력"/>
						</li>
					</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","${ssnLocaleCd}"); </script>
				</td>
			</tr>
		</table>

		<div class="popup_button outer">
			<ul>
				<li>
					<btn:a href="javascript:p.self.close();" css="gray large" mid='110881' mdef="닫기"/>
				</li>
			</ul>
		</div>
	</div>
</div>
</body>
</html>
