<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>선물신청</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var p = eval("${popUpStatus}");
	var gPRow = "";
	var pGubun = "";

	$(function() {

		var arg = p.window.dialogArguments;
		var giftSeq = "";
		var applSabun = "";
	    if( arg != undefined ) {
	    	giftSeq   = arg["giftSeq"];
	    	applSabun = arg["applSabun"];
	    }else{
			if ( p.popDialogArgument("giftSeq")   !=null ) { giftSeq   = p.popDialogArgument("giftSeq"); }
			if ( p.popDialogArgument("applSabun") !=null ) { applSabun = p.popDialogArgument("applSabun"); }
	    }
		$("#searchGiftSeq").val(giftSeq);
		$("#searchApplSabun").val(applSabun);
		

    	$("#zooomImg").click(function(){
    		$("#zooomImg").hide();
    	});
    	
		//Sheet 초기화
		init_sheet1();
		$(window).smartresize(sheetResize); sheetInit();
		
		doAction1("Search");

	});

	//Sheet 초기화
	function init_sheet1(){

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:0,				Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",			Type:"${sDelTy}",	Hidden:"${sDelHdn}",	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",			Type:"${sSttTy}",	Hidden:"${sSttHdn}",	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			
			{Header:"선택",			Type:"Radio",	Hidden:0, Width:60, Align:"Center",		ColMerge:0,	SaveName:"sel",			KeyField:0,	Format:"",		Edit:0  , Cursor:"Pointer"},

			{Header:"선물코드",		Type:"Text",	Hidden:0, Width:60, Align:"Center",		ColMerge:0,	SaveName:"giftCd",		KeyField:0,	Format:"",		Edit:0 },
			{Header:"선물명",			Type:"Text",	Hidden:0, Width:100, Align:"Center",	ColMerge:0,	SaveName:"giftNm",		KeyField:0,	Format:"",		Edit:0 },
			{Header:"선물상세설명",		Type:"Text",	Hidden:0, Width:300, Align:"Left",		ColMerge:0,	SaveName:"giftDesc",	KeyField:0,	Format:"",		Edit:0 },
			{Header:"선물이미지",		Type:"Image",	Hidden:0, Width:80,	 Align:"Center",	ColMerge:0,	SaveName:"giftImg", 	Edit:0, ImgWidth:80, ImgHeight:100, Sort:0 , Cursor:"Pointer" },
			
			{Header:"Hidden",	 Hidden:1, SaveName:"giftImgSeq"},
			{Header:"Hidden",	 Hidden:1, SaveName:"giftSeq"},
			
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(1);sheet1.SetVisible(true);//sheet2.SetCountPosition(4);

		sheet1.SetEditableColorDiff(0); //편집불가 배경색 적용안함
		sheet1.SetDataAlternateBackColor(sheet1.GetDataBackColor()); //홀짝 배경색 같게
		sheet1.SetDataRowHeight(100);
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Search":

				//신청자정보 조회
				var user = ajaxCall( "${ctx}/GiftApp.do?cmd=getGiftAppDetUseInfo", $("#searchForm").serialize(),false);
				if ( user != null && user.DATA != null ){ 
					$("#recName").val(user.DATA.applName);
					$("#recPhone").val(user.DATA.phoneNo);
					$("#note").val(user.DATA.note);
					var addrs;
					if( user.DATA.addrGubun == "A" ){
						addrs = (user.DATA.empAddr).split("__");
					}else{
						addrs = (user.DATA.locAddr).split("__");
						$("#recName,#recPhone, #recZip, #recAddr").removeClass("required").addClass("transparent").attr("readonly", "readonly");
						$("#btnSearchAddr").hide();
					}
					
					$("#recZip").val(addrs[0]); 
					$("#recAddr").val(addrs[1]);
				}
				
				sheet1.DoSearch( "${ctx}/GiftApp.do?cmd=getGiftStdDtlList", $("#searchForm").serialize() );
				break;
			case "Save":
		        // 항목 체크 리스트
		        if ( !checkList() ) {
		            return;
		        }
		        
				if( $("#giftCd").val() == "" ){
					alert("선물을 선택 해주세요");
					return;
				}

				var rtn = ajaxCall("${ctx}/GiftApp.do?cmd=saveGiftAppDet", $("#searchForm").serialize(), false);

				if(rtn.Result.Code < 1) {
					alert(rtn.Result.Message);
				} else {
					alert("신청 되었습니다.");
					p.popReturnValue(); p.self.close();
				}
		}
	}

	//--------------------------------------------------------------------------------
	//  저장 시 필수 입력 및 조건 체크
	//--------------------------------------------------------------------------------
	function checkList(status) {
		var ch = true;
		//alert("11")
		// 화면의 개별 입력 부분 필수값 체크
		$(".required").each(function(index){
			if($(this).val() == null || $(this).val() == ""){
				alert($(this).parent().prev().text()+"<msg:txt mid='required2' mdef='은(는) 필수값입니다.' />");
				$(this).focus();
				ch =  false;
				return ch;
			}

		});



		return ch;
		

		
		
	}
	

	//---------------------------------------------------------------------------------------------------------------
	// sheet1 Event
	//---------------------------------------------------------------------------------------------------------------
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

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			if( Code > -1 ) doAction1("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	//셀 선택시
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
		try{
			//sheet1.SetRowBackColor(OldRow, "#FFFFFF");
			//sheet1.SetRowBackColor(NewRow, "#F5EFB3");
			sheet1.SetCellValue(NewRow, "sel", 1);
			$("#span_giftNm").html(sheet1.GetCellValue(NewRow, "giftNm"));
			$("#giftCd").val(sheet1.GetCellValue(NewRow, "giftCd"));
			if( NewRow >= sheet1.HeaderRows() && OldRow != NewRow ){
				
			}
		}catch(ex){alert("OnSelectCell Event Error : " + ex);}
	}

	// 셀 클릭시 발생
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
			if( Row < sheet1.HeaderRows() ) return;
			
		    if( sheet1.ColSaveName(Col) == "giftImg" &&  Value != "" ) {
		    	$("#zooomImg").html("<img src='"+Value+"' />");
		    	$("#zooomImg").show();
		    }
		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}
	

	//---------------------------------------------------------------------------------------------------------------
	// 주소검색 팝업
	//---------------------------------------------------------------------------------------------------------------
	function onZipCodePopup(){

		if(!isPopup()) {return;}
		pGubun = "ZipCodePopup";
		openPopup("/ZipCodePopup.do?cmd=viewZipCodePopup&authPg=${authPg}", "", "740","620");
	}
	//---------------------------------------------------------------------------------------------------------------
	// 팝업 리턴 호출 함수
	//---------------------------------------------------------------------------------------------------------------
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');
		if(pGubun == "ZipCodePopup"){
			$("#recZip").val(rv["zip"]);
			$("#recAddr").val(rv["doroFullAddr"]);
	    }
	}
