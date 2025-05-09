<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script src="${ctx}/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>
<!-- swiper -->
<link rel="stylesheet" href="/assets/plugins/swiper-10.2.0/swiper-bundle.min.css" />
<script src="${ctx}/assets/plugins/swiper-10.2.0/swiper-bundle.min.js" type="text/javascript" charset="utf-8"></script> 
<script type="text/javascript">
	$(function() {
		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22, MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No|No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제|삭제",				Type:"${sDelTy}",	Hidden:1,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",				Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			
			{Header:"\n선택|\n선택",			Type:"CheckBox",	Hidden:1,					Width:50,	Align:"Center",	ColMerge:0,	SaveName:"chk",					KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header:"평가명|평가명",			Type:"Text",		Hidden:0,					Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appraisalNm",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"소속|소속",				Type:"Text",		Hidden:0,					Width:150,	Align:"Center",	ColMerge:0,	SaveName:"appOrgNm",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"직위|직위",				Type:"Text",		Hidden:Number("${jwHdn}"),	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"직급|직급",				Type:"Text",		Hidden:Number("${jgHdn}"),	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"직책|직책",				Type:"Text",		Hidden:0,					Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"평가등급|업적",			Type:"Text",		Hidden:1,					Width:60,	Align:"Center",	ColMerge:0,	SaveName:"finalMboClassNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0},
			{Header:"평가등급|역량",			Type:"Text",		Hidden:1,					Width:60,	Align:"Center",	ColMerge:0,	SaveName:"finalCompClassNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0},
			{Header:"평가등급|다면",			Type:"Text",		Hidden:1,					Width:60,	Align:"Center",	ColMerge:0,	SaveName:"finalMutualClassNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0},
			{Header:"평가등급|최종",			Type:"Text",		Hidden:0,					Width:60,	Align:"Center",	ColMerge:0,	SaveName:"finalClassNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0},
	
			{Header:"출력|출력",				Type:"Image",		Hidden:1,					Width:40,	Align:"Center",	ColMerge:0,	SaveName:"print", Cursor:"Pointer" },
			{Header:"이의제기|세부\n내역",		Type:"Image",		Hidden:0,					Width:40,	Align:"Center",	ColMerge:0,	SaveName:"detail", Cursor:"Pointer" },
			{Header:"이의제기|상태",			Type:"Text",		Hidden:0,					Width:40,	Align:"Center",	ColMerge:0,	SaveName:"protestYn"},
			{Header:"이의제기|의견(업적)",		Type:"Text",		Hidden:1,					Width:40,	Align:"Center",	ColMerge:0,	SaveName:"protestMemoMbo"},
			{Header:"이의제기|의견(역량)",		Type:"Text",		Hidden:1,					Width:40,	Align:"Center",	ColMerge:0,	SaveName:"protestMemoComp"},
	
			{Header:"이의제기|허용여부",		Type:"Text",		Hidden:1,					Width:40,	Align:"Center",	ColMerge:0,	SaveName:"exceptionYn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0},
			{Header:"이의제기|허용시작일",		Type:"Date",		Hidden:1,					Width:40,	Align:"Center",	ColMerge:0,	SaveName:"exceptionSdate",		KeyField:0, Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0},
			{Header:"이의제기|허용종료일",		Type:"Date",		Hidden:1,					Width:40,	Align:"Center",	ColMerge:0,	SaveName:"exceptionEdate",		KeyField:0, Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0},
			
			{Header:"평가ID|평가ID",			Type:"Text",		Hidden:1,					Width:40,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd"},
			{Header:"평가소속|평가소속",		Type:"Text",		Hidden:1,					Width:40,	Align:"Center",	ColMerge:0,	SaveName:"appOrgCd"},
			{Header:"사번|사번",				Type:"Text",		Hidden:1,					Width:40,	Align:"Center",	ColMerge:0,	SaveName:"sabun"}
	
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("true");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
	
		sheet1.SetImageList(1,"${ctx}/common/images/icon/icon_popup.png");
		//sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_print.png");
		sheet1.SetDataLinkMouse("detail",1);
		$(window).smartresize(sheetResize); sheetInit();
	
		setEmpPage();
		//이의제기
		$('.btn-challenge').on('click', function(){
		    let args = {};
		    let layerModal = new window.top.document.LayerModal({
		        id : 'appFeedBackLstLayer'
		        , url : '/AppFeedBackLst.do?cmd=viewAppFeedBackLstLayer'
		        , parameters : args
		        , width : 'auto'
		        , height : 'auto'
		        , title : "이의제기신청"
		    });
		    layerModal.show();
		});

		
		//평가상세
		$('.grade').on('click', function(){
		    let args = {};
		    let layerModal = new window.top.document.LayerModal({
		        id : 'appFeedBackResultLayer'
		        , url : '/AppFeedBackLst.do?cmd=viewAppFeedBackResultLayer'
		        , parameters : args
		        , width : 'auto'
		        , height : 'auto'
		        , title : "평가상세"
		    });
		    layerModal.show();
		});

		var vacationSwiper = {
		    swiper: null
		};
		//swiper
		var swiper = new Swiper(".feedBackSwiper", {
	      pagination: {
	        el: ".swiper-pagination",
	        type: 'bullets',
	        clickable: true,
	      },
	    });
	});
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/AppFeedBackLst.do?cmd=getAppFeedBackLstList", $("#srchFrm").serialize() ); break;
		case "Save":
							IBS_SaveName(document.srchFrm,sheet1);
							sheet1.DoSave( "${ctx}/AppFeedBackLst.do?cmd=saveAppFeedBackLst", $("#srchFrm").serialize()); break;
		case "Insert":		sheet1.SelectCell(sheet1.DataInsert(0), "col2"); break;
		case "Copy":		sheet1.DataCopy(); break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet1.Down2Excel(param);
			break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		case "Print": //출력
			rdPopup();
			break;
		}
	}
	
	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != ""){
				alert(Msg);
			}
			sheetResize();
		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
	
	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != ""){
				alert(Msg);
			}
			doAction1("Search");
		}catch(ex){
			alert("OnSaveEnd Event Error " + ex);
		}
	}
	
	function exception_chk(Row){
		if(sheet1.GetCellValue(Row, "exceptionYn") == "Y"){
			var date = new Date();
			/* 날짜 테스트용 */
			//date = makeDateFormat("2017-06-25");
	
			if(makeDateFormat(sheet1.GetCellValue(Row, "exceptionSdate")) != false && makeDateFormat(sheet1.GetCellValue(Row, "exceptionEdate")) != false) {
				if (date < makeDateFormat(sheet1.GetCellValue(Row, "exceptionSdate"))) {
					alert("이의제기는 이의제기 허용시작일 이전에 할 수 없습니다.");
					return 0;
				} else if (date > makeDateFormat(sheet1.GetCellValue(Row, "exceptionEdate"))) {
					alert("확인 및 입력할 수 있는 기간이 아닙니다!");
					return 0;
				}
			}else{
				alert("이의제기 허용시작일 또는 종료일이 없습니다.\n관리자에게 문의하세요.");
				return 0;
			}
			return 2;
		}else{
			alert("이의제기가 허용되지 않는 평가입니다!");
			return 0;
		}
	}
	
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try{
			if(Row <= 1) return;
			if(sheet1.ColSaveName(Col) == "detail" ){
				/* 이의제기 조건 체크 */
				var chkData = exception_chk(Row);
				var protestYn;
				var protestFeedBackYn;
				var saveBtnYn;
	
				if(chkData == 0) {
					return;
				}else if(chkData == 1){
					protestYn		   = 'N';
					protestFeedBackYn   = 'N';
					saveBtnYn			= 'N';
				}else if(chkData == 2){
					protestYn		   = 'Y';
					protestFeedBackYn   = 'N';
					saveBtnYn			= 'Y';
				}
				if(!isPopup()) {return;}
	
		 		var args = {};
		 		args["searchAppraisalCd"]	   = sheet1.GetCellValue(Row, "appraisalCd");
		 		args["searchSabun"]			 = sheet1.GetCellValue(Row, "sabun");
		 		args["searchAppOrgCd"]		  = sheet1.GetCellValue(Row, "appOrgCd");
		 		args["protestYn"]			   = protestYn;
		 		args["protestMemoMbo"]			= sheet1.GetCellValue(Row, "protestMemoMbo");
		 		args["protestMemoComp"]			= sheet1.GetCellValue(Row, "protestMemoComp");
		 		args["protestMemoFeedBackYn"]   = protestFeedBackYn;
				args["saveBtnYn"]   			= saveBtnYn;
				gPRow = "";
				pGubun = "apFeedBackLstCommentView";
	
				var layer = new window.top.document.LayerModal({
					id : 'apFeedBackLstCommentViewLayer'
					, url : "${ctx}/AppFeedBackLst.do?cmd=viewAppFeedBackLstComment"
					, parameters: args
					, width : 500
					, height : 850
					, title : "이의제기"
					, trigger :[
						{
							name : 'apFeedBackLstCommentViewTrigger'
							, callback : function(rv){
								getReturnValue(rv);
							}
						}
					]
				});
				layer.show();
	
	
	
	
			}else if(sheet1.ColSaveName(Col) == "print" && Value == "1" ){
				rdPopup(sheet1.GetCellValue(Row, "appraisalCd"), sheet1.GetCellValue(Row, "sabun"), sheet1.GetCellValue(Row, "appOrgCd"));
			}
		}catch(ex){
			alert("OnClick Event Error : " + ex);
		}
	}
	
	function setEmpPage() {
		$("#searchSabun").val($("#searchUserId").val());
		$("#searchName").val($("#searchKeyword").val());
	
		doAction1("Search");
	}
	
	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		if(pGubun == "apFeedBackLstCommentView"){
			doAction1("Search");
		}
	}

