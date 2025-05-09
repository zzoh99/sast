<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='113773' mdef='임직원 조회 팝업'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var srchBizCd = null;
	var p = eval("${popUpStatus}");
	var searchEnterCdView  	= "";
	var ssnSearchType = "";

	/*Sheet 기본 설정 */
	$(function() {
		var arg = p.popDialogArgumentAll();
		var schDate 	= "";
		var schType  	= "";
		var schOrgCd	= "";
		var schCode 	= "";
		
		var schOrgNm 	= "";
		var schTitle1 	= "";
		var schTitle2 	= "";
		
		/*
		var except1 	= "";
		var except2 	= "";
		var except3 	= "";
		*/

	    if( arg != undefined ) {
	    	schDate 	= arg["schDate"];
	    	schType 	= arg["schType"];
	    	schOrgCd		= arg["orgCd"];
	    	schCode		= arg["code"];
	    	
	    	schOrgNm		= arg["orgNm"];
	    	schTitle1		= arg["schTitle1"];
	    	schTitle2		= arg["schTitle2"];
	    	/*
	    	except1		= arg["except1"];
	    	except2		= arg["except2"];
	    	except3		= arg["except3"];
	    */
	    }

		$("#schDate").val(schDate);
		$("#schType").val(schType);
		$("#schOrgCd").val(schOrgCd);
		$("#schCode").val(schCode);
		/*
		$("#except1").val(except1);
		$("#except2").val(except2);
		$("#except3").val(except3);
		*/
		var titleTxt = schOrgNm + " "+ schDate + " " + schTitle1 + " (" +schTitle2 +")";
		$("#titleTxt").html(titleTxt);
		
		ssnSearchType = "${ssnSearchType}";
		


		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:0, DataRowMerge:0};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:0,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
 			{Header:"프로필",			Type:"Image",		Hidden:1,	Width:40,			Align:"Center",	ColMerge:1,	SaveName:"detail0",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0},
 			{Header:"회사코드",		Type:"Text",		Hidden:1,	Width:80,			Align:"Center",	ColMerge:0,	SaveName:"enterCd", UpdateEdit:0 },
 			{Header:"회사",			Type:"Text",		Hidden:1,	Width:100,			Align:"Center",	ColMerge:0,	SaveName:"enterNm", UpdateEdit:0 },
 			{Header:"사진",			Type:"Image",		Hidden:0,	Width:90,			Align:"Center",	ColMerge:0,	SaveName:"photo",	UpdateEdit:0, ImgWidth:80, ImgHeight:90 },
			{Header:"사번",			Type:"Text",		Hidden:0,	Width:50,			Align:"Center",	ColMerge:0,	SaveName:"sabun", UpdateEdit:0 },
			{Header:"성명",			Type:"Text",		Hidden:0,	Width:60,			Align:"Center",	ColMerge:0,	SaveName:"name", UpdateEdit:0 },
			{Header:"재직상태",		Type:"Text",		Hidden:1,	Width:50,			Align:"Center",	ColMerge:0,	SaveName:"statusNm", UpdateEdit:0 },			
			{Header:"소속",			Type:"Text",		Hidden:0,	Width:130,			Align:"Center",	ColMerge:0,	SaveName:"orgNm", UpdateEdit:0 },
			{Header:"직책",			Type:"Text",		Hidden:0,	Width:80,			Align:"Center",	ColMerge:0,	SaveName:"jikchakNm", UpdateEdit:0 },
			{Header:"직위",			Type:"Text",		Hidden:0,	Width:80,			Align:"Center",	ColMerge:0,	SaveName:"jikweeNm", UpdateEdit:0 },
			{Header:"직급",			Type:"Text",		Hidden:Number("${jgHdn}"),		Width:60,		Align:"Center",	ColMerge:0,	SaveName:"jikgubNm", UpdateEdit:0 },
			{Header:"직군",			Type:"Text",		Hidden:0,	Width:60,			Align:"Center",	ColMerge:0,	SaveName:"workTypeNm", UpdateEdit:0 },
			{Header:"사원구분",		Type:"Text",		Hidden:0,	Width:80,			Align:"Center",	ColMerge:0,	SaveName:"manageNm", UpdateEdit:0 },
			{Header:"조회권한",		Type:"Text",		Hidden:1,	Width:45,			Align:"Center",	ColMerge:0,	SaveName:"authYn", UpdateEdit:0 }
		];
		IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(4);sheet1.SetEditableColorDiff (0);

		sheet1.SetImageList(1,"${ctx}/common/images/icon/icon_popup.png");
		sheet1.SetDataLinkMouse("detail0",1);
		
		$(window).smartresize(sheetResize);
		sheetInit();

		doAction("Search");

        $(".close").click(function() {
	    	p.self.close();
	    });
	});

	function doAction(sAction) {
	/*Sheet Action*/
		switch (sAction) {
		case "Search": //조회
		    sheet1.DoSearch( "${ctx}/HrmSta.do?cmd=getHrmStaPopupList", $("#mySheetForm").serialize(), 1);
            break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet1.Down2Excel(param);
			break;
		}
    }

	// 	조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, ErrMsg, StCode, StMsg) {
		try{
		    if (ErrMsg != "") {
				alert(ErrMsg);
			}

			sheetResize();
	  	}catch(ex){alert("OnSearchEnd Event Error : " + ex);}
	}
	
	
	
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		
		var authYn = sheet1.GetCellValue(Row, "authYn");
		if(sheet1.ColSaveName(Col) == "detail0" && Value != "") {
			
			if(ssnSearchType == "A"){
	            if( "${profilePopYn}"=="Y"){
	            	
					// 인사기본 팝업 
					var url     = "${ctx}/EisEmployeePopup.do?cmd=viewEmployeeProfilePopup&authPg=R";
		            var args    = new Array();
		            args["sabun"]      = sheet1.GetCellValue(Row, "sabun");
		            args["enterCd"]    = sheet1.GetCellValue(Row, "enterCd");
		            args["empName"]    = sheet1.GetCellValue(Row, "name");
		            openPopup(url,args,"1300","780");
	            	
	            }else{
	            	
					// 부모창 인사 기본으로 이동
					var returnValue    = new Array(2);
		            returnValue["sabun"]       = sheet1.GetCellValue(Row, "sabun");
					returnValue["enterCd"]     = sheet1.GetCellValue(Row, "enterCd");
	
					if(p.popReturnValue) p.popReturnValue(returnValue);
					p.self.close();
	            }
	            
			}else if(ssnSearchType == "P"){
				// 프로필 화면 팝업 띄우기
				var url     = "${ctx}/EmpProfilePopup.do?cmd=viewEmpProfile&authPg=${authPg}";
	            var args    = new Array();
	            args["sabun"]       = sheet1.GetCellValue(Row, "sabun");
	            args["enterCd"]     = sheet1.GetCellValue(Row, "enterCd");
	            
				openPopup(url,args,"610","350");
				
			}else if(ssnSearchType == "B"){
				/*
				// 부모창 인사 기본으로 이동
				var returnValue    = new Array(2);
	            returnValue["sabun"]       = sheet1.GetCellValue(Row, "sabun");
				returnValue["enterCd"]     = sheet1.GetCellValue(Row, "enterCd");

				if(p.popReturnValue) p.popReturnValue(returnValue);
				p.self.close();
				*/	
			}else if(ssnSearchType == "O"){
				/*
				var chkVal = "N";
				var chkOrg = sheet1.GetCellValue(Row, "orgCd");
				if(authYn == "Y"){
					if( "${profilePopYn}"=="Y"){
						// 인사기본 팝업 
						var url     = "${ctx}/EisEmployeePopup.do?cmd=viewEmployeeProfilePopup&authPg=R";
			            var args    = new Array();
			            args["sabun"]      = sheet1.GetCellValue(Row, "sabun");
			            args["enterCd"]    = sheet1.GetCellValue(Row, "enterCd");
			            args["empName"]    = sheet1.GetCellValue(Row, "name");
			            openPopup(url,args,"1250","780");
					}else{
						// 부모창 인사 기본으로 이동
						var returnValue    = new Array(2);
			            returnValue["sabun"]       = sheet1.GetCellValue(Row, "sabun");
						returnValue["enterCd"]     = sheet1.GetCellValue(Row, "enterCd");

						if(p.popReturnValue) p.popReturnValue(returnValue);
						p.self.close();
						
					}
				}else{
					 var url     = "${ctx}/EmpProfilePopup.do?cmd=viewEmpProfile&authPg=${authPg}";
	                 var args    = new Array();
	                 args["sabun"]       = sheet1.GetCellValue(Row, "sabun");
	                 args["enterCd"]     = sheet1.GetCellValue(Row, "enterCd");
	                 
	                 openPopup(url,args,"610","350");
				}
				*/	
			}
			
			
		}
	}
	

