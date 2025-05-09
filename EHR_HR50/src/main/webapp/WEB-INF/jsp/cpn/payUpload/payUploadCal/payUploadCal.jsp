<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script src="/common/js/jquery/select2.js"></script>

<script type="text/javascript">
var pRow = "";
var pGubun = "";

	$(function() {


		var initdata = {};
		initdata.Cfg = {FrozenCol:5,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"사번",				Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:15},
			{Header:"성명",				Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:30},
			{Header:"급호",				Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100},
			{Header:"수당항목",			Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"manageNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100},
			{Header:"비과세계",			Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100},
			{Header:"지급합계",			Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100},
			{Header:"공제항목",			Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100},
			{Header:"공제합계",			Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"statusNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"실지급합계",		Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"sdate",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10},

		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");




		//Autocomplete
		$(sheet1).sheetAutocomplete({
			Columns: [
				{
					ColSaveName  : "name",
					CallbackFunc : function(returnValue){
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet1.SetCellValue(gPRow, "sabun",		rv["sabun"]);
						sheet1.SetCellValue(gPRow, "name",		rv["name"]);
						sheet1.SetCellValue(gPRow, "orgNm",		rv["orgNm"]);
						sheet1.SetCellValue(gPRow, "jikchakCd",	rv["jikchakCd"]);
						sheet1.SetCellValue(gPRow, "jikweeNm",	rv["jikweeNm"]);
						sheet1.SetCellValue(gPRow, "jikgubNm",	rv["jikgubNm"]);
						sheet1.SetCellValue(gPRow, "statusCd",	rv["statusCd"]);
						sheet1.SetCellValue(gPRow, "statusNm",	rv["statusNm"]);
						sheet1.SetCellValue(gPRow, "empYmd",	rv["empYmd"]);
						sheet1.SetCellValue(gPRow, "gempYmd",	rv["gempYmd"]);
						sheet1.SetCellValue(gPRow, "gubho",	rv["gubho"]);
					}
				}
			]
		});

		// 최근급여일자 조회
		getCpnLatestPaymentInfo();

		doAction1("Search");

		$(window).smartresize(sheetResize); sheetInit();

	});

/**
 * Sheet 각종 처리
 */
function doAction1(sAction){
	switch(sAction){
		case "Search":	//조회
						searchTitleList();
						break;

		case "Save":	//저장
						if(!dupChk(sheet1,"sabun", false, true)){break;}
						IBS_SaveName(document.srchFrm,sheet1);
						sheet1.DoSave( "${ctx}/PayUploadCal.do?cmd=savePayUploadCal", $("#srchFrm").serialize() );

						break;

		case "Insert":

					sheet1.SelectCell(sheet1.DataInsert(0), 4);

				break;
						

		case "Copy":

				var row = sheet1.DataCopy();
				sheet1.SelectCell(row, 4);
			break;
		case "Down2Excel":  //엑셀내려받기
				sheet1.Down2Excel({DownCols:makeHiddenSkipCol(sheet1),SheetDesign:1,Merge:1});
			break;

		case "LoadExcel":   //엑셀업로드
				var params = {Mode:"HeaderMatch", WorkSheetNo:1};
				sheet1.LoadExcel(params);
			break;
		case "Down2Template":


				var downCols = makeHiddenSkipCol(sheet1,'',["gubho"]);
				var param  = {DownCols:downCols,SheetDesign:1,Merge:1,DownRows:'0',ExcelFontSize:"9"};
				sheet1.Down2Excel(param);
			break;
		case "execute":
			var dataList = ajaxCall("${ctx}/PayUploadCal.do?cmd=getPayUploadCalCountTcpn203", "payActionCd="+$('#payActionCd').val(), false).DATA;
			if(dataList[0].count > 0){
				if(confirm('이미 급여 작업된 내용이 있습니다. 계속 진행하시겠습니까?')){
				}else{
					return;
				}
			}
			var param = {"payActionCd" : $('#payActionCd').val()};

			showOverlay(0,"처리중입니다. 잠시만 기다려주세요.");
			setTimeout(function(){
				$.ajax({
					url : "${ctx}/PayUploadCal.do?cmd=prcP_CPN_CAL_UPLOAD",
					type : "post",
					dataType : "json",
					// async : sync,
					data : param,
					success : function(data) {

						if(data.Result != null && data.Result.Code == "1") {

							alertTimer("<msg:txt mid='110120' mdef='처리되었습니다.'/>", 1000, globalWindowPopup, function(){
								globalWindowPopup.close(); doAction1("Search");
							});
						} else {
							alertTimer(data.Result.Message, 1000);
						}
					},
					error : function(jqXHR, ajaxSettings, thrownError) {
						ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
					},
					complete : function (){
						hideOverlay();
					}
				});
			}, 1000);
			break;
	}
}

function searchTitleList() {

	sheet1.Reset();
	var initdata1 = {};
	initdata1.Cfg = {FrozenCol:6,SearchMode:smLazyLoad, Page:22/* , FrozenCol:11 */ };
	initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:1};

	initdata1.Cols = [];

	initdata1.Cols.push({Header:"No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" });
	initdata1.Cols.push({Header:"삭제",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0, HeaderCheck:1 });
	initdata1.Cols.push({Header:"상태",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 });
	initdata1.Cols.push({Header:"사번",				Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:1,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:20});
	initdata1.Cols.push({Header:"성명",				Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:20});
	initdata1.Cols.push({Header:"급호",				Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"gubho",		KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:150});
	var dataList = ajaxCall("${ctx}/PayUploadCal.do?cmd=getPayUploadCalTitleList", "elementType=A&payActionCd="+$('#payActionCd').val(), false);
	var sumText = "";
	dataList.DATA.forEach(function (data,idx){
		initdata1.Cols.push({Header:data.elementNm,				Type:"AutoSum",		Hidden:0,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:"mon"+Number(idx+1),		KeyField:0,	Format:"Integer",				PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:150});
		sumText += "|mon"+Number(idx+1)+"|";

		if(Number(idx+1) != dataList.DATA.length){
			sumText+="+";
		}
	});
	for( var i = dataList.DATA.length+1  ; i <= 50 ; i++){//빈 컬럼을  0으로 채우는 반복문
		initdata1.Cols.push({Header:"MON_" + i ,				Type:"AutoSum",		Hidden:1,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:"mon"+i,		KeyField:0,	Format:"Integer",				PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:150});
	}
	initdata1.Cols.push({Header:"비과세계",			Type:"AutoSum",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"notaxTotMon",	KeyField:0,	Format:"Integer",				PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100});
	initdata1.Cols.push({Header:"과세합계",			Type:"AutoSum",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"taxibleEarnMon",	KeyField:0,	Format:"Integer",				PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100});
	initdata1.Cols.push({Header:"지급합계",			Type:"AutoSum",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"totEarningMon",	KeyField:0,	Format:"Integer",				PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100});
	initdata1.Cols.push({Header:"지급합계_계산",		Type:"AutoSum",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"totSumMon",	KeyField:0,	Format:"Integer",				PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100,CalcLogic:sumText});

	debugger;
	dataList = ajaxCall("${ctx}/PayUploadCal.do?cmd=getPayUploadCalTitleList", "elementType=D&payActionCd="+$('#payActionCd').val(), false);
	var minText = "";
	dataList.DATA.forEach((data, idx) => {
		console.log(data, idx);
		initdata1.Cols.push({Header:data.elementNm,				Type:"AutoSum",		Hidden:0,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:"ded"+Number(idx+1),		KeyField:0,	Format:"Integer",				PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:150});
		minText += "|ded"+Number(idx+1)+"|";

		if(Number(idx+1) != dataList.DATA.length){
			minText+="+";
		}
	})
	for( var i = dataList.DATA.length+1  ; i <= 50 ; i++){//빈 컬럼을  0으로 채우는 반복문
		initdata1.Cols.push({Header:"DED_" + i ,				Type:"AutoSum",		Hidden:1,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:"ded"+i,		KeyField:0,	Format:"Integer",				PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:150});
	}
	initdata1.Cols.push({Header:"공제합계",				Type:"AutoSum",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"totDedMon",	KeyField:0,	Format:"Integer",				PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100});
	initdata1.Cols.push({Header:"공제합계_계산",			Type:"AutoSum",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"totMinMon",	KeyField:0,	Format:"Integer",				PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100,CalcLogic:minText});

	initdata1.Cols.push({Header:"실지급합계",			Type:"AutoSum",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"paymentMon",	KeyField:0,	Format:"Integer",				PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100});



	IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(4);

	sheet1.DoSearch( "${ctx}/PayUploadCal.do?cmd=getPayUploadCalList", $("#srchFrm").serialize() );

}



// 조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try {
		if (Msg != "") {
			alert(Msg);
		}
		for(var i = sheet1.HeaderRows(); i < sheet1.RowCount()+sheet1.HeaderRows() ; i++) {
			if(sheet1.GetCellValue(i,'totEarningMon') != sheet1.GetCellValue(i,'totSumMon') ){
				// 지급합계와 지급합계_계산이 다를경우
				sheet1.SetCellBackColor(i,'totSumMon','#ff0000');
			}

			if (sheet1.GetCellValue(i,'totDedMon') != sheet1.GetCellValue(i,'totMinMon') ) {
				// 공제합계와 공제합계_계산이 다를경우
				sheet1.SetCellBackColor(i,'totMinMon','#ff0000');

			}
		}
		//sheetResize();
	} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