</script>
</head>
<body class="hidden">
<div class="wrapper">
	<!-- include 기본정보 page TODO -->
	<%@ include file="/WEB-INF/jsp/common/include/employeeHeader.jsp"%>
	<form id="srchFrm" name="srchFrm" >
	<input type="hidden" id="searchSabun" name="searchSabun" value=""/>
	<input type="hidden" id="searchName" name="searchName" value=""/>
	<!-- 호출 팝업 넘겨줄 키 값 -->
	<input type="hidden" id="exceptionSdateValue" name="exceptionSdateValue" value=""/>
	<input type="hidden" id="exceptionEdateValue" name="exceptionEdateValue" value=""/>
	</form>
	<div class="row eval-feedback eval-common">
		<div class="col-6">
			<!-- 년도 표시 -->
			<div class="year-wrap">
				<button class="btn-year btn-prev"><i class="mdi-ico filled">chevron_left</i></button>
				<span class="year">2023<span class="unit">년</span></span>
				<button class="btn-year btn-next"><i class="mdi-ico filled">chevron_right</i></button>
			</div>
			<div class="swiper feedBackSwiper">
				<div class="swiper-wrapper">
					<div class="swiper-slide">
						<div class="row feedback-score">
							<div class="col-6">
								<div class="feedback-box">
									<div class="box-header">
										<div class="d-flex inner-wrap">
											<span class="name">김이수</span>
											<span class="position">대리</span>
											<div class="ml-auto toggle-wrap">
								                <input type="checkbox" id="toggle1" hidden="">
								                <label for="toggle1" class="toggleSwitch">
								                  <span class="toggleButton"></span>
								                </label>
											</div>
										</div>
										<div class="job-info">
											<span class="team">인사 총무실</span>
											<span class="divider"></span>
											<span class="job">프로젝트관리(EB)</span>
										</div>
									</div>
									<div class="box-body">
										<div class="section-title">
											상반기 성과평가
											<div class="btn-wrap ml-auto">
												<!-- <a href="#" class="btn outline thinner btn-challenge" id="challenge"><i class="mdi-ico filled">pan_tool</i>이의제기</a> -->
												<button class="btn outline thinner btn-challenge" id="challenge"><i class="mdi-ico filled">pan_tool</i>이의제기</button>
											</div>
										</div>
										<div class="row section-box">
											<div class="col-4">
												<div class="grade">M</div>
												<div class="desc achiev">업적</div>
											</div>
											<div class="col-4">
												<div class="grade">O</div>
												<div class="desc salary">연봉</div>
											</div>
										</div>
										<div class="section-title">
											성과평가(역량최종)
											<div class="btn-wrap ml-auto">
												<button class="btn outline thinner btn-challenge"><i class="mdi-ico filled">pan_tool</i>이의제기</button>
											</div>
										</div>
										<div class="row section-box">
											<div class="col-4">
												<div class="grade">M</div>
												<div class="desc achiev">업적</div>
											</div>
											<div class="col-4">
												<div class="grade">O</div>
												<div class="desc salary">연봉</div>
											</div>
										</div>
										<div class="section-title">
											최종업적평가
											<div class="btn-wrap ml-auto">
												<button class="btn outline thinner btn-challenge"><i class="mdi-ico filled">pan_tool</i>이의제기</button>
											</div>
										</div>
										<div class="row section-box">
											<div class="col-4">
												<div class="grade">M</div>
												<div class="desc achiev">업적</div>
											</div>
											<div class="col-4">
												<div class="grade">O</div>
												<div class="desc salary">연봉</div>
											</div>
											<div class="col-4">
												<div class="grade">M</div>
												<div class="desc ability">역량</div>
											</div>
										</div>
									</div>
									<div class="box-footer">
										<i class="mdi-ico filled">pan_tool</i>
										<p class="desc">이의제기 버튼을 클릭하여 이의제기를 신청할 수 있습니다.<br>이의제기 기간에만 버튼이 활성화됩니다.</p>
									</div>
								</div>
							</div>
							<div class="col-6">
								<!-- 1) 평가결과 피드백 설문조사 버튼 있을 때-->
								<div class="feedback-box">
									<div class="box-header">
										<div class="d-flex inner-wrap">
											<span class="name">김이수</span>
											<span class="position">대리</span>
											<div class="ml-auto toggle-wrap">
								                <input type="checkbox" id="toggle2" hidden="">
								                <label for="toggle2" class="toggleSwitch">
								                  <span class="toggleButton"></span>
								                </label>
											</div>
										</div>
										<div class="job-info">
											<span class="team">HR</span>
											<span class="divider"></span>
											<span class="job">프로젝트관리</span>
										</div>
									</div>
									<div class="box-body">
										<div class="register-box">
											<div class="img-wrap">
												<img src="/common/images/icon/icon_result_empty.png">
											</div>
											<p class="desc">설문조사 진행 후 평가 결과를<br>확인 할 수 있습니다.​</p>
											<div class="btn-wrap">
												<button class="btn dark">설문조사</button>
											</div>
										</div>
									</div>
								</div>
								<!-- 2) 평가결과 피드백 설문조사 버튼 있을 때-->
								<!-- <div class="feedback-box">
									<div class="empty-wrap">
										<div class="img-wrap">
											<img src="/common/images/icon/icon_no_data.png">
										</div>
									</div>
								</div>-->
							</div>
						</div>
					</div>
					<div class="swiper-slide">
						<div class="row feedback-score">
							<div class="col-6">
								<div class="feedback-box">
									<div class="box-header">
										<div class="d-flex inner-wrap">
											<span class="name">김이수</span>
											<span class="position">대리</span>
											<div class="ml-auto toggle-wrap">
								                <input type="checkbox" id="toggle1" hidden="">
								                <label for="toggle1" class="toggleSwitch">
								                  <span class="toggleButton"></span>
								                </label>
											</div>
										</div>
										<div class="job-info">
											<span class="team">인사 총무실</span>
											<span class="divider"></span>
											<span class="job">프로젝트관리(EB)</span>
										</div>
									</div>
									<div class="box-body">
										<div class="section-title">
											상반기 성과평가
											<div class="btn-wrap ml-auto">
												<!-- <a href="#" class="btn outline thinner btn-challenge" id="challenge"><i class="mdi-ico filled">pan_tool</i>이의제기</a> -->
												<button class="btn outline thinner btn-challenge" id="challenge"><i class="mdi-ico filled">pan_tool</i>이의제기</button>
											</div>
										</div>
										<div class="row section-box">
											<div class="col-4">
												<div class="grade">M</div>
												<div class="desc achiev">업적</div>
											</div>
											<div class="col-4">
												<div class="grade">O</div>
												<div class="desc salary">연봉</div>
											</div>
										</div>
										<div class="section-title">
											성과평가(역량최종)
											<div class="btn-wrap ml-auto">
												<button class="btn outline thinner btn-challenge"><i class="mdi-ico filled">pan_tool</i>이의제기</button>
											</div>
										</div>
										<div class="row section-box">
											<div class="col-4">
												<div class="grade">M</div>
												<div class="desc achiev">업적</div>
											</div>
											<div class="col-4">
												<div class="grade">O</div>
												<div class="desc salary">연봉</div>
											</div>
										</div>
										<div class="section-title">
											최종업적평가
											<div class="btn-wrap ml-auto">
												<button class="btn outline thinner btn-challenge"><i class="mdi-ico filled">pan_tool</i>이의제기</button>
											</div>
										</div>
										<div class="row section-box">
											<div class="col-4">
												<div class="grade">M</div>
												<div class="desc achiev">업적</div>
											</div>
											<div class="col-4">
												<div class="grade">O</div>
												<div class="desc salary">연봉</div>
											</div>
											<div class="col-4">
												<div class="grade">M</div>
												<div class="desc ability">역량</div>
											</div>
										</div>
									</div>
									<div class="box-footer">
										<i class="mdi-ico filled">pan_tool</i>
										<p class="desc">이의제기 버튼을 클릭하여 이의제기를 신청할 수 있습니다.<br>이의제기 기간에만 버튼이 활성화됩니다.</p>
									</div>
								</div>
							</div>
							<div class="col-6">
								<!-- 2) 평가결과 피드백 설문조사 버튼 있을 때-->
								<div class="feedback-box">
									<div class="empty-wrap">
										<div class="img-wrap">
											<img src="/common/images/icon/icon_no_data.png">
										</div>
									</div>
								</div>
							</div>
							<!-- <div class="col-12">
								<div class="indicator-wrap">
									<span class="indicator on"></span>
									<span class="indicator"></span>
								</div>
							</div> -->
						</div>		
					</div>
				</div>
				<div class="swiper-pagination"></div>
			</div>
		</div>
		<div class="col-6 left-line">
			<form id="srchFrm" name="srchFrm" >
				<input type="hidden" id="searchSabun" name="searchSabun" value=""/>
				<input type="hidden" id="searchName" name="searchName" value=""/>
				<!-- 호출 팝업 넘겨줄 키 값 -->
				<input type="hidden" id="exceptionSdateValue" name="exceptionSdateValue" value=""/>
				<input type="hidden" id="exceptionEdateValue" name="exceptionEdateValue" value=""/>
			</form>
			<div class="outer">
				<div class="sheet_title">
					<ul>
						<li class="txt">이의제기 신청이력</li>
					</ul>
				</div>
			</div>
			<!-- 시트 -->
			<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
		</div>
	</div>
</div>
</body>
</html>