</script>

</head>
<body class="bodywrap">
    <div class="wrapper">
        <div class="popup_title">
            <ul>
                <li id="titleTxt" name="titleTxt"></li>
                <li class="close"></li>
            </ul>
        </div>
        <div class="popup_main">
            <form id="mySheetForm" name="mySheetForm">	    
                <input type="hidden" id="schDate" name="schDate" />
                <input type="hidden" id="schType" name="schType" />
                <input type="hidden" id="schOrgCd" name="schOrgCd" />
                <input type="hidden" id="schCode" name="schCode" />
                <!-- 
				<input type="hidden" id="except1" name="except1"/>
				<input type="hidden" id="except2" name="except2"/>
				<input type="hidden" id="except3" name="except3"/>                
 	        	 -->
 	        </form>
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li id="txt" class="txt"><tit:txt mid='schEmployee' mdef='사원조회'/></li>
					<li class="btn"><btn:a href="javascript:doAction('Down2Excel')" 	css="basic authR" mid='down2excel' mdef="다운로드"/></li>
				</ul>
				</div>
			</div>
			<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>

	        <div class="popup_button outer">
	            <ul>
	                <li>
	                    <btn:a href="javascript:p.self.close();" css="gray large" mid='close' mdef="닫기"/>
	                </li>
	            </ul>
	        </div>
        </div>
    </div>
</body>
</html>
