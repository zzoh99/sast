<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='searchResearchNmPopup' mdef='설문 리스트 조회'/></title>
<script type="text/javascript">

	var gPRow = "";
	var pGubun = "";

	$(function() {
		createIBSheet3(document.getElementById('researchAppLayerSheet-wrap'), "researchAppLayerSheet", "100%", "100%","${ssnLocaleCd}");

		const modal = window.top.document.LayerModalUtility.getModal('researchAppLayer');
		var searchEduOrgNm = modal.parameters.searchEduOrgNm || '';
		$("#searchEduOrgNm").val(searchEduOrgNm);

		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly, AutoFitColWidth:'init|search|resize|rowtransaction'};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>", Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
            {Header:"<sht:txt mid='researchAppSeqV1' mdef='설문순서'/>", Type:"Text", Hidden:1,  Width:150,  Align:"Left", ColMerge:0,   SaveName:"code", KeyField:0,   CalcLogic:"", Format:"", PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:1000},
            {Header:"<sht:txt mid='researchAppNmV1' mdef='설문명'/>", Type:"Text", Hidden:0,  Width:150,  Align:"Left", ColMerge:0,   SaveName:"codeNm", KeyField:0,   CalcLogic:"", Format:"", PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:1000}
        ]; IBS_InitSheet(researchAppLayerSheet, initdata);researchAppLayerSheet.SetEditable(false);researchAppLayerSheet.SetVisible(true);researchAppLayerSheet.SetCountPosition(4);researchAppLayerSheet.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");

		var sheetHeight = $('.modal_body').height() - $('.sheet_title').height() - $('#researchAppLayerSheetForm').height();
		researchAppLayerSheet.SetSheetHeight(sheetHeight);

		$("#searchResearchAppNm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});

		researchAppLayerSheet.SetDataLinkMouse("detail", 1);
		doAction1("Search");

	});

	/**
	 * Sheet 각종 처리
	 */
	function doAction1(sAction){
	    switch(sAction){
	        case "Search":      //조회
	        	researchAppLayerSheet.DoSearch( "${ctx}/ResearchResultLst.do?cmd=getResearchResultLstResearchList", $("#researchAppLayerSheetForm").serialize() );
	            break;
	        case "Down2Excel":  //엑셀내려받기
	            researchAppLayerSheet.Down2Excel();
	            break;
	    }
	}
	</script>

	<!-- 조회 후 에러 메시지 -->
	<script language="javascript">
	  function researchAppLayerSheet_OnSearchEnd(Code, ErrMsg, StCode, StMsg){
	  try{
	    if (ErrMsg != ""){
	        alert(ErrMsg);
	    }
	    //setSheetSize(this);
	  }catch(ex){alert("OnSearchEnd Event Error : " + ex);}
	}
	</script>

	<script language="javascript">
	  function researchAppLayerSheet_OnClick(Row, Col, Value){
	  try{

	    if(Row > 0 && researchAppLayerSheet.ColSaveName(Col) == "detail"){
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

				args["eduOrgCd"]         =   researchAppLayerSheet.GetCellValue(Row, "eduOrgCd"         );
				args["eduOrgNm"]         =   researchAppLayerSheet.GetCellValue(Row, "eduOrgNm"         );
				args["mainEduOrgYn"]     =   researchAppLayerSheet.GetCellValue(Row, "mainEduOrgYn"     );
				args["nationalCd"]       =   researchAppLayerSheet.GetCellValue(Row, "nationalCd"       );
				args["zip"]              =   researchAppLayerSheet.GetCellValue(Row, "zip"              );
				args["curAddr1"]         =   researchAppLayerSheet.GetCellValue(Row, "curAddr1"         );
				args["curAddr2"]         =   researchAppLayerSheet.GetCellValue(Row, "curAddr2"         );
				args["bigo"]             =   researchAppLayerSheet.GetCellValue(Row, "bigo"             );
				args["chargeName"]       =   researchAppLayerSheet.GetCellValue(Row, "chargeName"       );
				args["orgNm"]            =   researchAppLayerSheet.GetCellValue(Row, "orgNm"            );
				args["jikweeNm"]         =   researchAppLayerSheet.GetCellValue(Row, "jikweeNm"         );
				args["telNo"]            =   researchAppLayerSheet.GetCellValue(Row, "telNo"            );
				args["telHp"]            =   researchAppLayerSheet.GetCellValue(Row, "telHp"            );
				args["faxNo"]            =   researchAppLayerSheet.GetCellValue(Row, "faxNo"            );
				args["email"]            =   researchAppLayerSheet.GetCellValue(Row, "email"            );
				args["companyNum"]       =   researchAppLayerSheet.GetCellValue(Row, "companyNum"       );
				args["companyHead"]      =   researchAppLayerSheet.GetCellValue(Row, "companyHead"      );
				args["businessPart"]     =   researchAppLayerSheet.GetCellValue(Row, "businessPart"     );
				args["businessType"]     =   researchAppLayerSheet.GetCellValue(Row, "businessType"     );
				args["bankNum"]          =   researchAppLayerSheet.GetCellValue(Row, "bankNum"          );
				args["bankCd"]           =   researchAppLayerSheet.GetCellValue(Row, "bankCd"           );
				args["mainEduOrgYn_STR"] =   researchAppLayerSheet.GetCellValue(Row, "mainEduOrgYn_STR" );
		}
		openPopup(url,args,w,h);
	}

	function researchAppLayerSheet_OnDblClick(Row, Col){
		const p = {
			code : researchAppLayerSheet.GetCellValue(Row, "code"),
			codeNm : researchAppLayerSheet.GetCellValue(Row, "codeNm")
		};

		const modal = window.top.document.LayerModalUtility.getModal('researchAppLayer');

		modal.fire('researchAppLayerTrigger', p).hide();
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
	<div class="wrapper modal_layer">
        <div class="modal_body">
		<form id="researchAppLayerSheetForm" name="researchAppLayerSheetForm" tabindex="1">
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

		<div class="inner survey-wrap">
			<div class="sheet_title">
			</div>
			<div id="researchAppLayerSheet-wrap"></div>
		</div>
	</div>
	<div class="modal_footer">
		<btn:a href="javascript:closeCommonLayer('researchAppLayer');" css="gray large" mid='110881' mdef="닫기"/>
	</div>
</div>
</body>
</html>
