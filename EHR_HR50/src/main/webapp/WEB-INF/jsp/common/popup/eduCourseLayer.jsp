<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="bodywrap"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<script type="text/javascript">
var gPRow = "";
var pGubun = "";

	$(function() {
		const modal = window.top.document.LayerModalUtility.getModal('eduCourseLayer');
		//교육구분
		var eduBranchCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","L10010"), "전체");
		$("#searchEduBranchCd").html(eduBranchCdList[2]);
		//교육분류
		var eduMBranchCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","L10015"), "전체");
		$("#searchEduMBranchCd").html(eduMBranchCdList[2]);


		var arg = modal.parameters;
		if( arg != undefined ) {
			$("#searchEduBranchCd").val(arg["searchEduBranchCd"]);
			$("#searchEduMBranchCd").val(arg["searchEduMBranchCd"]);
			$("#searchEduMethodCd").val(arg["searchEduMethodCd"]);
			
		}

		createIBSheet3(document.getElementById('eduCourseLayerSht1-wrap'), "eduCourseLayerSht1", "100%", "100%", "${ssnLocaleCd}");

		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",				Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",				Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"교육구분",	Type:"Text",	Hidden:0,	Width:80,	Align:"Left",	SaveName:"eduBranchNm" ,	Edit:0 },
			{Header:"교육분류",	Type:"Text", 	Hidden:0,	Width:150, 	Align:"Left",	SaveName:"eduMBranchNm" ,	Edit:0 },
			{Header:"과정명",	Type:"Text", 	Hidden:0,	Width:180,	Align:"Left",	ColMerge:0,	SaveName:"eduCourseNm",	KeyField:0,	Format:"",	Edit:0 },
			{Header:"과정난이도",	Type:"Combo",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"eduLevel",	KeyField:0,	Format:"",	Edit:0 },

			//Hidden
			{Header:"과정상태",	Hidden:1,	SaveName:"eduStatusCd"},
			{Header:"교육기관",	Hidden:1,	SaveName:"eduOrgNm"},
			{Header:"구분",		Hidden:1,	SaveName:"inOutType"},
			{Header:"시행방법",	Hidden:1,	SaveName:"eduMethodCd"},
			{Header:"교육구분",	Hidden:1,	SaveName:"eduBranchCd"},
			{Header:"교육분류",	Hidden:1,	SaveName:"eduMBranchCd"},
			{Header:"관련직무",	Hidden:1,	SaveName:"jobNm"},
			{Header:"강의난이도",	Hidden:1,	SaveName:"eduLevel"},
			{Header:"필수여부",	Hidden:1,	SaveName:"mandatoryYn"},
			{Header:"비고",		Hidden:1,	SaveName:"note"},
			{Header:"Hidden", Hidden:1, SaveName:"eduSeq"},
			{Header:"Hidden", Hidden:1, SaveName:"eduOrgCd"},
			{Header:"Hidden", Hidden:1, SaveName:"jobCd"},
			
        ]; IBS_InitSheet(eduCourseLayerSht1, initdata);eduCourseLayerSht1.SetEditable("${editable}");eduCourseLayerSht1.SetVisible(true);eduCourseLayerSht1.SetCountPosition(4);


		//공통코드 한번에 조회
		var grpCds = "L10090'";
		var codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists&useYn=Y","grpCd="+grpCds,false).codeList, "전체");
		eduCourseLayerSht1.SetColProperty("eduLevel",  	{ComboText:"|"+codeLists["L10090"][0], ComboCode:"|"+codeLists["L10090"][1]} ); //과정난이도
		
		//교육구분 선택 시
		$("#searchEduBranchCd, #searchEduMBranchCd").on("change", function(e) {
			doAction1("Search");
		})
		$("#searchEduCourseNm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});
		
		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});
/**
 * Sheet 각종 처리
 */
function doAction1(sAction){
    switch(sAction){
        case "Search":      //조회

        	eduCourseLayerSht1.DoSearch( "${ctx}/EduCourseMgr.do?cmd=getEduCourseMgrList", $("#eduCourseLayerSht1Form").serialize() );
            break;

        case "Down2Excel":  //엑셀내려받기

            eduCourseLayerSht1.Down2Excel();
            break;

        case "LoadExcel":   //엑셀업로드

			var params = {Mode:"HeaderMatch", WorkSheetNo:1};
			eduCourseLayerSht1.LoadExcel(params);
            break;

    }
}

