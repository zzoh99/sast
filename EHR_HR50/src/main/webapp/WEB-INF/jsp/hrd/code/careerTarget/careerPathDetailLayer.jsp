<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ajax.jsp"%>
<script type="text/javascript">
	var gSheet = "";
	var gSheetNm = "";
	var searchCareerTargetCd = "";
	var careerTargetNm       = "";

	$(function() {
		createIBSheet3(document.getElementById('careerPathDetailLayerSheet1-wrap'), "careerPathDetailLayerSheet1", "100%", "100%", "${ssnLocaleCd}");
		createIBSheet3(document.getElementById('careerPathDetailLayerSheet2-wrap'), "careerPathDetailLayerSheet2", "100%", "30%", "${ssnLocaleCd}");
		createIBSheet3(document.getElementById('careerPathDetailLayerSheet3-wrap'), "careerPathDetailLayerSheet3", "100%", "30%", "${ssnLocaleCd}");
		createIBSheet3(document.getElementById('careerPathDetailLayerSheet4-wrap'), "careerPathDetailLayerSheet4", "100%", "30%", "${ssnLocaleCd}");
		createIBSheet3(document.getElementById('careerPathDetailLayerSheet5-wrap'), "careerPathDetailLayerSheet5", "100%", "0%", "${ssnLocaleCd}");

		const modal = window.top.document.LayerModalUtility.getModal('careerPathDetailLayer');

		searchCareerTargetCd = modal.parameters.careerTargetCd || '';
		careerTargetNm       = modal.parameters.careerTargetNm || '';

		let titleTxt = careerTargetNm + " 경력경로";

		$('#modal-careerPathDetailLayer').find('div.layer-modal-header span.layer-modal-title').text(titleTxt);
		$('#searchCareerTargetCd').val(searchCareerTargetCd);

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msAll, AutoFitColWidth:'init|search|resize|rowtransaction'};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",	Align:"Center", ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='BLANK' mdef='직렬코드'/>",      Type:"Text",    Hidden:1, Width:0,  Align:"Left", ColMerge:0, SaveName:"jikCd",    KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:10 },
			{Header:"<sht:txt mid='BLANK' mdef='직렬'/>",      Type:"Text",    Hidden:1, Width:150,  Align:"Left", ColMerge:1, SaveName:"jikNm",    KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:4000 },
			{Header:"<sht:txt mid='BLANK' mdef='직무코드'/>",      Type:"Text",    Hidden:1, Width:0,  Align:"Left", ColMerge:0, SaveName:"jobCd",    KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:10 },
			{Header:"<sht:txt mid='BLANK' mdef='직무'/>",      Type:"Text",    Hidden:0, Width:200,  Align:"Left", ColMerge:0, SaveName:"jobNm",    KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:4000 },
            ];
		IBS_InitSheet(careerPathDetailLayerSheet1, initdata);careerPathDetailLayerSheet1.SetEditable("${editable}");careerPathDetailLayerSheet1.SetVisible(true);careerPathDetailLayerSheet1.SetCountPosition(0);


		var initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad, Page:22,MergeSheet:msAll, AutoFitColWidth:'init|search|resize|rowtransaction'};
		initdata2.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
		initdata2.Cols = [
			{Header:"삭제",	Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:22,	Align:"Center", ColMerge:0,	SaveName:"sDelete"},
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",     Type:"${sSttTy}", Hidden:Number("${sSttHdn}"),  Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0 },
			{Header:"<sht:txt mid='BLANK' mdef='경력목표코드'/>",      Type:"Text",    Hidden:1, Width:0,  Align:"Left", ColMerge:0, SaveName:"careerTargetCd",    KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:22 },
			{Header:"<sht:txt mid='BLANK' mdef='경력경로코드'/>",      Type:"Text",    Hidden:1, Width:0,  Align:"Left", ColMerge:0, SaveName:"careerPathCd",    KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:2 },
			{Header:"<sht:txt mid='BLANK' mdef='구분'/>",      Type:"Text",    Hidden:1, Width:0,  Align:"Left", ColMerge:0, SaveName:"careerPathNm",    KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:100 },
			{Header:"<sht:txt mid='BLANK' mdef='직렬코드'/>",      Type:"Text",    Hidden:1, Width:0,  Align:"Left", ColMerge:0, SaveName:"jikCd",    KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:10 },
			{Header:"<sht:txt mid='BLANK' mdef='직렬'/>",      Type:"Text",    Hidden:1, Width:145,  Align:"Left", ColMerge:1, SaveName:"jikNm",    KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:4000 },
			{Header:"<sht:txt mid='BLANK' mdef='직무코드'/>",      Type:"Text",    Hidden:1, Width:0,  Align:"Left", ColMerge:0, SaveName:"jobCd",    KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:10 },
			{Header:"<sht:txt mid='BLANK' mdef='직무'/>",      Type:"Text",    Hidden:0, Width:150,  Align:"Left", ColMerge:0, SaveName:"jobNm",    KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:4000 },
			{Header:"<sht:txt mid='BLANK' mdef='선행\n직무'/>",          Type:"Combo",  Hidden:0, Width:100,  Align:"Left", ColMerge:0, SaveName:"bfJobCd",    KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:10 },
			{Header:"<sht:txt mid='BLANK' mdef='최소\n수행기간'/>",      Type:"Int",    Hidden:0, Width:55,  Align:"Center", ColMerge:0, SaveName:"exeTerm",    KeyField:0, CalcLogic:"", Format:"Integer",  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:2 },

		]; IBS_InitSheet(careerPathDetailLayerSheet2, initdata2); careerPathDetailLayerSheet2.SetCountPosition(0);

		var initdata3 = {};
		initdata3.Cfg = {SearchMode:smLazyLoad, Page:22,MergeSheet:msAll, AutoFitColWidth:'init|search|resize|rowtransaction'};
		initdata3.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
		initdata3.Cols = [
			{Header:"삭제",	Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:22,	Align:"Center", ColMerge:0,	SaveName:"sDelete"},
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",     Type:"${sSttTy}", Hidden:Number("${sSttHdn}"),  Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0 },
			{Header:"<sht:txt mid='BLANK' mdef='경력목표코드'/>",      Type:"Text",    Hidden:1, Width:0,  Align:"Left", ColMerge:0, SaveName:"careerTargetCd",    KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:22 },
			{Header:"<sht:txt mid='BLANK' mdef='경력경로코드'/>",      Type:"Text",    Hidden:1, Width:0,  Align:"Left", ColMerge:0, SaveName:"careerPathCd",    KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:2 },
			{Header:"<sht:txt mid='BLANK' mdef='구분'/>",      Type:"Text",    Hidden:1, Width:0,  Align:"Left", ColMerge:0, SaveName:"careerPathNm",    KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:100 },
			{Header:"<sht:txt mid='BLANK' mdef='직렬코드'/>",      Type:"Text",    Hidden:1, Width:0,  Align:"Left", ColMerge:0, SaveName:"jikCd",    KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:10 },
			{Header:"<sht:txt mid='BLANK' mdef='직렬'/>",      Type:"Text",    Hidden:1, Width:145,  Align:"Left", ColMerge:1, SaveName:"jikNm",    KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:4000 },
			{Header:"<sht:txt mid='BLANK' mdef='직무코드'/>",      Type:"Text",    Hidden:1, Width:0,  Align:"Left", ColMerge:0, SaveName:"jobCd",    KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:10 },
			{Header:"<sht:txt mid='BLANK' mdef='직무'/>",      Type:"Text",    Hidden:0, Width:150,  Align:"Left", ColMerge:0, SaveName:"jobNm",    KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:4000 },
			{Header:"<sht:txt mid='BLANK' mdef='선행\n직무'/>",          Type:"Combo",  Hidden:0, Width:100,  Align:"Left", ColMerge:0, SaveName:"bfJobCd",    KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:10 },
			{Header:"<sht:txt mid='BLANK' mdef='최소\n수행기간'/>",      Type:"Int",    Hidden:0, Width:55,  Align:"Center", ColMerge:0, SaveName:"exeTerm",    KeyField:0, CalcLogic:"", Format:"Integer",  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:2 },
		]; IBS_InitSheet(careerPathDetailLayerSheet3, initdata3); careerPathDetailLayerSheet3.SetCountPosition(0);



		var initdata4 = {};
		initdata4.Cfg = {SearchMode:smLazyLoad, Page:22,MergeSheet:msAll, AutoFitColWidth:'init|search|resize|rowtransaction'};
		initdata4.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
		initdata4.Cols = [
			{Header:"삭제",	Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:22,	Align:"Center", ColMerge:0,	SaveName:"sDelete"},
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",     Type:"${sSttTy}", Hidden:Number("${sSttHdn}"),  Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0 },
			{Header:"<sht:txt mid='BLANK' mdef='경력목표코드'/>",      Type:"Text",    Hidden:1, Width:0,  Align:"Left", ColMerge:0, SaveName:"careerTargetCd",    KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:22 },
			{Header:"<sht:txt mid='BLANK' mdef='경력경로코드'/>",      Type:"Text",    Hidden:1, Width:0,  Align:"Left", ColMerge:0, SaveName:"careerPathCd",    KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:2 },
			{Header:"<sht:txt mid='BLANK' mdef='구분'/>",      Type:"Text",    Hidden:1, Width:0,  Align:"Left", ColMerge:0, SaveName:"careerPathNm",    KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:100 },
			{Header:"<sht:txt mid='BLANK' mdef='직렬코드'/>",      Type:"Text",    Hidden:1, Width:0,  Align:"Left", ColMerge:0, SaveName:"jikCd",    KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:10 },
			{Header:"<sht:txt mid='BLANK' mdef='직렬'/>",      Type:"Text",    Hidden:1, Width:145,  Align:"Left", ColMerge:1, SaveName:"jikNm",    KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:4000 },
			{Header:"<sht:txt mid='BLANK' mdef='직무코드'/>",      Type:"Text",    Hidden:1, Width:0,  Align:"Left", ColMerge:0, SaveName:"jobCd",    KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:10 },
			{Header:"<sht:txt mid='BLANK' mdef='직무'/>",      Type:"Text",    Hidden:0, Width:150,  Align:"Left", ColMerge:0, SaveName:"jobNm",    KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:4000 },
			{Header:"<sht:txt mid='BLANK' mdef='선행\n직무'/>",          Type:"Combo",  Hidden:0, Width:100,  Align:"Left", ColMerge:0, SaveName:"bfJobCd",    KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:10 },
			{Header:"<sht:txt mid='BLANK' mdef='최소\n수행기간'/>",      Type:"Int",    Hidden:0, Width:55,  Align:"Center", ColMerge:0, SaveName:"exeTerm",    KeyField:0, CalcLogic:"", Format:"Integer",  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:2 },
		]; IBS_InitSheet(careerPathDetailLayerSheet4, initdata4); careerPathDetailLayerSheet4.SetCountPosition(0);


		var initdata5 = {};
		initdata5.Cfg = {SearchMode:smLazyLoad, Page:22, AutoFitColWidth:'init|search|resize|rowtransaction'};
		initdata5.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
		initdata5.Cols = [
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",  Type:"${sSttTy}", Hidden:Number("${sSttHdn}"),  Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0 },
			{Header:"<sht:txt mid='BLANK' mdef='경력목표코드'/>",      Type:"Text",    Hidden:1, Width:0,  Align:"Left", ColMerge:0, SaveName:"careerTargetCd",    KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:22 },
			{Header:"<sht:txt mid='BLANK' mdef='경력경로코드'/>",      Type:"Text",    Hidden:1, Width:0,  Align:"Left", ColMerge:0, SaveName:"careerPathCd",    KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:2 },
			{Header:"<sht:txt mid='BLANK' mdef='직무코드'/>",      Type:"Text",    Hidden:1, Width:0,  Align:"Left", ColMerge:0, SaveName:"jobCd",    KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:10 },
			{Header:"<sht:txt mid='BLANK' mdef='최소\n수행기간'/>",      Type:"Int",    Hidden:0, Width:55,  Align:"Center", ColMerge:0, SaveName:"exeTerm",    KeyField:0, CalcLogic:"", Format:"Integer",  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:2 },
		]; IBS_InitSheet(careerPathDetailLayerSheet5, initdata5); careerPathDetailLayerSheet5.SetCountPosition(0);

		const vlttt = codeList("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "getCareerPathJobCd")
		const vlJobCd = stfConvCode( vlttt, "");

		careerPathDetailLayerSheet2.SetColProperty("bfJobCd", 		{ComboText:"|" + vlJobCd[0], ComboCode:"|"+ vlJobCd[1]} );
		careerPathDetailLayerSheet3.SetColProperty("bfJobCd", 		{ComboText:"|" + vlJobCd[0], ComboCode:"|"+ vlJobCd[1]} );
		careerPathDetailLayerSheet4.SetColProperty("bfJobCd", 		{ComboText:"|" + vlJobCd[0], ComboCode:"|"+ vlJobCd[1]} );

		let sheetHeight1 = $(".modal_body").height() - $(".sheet_title").height() - 2;
		careerPathDetailLayerSheet1.SetSheetHeight(sheetHeight1);
		let sheetHeight2 = (sheetHeight1 / 3) - ( $(".sheet_title").height()) ;
		careerPathDetailLayerSheet2.SetSheetHeight(sheetHeight2);
		careerPathDetailLayerSheet3.SetSheetHeight(sheetHeight2);
		careerPathDetailLayerSheet4.SetSheetHeight(sheetHeight2);
		careerPathDetailLayerSheet5.SetSheetHeight(sheetHeight2);

		doAction1("Search");
		doAction2("Search");
		doAction3("Search");
		doAction4("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Search":
				careerPathDetailLayerSheet1.DoSearch( "${ctx}/CareerTarget.do?cmd=getCareerPathDetailSHT1", $("#mySheetForm").serialize() );
				break;
			case "Insert": //입력
				var Row = careerPathDetailLayerSheet1.DataInsert(0);
				break;

		}
	}

	// 조회 후 에러 메시지
	function careerPathDetailLayerSheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg);	}
			// sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function careerPathDetailLayerSheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } doAction1('Search'); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	//Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
			case "Search":
				careerPathDetailLayerSheet2.DoSearch( "${ctx}/CareerTarget.do?cmd=getCareerPathDetailSHT2", $("#mySheetForm").serialize()+"&searchCareerPathCd=G1" );
				break;
			case "Insert": //입력
				var Row = careerPathDetailLayerSheet2.DataInsert(0);
				break;

			case "Save": //저장
				IBS_SaveName(document.mySheetForm, careerPathDetailLayerSheet2);
				careerPathDetailLayerSheet2.DoSave("${ctx}/CareerTarget.do?cmd=saveCareerPathDetailSHT2", $("#mySheetForm").serialize(), -1, 0);
				break;

		}
	}

	// 조회 후 에러 메시지
	function careerPathDetailLayerSheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg);	}
			// sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function careerPathDetailLayerSheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { showMessage(Msg); } doAction2('Search'); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}


	//Sheet3 Action
	function doAction3(sAction) {
		switch (sAction) {
			case "Search":

				careerPathDetailLayerSheet3.DoSearch( "${ctx}/CareerTarget.do?cmd=getCareerPathDetailSHT2", $("#mySheetForm").serialize()+"&searchCareerPathCd=G2" );
				break;
			case "Insert": //입력
				var Row = careerPathDetailLayerSheet3.DataInsert(0);
				break;

			case "Save": //저장
				IBS_SaveName(document.mySheetForm, careerPathDetailLayerSheet3);
				careerPathDetailLayerSheet3.DoSave("${ctx}/CareerTarget.do?cmd=saveCareerPathDetailSHT2", $("#mySheetForm").serialize(), -1, 0);
				break;

		}
	}

	// 조회 후 에러 메시지
	function careerPathDetailLayerSheet3_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg);	}
			// sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function careerPathDetailLayerSheet3_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { showMessage(Msg); } doAction3('Search'); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	//Sheet4 Action
	function doAction4(sAction) {
		switch (sAction) {
			case "Search":
				careerPathDetailLayerSheet4.DoSearch( "${ctx}/CareerTarget.do?cmd=getCareerPathDetailSHT2", $("#mySheetForm").serialize()+"&searchCareerPathCd=G3" );
				break;
			case "Insert": //입력
				var Row = careerPathDetailLayerSheet4.DataInsert(0);
				break;

			case "Save": //저장
				IBS_SaveName(document.mySheetForm, careerPathDetailLayerSheet4);
				careerPathDetailLayerSheet4.DoSave("${ctx}/CareerTarget.do?cmd=saveCareerPathDetailSHT2", $("#mySheetForm").serialize(), -1, 0);

				break;

		}
	}

	// 조회 후 에러 메시지
	function careerPathDetailLayerSheet4_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg);	}
			// sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function careerPathDetailLayerSheet4_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { showMessage(Msg); } doAction4('Search'); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}


	//Sheet5 Action
	function doAction5(sAction) {
		switch (sAction) {
			case "Search":
				careerPathDetailLayerSheet5.DoSearch( "${ctx}/CareerTarget.do?cmd=getCareerPathDetailSHT2", $("#mySheetForm").serialize());
				break;
			case "Insert": //입력
				var Row = careerPathDetailLayerSheet5.DataInsert(0);
				break;
			case "Save": //저장
				IBS_SaveName(document.mySheetForm, careerPathDetailLayerSheet5);
				careerPathDetailLayerSheet5.DoSave("${ctx}/CareerTarget.do?cmd=saveCareerPathDetailSHT2", $("#mySheetForm").serialize(),-1,0);
				break;
		}
	}

	// 조회 후 에러 메시지
	function careerPathDetailLayerSheet5_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg);	}
			// sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function careerPathDetailLayerSheet5_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") { showMessage(Msg); }

			switch (gSheetNm) {
				case "careerPathDetailLayerSheet2" : doAction2("Search"); break;
				case "careerPathDetailLayerSheet3" : doAction3("Search"); break;
				case "careerPathDetailLayerSheet4" : doAction4("Search"); break;
			}

		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}


	function showMessage(Msg) {
		if (Msg != "저장 되었습니다.") {
			alert(Msg);
		}
	}

