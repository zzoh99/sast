<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
    <%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
    <%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
    <%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
    <script type="text/javascript">
        var gPRow = "";
        var pGubun = "";

        $(function() {
            var initdata = {};
            initdata.Cfg = {FrozenCol:22,SearchMode:smLazyLoad,Page:22,MergeSheet:msAll};
            initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
            initdata.Cols = [
                {Header:"<sht:txt mid='sNo'         mdef='No'           />",     Type:"${sNoTy}" , Hidden:Number("${sNoHdn}") , Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
                {Header:"<sht:txt mid='sDelete V5'  mdef='삭제'         />",     Type:"${sDelTy}", Hidden:Number("${sDelHdn}"),  Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete", Sort:0 },
                {Header:"<sht:txt mid='sStatus'     mdef='상태'         />",     Type:"${sSttTy}", Hidden:Number("${sSttHdn}"),  Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0 },
                {Header:"<sht:txt mid='BLANK'       mdef='대분류'     />",     Type:"Text"     , Hidden:0, Width:50 ,  Align:"Center", ColMerge:0, SaveName:"workAssignNmLarge"    ,    KeyField:1, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:500 },
                {Header:"<sht:txt mid='BLANK'       mdef='대분류코드'     />",     Type:"Text"     , Hidden:1, Width:50 ,  Align:"Center", ColMerge:0, SaveName:"workAssignCdLarge"    ,    KeyField:1, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100 },
                {Header:"<sht:txt mid='BLANK'       mdef='중분류'     />",     Type:"Text"     , Hidden:0, Width:50 ,  Align:"Center", ColMerge:0, SaveName:"workAssignNmMiddle"    ,    KeyField:1, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:500 },
                {Header:"<sht:txt mid='BLANK'       mdef='중분류코드'     />",     Type:"Text"     , Hidden:1, Width:50 ,  Align:"Center", ColMerge:0, SaveName:"workAssignCdMiddle"    ,    KeyField:1, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100 },
                {Header:"<sht:txt mid='BLANK'       mdef='사무분담'     />",     Type:"Popup"     , Hidden:0, Width:50 ,  Align:"Center", ColMerge:0, SaveName:"workAssignNm"    ,    KeyField:1, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:500 },
                {Header:"<sht:txt mid='BLANK'       mdef='사무분담코드'     />",     Type:"Text"     , Hidden:1, Width:50 ,  Align:"Center", ColMerge:0, SaveName:"workAssignCd"    ,    KeyField:1, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100 },
                {Header:"<sht:txt mid='BLANK'       mdef='부사무분담'     />",     Type:"Text"     , Hidden:0, Width:50 ,  Align:"Center", ColMerge:0, SaveName:"detailNm"    ,    KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:500 },
                {Header:"<sht:txt mid='BLANK'       mdef='성명'     />",     Type:"Text"     , Hidden:0, Width:30 ,  Align:"Center", ColMerge:0, SaveName:"name"    ,    KeyField:1, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:100 },
                {Header:"<sht:txt mid='BLANK'       mdef='사번'     />",     Type:"Text"     , Hidden:1, Width:50 ,  Align:"Center", ColMerge:0, SaveName:"sabun"    ,    KeyField:1, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100},
                {Header:"<sht:txt mid='BLANK'       mdef='순번'     />",     Type:"Text"     , Hidden:1, Width:50 ,  Align:"Center", ColMerge:0, SaveName:"approvalSeq"    ,    KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100 },
            ]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");


            $("#searchWorkAssignNm").bind("keyup",function(event){
                if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
            });
            
            $("#searchName").bind("keyup",function(event){
    			if( event.keyCode == 13){
    				employeePopup(); $(this).focus();
    			}
    		});

            $(window).smartresize(sheetResize); sheetInit();

//             fnSetCode()

            doAction1("Search");
            
    		$(sheet1).sheetAutocomplete({
    			Columns: [
    				{
    					ColSaveName  : "name",
    					CallbackFunc : function(returnValue){
    						var rv = $.parseJSON('{' + returnValue+ '}');
    						sheet1.SetCellValue(gPRow, "name",		rv["name"]);
    						sheet1.SetCellValue(gPRow, "sabun",		rv["sabun"]);
    					}
    				}
    			]
    		});	            
        });



        function fnSetCode() {

//             var halfGubunTypeCd     = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","D00005"), "");
//             sheet1.SetColProperty("halfGubunType", 	{ComboText:halfGubunTypeCd[0], ComboCode:halfGubunTypeCd[1]} );

        }




        /**
         * Sheet 각종 처리
         */
        function doAction1(sAction) {
            switch (sAction) {
                case "Search": //조회

                    sheet1.DoSearch("${ctx}/ShrOfcWrkMgr.do?cmd=getShrOfcWrkMgrList", $("#srchFrm").serialize());
                    break;
                case "Save": //저장
                    if(!dupChk(sheet1,"workAssignCd|sabun", true, true)){break;}
                    IBS_SaveName(document.srchFrm, sheet1);
                    sheet1.DoSave("${ctx}/ShrOfcWrkMgr.do?cmd=saveShrOfcWrkMgrList", $("#srchFrm").serialize());
                    break;

                case "Insert": //입력

                    var Row = sheet1.DataInsert(0);
                    break;
                    
    			case "Copy":
    				var row = sheet1.DataCopy();
    				sheet1.SetCellValue(row,"approvalSeq","");
    				break;

                case "Down2Excel": //엑셀내려받기

                    sheet1.Down2Excel({ DownCols : makeHiddenSkipCol(sheet1), SheetDesign : 1, Merge : 1 });
                    break;

                case "LoadExcel": //엑셀업로드

                    var params = { Mode : "HeaderMatch", WorkSheetNo : 1 };
                    sheet1.LoadExcel(params);
                    break;

            }
        }

        function sheet1_OnSearchEnd(Code, ErrMsg, StCode, StMsg) {
            try {
                if (ErrMsg != "") {
                    alert(ErrMsg);
                }
                //setSheetSize(this);
            } catch (ex) {
                alert("OnSearchEnd Event Error : " + ex);
            }
        }

        function sheet1_OnSaveEnd(Code, ErrMsg, StCode, StMsg) {
            try {
                if (ErrMsg != "") {
                    alert(ErrMsg);
                }

                if (Code > 0) {
                    doAction1("Search");
                }

            } catch (ex) {
                alert("OnSaveEnd Event Error : " + ex);
            }
        }


        function sheet1_OnClick(Row, Col, Value) {
        	try {
                if (Row > 0 && sheet1.ColSaveName(Col) == "name" && sheet1.GetCellValue(Row,"sStatus") == "I") {
               	    //if (!isPopup()) {
                    //    return;
                    //}
                    //
                    //var w = 840;
                    //var h = 520;
                    //var url = "${ctx}/Popup.do?cmd=employeePopup&authPg=${authPg}";
                    //var args = new Array();

                    //gPRow = Row;
                    //pGubun = "employeePopup";

                    //openPopup(url, args, w, h);
                }else if(Row > 0 && sheet1.ColSaveName(Col) == "workAssignNm" && sheet1.GetCellValue(Row,"sStatus") == "I"){
                	if (!isPopup()) {
                        return;
                    }

                    gPRow = Row;
                    pGubun = "workAssignMgrPopup";

                    // openPopup(url, args, w, h);

                    let w = 840;
                    let h = 520;
                    let url = "/WorkSklKnlgMgr.do?cmd=viewWorkAssignLayer&authPg=${authPg}";

                    const workAssignLayer = new window.top.document.LayerModal({
                        id : 'workAssignLayer'
                        , url : url
                        , parameters : {}
                        , width : w
                        , height : h
                        , title : '단위업무체계조회'
                        , trigger :[
                            {
                                name : 'workAssignLayerTrigger'
                                , callback : function(result){
                                    getReturnValue(result);
                                }
                            }
                        ]
                    });
                    workAssignLayer.show();
                }
            } catch (ex) {
                alert("OnClick Event Error : " + ex);
            }
        }

        function sheet1_OnPopupClick(Row, Col) {
            try {
                if (sheet1.ColSaveName(Col) == "zip") {
                    if (!isPopup()) {
                        return;
                    }

                    gPRow = Row;
                    pGubun = "ZipCodePopup";
                    openPopup("/ZipCodePopup.do?cmd=viewZipCodePopup&authPg=${authPg}", "", "740", "620");

                }
            } catch (ex) {
                alert("OnPopupClick Event Error : " + ex);
            }
        }

        function sheet1_OnValidation(Row, Col, Value) {
            try {
            } catch (ex) {
                alert("OnValidation Event Error : " + ex);
            }
        }
        
        //팝업 콜백 함수.
	   	function getReturnValue(returnValue) {
	           if(pGubun == "employeePopup"){
	        	   sheet1.SetCellValue(gPRow,"name",(returnValue.name));
	       		   sheet1.SetCellValue(gPRow,"sabun",(returnValue.sabun));
	           }else if(pGubun == "workAssignMgrPopup"){
		       		sheet1.SetCellValue(gPRow,"workAssignCdLarge",(returnValue.gWorkAssignCd));
		       		sheet1.SetCellValue(gPRow,"workAssignNmLarge",(returnValue.gWorkAssignNm));
		       		sheet1.SetCellValue(gPRow,"workAssignCdMiddle",(returnValue.mWorkAssignCd));
		       		sheet1.SetCellValue(gPRow,"workAssignNmMiddle",(returnValue.mWorkAssignNm));
		       		sheet1.SetCellValue(gPRow,"workAssignCd",(returnValue.workAssignCd));
		       		sheet1.SetCellValue(gPRow,"workAssignNm",(returnValue.workAssignNm));
	           }else if(pGubun == "searchEmployeePopup"){
                   var rv = $.parseJSON('{' + returnValue+ '}');
	        	   $("#searchName").val(rv["name"]);
	               $("#searchSabun").val(rv["sabun"]);
	           }
	   	}
	  
        //사원 팝업
	    function employeePopup(){
	        try{
	            if(!isPopup()) {return;}

	            gPRow = "";
	            pGubun = "searchEmployeePopup";

	            <%--openPopup("${ctx}/Popup.do?cmd=employeePopup", args, "840","520");--%>
                let w = 840;
                let h = 520;
                let url = "/Popup.do?cmd=viewEmployeeLayer";
                let p = {
                    topKeyword : $("#searchName").val()
                };

                let layerModal = new window.top.document.LayerModal({
                    id : 'employeeLayer'
                    , url : url
                    , parameters : p
                    , width : w
                    , height : h
                    , title : '사원조회'
                    , trigger :[
                        {
                            name : 'employeeTrigger'
                            , callback : function(result){
                                getReturnValue(result);
                            }
                        }
                    ]
                });
                layerModal.show();

	        }catch(ex){alert("Open Popup Event Error : " + ex);}
	    }
        
	    function makeDic(){
	    	var msg = "기존 데이터가 초기화 됩니다.\n전체 대상자 사무분담을 생성합니다\n계속하시겠습니까?";
			if(  $("#searchSabun").val() != "" ){
				msg = "기존 데이터가 초기화 됩니다.\n대상자 ["+$("#searchName").val()+"]님의 사무분담을 생성합니다.\n계속하시겠습니까?";
			}
			if(confirm(msg)){
		        var data = ajaxCall("${ctx}/ShrOfcWrkMgr.do?cmd=prcShrOfcWrkMgr",$("#srchFrm").serialize(),false);
				if(data.Result.Code == null) {
		    		doAction1("Search");
		    		alert("<msg:txt mid='110120' mdef='처리되었습니다.'/>");
		    	} else {
			    	alert(data.Result.Message);
		    	}
			}
		}

    </script>
</head>
<body class="hidden">
<div class="wrapper">
    <form id="srchFrm" name="srchFrm" >
        <input id="searchSabun" name ="searchSabun" type="hidden" value="" />
        <div class="sheet_search outer">
            <div>
                <table>
                    <tr>
                    	<th>사무분담명</th>
                        <td>  <input id="searchWorkAssignNm" name ="searchWorkAssignNm" type="text" class="text w100" /> </td>
                        <td><btn:a href="javascript:doAction1('Search')" id="btnSearch" css="button" mid='110697' mdef="조회"/> </td>
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
                            <li id="txt" class="txt"><tit:txt mid='BLANK' mdef='현사무분담'/></li>
                            <li class="btn">
                            	<span>대상자</span>
	                            <input id="searchName" name="searchName" type="text" class="text" style="margin-right:2px;"/>
	                            <a onclick="javascript:employeePopup();return false;" class="button6" id="btnAppSabunPop">
	                            	<img src="/common/${theme}/images/btn_search2.gif" style="height: 25px;"/>
	                            </a>
	                            <a href="javascript:makeDic()" class="btn soft authA"><tit:txt mid='112181' mdef='사무분담생성'/></a>
                                <btn:a href="javascript:doAction1('Insert')" css="btn outline_gray authA" mid='110700' mdef="입력"/>
                                <btn:a href="javascript:doAction1('Copy')" 	css="btn outline_gray authA" mid='110696' mdef="복사"/>
                                <btn:a href="javascript:doAction1('Save')" 	css="btn filled authA" mid='110708' mdef="저장"/>
                                <btn:a href="javascript:doAction1('Down2Excel')" css="btn outline_gray authR" mid='110698' mdef="다운로드"/>
                            </li>
                        </ul>
                    </div>
                </div>
                <script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
            </td>
        </tr>
    </table>
</div>
</body>
</html>