//저장 후 메시지
function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try {
		if (Msg != "") {
			alert(Msg);
		}
		if (Code != "-1"){
			doAction1("Search");
		}
	} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
}



//엑셀로드시
function sheet1_OnLoadExcel(result) {
	try{
		if(result) {

		} else {
			alert("엑셀 로딩중 오류가 발생하였습니다.");
		}
	}catch(ex){alert("OnLoadExcel Event Error : " + ex);}
}

//최근급여일자 조회
function getCpnLatestPaymentInfo() {
	var procNm = "최근급여일자";
	// 급여구분(C00001-RETRO.소급)
	var paymentInfo = ajaxCall("${ctx}/PayUploadCal.do?cmd=getCpnQueryList", "queryId=getCpnLatestPaymentInfoMap&procNm="+procNm+"&runType=00001,00002,00003,00007,U0001,&payCd=A1", false);

	if (paymentInfo.DATA && paymentInfo.DATA[0]) {
		$("#payActionCd").val(paymentInfo.DATA[0].payActionCd);
		$("#payActionNm").val(paymentInfo.DATA[0].payActionNm);
		$("#payCd").val(paymentInfo.DATA[0].payCd);
	} else if (paymentInfo.Message) {
		alert(paymentInfo.Message);
	}
}
//급여일자 검색 팝업
function payActionSearchPopup() {
	let layerModal = new window.top.document.LayerModal({
		id : 'payDayLayer'
		, url : '/PayDayPopup.do?cmd=viewPayDayLayer&authPg=R'
		, parameters : {
			runType : '00001,00002,00003,U0001',
			payCd: 'A1'
		}
		, width : 900
		, height : 520
		, title : '<tit:txt mid='payDayPop' mdef='급여일자 조회'/>'
		, trigger :[
			{
				name : 'payDayTrigger'
				, callback : function(result){
					$("#payActionCd").val(result.payActionCd);
					$("#payActionNm").val(result.payActionNm);
				}
			}
		]
	});
	layerModal.show();
}
</script>