</script>
<style type="text/css">
#zooomImg img {cursor: pointer; border:5px solid #b1b1b1;}
</style>
</head>
<body class="bodywrap">
<div class="wrapper">
	<div id="zooomImg" style="display:none;position: absolute;top:0;left:50%; margin-left:-200px; margin-top:100px;width:400px;height:500px;z-index:999999">
	</div>	
	
	<div class="popup_title">
		<ul>
			<li>선물신청</li>
			<li class="close"></li>
		</ul>
	</div>
	<div class="popup_main">
      
		<form name="searchForm" id="searchForm" method="post">
		<input type="hidden" id="searchApplSabun"	name="searchApplSabun"	 value=""/>
		<input type="hidden" id="searchGiftSeq" 	name="searchGiftSeq" />
		<input type="hidden" id="giftCd" 			name="giftCd" />
	
	
		<div class="sheet_title">
			<ul>
				<li class="txt">신청내용</li>
			</ul>
		</div>
		
		<table class="table">
			<colgroup>
				<col width="120px" />
				<col width="25%" />
				<col width="120px" />
				<col width="" />
			</colgroup>
		
			<tr>
				<th>이름</th>
				<td>
					<input type="text" id="recName" name="recName" class="text required w80" />
				</td>
				<th>연락처</th>
				<td>
					<input type="text" id="recPhone" name="recPhone" class="text required w150" />
				</td>
			</tr>
			<tr>
				<th>배송지주소</th>
				<td colspan="3">
					<input type="text" id="recZip" name="recZip" class="text required w60" maxlength="5"/>&nbsp;&nbsp;&nbsp;
					<input type="text" id="recAddr" name="recAddr" class="text required" style="width:450px"/>
					<a href="javascript:onZipCodePopup()" 	class="basic" id="btnSearchAddr" >주소검색</a>
				</td>
			</tr>	
			<tr>
				<th>배송요청사항</th>
				<td colspan="3">
					<input type="text" id="note" name="note" class="text w100p" maxlength="1000"/>
				</td>
			</tr>		
			<tr>
				<th>신청 선물명</th>
				<td colspan="3">
					<span id="span_giftNm"></span>
				</td>
			</tr>			
		</table>	
		</form>
		<div class="h10"></div>
		<script type="text/javascript"> createIBSheet("sheet1", "100%", "300px"); </script>

		<div class="popup_button outer">
            <ul>
                <li>
                    <btn:a href="javascript:doAction1('Save');" css="button large" mid='110881' mdef="신청"/>
                    <btn:a href="javascript:p.self.close();"    css="gray large" mid='110881' mdef="닫기"/>
                </li>
            </ul>
		</div>
	</div>
</div>
</body>
</html>
