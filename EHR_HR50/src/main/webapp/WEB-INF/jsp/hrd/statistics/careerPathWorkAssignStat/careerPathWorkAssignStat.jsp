<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
	<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
	<title>경력목표 세부내역</title>
	<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
	<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">

	var headerStartCnt = 0;
	var locationCdList = "";
	var p = eval("${popUpStatus}");

	var arg = p.popDialogArgumentAll();

	var searchCareerTargetCd = arg['careerTargetCd'];
	var careerTargetNm       = arg['careerTargetNm'];
	var searchJobCd          = arg['jobCd'];

	$(function() {


		//Cancel 버튼 처리
		$(".close").click(function(){
			p.self.close();
		});


		$("#title").html("직무별 단위업무 ( "+careerTargetNm + " )");



		var initdata = {};
		initdata.Cfg = {FrozenCol:6,SearchMode:smLazyLoad,Page:22,MergeSheet:msAll};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",     Type:"${sNoTy}",  Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },

			/*{Header:"<sht:txt mid='sStatus' mdef='상태'/>",     Type:"${sSttTy}", Hidden:Number("${sSttHdn}"),  Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0 },*/
			{Header:"<sht:txt mid='BLANK' mdef='대분류코드'        />",      Type:"Text" ,    Hidden:1, Width:0  ,  Align:"Left"  , ColMerge:0, SaveName:"gWorkAssignCd"   , KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100 },
			{Header:"<sht:txt mid='BLANK' mdef='대분류'            />",      Type:"Text" ,    Hidden:0, Width:160,  Align:"Center", ColMerge:1, SaveName:"gWorkAssignNm"   , KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100 },
			{Header:"<sht:txt mid='BLANK' mdef='중분류코드'        />",      Type:"Text" ,    Hidden:1, Width:0  ,  Align:"Left"  , ColMerge:0, SaveName:"mWorkAssignCd"   , KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100 },
			{Header:"<sht:txt mid='BLANK' mdef='중분류'            />",      Type:"Text" ,    Hidden:0, Width:200,  Align:"Center", ColMerge:1, SaveName:"mWorkAssignNm"   , KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100 },
			{Header:"<sht:txt mid='BLANK' mdef='단위업무코드'      />",      Type:"Text" ,    Hidden:1, Width:0  ,  Align:"Left"  , ColMerge:0, SaveName:"workAssignCd"    , KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100 },
			{Header:"<sht:txt mid='BLANK' mdef='단위업무명칭'      />",      Type:"Text" ,    Hidden:0, Width:250,  Align:"Left"  , ColMerge:0, SaveName:"workAssignNm"    , KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100 },
			{Header:"<sht:txt mid='BLANK' mdef='단위업무\n기술서'  />",      Type:"Image",    Hidden:0, Width:60 ,  Align:"Center", ColMerge:0, SaveName:"workAssignNote"  , KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:100 },
			{Header:"<sht:txt mid='BLANK' mdef='단위업무기술서코드'/>",      Type:"Text" ,    Hidden:1, Width:0  ,  Align:"Center", ColMerge:0, SaveName:"workAssignNoteCd", KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100 },


		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");


		sheet1.SetColProperty("useYn",          {ComboText:"Y|N", ComboCode:"Y|N"} );

		$("#searchWorkAssignNm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});

		sheet1.SetDataLinkMouse("workAssignNote", 1);

		$(window).smartresize(sheetResize); sheetInit();

		doAction1("Search");
	});

	//Sheet Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Search":
				sheet1.DoSearch("${ctx}/CareerPathWorkAssignStat.do?cmd=getCareerPathWorkAssignStat", $("#sheetForm").serialize()+"&searchCareerTargetCd="+searchCareerTargetCd+"&searchJobCd="+searchJobCd);
				break;

		}
	}

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try{
			if( sheet1.ColSaveName(Col) == "workAssignNote" ) {
				// TODO REPORT 단위업무기술서 출력
				ALERT("단위업무기술서 출력");
			}
		}catch(ex){
			alert("OnClick Event Error : " + ex);
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg, responseText) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}


	function getReturnValue(returnValue) {

		var rv = $.parseJSON('{'+ returnValue+'}');

		if( popGubun == "O"){
			$("#searchOrgCd").val(rv["orgCd"]);
        	$("#searchOrgNm").val(rv["orgNm"]);
        	doAction1("Search");
        }else if( popGubun == "E"){
   			$('#name').val(rv["name"]);
   			$('#searchSabun').val(rv["sabun"]);
   	    	doAction1("Search");
        }else if ( popGubun == "insert"){
			sheet1.SetCellValue(gPRow, "sabun",			rv["sabun"] );
			sheet1.SetCellValue(gPRow, "name",			rv["name"] );
			sheet1.SetCellValue(gPRow, "orgNm",			rv["orgNm"] );
			sheet1.SetCellValue(gPRow, "alias",			rv["alias"] );
			sheet1.SetCellValue(gPRow, "jikgubNm",		rv["jikgubNm"] );
			sheet1.SetCellValue(gPRow, "jikweeNm",		rv["jikweeNm"] );
			sheet1.SetCellValue(gPRow, "jikchakNm",		rv["jikchakNm"] );
			sheet1.SetCellValue(gPRow, "manageNm",		rv["manageNm"] );
	        sheet1.SetCellValue(gPRow, "workTypeNm",	rv["workTypeNm"] );
	        sheet1.SetCellValue(gPRow, "payTypeNm",		rv["payTypeNm"] );
        }
	}


</script>
</head>
<body class="bodywrap">


<div class="wrapper popup_scroll">
	<div class="popup_title">
		<ul>
			<li><span id="title"></span></li>
			<li class="close"></li>
		</ul>
	</div>

	<div class="popup_main">
		<form id="sheetForm" name="sheetForm" onsubmit="return false;">
			<input id="gubun" name="gubun" type="hidden" value="">
			<div class="sheet_search outer">
				<div>
					<table>
						<tr>
							<th><tit:txt mid='BLANK' mdef='단위업무명'/></th>
							<td>
								<input id="searchWorkAssignNm" name ="searchWorkAssignNm" type="text" class="text" />
							</td>
							<td>
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
								<li id="txt" class="txt"><tit:txt mid='BLNAK' mdef='단위업무'/></li>
							</ul>
						</div>
					</div>
					<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
				</td>
			</tr>
		</table>



		<div class="popup_button outer">
			<ul>
				<li>
					<%--<btn:a href="javascript:setValue();" css="pink large authA" mid='110716' mdef="확인"/>--%>
					<btn:a href="javascript:p.self.close();" css="gray large authR" mid='110881' mdef="닫기"/>
				</li>
			</ul>
		</div>

	</div>

</div>
</body>
</html>