</head>
<body class="hidden">
<div class="wrapper">
<form id="srchFrm" name="srchFrm" >
	<div class="sheet_search outer">
		<div>
			<table>
				<tr>
					<td>
						<span>급여일자</span>
						<input type="hidden" id="payActionCd" name="payActionCd" value="" />
						<input type="text" id="payActionNm" name="payActionNm" class="text required readonly" value="" readonly style="width:180px" />
						<a onclick="javascript:payActionSearchPopup();" class="button6"><img src="/common/images/common/btn_search2.gif"/></a>
					</td>
					<td>
						<a href="javascript:doAction1('Search')" class="button authR">조회</a>
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
							<li id="txt" class="txt">급여업로드</li>
							<li class="btn">
 								<!-- <a href="javascript:doAction1('AutoCalculate')" class="basic authA">연봉계산</a> -->
 								<a href="javascript:doAction1('execute')" 	class="button">반영</a>
 								<a href="javascript:doAction1('Down2Template')" class="basic authA">양식다운로드</a>
								<a href="javascript:doAction1('LoadExcel')" 	class="basic authA">업로드</a>
								<a href="javascript:doAction1('Insert')"		class="basic authA">입력</a>
								<a href="javascript:doAction1('Copy')"			class="basic authA">복사</a>
								<a href="javascript:doAction1('Save')"			class="basic authA">저장</a>
								<a href="javascript:doAction1('Down2Excel')"	class="basic authR">다운로드</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","kr"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>