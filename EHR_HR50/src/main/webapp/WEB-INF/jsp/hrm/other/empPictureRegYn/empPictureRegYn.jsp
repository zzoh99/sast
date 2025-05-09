<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='pictureRegYn' mdef='개인사진등록여부'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	$(function() {
		var signViewYnData = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&searchStdCd=HRI_SIGN_VIEW_YN", "queryId=getSystemStdData",false).codeList, "");
		var signViewYn = "status";
		if(signViewYnData[0] != "") {
			if( signViewYnData[0] == "Y" ) {
				signViewYn = "0";
			} else if( signViewYnData[0] == "N" ) {
				signViewYn = "1";
			}
		}

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msAll};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNoV1' mdef='No|No'/>",		Type:"${sNoTy}",	Hidden:1,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
	        {Header:"<sht:txt mid='sDelete V1' mdef='삭제|삭제'/>",      Type:"${sDelTy}",   Hidden:1,  Width:Number("${sDelWdt}"), Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
	        {Header:"<sht:txt mid='sStatus V4' mdef='상태|상태'/>",      Type:"${sSttTy}",   Hidden:1,  Width:Number("${sSttWdt}"), Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
			{Header:"<sht:txt mid='photo' mdef='사진|사진'/>",			Type:"Image",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"photo", 		UpdateEdit:0, ImgWidth:40, ImgHeight:60 },
			{Header:"<sht:txt mid='sign' mdef='서명|서명'/>",			Type:"Image",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sign", 		UpdateEdit:0, ImgWidth:50, ImgHeight:60 },
			{Header:"<sht:txt mid='appOrgNmV6' mdef='소속|소속'/>",			Type:"Text",	Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='sabunV2' mdef='사번|사번'/>",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='nameV3' mdef='성명|성명'/>",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='2017082500567'  mdef='호칭|호칭'/>",			Type:"Text",	Hidden:Number("${aliasHdn}"),	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"alias",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='jikchakCdV1' mdef='직책|직책'/>",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='jikweeCdV1' mdef='직위|직위'/>",			Type:"Text",	Hidden:Number("${jwHdn}"),	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='jikgubCdV1' mdef='직급|직급'/>",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='workTypeNmV4' mdef='직군|직군'/>",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"workTypeNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='manageCdV1' mdef='사원구분|사원구분'/>",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"manageNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='statusCdV2' mdef='재직상태|재직상태'/>",		Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"statusCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='fileYn' mdef='사진\n등록|사진\n등록'/>",	Type:"Image",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"fileYn",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100, Cursor:"Pointer" },
			{Header:"<sht:txt mid='signYn' mdef='서명\n등록|서명\n등록'/>",	Type:"Image",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"signYn",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100, Cursor:"Pointer" },
			{Header:"<sht:txt mid='fileYnVal' mdef='사진\n존재|사진\n존재'/>",	Type:"CheckBox",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"fileynval",	KeyField:0, CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:0,  TrueValue:"Y", FalseValue:"N"}
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(true);sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		sheet1.SetEditableColorDiff(0); //편집불가 상관없이 기본색상 출력

		sheet1.SetImageList(0,"/common/images/icon/icon_upload.png");
		sheet1.SetImageList(1,"/common/images/icon/icon_upload.png");

		/* 다운로드시 페이지 랜더링(화면에 올림)을 하기 위하여 자동 Row높이설정을 false로 준다. */
		sheet1.SetAutoRowHeight(0);
		sheet1.SetDataRowHeight(60);

		$("#searchPhotoYn").attr('checked', 'checked');


		var statusCd = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10010"), "");
		sheet1.SetColProperty("statusCd", 			{ComboText:"|"+statusCd[0], ComboCode:"|"+statusCd[1]} );

		//사진크기 추가 -- 2020.06.01 jylee
		$("#searchPhotoYn").attr('checked', 'checked');
		$("#searchPhotoYn, #photoSize").bind("change",function(){
			
			if($("#searchPhotoYn").is(":checked") == true){

				var iwid = parseInt($("#photoSize").val());
				var ihei = parseInt($("#photoSize option:selected").attr("height"));

				var info = {Width:iwid+10, ImgWidth:iwid, ImgHeight:ihei};
				sheet1.SetColProperty(0, "photo" ,info);
				sheet1.SetDataRowHeight(ihei);
				sheet1.SetColHidden("photo", 0);
				
				if(signViewYn == "Y") {
					sheet1.SetColHidden("sign", 0);
				}

			}else{
				sheet1.SetDataRowHeight(24);
				sheet1.SetColHidden("photo", 1);
				sheet1.SetColHidden("sign", 1);
			}
			
			clearSheetSize(sheet1);sheetResize();
			//doAction2("Search");
			
		});


		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	$(function() {

        $("#searchName,#searchOrgNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});

        $("#fileYn, #signYn").bind("change",function(event){
			doAction1("Search");
		});

	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":

			sheet1.DoSearch( "${ctx}/EmpPictureRegYn.do?cmd=getEmpPictureRegYnList",$("#mySheetForm").serialize() );
			break;
		case "Down2Excel":

			//if($("#searchPhotoYn").is(":checked") == true){
			//	alert("<msg:txt mid='errorNotPhotoDown' mdef='사진이 포함된 상태에서는 다운로드 하실 수 없습니다.'/>") ;
			//	return ;
			//}

			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param); break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {

		try {
			if (Msg != "") {
				alert(Msg);
			}

			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {

		var colName = sheet1.ColSaveName(Col);
        var args    = new Array();


        args["sabun"]  = sheet1.GetCellValue(Row, "sabun");
        args["name"]  = sheet1.GetCellValue(Row, "name");

        if(colName == "fileYn" && Row > 1) {

			if(!isPopup()) {return;}

			pGubun = "phtRegPopup";

			//var win = openPopup("/Popup.do?cmd=signRegPopup", args, "500","590");
			url = '/Popup.do?cmd=viewPhtRegLayer';
			phtRegPopup(url, args);

			// gPRow = Row;
			// pGubun = "phtRegPopup";
			//
			// var win = openPopup("/Popup.do?cmd=phtRegPopup", args, "700","400");
        }
        if(colName == "signYn" && Row > 1) {
			if(!isPopup()) {return;}

			pGubun = "signRegPopup";

			//var win = openPopup("/Popup.do?cmd=signRegPopup", args, "500","590");
			url = '/Popup.do?cmd=viewSignRegLayer';
			signRegPopup(url, args);
        }
	}

	function phtRegPopup(pUrl, param) {

		let layerModal = new window.top.document.LayerModal({
			id : 'phtRegLayer'
			, url : pUrl
			, parameters : param
			, width : 500
			, height : 410
			, title : ' 사진등록'
			, trigger :[
				{
					name : 'phtRegTrigger'
					, callback : function(result){
					}
				}
			]
		});
		layerModal.show();
	}

	function signRegPopup(pUrl, param) {

		let layerModal = new window.top.document.LayerModal({
			id : 'signRegLayer'
			, url : pUrl
			, parameters : param
			, width : 500
			, height : 650
			, title : '서명등록'
			, trigger :[
				{
					name : 'signRegTrigger'
					, callback : function(result){
					}
				}
			]
		});
		layerModal.show();
	}

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

        if(pGubun == "phtRegPopup"){
            var chkVal = ajaxCall("${ctx}/ImageExistYn.do", "sabun="+sheet1.GetCellValue(gPRow,"sabun"), false);

            if($("#searchPhotoYn").is(":checked") == true){
				sheet1.SetCellValue(gPRow,"photo",sheet1.GetCellValue(gPRow,"photo")+"&temp="+secureRandom());
            }

            if(chkVal.map.exgstYn == "Y"){
            	sheet1.SetCellValue(gPRow, "fileYn",1);
            }else{
            	sheet1.SetCellValue(gPRow, "fileYn",0);
            }
        } else if(pGubun == "signRegPopup") {
            var chkVal = ajaxCall("${ctx}/imageSignExistYn.do", "sabun="+sheet1.GetCellValue(gPRow,"sabun"), false);

            if($("#searchPhotoYn").is(":checked") == true){
				sheet1.SetCellValue(gPRow,"sign",sheet1.GetCellValue(gPRow,"sign")+"&temp="+secureRandom());
            }

            if(chkVal.map.exgstYn == "Y"){
            	sheet1.SetCellValue(gPRow, "signYn",1);
            }else{
            	sheet1.SetCellValue(gPRow, "signYn",0);
            }
        }
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="mySheetForm" name="mySheetForm" >
		<div class="sheet_search outer">
			<div>
			<table>
			<tr>
				<th><tit:txt mid='104279' mdef='소속'/></th>
				<td>
					<input id="searchOrgNm" name="searchOrgNm" type="text" class="text"/>
				</td>
				<th><tit:txt mid='104330' mdef='사번/성명'/></th>
				<td>
					<input id="searchName" name="searchName" type="text" class="text"/>
				</td>
				<th><tit:txt mid='112988' mdef='사진포함여부 '/></th>
				<td>  <input id="searchPhotoYn" name="searchPhotoYn" type="checkbox"  class="checkbox" /></td>
				<th>사진등록여부</th>
				<td>
                    <select id="fileYn" name="fileYn">
                        <option value="" selected>전체</option>
                        <option value="1">등록</option>
                        <option value="0">미등록</option>
                    </select>
                </td>
                <th>사진크기</th>
				<td>
					<select id="photoSize" id="photoSize">
						<option value="48" height="60" selected>소</option>
						<option value="100" height="125">중</option>
						<option value="160" height="200">대</option>
					</select>
				</td>
				<td>
					<input id="statusCd" name="statusCd" type="radio" value="RA" checked><tit:txt mid='113521' mdef='퇴직자 제외'/>
					<input id="statusCd" name="statusCd"  type="radio" value="" ><tit:txt mid='114221' mdef='퇴직자 포함'/>
				</td>
				<td>
					<btn:a href="javascript:doAction1('Search');" css="btn dark" mid='110697' mdef="조회"/>
				</td>
			</tr>
			<tr class="hide">
				<th><tit:txt mid='113877' mdef='사진등록여부'/></th>
				<td>
					<select id="fileYn" name="fileYn">
                        <option value="" selected><tit:txt mid='103895' mdef='전체'/></option>
                        <option value="1"><tit:txt mid='112115' mdef='등록'/></option>
                        <option value="0"><tit:txt mid='112976' mdef='미등록'/></option>
					</select>
				</td>
				<th><tit:txt mid='114217' mdef='서명등록여부'/></th>
				<td>
					<select id="signYn" name="signYn">
                        <option value="" selected><tit:txt mid='103895' mdef='전체'/></option>
                        <option value="1"><tit:txt mid='112115' mdef='등록'/></option>
                        <option value="0"><tit:txt mid='112976' mdef='미등록'/></option>
					</select>
				</td>
				<td></td>
				<td></td>
				<td></td>
			</tr>
			</table>
			</div>
		</div>
	</form>
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='pictureRegYn' mdef='개인사진등록여부'/></li>
			<li class="btn">
				<btn:a href="javascript:doAction1('Down2Excel');" css="btn outline_gray authR" mid='110698' mdef="다운로드"/>
			</li>
		</ul>
		</div>
	</div>

	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>