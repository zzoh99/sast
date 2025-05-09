<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">

var gPRow="";
var pGubun="";
var ssnSearchType = "";

	$(function() {
		
		ssnSearchType = "${ssnSearchType}";
		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:100,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No|No",		Type:"${sNoTy}",	Hidden:1,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제|삭제",		Type:"${sDelTy}",	Hidden:1,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",		Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"구분|구분",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"priorOrgNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"구분|구분",			Type:"Text",	Hidden:0,	Width:200,	Align:"Left",	ColMerge:1,	SaveName:"orgNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"현재인원|부회장",		Type:"AutoSum",	Hidden:0,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"mmbCnt01",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"현재인원|사장",		Type:"AutoSum",	Hidden:0,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"mmbCnt02",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"현재인원|부사장",		Type:"AutoSum",	Hidden:0,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"mmbCnt03",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"현재인원|감사",		Type:"AutoSum",	Hidden:0,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"mmbCnt04",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"현재인원|전무\n이사",	Type:"AutoSum",	Hidden:0,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"mmbCnt05",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"현재인원|상무\n이사",	Type:"AutoSum",	Hidden:0,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"mmbCnt06",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"현재인원|이사",		Type:"AutoSum",	Hidden:0,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"mmbCnt07",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"현재인원|상무보",		Type:"AutoSum",	Hidden:0,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"mmbCnt08",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"현재인원|고문",		Type:"AutoSum",	Hidden:0,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"mmbCnt09",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"현재인원|자문",		Type:"AutoSum",	Hidden:0,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"mmbCnt10",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"현재인원|본부장",		Type:"AutoSum",	Hidden:0,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"mmbCnt11",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"현재인원|부장",		Type:"AutoSum",	Hidden:0,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"mmbCnt12",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"현재인원|촉탁\n부장",	Type:"AutoSum",	Hidden:0,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"mmbCnt13",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"현재인원|차장",		Type:"AutoSum",	Hidden:0,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"mmbCnt14",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"현재인원|과장",		Type:"AutoSum",	Hidden:0,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"mmbCnt15",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"현재인원|대리",		Type:"AutoSum",	Hidden:0,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"mmbCnt16",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"현재인원|사원",		Type:"AutoSum",	Hidden:0,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"mmbCnt17",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"현재인원|수습\n사원",	Type:"AutoSum",	Hidden:0,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"mmbCnt18",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"현재인원|인턴",		Type:"AutoSum",	Hidden:0,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"mmbCnt19",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"현재인원|사무장",		Type:"AutoSum",	Hidden:0,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"mmbCnt20",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"현재인원|선임\n사무장",	Type:"AutoSum",	Hidden:0,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"mmbCnt21",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"현재인원|수석\n사무장",	Type:"AutoSum",	Hidden:0,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"mmbCnt22",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"현재인원|부\n사무장",	Type:"AutoSum",	Hidden:0,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"mmbCnt23",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"현재인원|승무원",		Type:"AutoSum",	Hidden:0,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"mmbCnt24",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"현재인원|인턴\n승무원",	Type:"AutoSum",	Hidden:0,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"mmbCnt25",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"현재인원|기장",		Type:"AutoSum",	Hidden:0,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"mmbCnt26",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"현재인원|수습\n기장",	Type:"AutoSum",	Hidden:0,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"mmbCnt27",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"현재인원|수석\n기장",	Type:"AutoSum",	Hidden:0,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"mmbCnt28",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"현재인원|선임\n기장",	Type:"AutoSum",	Hidden:0,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"mmbCnt29",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"현재인원|부기장",		Type:"AutoSum",	Hidden:0,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"mmbCnt30",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"현재인원|선임\n부기장",	Type:"AutoSum",	Hidden:0,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"mmbCnt31",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"현재인원|수습\n부기장",	Type:"AutoSum",	Hidden:0,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"mmbCnt32",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"현재인원|간호사",		Type:"AutoSum",	Hidden:0,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"mmbCnt33",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"현재인원|변호사",		Type:"AutoSum",	Hidden:0,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"mmbCnt34",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"합계|합계",			Type:"AutoSum",	Hidden:0,	Width:50,	Align:"Right",	ColMerge:0,	SaveName:"totCnt",	CalcLogic:"|mmbCnt01|+|mmbCnt02|+|mmbCnt03|+|mmbCnt04|+|mmbCnt05|+|mmbCnt06|+|mmbCnt07|+|mmbCnt08|+|mmbCnt09|+|mmbCnt10|+|mmbCnt11|+|mmbCnt12|+|mmbCnt13|+|mmbCnt14|+|mmbCnt15|+|mmbCnt16|+|mmbCnt17|+|mmbCnt18|+|mmbCnt19|+|mmbCnt20|+|mmbCnt21|+|mmbCnt22|+|mmbCnt23|+|mmbCnt24|+|mmbCnt25|+|mmbCnt26|+|mmbCnt27|+|mmbCnt28|+|mmbCnt29|+|mmbCnt30|+|mmbCnt31|+|mmbCnt32|+|mmbCnt33|+|mmbCnt34|", KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"입퇴사|입사",			Type:"AutoSum",	Hidden:0,	Width:50,	Align:"Right",	ColMerge:0,	SaveName:"ecnt",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"입퇴사|퇴사",			Type:"AutoSum",	Hidden:0,	Width:50,	Align:"Right",	ColMerge:0,	SaveName:"rcnt",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"입퇴사|증감",			Type:"AutoSum",	Hidden:0,	Width:50,	Align:"Right",	ColMerge:0,	SaveName:"ercnt",	CalcLogic:"|ecnt|-|rcnt|", KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		];


		IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.FitColWidth();
		
		//sheet1.SetDataRowMerge(1);

		/* 개별 DB 함수와 개별 QUERY 방식에서 단일 QUERY 와 단인함수 F_HRM_GET_ELEMENT_EMP_CNT 사용으로 변경.
		      항목 추가 시 changeTitle() 에 코드 추가 필요
		   CBS. 2017.09.28
		*/
		var schTypeHtml = "<option value='WORK_TYPE'>"+"직군별"+"</option>"
						 + "<option value='MANAGE_CD'>"+"사원구분별"+"</option>"
						 //+"<option value='STF_TYPE'>"+"채용구분별"+"</option>"
						 +"<option value='EMP_TYPE'>"+"입사구분별"+"</option>"
						 +"<option value='JIKCHAK_CD'>"+"직책별"+"</option>";
		 if("${ssnJikweeUseYn}" == "Y") {
			 schTypeHtml +=  "<option value='JIKWEE_CD'>"+"직위별"+"</option>";
		 }
		 if("${ssnJikgubUseYn}" == "Y") {
			 schTypeHtml +=  "<option value='JIKGUB_CD'>"+"직급별"+"</option>";
		 }
		 $("#schType").html(schTypeHtml);

		
		if("${ssnAdminYn}" == "Y") {
			$("#schDate").datepicker2();
		}else{
			$("#schDate").datepicker2({startdate:"searchBaseYmd"} );
		}
		 
		$("#searchBaseYmd").val("${curSysYyyyMMddHyphen}") ;//현재년월 세팅
		
		$("#schDate").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});
		
		$("#schDate").bind("change",function(event){
			if($("#schDate").val() > $("#searchBaseYmd").val() && $("#schDate").val().length ==10 && "${ssnAdminYn}" != "Y" ) {
				//alert("오늘 이전 날짜로 입력해주세요.");
				$("#schDate").val($("#searchBaseYmd").val()); 
				return;
			}
				
		});
		
		/*
		$("#checkExcept1, #checkExcept2, #checkExcept3").on("click", function(e) {
			doAction1("Search");
		});		
		*/
		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":

			var inteYn = changeTitle();

			if(inteYn != false){
				var sumColsInfo = "";
				for(i=1;i<=inteYn+6;i++){
					if(i == 1){
						sumColsInfo = i+4;
					}else{
						sumColsInfo += "|"+(i+4);
					}
				}

			var info =[{StdCol:"priorOrgNm", SumCols:sumColsInfo, ShowCumulate:0, CaptionCol:3}];
// 			sheet1.ShowSubSum(info) ;

			/*
			if($("#checkExcept1").is(":checked") == true){
				$("#except1").val("Y");
			}else{
				$("#except1").val("N");
			}	
			
			if($("#checkExcept2").is(":checked") == true){
				$("#except2").val("Y");
			}else{
				$("#except2").val("N");
			}	
			
			if($("#checkExcept3").is(":checked") == true){
				$("#except3").val("Y");
			}else{
				$("#except3").val("N");
			}	
			
			var except = $("#except1").val() + $("#except2").val() + $("#except3").val();
			*/
			sheet1.DoSearch( "${ctx}/HrmSta.do?cmd=getHrmStaList", $("#srchFrm").serialize() );
			}
			break;
		case "Save":
							IBS_SaveName(document.srchFrm,sheet1);
							sheet1.DoSave( "${ctx}/HrmSta.do?cmd=saveHrmSta", $("#srchFrm").serialize()); break;
		case "Insert":		sheet1.SelectCell(sheet1.DataInsert(0), "col2"); break;
		case "Copy":		sheet1.DataCopy(); break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":
			//삭제/상태/hidden 지우고 엑셀내려받기
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
			break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			    if (Msg != "") {
					alert(Msg);
				}

				 //합계 행 다듬기
				var lr = sheet1.LastRow();
				sheet1.SetSumValue(3,"합계");
				sheet1.SetMergeCell(lr, 3, 1,2);
				sheet1.SetCellAlign(lr,3,"Center");


				 sheetResize();

		} catch (ex) {
				alert("OnSearchEnd Event Error : " + ex);
	    }
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doAction1("Insert");
			}
			//Delete KEY
			if (Shift == 1 && KeyCode == 46 && sheet1.GetCellValue(Row, "sStatus") == "I") {
				sheet1.SetCellValue(Row, "sStatus", "D");
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try{
			if(sheet1.GetCellProperty(Row, Col, "Cursor") == "Pointer" && Row > 1) {
				if(!isPopup()) {return;}
				
				gPRow = "";
				pGubun = "hrmStaPopup";

	            var args = [];
	            var colName = sheet1.ColSaveName(Col);

				var schType = $("#schType").val();
				var code = "";

				if(colName == "totCnt") {
					schType = "";
				} else if(colName == "manCnt") {
					schType = "SEX";
					code = "1";
				} else if(colName == "womanCnt") {
					schType = "SEX";
					code = "2";
				} else if(colName == "ecnt") {
					schType = "ECNT";
					code = "";
				} else if(colName == "rcnt") {
					schType = "RCNT";
					code = "";
				} else {
					code = sheet1.GetCellValue(Row, "code"+colName);
				}

				var w = 850;
				var h = 700;
				var url = "${ctx}/HrmSta.do?cmd=viewHrmStaLayer";
				var p = {
					schDate : $("#schDate").val(),
					orgCd : sheet1.GetCellValue(Row, "orgCd"),
					orgNm : sheet1.GetCellValue(Row, "orgNm"),
					schTitle1 : sheet1.GetCellValue(0, Col),
					schTitle2 : sheet1.GetCellValue(1, Col),
					schType : schType,
					code : code,
					except1 : $("#except1").val(),
					except2 : $("#except2").val(),
					except3 : $("#except3").val()
				};

				var hrmStaLayer = new window.top.document.LayerModal({
					id: 'hrmStaLayer',
					url: url,
					parameters: p,
					width: w,
					height: h,
					title: '현재인원',
					trigger: [
						{
							name: 'hrmStaLayerTrigger',
							callback: function(rv) {
								getReturnValue(rv);
							}
						}
					]
				});
				hrmStaLayer.show();
	            <%--openPopup("${ctx}/HrmSta.do?cmd=viewHrmStaPopup", args, "850","700");--%>
			}
		}catch(ex){
			alert("OnClick Event Error : " + ex);
		}
	}


	function changeTitle(){

		var rtnValue = true;
		var grcode = "";
		if($("#schType").val() == "WORK_TYPE"){
			grcode = "H10050";
		}else if($("#schType").val() == "MANAGE_CD"){
			grcode = "H10030";
		}else if($("#schType").val() == "STF_TYPE"){
			grcode = "F10001";
		}else if($("#schType").val() == "EMP_TYPE"){
			grcode = "F10003";
		}else if($("#schType").val() == "JIKWEE_CD"){
			grcode = "H20030";
		}else if($("#schType").val() == "JIKCHAK_CD"){
			grcode = "H20020";
		}else if($("#schType").val() == "JIKGUB_CD"){
			grcode = "H20010";
				
		}
		$("#grpCd").val(grcode);

		var data = ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeList","grpCd="+grcode+"&useYn=Y&baseYmd=" + $("#schDate").val(), false);
		var headerInfo = data.codeList;

		if (headerInfo == 'undefine' || headerInfo == null){
			return false;
		}

		var tempCols = [
							{Header:"No|No",		Type:"${sNoTy}",	Hidden:1,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
							{Header:"삭제|삭제",		Type:"${sDelTy}",	Hidden:1,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
							{Header:"상태|상태",		Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
							{Header:"구분|구분",			Type:"Text",	Hidden:1,	Width:200,	Align:"Center",	ColMerge:1,	SaveName:"priorOrgNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
							{Header:"구분|구분",			Type:"Text",	Hidden:0,	Width:200,	Align:"Left",	ColMerge:1,	SaveName:"orgNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 ,    TreeCol:1,  LevelSaveName:"sLevel" },
							{Header:"구분|구분",			Type:"Text",	Hidden:1,	Width:200,	Align:"Left",	ColMerge:1,	SaveName:"orgCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
					   ];


		for(var i = 0; i<headerInfo.length; i++ ){
			tempCols.push({Header:"현재인원|"+headerInfo[i].codeNm,	Type:"AutoSum",	Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"mmbCnt"+(i+1),	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100, Cursor: "Pointer" });
			tempCols.push({Header:"현재인원|"+headerInfo[i].codeNm,	Type:"Text",	Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"codemmbCnt"+(i+1),	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 });
		}

		var calcLogicInfo = "";

		for(i=1;i<=headerInfo.length;i++){
			if(i == 1){
				calcLogicInfo = "|mmbCnt1|";
			}else{
				calcLogicInfo += "+|mmbCnt"+i+"|";
			}

		}
		
		calcLogicInfo += "+|etcCnt|";
		
		tempCols.push({Header:"현재인원|기타",          Type:"AutoSum", Hidden:0,   Width:50,   Align:"Center", ColMerge:0, SaveName:"etcCnt",   KeyField:0,    Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100, Cursor: "Pointer" });
		tempCols.push({Header:"합계|합계",			Type:"AutoSum",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"totCnt",	CalcLogic:calcLogicInfo, KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100, Cursor: "Pointer" ,   BackColor:"#e8a85f"});
		tempCols.push({Header:"성별|남",		Type:"AutoSum",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"manCnt",	CalcLogic:"", KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100, Cursor: "Pointer" });
		tempCols.push({Header:"성별|여",		Type:"AutoSum",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"womanCnt",	CalcLogic:"", KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100, Cursor: "Pointer" });
		tempCols.push({Header:"입퇴사 (전월말 대비)|입사",		Type:"AutoSum",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"ecnt",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100, Cursor: "Pointer" });
		tempCols.push({Header:"입퇴사 (전월말 대비)|퇴사",		Type:"AutoSum",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"rcnt",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100, Cursor: "Pointer" });
		tempCols.push({Header:"입퇴사 (전월말 대비)|증감",		Type:"AutoSum",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"ercnt",	CalcLogic:"|ecnt|-|rcnt|", KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 });
		tempCols.push({Header:"평균\n근속년수|평균\n근속년수",		Type:"Float",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"yearCnt",	CalcLogic:"", KeyField:0,	Format:"NullFloat",	PointCount:1,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 });



		sheet1.Reset();

		// 2번 그리드
		var initdata1 = {};
		initdata1.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:100,MergeSheet:msAll};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata1.Cols = tempCols;

		IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		//sheet1.SetDataRowMerge(1);	//RowMerge주석처리함




		return headerInfo.length;


	}
	
	//팝업 콜백 함수.
	function getReturnValue(rv) {

		if(pGubun == "hrmStaPopup")  {
			var sabun = rv.sabun;
			var enterCd = rv.enterCd;
			goMenu(sabun,enterCd);
		}
	}

	// 비교대상 화면으로 이동
	function goMenu(sabun,enterCd) {

        //비교대상 정보 쿠키에 담아 관리
        var paramObj = [{"key":"searchSabun", "value":sabun},{"key":"searchEnterCd", "value":enterCd}];

        //var prgCd = "View.do?cmd=viewPsnalBasicInf";
        var prgCd = "PsnalBasicInf.do?cmd=viewPsnalBasicInf";
        var location = "인사관리 > 인사정보 > 인사기본";

        var $form = $('<form></form>');
        $form.appendTo('body');
        var param1 	= $('<input name="prgCd" 	type="hidden" 	value="'+prgCd+'">');
        var param2 	= $('<input name="goMenu" 	type="hidden" 	value="Y">');
        $form.append(param1).append(param2);

    	var prgData = ajaxCall("${ctx}/OrgPersonSta.do?cmd=getCompareEmpOpenPrgMap",$form.serialize(),false);

    	if(prgData.map == null) {
			alert("<msg:txt mid='109611' mdef='권한이 없거나 존재하지 않는 메뉴입니다.'/>");
			return;
		}

    	var lvl 		= prgData.map.lvl;
    	var menuId		= prgData.map.menuId;
		var menuNm 		= prgData.map.menuNm;
		var menuNmPath	= prgData.map.menuNmPath;
		var prgCd 		= prgData.map.prgCd;
		var mainMenuNm 	= prgData.map.mainMenuNm;
		var surl      	= prgData.map.surl;
		parent.openContent(menuNm,prgCd,location,surl,menuId,paramObj);
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
			<input type="hidden" id="except1" name="except1"/>
			<input type="hidden" id="except2" name="except2"/>
			<input type="hidden" id="except3" name="except3"/>		
				
			<input id="grpCd" name="grpCd" type="hidden">
			<input id="useYn" name="useYn" type="hidden" value="Y">
			<input type="hidden" id="searchBaseYmd" name="searchBaseYmd"  >
			
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th>기준일자</th>
						<td>
							<input type="text" id="schDate" name="schDate" type="date2" class="text required" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>"/>
						</td>
						<th>구분 </th>
						<td>  <select id="schType" name="schType" onchange="javaScript:doAction1('Search')"> </select> </td>			
						<!-- 			
						<td>
							<span>제외 :
							<input id="checkExcept1" name="checkExcept1" type="checkbox"  class="checkbox" />&nbsp;휴직자
							<input id="checkExcept2" name="checkExcept2" type="checkbox"  class="checkbox" />&nbsp;등기임원
							<input id="checkExcept3" name="checkExcept3" type="checkbox"  class="checkbox" />&nbsp;인턴		
							</span>
						</td>
						 -->			
						<td> <a href="javascript:doAction1('Search')" id="btnSearch" class="btn dark">조회</a> </td>
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
							<li id="txt" class="txt">인원현황</li>
							<li class="btn">
								<a href="javascript:doAction1('Down2Excel')" 	class="btn outline-gray authR">다운로드</a>
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
