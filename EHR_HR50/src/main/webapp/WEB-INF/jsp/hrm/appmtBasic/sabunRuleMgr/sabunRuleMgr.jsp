<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='sabunRuleMgr' mdef='사번생성규칙'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	$(function() {
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='statusCd' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='sabunType' mdef='사번생성룰구분'/>",	Type:"Combo",	Hidden:0,	Width:140,	Align:"Center",	ColMerge:0,	SaveName:"sabunType",	KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='autoYn' mdef='자동부여여부'/>",	Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"autoYn",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='bizCdV2' mdef='구분'/>",			Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"fixGbn",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='fixVal' mdef='고정값'/>",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"fixVal",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='fixValLoc' mdef='고정값위치'/>",		Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"fixValLoc",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:2 },
			{Header:"<sht:txt mid='autonum' mdef='자동부여자릿수'/>",	Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"autonum",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='autonumGbn' mdef='자동부여규칙'/>",	Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"autonumGbn",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"최소값",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"startVal",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"최대값",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"endVal",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		var userCd1 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10160"), "");
		var userCd2 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10161"), "");
		var userCd3 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10162"), "");
		var userCd4 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10163"), "");
		//var userCd2 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10070"), "");

		sheet1.SetColProperty("sabunType", 		{ComboText:userCd1[0], ComboCode:userCd1[1]} );
		sheet1.SetColProperty("autoYn", 			{ComboText:"YES|NO", ComboCode:"Y|N"} );

		sheet1.SetColProperty("fixGbn", 			{ComboText:userCd2[0], ComboCode:userCd2[1]} );
		sheet1.SetColProperty("autonum", 			{ComboText:"0|1|2|3|4|5|6|7|8|9|10|11|12|13", ComboCode:"0|1|2|3|4|5|6|7|8|9|10|11|12|13"} );
		sheet1.SetColProperty("autonumGbn", 		{ComboText:userCd3[0], ComboCode:userCd3[1]} );
		sheet1.SetColProperty("fixValLoc", 			{ComboText:"|"+userCd4[0], ComboCode:"|"+userCd4[1]}); //고정값 위치 전: 10, 중 : 20, 후 : 90

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");

	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/SabunRuleMgr.do?cmd=getSabunRuleMgrList" );
			break;
		case "Save":

			if(!dupChk(sheet1,"sabunType", true, true)){break;}
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/SabunRuleMgr.do?cmd=saveSabunRuleMgr", $("#sheet1Form").serialize());
			break;
		case "Insert":
			var row = sheet1.DataInsert(0);

			sheet1.SetCellValue(row,"autonum","3");
			sheet1.SelectCell(row, "sabunType");
			break;
		case "Copy":
			sheet1.DataCopy();
			break;
		case "Clear":
			sheet1.RemoveAll();
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			sheetResize();

			if(sheet1.RowCount() > 0) {
				for(var i = 1; i < sheet1.RowCount()+1; i++) {
					if(sheet1.GetCellValue(i,"autoYn") == "N") {
			            sheet1.SetCellEditable(i,"fixGbn",false);
			            sheet1.SetCellEditable(i,"fixVal",false);
			            sheet1.SetCellEditable(i,"fixValLoc",false);
			            sheet1.SetCellEditable(i,"autonum",false);
			            sheet1.SetCellEditable(i,"autonumGbn",false);
					}
				}
			}
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
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 셀 값 변경시 발생
	function sheet1_OnChange(Row, Col, Value) {
		try {
		    var sSaveName = sheet1.ColSaveName(Col);

		    if ( sSaveName == "autoYn" ) {
		        if ( sheet1.GetCellValue(Row, "autoYn") == "Y" ) {
		            if( sheet1.GetCellValue(Row, "fixGbn") == "" ) {
		            	sheet1.SetCellValue(Row, "fixGbn", "1");
		            }

		            sheet1.SetCellEditable(Row,"fixGbn",true);
		            sheet1.SetCellEditable(Row,"fixVal",true);
		            sheet1.SetCellEditable(Row,"fixValLoc",true);
		            sheet1.SetCellEditable(Row,"autonum",true);
		            sheet1.SetCellEditable(Row,"autonumGbn",true);

		        } else if ( sheet1.GetCellValue(Row, "autoYn") == "N" ) {

		            sheet1.SetCellValue(Row,"fixGbn","");
		            sheet1.SetCellEditable(Row,"fixGbn",false);
		            sheet1.SetCellValue(Row,"fixVal","");
		            sheet1.SetCellEditable(Row,"fixVal",false);
		            sheet1.SetCellValue(Row,"fixValLoc","");
		            sheet1.SetCellEditable(Row,"fixValLoc",false);
		            sheet1.SetCellValue(Row,"autonum","0");
		            sheet1.SetCellEditable(Row,"autonum",false);
		            sheet1.SetCellValue(Row,"autonumGbn","");
		            sheet1.SetCellEditable(Row,"autonumGbn",false);
		        }
		    }


		    if ( sSaveName == "fixGbn" ) {
		    	sheet1.SetCellValue(Row,"fixVal","");
		    	sheet1.SetCellValue(Row,"fixValLoc","");
		    	sheet1.SetCellValue(Row,"autonum","0");
		    	sheet1.SetCellValue(Row,"autonumGbn","");
		    }


		    if ( sSaveName == "autonum" ) {
		        if ( sheet1.GetCellValue( Row, "fixGbn") == "1" ) {
		            if((sheet1.GetCellValue( Row, "fixVal").length+eval(sheet1.GetCellValue( Row, "autonum"))) > 13) {
		                alert("<msg:txt mid='110188' mdef='자동부여 자릿수는 최대 "+(13-sheet1.GetCellValue( Row, "fixVal'/>").length)+" 자리 까지 선택하실 수 있습니다.");
		                sheet1.SetCellValue(Row, "autonum", "");

		                return;
		            }

		        } else if ( sheet1.GetCellValue( Row, "fixGbn") == "2" ) {
		            if((sheet1.GetCellValue( Row, "fixVal").length+eval(sheet1.GetCellValue( Row, "autonum"))) > 9) {
		                alert("<msg:txt mid='110034' mdef='자동부여 자릿수는 최대 "+(9-sheet1.GetCellValue( Row, "fixVal'/>").length)+" 자리 까지 선택하실 수 있습니다.");
		                sheet1.SetCellValue(Row, "autonum", "");

		                return;
		            }
		        } else if ( sheet1.GetCellValue( Row, "fixGbn") == "3" ) {
		            if((sheet1.GetCellValue( Row, "fixVal").length+eval(sheet1.GetCellValue( Row, "autonum"))) > 11) {
		                alert("<msg:txt mid='110462' mdef='자동부여 자릿수는 최대 "+(11-sheet1.GetCellValue( Row, "fixVal'/>").length)+" 자리 까지 선택하실 수 있습니다.");
		                sheet1.SetCellValue(Row, "autonum", "");

		                return;
		            }
		        } else if ( sheet1.GetCellValue( Row, "fixGbn") == "4" ) {
		            if((sheet1.GetCellValue( Row, "fixVal").length+eval(sheet1.GetCellValue( Row, "autonum"))) > 7) {
		                alert("<msg:txt mid='110463' mdef='자동부여 자릿수는 최대 "+(7-sheet1.GetCellValue( Row, "fixVal'/>").length)+" 자리 까지 선택하실 수 있습니다.");
		                sheet1.SetCellValue(Row, "autonum", "");

		                return;
		            }
		        } else if ( sheet1.GetCellValue( Row, "fixGbn") == "5" ) {
		            if((sheet1.GetCellValue( Row, "fixVal").length+eval(sheet1.GetCellValue( Row, "autonum"))) > 9) {
		                alert("<msg:txt mid='110034' mdef='자동부여 자릿수는 최대 "+(9-sheet1.GetCellValue( Row, "fixVal'/>").length)+" 자리 까지 선택하실 수 있습니다.");
		                sheet1.SetCellValue(Row, "autonum", "");

		                return;
		            }
		        }
		    }
		} catch (ex) {
			alert("OnChange Event Error " + ex);
		}
	}

	function sheet1_OnValidation(Row, Col, Value) {
		try {
		    if ( sheet1.GetCellValue( Row, "fixGbn") == "1" ) {
		        if((sheet1.GetCellValue( Row, "fixVal").length+eval(sheet1.GetCellValue( Row, "autonum"))) > 13) {
		            alert("<msg:txt mid='110188' mdef='자동부여 자릿수는 최대 "+(13-sheet1.GetCellValue( Row, "fixVal'/>").length)+" 자리 까지 선택하실 수 있습니다.");
		            sheet1.ValidateFail(true);

		            return;
		        }
		    } else if ( sheet1.GetCellValue( Row, "fixGbn") == "2" ) {
		        if((sheet1.GetCellValue( Row, "fixVal").length+eval(sheet1.GetCellValue( Row, "autonum"))) > 9) {
		            alert("<msg:txt mid='110034' mdef='자동부여 자릿수는 최대 "+(9-sheet1.GetCellValue( Row, "fixVal'/>").length)+" 자리 까지 선택하실 수 있습니다.");
		            sheet1.ValidateFail(true);

		            return;
		        }
		    } else if ( sheet1.GetCellValue( Row, "fixGbn") == "3" ) {
		        if((sheet1.GetCellValue( Row, "fixVal").length+eval(sheet1.GetCellValue( Row, "autonum"))) > 11) {
		            alert("<msg:txt mid='110462' mdef='자동부여 자릿수는 최대 "+(11-sheet1.GetCellValue( Row, "fixVal'/>").length)+" 자리 까지 선택하실 수 있습니다.");
		            sheet1.ValidateFail(true);

		            return;
		        }
		    } else if ( sheet1.GetCellValue( Row, "fixGbn") == "4" ) {
		        if((sheet1.GetCellValue( Row, "fixVal").length+eval(sheet1.GetCellValue( Row, "autonum"))) > 7) {
		            alert("<msg:txt mid='110463' mdef='자동부여 자릿수는 최대 "+(7-sheet1.GetCellValue( Row, "fixVal'/>").length)+" 자리 까지 선택하실 수 있습니다.");
		            sheet1.ValidateFail(true);

		            return;
		        }
		    } else if ( sheet1.GetCellValue( Row, "fixGbn") == "5" ) {
		        if((sheet1.GetCellValue( Row, "fixVal").length+eval(sheet1.GetCellValue( Row, "autonum"))) > 9) {
		            alert("<msg:txt mid='110034' mdef='자동부여 자릿수는 최대 "+(9-sheet1.GetCellValue( Row, "fixVal'/>").length)+" 자리 까지 선택하실 수 있습니다.");
		            sheet1.ValidateFail(true);

		            return;
		        }
		    }
		} catch (ex) {
			alert("OnValidation Event Error " + ex);
		}
	}

</script>
</head>
<body class="bodywrap">
<form id="sheet1Form" name="sheet1Form"></form>
<div class="wrapper">
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='sabunRuleMgr' mdef='사번생성규칙'/></li>
			<li class="btn">
			    <btn:a href="javascript:doAction1('Search');" css="basic authR" mid='search' mdef="조회"/>
				<btn:a href="javascript:doAction1('Insert');" css="basic authA" mid='insert' mdef="입력"/>
				<btn:a href="javascript:doAction1('Copy');" css="basic authA" mid='copy' mdef="복사"/>
				<btn:a href="javascript:doAction1('Save');" css="basic authA" mid='save' mdef="저장"/>
				<btn:a href="javascript:doAction1('Down2Excel');" css="basic authR" mid='down2excel' mdef="다운로드"/>
			</li>
		</ul>
		</div>
	</div>

	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>

	<div class="explain inner">
		<div class="title"><tit:txt mid='113502' mdef='작업설명'/></div>
		<div class="txt">
		<ul>
			<li><tit:txt mid='112357' mdef='- 구분 : 사번부여시 고정으로 등록하는 값'/></li>
			<li style="line-height:5px">&nbsp;</li>
			<li><tit:txt mid='114115' mdef='- 고정값 : 최대 10자리까지 고정값 등록 가능'/></li>
			<li style="text-indent:47px"><tit:txt mid='113768' mdef='고정값 : 고정값으로 처리'/></li>
			<li style="text-indent:47px"><tit:txt mid='112684' mdef='년(YYYY), 년(YY) : 입사년과 고정값으로 처리'/></li>
			<li style="text-indent:47px"><tit:txt mid='113420' mdef='년월(YYYYMM), 년월(YYMM) : 입사년월과 고정값으로 처리'/></li>
			<li style="line-height:5px">&nbsp;</li>
			<li><tit:txt mid='114116' mdef='- 고정값위치 &nbsp전 : '/><b><tit:txt mid='112358' mdef='"구분"'/></b><tit:txt mid='2018080300032' mdef='"의 앞에 위치=>"'/><tit:txt mid='112685' mdef=' ex) 구분값: '/><font style="color:blue"><tit:txt mid='112686' mdef='년월(YYYYMM)'/></font><tit:txt mid='112687' mdef=', 고정값 : '/><font style="color:red">P</font> <b>→</b> <font style="color:red">P</font><font style="color:blue">201301</font><font style="color:green">001</font></li>
			<li style="text-indent:65px"><tit:txt mid='114487' mdef=' 중 : '/><b><tit:txt mid='112358' mdef='"구분"'/></b><tit:txt mid='112359' mdef='과 '/><b><tit:txt mid='113421' mdef='"자동부여자릿수"'/></b> <tit:txt mid='2018080300035' mdef='"중간 위치=>"'/><tit:txt mid='112685' mdef=' ex) 구분값: '/><font style="color:blue"><tit:txt mid='112686' mdef='년월(YYYYMM)'/></font><tit:txt mid='112687' mdef=', 고정값 : '/><font style="color:red">P</font> <b>→</b> <font style="color:blue">201301</font><font style="color:red">P</font><font style="color:green">001</font></li>
			<li style="text-indent:65px"><tit:txt mid='114117' mdef=' 후 : '/><b><tit:txt mid='112360' mdef='"구분", "자동부여자릿수"'/></b><tit:txt mid='2018080300036' mdef='"에 관계 없이 맨뒤에 위치=>"'/><tit:txt mid='112685' mdef=' ex) 구분값: '/><font style="color:blue"><tit:txt mid='112686' mdef='년월(YYYYMM)'/></font><tit:txt mid='112687' mdef=', 고정값 : '/><font style="color:red">P</font> <b>→</b> <font style="color:blue">201301</font><font style="color:green">001</font><font style="color:red">P</font></li>
			<li style="line-height:5px">&nbsp;</li>
			<li><tit:txt mid='112361' mdef='- 자동부여규칙 : 전번 - 전체 직원에서 자리수 증가 '/></li>
			<li style="text-indent:80px"><tit:txt mid='113422' mdef='년번 - 입사년도 기준 직원에서 자리수 증가 '/></li>
			<li style="text-indent:80px"><tit:txt mid='114488' mdef='월번 - 입사월 기준 직원에서 자리수 증가 '/></li>
		</ul>
		</div>
	</div>
</div>
</body>
</html>
