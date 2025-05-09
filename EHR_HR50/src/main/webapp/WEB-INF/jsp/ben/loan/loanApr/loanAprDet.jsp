<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">

	var p = eval("${popUpStatus}");

	$(function() {

		var arg = p.popDialogArgumentAll();

		$("#searchSabun").val( arg['searchSabun'] );
		$("#searchApplSabun").val( arg['searchSabun'] );

		$("#searchApplSeq").val( arg['searchApplSeq'] );

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No|No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제|삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"납입 회차|납입 회차",					Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"repayCnt",			KeyField:1,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:2},
			{Header:"상환구분|상환구분",						Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"repayType",			KeyField:1,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:2},
			{Header:"대출금 상환\n납입월일|대출금 상환\n납입월일",	Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"repayYmd",			KeyField:1,	CalcLogic:"",	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10},
			{Header:"이자산출내역|적용기간",		 			Type:"Text",	Hidden:1,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"applyTerm",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:50},
			{Header:"이자산출내역|적용기간 시작일",	 			Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"applySdate",			KeyField:1,	CalcLogic:"",	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50},
			{Header:"이자산출내역|적용기간 종료일",	 			Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"applyEdate",			KeyField:1,	CalcLogic:"",	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50},
			{Header:"이자산출내역|적용일수",					Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"applyDay",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:3},
			{Header:"이자산출내역|원금",						Type:"Int",		Hidden:0,	Width:90,	Align:"Right",	ColMerge:0,	SaveName:"monthPrincipal",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50},
			{Header:"이자산출내역|이율",						Type:"Float",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"applyInterestRate",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:2,	UpdateEdit:0,	InsertEdit:1,	EditLen:5},
			{Header:"상환내역|원금",						Type:"AutoSum",	Hidden:0,	Width:90,	Align:"Right",	ColMerge:0,	SaveName:"repayPrincipal",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:50},
			{Header:"상환내역|이자",						Type:"AutoSum",	Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"personalChargeInterest",KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:50},
			{Header:"상환내역|계",							Type:"AutoSum",	Hidden:0,	Width:90,	Align:"Right",	ColMerge:0,	SaveName:"repaySum",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50},
			{Header:"대출잔액|대출잔액",						Type:"Int",		Hidden:0,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:"monthBalance",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50},
			{Header:"마감|마감",							Type:"CheckBox",Hidden:0, 	Width:80 , 	Align:"Center",	ColMerge:1,	SaveName:"magamYn",				KeyField:0,	CalcLogic:"", Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50,TrueValue:"Y", FalseValue:"N"},
			{Header:"비고|비고",				 			Type:"Text",	Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"note",				KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4000},

			{Header:"마감여부|마감여부",		 				Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"magamYn",				KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:50}

        ]; IBS_InitSheet(sheet1, initdata);
        sheet1.SetEditable(true);
        sheet1.SetVisible(true);
        sheet1.SetCountPosition(4);

        var repayType 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","B50050"), "");
		sheet1.SetColProperty("repayType", {ComboText:"|"+repayType[0], ComboCode:"|"+repayType[1]} );

	    $(window).smartresize(sheetResize);
	    sheetInit();

        $(".close").click(function() {
	    	p.self.close();
	    });

        doAction1("Search");
	});

	function loadLoan(){
		// 대출 정보 조회
		var data = ajaxCall( "${ctx}/LoanApr.do?cmd=getLoanAppMap",$("#sheet1Form").serialize(),false);

		if(data.map != null ){
			$("#loanTypeNm").val( data.map.loanTypeNm );					//대출구분
			$("#loanDtlTypeNm").val( data.map.loanDtlTypeNm );				//상환용도
			$("#loanSYmd").val( getDateVal(data.map.loanSYmd) );			//상환시작일

			$("#loanTerm").val( data.map.loanTerm );						//대출기간(개월)
			$("#interestRate").val( data.map.interestRate );				//대출이율
			$("#repayCnt").val( data.map.repayCnt );						//상환회차/대출기간
			$("#loanType").val( data.map.loanType );						//대출타입

			$("#loanPrincipal").val( data.map.loanPrincipal ).mask('999,999,999,999',{reverse:true});			//대출원금
			$("#loanRemain").val( data.map.loanRemain ).mask('999,999,999,999',{reverse:true});					//대출잔액
			$("#repayPrincipalSum").val( data.map.repayPrincipalSum ).mask('999,999,999,999',{reverse:true});	//총상환액

			$("#repayCntMax").val( data.map.repayCntMax );					//총상환회차
			$("#fullPaymentYn").val( data.map.fullPaymentYn );				//완납여부

			$("#afterApplyDate").val( data.map.afterApplyDate );			//다음회차 적용기간 시작일

			$("#interestRate").val( data.map.interestRate );				//이율

		}else{
			alert( "대출 정보 조회 시, 오류가 발생하였습니다." );
			return;
		}
	}

	/*Sheet1 Action*/
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 		//조회

			//대출정보조회
			loadLoan();

			sheet1.DoSearch( "${ctx}/LoanApp.do?cmd=getLoanAppRepayList", $("#sheet1Form").serialize() );
			break;
		case "Insert":      //입력

			//입력 중 체크, 입력 중이면 또 입력하지 못하게 막음. 하나씩 처리.
			var cnt = 0;

			for(var i = sheet1.HeaderRows(); i<sheet1.RowCount()+sheet1.HeaderRows(); i++){
				if( sheet1.GetCellValue( i, "sStatus" ) != "R" ){
					cnt++;
				}
			}
			if( cnt > 0 ){
				alert("현재 작업 중인 납입회차가 존재합니다. 저장 후 다시 입력해 주시기 바랍니다.");
				return;
			}

			//완납체크
			if($("#fullPaymentYn").val() == 'Y'){
				alert("이미 완납 된 대출입니다. 입력이 불가능합니다.");
				return;
			}

			var Row = sheet1.DataInsert(0);

			//납입회차-repayCntMax+1
			var repayCnt = 0;
			repayCnt = parseInt($("#repayCntMax").val()) + 1;
			sheet1.SetCellValue( Row, "repayCnt", repayCnt, 0);

			//상황구분-중도상환만 입력
			sheet1.SetCellValue( Row, "repayType", "00002", 0);

			//마감 Y
			sheet1.SetCellValue( Row, "magamYn", "Y", 0);

			//대출금 상환 납입월일
			sheet1.SetCellValue( Row, "repayYmd", $("#afterApplyDate").val(), 0);

			//적용기간 시작일
			sheet1.SetCellValue( Row, "applySdate", $("#afterApplyDate").val(), 0);

			//적용기간 종료일
			sheet1.SetCellValue( Row, "applyEdate", $("#afterApplyDate").val(), 0);

			//적용일수
			sheet1.SetCellValue( Row, "applyDay", 1, 0);

			//대출원금
			sheet1.SetCellValue( Row, "monthPrincipal", $("#loanRemain").val(), 0);

			//이율
			sheet1.SetCellValue( Row, "applyInterestRate", $("#interestRate").val(), 0);

			break;
        case "Save":
        	IBS_SaveName(document.sheet1Form,sheet1);
        	sheet1.DoSave( "${ctx}/LoanApr.do?cmd=saveLoanAprDetail", $("#sheet1Form").serialize());
        	break;
        case "Copy":
        	var Row = sheet1.DataCopy();
        	//sheet1.SetCellValue( Row, "schType", "" );
        	//sheet1.SetCellValue( Row, "schApplType", "" );
        	break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet1.Down2Excel(param);
			break;
		}

    }

	function sheet1_OnChange(Row, Col, Value, OldValue, RaiseFlag) {

		try{

			var sSaveName = sheet1.ColSaveName(Col);

			//대출금 상환납입월일 변경
			if(sSaveName == "repayYmd"){

				//적용기간 종료일이 적용기간 시작일보다 작으면 리턴 - 그러면 안됨
				if( sheet1.GetCellValue( Row, "applySdate") > Value ){
					alert("적용기간 시작일보다 작습니다.");
					sheet1.SetCellValue(Row, Col, OldValue, 0);
					return;
				}

				//적용기간 종료일 세팅
				sheet1.SetCellValue(Row, "applyEdate", sheet1.GetCellValue( Row, "repayYmd"), 0);

				//적용일 세팅
				var ssdate = sheet1.GetCellValue(Row,"applySdate");
				var sedate = sheet1.GetCellValue(Row,"applyEdate");

				var sdate = new Date(ssdate.substr(0, 4), ssdate.substr(4, 2) - 1, ssdate.substr(6, 2));
				var edate = new Date(sedate.substr(0, 4), sedate.substr(4, 2) - 1, sedate.substr(6, 2));

				var betweenDay = ((edate.getTime() - sdate.getTime())/1000/60/60/24) +1;

				sheet1.SetCellValue(Row, "applyDay", betweenDay );

			}

			//상환원금 체크
			if( sSaveName == "repayPrincipal" ){

				//값을 원금보다 크면 롤빽
				if( sheet1.GetCellValue( Row, "monthPrincipal") < Value ){
					alert("상환원금이 대출잔액보다 큼니다.");
					sheet1.SetCellValue(Row, Col, OldValue, 0);
					return;
				}
			}

			//상환원금, 적용일수, 이율이 있을 경우 이자 계산
			if( sheet1.GetCellValue( Row, "applyDay" ) != "" && sheet1.GetCellValue( Row, "applyInterestRate" ) != ""
					&& sheet1.GetCellValue( Row, "repayPrincipal" ) != "" ){
				calc(Row);
			}

		}catch(ex){alert("OnChange Event Error : " + ex);}

	}

    function getDateVal(pVal) {
        if ( pVal.length == 8 ) {
            return pVal.substr(0,4) +"-"+ pVal.substr(4,2) +"-"+ pVal.substr(6,2);
        } else {
            return pVal;
        }
    }

	function sheetDataInit(Row){
		sheet1.SetCellValue( Row, "repayYmd" , "" , 0);
		sheet1.SetCellValue( Row, "applySdate" , "" , 0);
		sheet1.SetCellValue( Row, "applyEdate" , "" , 0);
		sheet1.SetCellValue( Row, "applyDay" , "" , 0);
		sheet1.SetCellValue( Row, "monthPrincipal" , "" , 0);
		sheet1.SetCellValue( Row, "applyInterestRate" , "" , 0);
		sheet1.SetCellValue( Row, "basicDay" , "" , 0);
		sheet1.SetCellValue( Row, "useDay" , "" , 0);
		sheet1.SetCellValue( Row, "repayPrincipal" , "" , 0);
		sheet1.SetCellValue( Row, "personalChargeInterest" , "" , 0);
		sheet1.SetCellValue( Row, "repaySum" , "" , 0);
		sheet1.SetCellValue( Row, "monthBalance" , "" , 0);
	}

	function calc(Row){

		/*
		 *	이자계산
		 *	대출원금 잔액*(대출이자율/100)*(경과일수/365) 의 0원 단위 버림
		 */
		var interest = 0;

		interest = sheet1.GetCellValue( Row, "monthPrincipal") * (sheet1.GetCellValue( Row, "applyInterestRate") / 100)
					* (sheet1.GetCellValue( Row, "applyDay") / 365);

		//1000단위 절삭
		interest = Math.floor(interest/10) * 10;

		//상환내역 이자
		sheet1.SetCellValue( Row, "personalChargeInterest", interest, 0 );

		//상환내역 계
		sheet1.SetCellValue( Row, "repaySum", parseInt( sheet1.GetCellValue( Row, "repayPrincipal") ) + parseInt( sheet1.GetCellValue( Row, "personalChargeInterest") ), 0 );

		//대출잔액 = 원금 - 상환원금
		sheet1.SetCellValue( Row, "monthBalance", parseInt( sheet1.GetCellValue( Row, "monthPrincipal") ) - parseInt( sheet1.GetCellValue( Row, "repayPrincipal") ), 0 );

	}

	// 	조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if(Msg != ""){
				alert(Msg);
			}else{

				if( sheet1.RowCount() > 0 ){

					//우선적으로 모든 Row edit 금지
					for(var i = sheet1.HeaderRows(); i<sheet1.RowCount()+sheet1.HeaderRows(); i++){
						sheet1.SetRowEditable(i, 0);

						sheet1.SetCellEditable( i, "note", 1 );
					}

					// 첫행이 중도상환일 경우만 삭제 가능
					if( sheet1.GetCellValue( sheet1.HeaderRows(), "repayType" ) == "00002" ){
						sheet1.SetCellEditable( sheet1.HeaderRows(), "sDelete", 1 );
					}
				}
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

			doAction1("Search");
			loadLoan();
			if(p.popReturnValue) p.popReturnValue();

		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

</script>
</head>
<body class="hidden bodywrap">
	<div class="wrapper">
		<div class="popup_title">
			<ul>
				<li>대출 상환 내역</li>
				<li class="close"></li>
			</ul>
		</div>
		<div class="popup_main">
			<form id="sheet1Form" name="sheet1Form">
				<input type="hidden" id="searchSabun" name="searchSabun" value=""/>
				<input type="hidden" id="searchApplSabun" name="searchApplSabun" value=""/>
				<input type="hidden" id="searchApplSeq" name="searchApplSeq" value=""/>
				<input type="hidden" id="repayCntMax" name="repayCntMax" value=""/>
				<input type="hidden" id="loanTerm" name="loanTerm" value=""/>
				<input type="hidden" id="loanType" name="loanType" value=""/>
				<input type="hidden" id="repayCnt" name="repayCnt" value=""/>
				<input type="hidden" id="fullPaymentYn" name="fullPaymentYn" value=""/>
				<input type="hidden" id="afterApplyDate" name="afterApplyDate" value=""/>
				<input type="hidden" id="interestRate" name="interestRate" value=""/>



			<table border="0" cellpadding="0" cellspacing="0" class="default outer">
				<colgroup>
					<col width="13%" />
					<col width="20%" />
					<col width="13%" />
					<col width="20%" />
					<col width="13%" />
					<col width="20%" />
				</colgroup>
				<tr>
					<th>대출구분</th>
					<td><input type="text" id="loanTypeNm" name="loanTypeNm" class="text readonly center" value="" readonly style="width:200px;" /></td>
					<th>대출용도</th>
					<td><input type="text" id="loanDtlTypeNm" name="loanDtlTypeNm" class="text readonly center" value="" readonly style="width:120px;text-align:center;" /></td>
					<th>대출금지급일</th>
					<td><input type="text" id="loanSYmd" name="loanSYmd" class="text readonly" value="" readonly style="width:120px;text-align:center;" /></td>
				</tr>
				<tr>
					<th>대출원금</th>
					<td><input type="text" id="loanPrincipal" name="loanPrincipal" class="text readonly" value="" readonly style="width:120px;text-align:Right;" /></td>
					<th>대출잔액</th>
					<td><input type="text" id="loanRemain" name="loanRemain" class="text readonly" value="" readonly style="width:120px;text-align:Right;" /></td>
					<th>총상환액</th>
					<td><input type="text" id="repayPrincipalSum" name="repayPrincipalSum" class="text readonly" value="" readonly style="width:120px;text-align:Right;" /></td>
				</tr>
			</table>
			<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
				<tr>
					<td>
					<div class="inner">
						<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">대출 상환 내역</li>
							<li class="btn">
								<a href="javascript:doAction1('Search')"		class="basic authR">조회</a>
								<a href="javascript:doAction1('Insert')"		class="basic authA">입력</a>
								<a href="javascript:doAction1('Save')"			class="basic authA">저장</a>
								<a href="javascript:doAction1('Down2Excel')"	class="basic authR">다운로드</a>
							</li>
						</ul>
						</div>
					</div>
					<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "kr"); </script>
					</td>
				</tr>
			</table>
			</form>
			<div class="popup_button outer">
				<ul>
					<li>
						<a href="javascript:p.self.close();" class="gray large">닫기</a>
					</li>
				</ul>
			</div>
		</div>
	</div>
</body>
</html>