</script>

<script language="javascript">
  function eduCourseLayerSht1_OnSearchEnd(Code, ErrMsg, StCode, StMsg){
  try{
    if (ErrMsg != ""){
        alert(ErrMsg) ;
    }else{

        for( i = 1; i<=eduCourseLayerSht1.LastRow(); i++) {
            if( eduCourseLayerSht1.GetCellValue(i, "cnt") != "0" ) {
                eduCourseLayerSht1.SetCellEditable(i, "sDelete",false);
            }
        }

    }
	$(window).smartresize(sheetResize); sheetInit();
  }catch(ex){alert("OnSearchEnd Event Error : " + ex);}
}

function eduCourseLayerSht1_OnDblClick(Row, Col){
	var rv = new Array();
	
	rv["eduSeq"]		= eduCourseLayerSht1.GetCellValue(Row, "eduSeq");
	rv["eduCourseNm"]	= eduCourseLayerSht1.GetCellValue(Row, "eduCourseNm");
	rv["eduOrgCd"]		= eduCourseLayerSht1.GetCellValue(Row, "eduOrgCd");
	rv["eduOrgNm"]		= eduCourseLayerSht1.GetCellValue(Row, "eduOrgNm");
	rv["jobCd"]			= eduCourseLayerSht1.GetCellValue(Row, "jobCd");
	rv["jobNm"]			= eduCourseLayerSht1.GetCellValue(Row, "jobNm");
	rv["eduStatusCd"]	= eduCourseLayerSht1.GetCellValue(Row, "eduStatusCd");
	rv["inOutType"]		= eduCourseLayerSht1.GetCellValue(Row, "inOutType");
	rv["eduMethodCd"]	= eduCourseLayerSht1.GetCellValue(Row, "eduMethodCd");
	rv["eduBranchCd"]	= eduCourseLayerSht1.GetCellValue(Row, "eduBranchCd");
	rv["eduMBranchCd"]	= eduCourseLayerSht1.GetCellValue(Row, "eduMBranchCd");
	rv["eduLevel"]		= eduCourseLayerSht1.GetCellValue(Row, "eduLevel");
	rv["mandatoryYn"]	= eduCourseLayerSht1.GetCellValue(Row, "mandatoryYn");
	rv["note"]			= eduCourseLayerSht1.GetCellValue(Row, "note");

	const modal = window.top.document.LayerModalUtility.getModal('eduCourseLayer');
	modal.fire('eduCourseLayerTrigger', rv).hide();
}

</script>
</head>
<body class="bodywrap">
<div class="wrapper modal_layer">
	<div class="modal_body">
        <form id="eduCourseLayerSht1Form" name="eduCourseLayerSht1Form" tabindex="1">
            <input type="hidden" id="searchEduMethodCd" name="searchEduMethodCd" />
			<div class="sheet_search outer">
				<table>
					<tr>
						<th>교육구분</th>
						<td>
							<select id="searchEduBranchCd" name="searchEduBranchCd"></select>
						</td>
						<th>교육분류</th>
						<td>
							<select id="searchEduMBranchCd" name="searchEduMBranchCd"></select>
						</td>
					</tr>
					<tr>
						<th class="hide"><tit:txt mid='112022' mdef='과정코드 '/></th>
						<td class="hide"> 
						    <input id="searchEduCourseCd" name ="searchEduCourseCd" type="text" class="text w50" maxlength="10"/> </td>
						<th><tit:txt mid='114492' mdef='과정명 '/></th>
						<td>
						    <input id="searchEduCourseNm" name ="searchEduCourseNm" type="text" class="text w150" /> </td>
						<td>
						<a href="javascript:doAction1('Search')" id="btnSearch" class="button"><tit:txt mid='104081' mdef='조회'/></a>
					</td>
					</tr>
				</table>
			</div>
		</form>
		<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
			<tr>
				<td>
					<div class="inner">
						<div class="sheet_title">
							<ul>
								<li id="txt" class="txt"><tit:txt mid='eduCoursePopV1' mdef='교육과정'/></li>

							</ul>
						</div>
					</div>
					<div id="eduCourseLayerSht1-wrap"></div>
				</td>
			</tr>
		</table>
	</div>
	<div class="modal_footer">
		<a href="javascript:closeCommonLayer('eduCourseLayer');" class="btn outline_gray"><tit:txt mid='104157' mdef='닫기'/></a>
	</div>
</div>
</body>
</html>