</script>


<script language="JavaScript">

	/* 1단계 Sheet 저장 */
	function doSave1()
	{
		gSheetNm = "careerPathDetailLayerSheet2";
		if ( fnChkDupStep(careerPathDetailLayerSheet2,'1') ) return;
		doAction2("Insert");
		setSHTData("G1", careerPathDetailLayerSheet2);
	}

	/* 2단계 Sheet 저장 */
	function doSave2()
	{
		gSheetNm = "careerPathDetailLayerSheet3";
		if ( fnChkDupStep(careerPathDetailLayerSheet3,'2') ) return;
		doAction3("Insert");
		setSHTData("G2", careerPathDetailLayerSheet3);
	}

	/* 3단계 Sheet 저장 */
	function doSave3()
	{
		gSheetNm = "careerPathDetailLayerSheet4";
		if ( fnChkDupStep(careerPathDetailLayerSheet4,'3') ) return;
		doAction4("Insert");
		setSHTData("G3", careerPathDetailLayerSheet4);
	}

	/* 1단계 Sheet Row 삭제 */
	function doDelete1()
	{
		careerPathDetailLayerSheet2.SetCellValue(careerPathDetailLayerSheet2.GetSelectRow(),"sStatus","D");
	}

	/* 2단계 Sheet Row 삭제 */
	function doDelete2()
	{
		careerPathDetailLayerSheet3.SetCellValue(careerPathDetailLayerSheet3.GetSelectRow(),"sStatus","D");
	}

	/* 3단계 Sheet Row 삭제 */
	function doDelete3()
	{
		careerPathDetailLayerSheet4.SetCellValue(careerPathDetailLayerSheet4.GetSelectRow(),"sStatus","D");
	}

	/* Arrow 버튼 추가시 Sheet별 파라미터 세팅 */
	function setSHTData(pCareerPathCd, paramSheet)
	{
		paramSheet.SetCellValue(paramSheet.GetSelectRow(),"careerTargetCd"  ,$('#searchCareerTargetCd').val());
		paramSheet.SetCellValue(paramSheet.GetSelectRow(),"careerPathCd"    ,pCareerPathCd);
		paramSheet.SetCellValue(paramSheet.GetSelectRow(),"jobCd"           ,careerPathDetailLayerSheet1.GetCellValue(careerPathDetailLayerSheet1.GetSelectRow(), "jobCd"));
		paramSheet.SetCellValue(paramSheet.GetSelectRow(),"jobNm"           ,careerPathDetailLayerSheet1.GetCellValue(careerPathDetailLayerSheet1.GetSelectRow(), "jobNm"));
		paramSheet.SetCellValue(paramSheet.GetSelectRow(),"exeTerm"         ,"1");
	}

	function fnChkDupStep(pSheet,step)
	{
		var bResult = false;

		var szJobCd = careerPathDetailLayerSheet1.GetCellValue(careerPathDetailLayerSheet1.GetSelectRow(), "jobCd");

		for ( i=1; i <= pSheet.LastRow(); i++ ) {
			
			if (  pSheet.GetCellValue(i, "jobCd") == szJobCd ) {
				alert(step+'단계 데이터와 중복입니다.');
				bResult = true;
				break;
			}

		}

		return bResult;
	}


	function doOpenCareerPath(Row) {
		if (!isPopup()) {
			return;
		}

		var w = 900;
		var h = 500;
		var url = "${ctx}/CareerPathPreView.do?cmd=viewCareerPathPreView&authPg=${authPg}";
		var args = new Array();

		args["careerTargetCd"] = $('#searchCareerTargetCd').val();
		args["careerTargetNm"] = careerTargetNm;

		gPRow = Row;
		pGubun = "careerPathPreViewPopup";

		openPopup(url, args, w, h);
	}

