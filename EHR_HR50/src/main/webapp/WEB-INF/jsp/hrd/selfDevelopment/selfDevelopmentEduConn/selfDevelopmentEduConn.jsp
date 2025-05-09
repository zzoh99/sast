<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">

	var popGubun;
	var gPRow = "";

	$(function() {
		
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22, ChildPage:5};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [

			{Header:"<sht:txt mid='sNo'     mdef='No'            />", Type:"${sNoTy}" , Hidden:Number("${sNoHdn}") , Width:"${sNoWdt}" , Align:"Center", ColMerge:0, SaveName:"sNo" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'          />", Type:"${sSttTy}", Hidden:Number("${sSttHdn}"), Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0 },
			{Header:"<sht:txt mid='BLANK'   mdef='방법'          />", Type:"Text"     , Hidden:1, Width:0  ,  Align:"Left"      , ColMerge:0, SaveName:"itemGubun"           , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10     },
			{Header:"<sht:txt mid='BLANK'   mdef='교육과정코드'  />", Type:"Text"     , Hidden:1, Width:0  ,  Align:"Left"      , ColMerge:0, SaveName:"education"           , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10     },
			{Header:"<sht:txt mid='BLANK'   mdef='번호'          />", Type:"Text"     , Hidden:1, Width:0  ,  Align:"Left"      , ColMerge:0, SaveName:"num"                 , KeyField:1, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:13     },
			{Header:"<sht:txt mid='BLANK'   mdef='희망교육과정명'/>", Type:"Text"     , Hidden:0, Width:160,  Align:"Left"      , ColMerge:0, SaveName:"educationnm"         , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:13     },
			{Header:"<sht:txt mid='BLANK'   mdef='희망인원'      />", Type:"Text"     , Hidden:0, Width:50 ,  Align:"Center"    , ColMerge:0, SaveName:"cnt"                 , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10     },
			{Header:"<sht:txt mid='BLANK'   mdef='가능여부'      />", Type:"Combo"    , Hidden:0, Width:70 ,  Align:"Center"    , ColMerge:0, SaveName:"educationYn"         , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:10     },
			{Header:"<sht:txt mid='BLANK'   mdef='실행년도'      />", Type:"Text"     , Hidden:1, Width:0  ,  Align:"Left"      , ColMerge:0, SaveName:"activeYyyy"          , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10     },
			{Header:"<sht:txt mid='BLANK'   mdef='반기구분'      />", Type:"Text"     , Hidden:1, Width:0  ,  Align:"Left"      , ColMerge:0, SaveName:"halfGubunType"       , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10     },

			]; IBS_InitSheet(sheet1, initdata);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [

			{Header:"<sht:txt mid='sNo'     mdef='No'            />", Type:"${sNoTy}" , Hidden:Number("${sNoHdn}") , Width:"${sNoWdt}" , Align:"Center", ColMerge:0, SaveName:"sNo" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'          />", Type:"${sSttTy}", Hidden:Number("${sSttHdn}"), Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0 },
			{Header:"<sht:txt mid='BLANK'   mdef='부코드'        />", Type:"Text"     , Hidden:1, Width:0  ,  Align:"Left"      , ColMerge:0, SaveName:"mainOrgCd"       , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:1      },
			{Header:"<sht:txt mid='BLANK'   mdef='부'            />", Type:"Text"     , Hidden:1, Width:125,  Align:"Center"    , ColMerge:0, SaveName:"mainOrgNm"       , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:13     },
			{Header:"<sht:txt mid='BLANK'   mdef='상위부서'            />", Type:"Text"     , Hidden:0, Width:125,  Align:"Center"    , ColMerge:0, SaveName:"priorOrgNm"       , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:13     },
			{Header:"<sht:txt mid='BLANK'   mdef='팀코드'        />", Type:"Text"     , Hidden:1, Width:0  ,  Align:"Left"      , ColMerge:0, SaveName:"orgCd"           , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:8      },
			{Header:"<sht:txt mid='BLANK'   mdef='소속'            />", Type:"Text"     , Hidden:0, Width:125,  Align:"Center"    , ColMerge:0, SaveName:"orgNm"           , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:1      },
			{Header:"<sht:txt mid='BLANK'   mdef='직급'          />", Type:"Text"     , Hidden:0, Width:50 ,  Align:"Center"    , ColMerge:0, SaveName:"jikgubNm"        , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10     },
			{Header:"<sht:txt mid='BLANK'   mdef='성명'          />", Type:"Text"     , Hidden:0, Width:50 ,  Align:"Center"    , ColMerge:0, SaveName:"name"            , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:20     },
			{Header:"<sht:txt mid='BLANK'   mdef='희망월'        />", Type:"Combo"    , Hidden:0, Width:50 ,  Align:"Center"    , ColMerge:0, SaveName:"eduPreYmd"       , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:20     },

		]; IBS_InitSheet(sheet2, initdata);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);

		fnSetCode();

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	function fnSetCode() {
		//상하반기
		var halfGubunTypeCd     = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","D00005"), "");
		sheet1.SetColProperty("halfGubunType", 	{ComboText:halfGubunTypeCd[0], ComboCode:halfGubunTypeCd[1]} );

		$("#searchHalfGubunTypeCd").html(halfGubunTypeCd[2]);              //.val("1");

		//var approvalStatusCd     = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","D00007"), "");
		//sheet1.SetColProperty("approvalStatus", 	{ComboText:approvalStatusCd[0], ComboCode:approvalStatusCd[1]} );

		var educationYnCd     = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","D00016"), " ");
		sheet1.SetColProperty("educationYn", 	{ComboText:educationYnCd[0], ComboCode:educationYnCd[1]} );

		var eduPreYmdCd     = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","D00014"), "");
		sheet2.SetColProperty("eduPreYmd" , {ComboText:eduPreYmdCd[0], ComboCode:eduPreYmdCd[1]} );

	}

	$(function() {

		$("#sYear").bind("keyup",function(event){
			makeNumber(this,"A");
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});
// 		$("#sYmd").datepicker2({startdate:"eYmd"});

// 		$("#sYmd").bind("keydown",function(event){
// 			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
// 		});
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			if ($("#sYear").val() == "") {
				alert("<msg:txt mid='alertVacationApp1' mdef='년도를 입력하여 주십시오.'/>");
				$("#sYear").focus();
				return;
			}

			sheet1.DoSearch( "${ctx}/SelfDevelopmentEduConn.do?cmd=getHopeEducationList", $("#srchFrm").serialize() );
			break;
		case "Save":
			IBS_SaveName(document.srchFrm,sheet1);
			sheet1.DoSave( "${ctx}/SelfDevelopmentEduConn.do?cmd=saveEducationYn", $("#srchFrm").serialize());
			break;
		}
	}

	//Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			var param = "&searchEducation="+sheet1.GetCellValue(sheet1.GetSelectRow(),"education");
			sheet2.DoSearch( "${ctx}/SelfDevelopmentEduConn.do?cmd=getHopePersonList", $("#srchFrm").serialize() + param);
			break;
		case "Down2Excel":
			sheet2.Down2Excel();
			break;
		}
	}



	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); }
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);

		}
	}

	// 셀이 선택 되었을때 발생한다
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol,isDelete) {
		try {
			if(OldRow != NewRow) {
				doAction2("Search");
			}
		} catch (ex) {
			alert("OnSelectCell Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
				doAction1('Search');
			}

		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}



	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != ""){
				alert(Msg);
			}
			sheetResize();
		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >

		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='BLANK' mdef='년도'/></th>
						<td>
							<input id="sYear" name ="sYear" type="text" class="text" maxlength="4"  value="${curSysYear}" />
						</td>
						<th>반기구분</th>
						<td>
							<select id="searchHalfGubunTypeCd" name="searchHalfGubunTypeCd"></select>
						</td>
						<th><tit:txt mid='104069' mdef='교육명'/></th>
						<td>
							<input type="text" id="searchEducationnm" name="searchEducationnm" class="text w150" />
						</td>
						<td><btn:a href="javascript:doAction1('Search')" id="btnSearch" css="button" mid='110697' mdef="조회"/></td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	<colgroup>
			<col width="32%" />
			<col width="68%" />
		</colgroup>
		<tr>
			<td class="sheet_left">
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='BLANK' mdef='희망교육과정'/>&nbsp;</li>
							<li class="btn">
								<btn:a href="javascript:doAction1('Save');" css="basic authA" mid='110708' mdef="저장"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet1", "30%", "100%", "${ssnLocaleCd}"); </script>
			</td>
		
			<td class="sheet_right">
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='BLANK' mdef='희망인원'/></li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet2", "100%", "100%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
	</form>
</div>
</body>
</html>