</script>

</head>
<div class="wrapper">
	<div class="wrapper modal_layer">
        <div class="modal_body">
		<form id="mySheetForm" name="mySheetForm">
			<input id="searchCareerTargetCd" name="searchCareerTargetCd" type="hidden"/>
		</form>
		<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
			<colgroup>
				<col width="45%" />
				<col width="5%"  />
				<col width="45%" />
			</colgroup>

					<tr>
				<td rowspan="3" class="top">
					<div>
						<div class="sheet_title outer">
							<ul>
								<li id="txt" class="txt">직무체계</li>
								<li class="btn">
<%-- 								        <btn:a href="javascript:doOpenCareerPath();"			css="basic authA" mid='preview' mdef="미리보기"/> --%>
								</li>
							</ul>
						</div>
					</div>
					<div id="careerPathDetailLayerSheet1-wrap"></div>

				<%--					<script type="text/javascript">createIBSheet("careerPathDetailLayerSheet1", "50%", "100%", "${ssnLocaleCd}"); </script>--%>
				</td>
				<td width="30" align="center">
					<div class="arrow_button">
						<a href="javascript:doSave3();" class="pink"><i class="mdi-ico filled">arrow_right</i></a>
					</div>
					<div class="arrow_button">
						<a href="javascript:doDelete3();" class="pink"><i class="mdi-ico filled">arrow_left</i></a>
					</div>
				</td>
				<td class="top" style="height:100px">
					<div>
						<div class="sheet_title">
							<ul>
								<li id="txt3" class="txt">3단계</li>
								<li class="btn">
									<btn:a href="javascript:doAction4('Save')"			css="basic authA" mid='save' mdef="저장"/>
								</li>
							</ul>
						</div>
					</div>
					<div id="careerPathDetailLayerSheet4-wrap"></div>

				<%--					<script type="text/javascript">createIBSheet("careerPathDetailLayerSheet4", "50%", "33%", "${ssnLocaleCd}"); </script>--%>
				</td>
			</tr>
			<tr>
				<td width="30" align="center">
					<div class="arrow_button">
						<a href="javascript:doSave2();" class="pink"><i class="mdi-ico filled">arrow_right</i></a>
					</div>
					<div class="arrow_button">
						<a href="javascript:doDelete2();" class="pink"><i class="mdi-ico filled">arrow_left</i></a>
					</div>
				</td>
				<td>
					<div class="inner">
						<div class="sheet_title">
							<ul>
								<li id="txt2" class="txt">2단계</li>
								<li class="btn">
									<btn:a href="javascript:doAction3('Save')"			css="basic authA" mid='save' mdef="저장"/>
								</li>
							</ul>
						</div>
					</div>
					<div id="careerPathDetailLayerSheet3-wrap"></div>

				<%--					<script type="text/javascript">createIBSheet("careerPathDetailLayerSheet3", "50%", "33%","${ssnLocaleCd}"); </script>--%>
				</td>
			</tr>
			<tr>
				<td width="30" align="center">
					<div class="arrow_button">
						<a href="javascript:doSave1();" class="pink"><i class="mdi-ico filled">arrow_right</i></a>
					</div>
					
					<div class="arrow_button">
						<a href="javascript:doDelete1();" class="pink"><i class="mdi-ico filled">arrow_left</i></a>
					</div>
				</td>
				<td>
					<div class="inner">
						<div class="sheet_title">
							<ul>
								<li id="txt1" class="txt">1단계</li>
								<li class="btn">
									<btn:a href="javascript:doAction2('Save')"			css="basic authA" mid='save' mdef="저장"/>
								</li>
							</ul>
						</div>
					</div>
<%--					<script type="text/javascript">createIBSheet("careerPathDetailLayerSheet2", "50%", "33%","${ssnLocaleCd}"); </script>--%>
					<div id="careerPathDetailLayerSheet2-wrap"></div>
				</td>
			</tr>
			<tr style="display:none">
				<td colspan="3">
<%--					<script type="text/javascript">createIBSheet("careerPathDetailLayerSheet5", "50%", "33%","${ssnLocaleCd}"); </script>--%>
					<div id="careerPathDetailLayerSheet5-wrap"></div>
				</td>
			</tr>
		</table>
       </div>
		<div class="modal_footer">
			<a href="javascript:closeCommonLayer('careerPathDetailLayer');" class="gray large"><tit:txt mid='104157' mdef='닫기'/></a>
		</div>
	</div>
</div>
</html>
