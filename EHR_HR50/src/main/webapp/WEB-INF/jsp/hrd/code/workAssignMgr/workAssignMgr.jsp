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
                {Header:"<sht:txt mid='BLANK'       mdef='코드'     />",     Type:"Text"     , Hidden:0, Width:50 ,  Align:"Center", ColMerge:0, SaveName:"workAssignCd"    ,    KeyField:1, CalcLogic:"", Format:"Integer",  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:20 },
                {Header:"<sht:txt mid='BLANK'       mdef='상위코드'     />",     Type:"Text"     , Hidden:1, Width:50 ,  Align:"Center", ColMerge:0, SaveName:"priorWorkAssignCd"    ,    KeyField:0, CalcLogic:"", Format:"Integer",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:20 },
                {Header:"<sht:txt mid='BLANK'       mdef='코드명'     />",     Type:"Text"    , Hidden:0, Width:50 ,  Align:"Left"  , ColMerge:0, SaveName:"workAssignNm" ,    KeyField:1, CalcLogic:"", Format:""       ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:100 },
                {Header:"<sht:txt mid='BLANK'       mdef='직무코드'     />",     Type:"Text"    , Hidden:1, Width:50 ,  Align:"Left"  , ColMerge:0, SaveName:"jobCd" ,    KeyField:1, CalcLogic:"", Format:""       ,  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:100 },
                {Header:"<sht:txt mid='BLANK'       mdef='사용여부'     />",     Type:"DummyCheck"    , Hidden:1, Width:50 ,  Align:"Left"  , ColMerge:0, SaveName:"useYn" ,    KeyField:0, CalcLogic:"", Format:""       ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:1, TrueValue:"Y", FalseValue:"N", DefaultValue:"Y"},
                {Header:"<sht:txt mid='BLANK'       mdef='코드타입'     />",     Type:"Text"    , Hidden:1, Width:50 ,  Align:"Left"  , ColMerge:0, SaveName:"workAssignType" ,    KeyField:1, CalcLogic:"", Format:""       ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:1 }
//                 {Header:"<sht:txt mid='BLANK'       mdef='사용여부'     />",     Type:"DummyCheck"    , Hidden:0, Width:50 ,  Align:"Left"  , ColMerge:0, SaveName:"useYn" ,    KeyField:1, CalcLogic:"", Format:""       ,  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:1 },
            ]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
            
            var initdata2 = {};
            initdata2.Cfg = {FrozenCol:22,SearchMode:smLazyLoad,Page:22,MergeSheet:msAll};
            initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
            initdata2.Cols = [
            	{Header:"<sht:txt mid='sNo'         mdef='No'           />",     Type:"${sNoTy}" , Hidden:Number("${sNoHdn}") , Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
                {Header:"<sht:txt mid='sDelete V5'  mdef='삭제'         />",     Type:"${sDelTy}", Hidden:Number("${sDelHdn}"),  Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete", Sort:0 },
                {Header:"<sht:txt mid='sStatus'     mdef='상태'         />",     Type:"${sSttTy}", Hidden:Number("${sSttHdn}"),  Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0 },
                {Header:"<sht:txt mid='BLANK'       mdef='코드'     />",     Type:"Text"     , Hidden:0, Width:50 ,  Align:"Center", ColMerge:0, SaveName:"workAssignCd"    ,    KeyField:1, CalcLogic:"", Format:"Integer",  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:20 },
                {Header:"<sht:txt mid='BLANK'       mdef='상위코드'     />",     Type:"Text"     , Hidden:1, Width:50 ,  Align:"Center", ColMerge:0, SaveName:"priorWorkAssignCd"    ,    KeyField:0, CalcLogic:"", Format:"Integer",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:20 },
                {Header:"<sht:txt mid='BLANK'       mdef='코드명'     />",     Type:"Text"    , Hidden:0, Width:50 ,  Align:"Left"  , ColMerge:0, SaveName:"workAssignNm" ,    KeyField:1, CalcLogic:"", Format:""       ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:100 },
                {Header:"<sht:txt mid='BLANK'       mdef='사용여부'     />",     Type:"DummyCheck"    , Hidden:1, Width:50 ,  Align:"Left"  , ColMerge:0, SaveName:"useYn" ,    KeyField:0, CalcLogic:"", Format:""       ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:1 ,TrueValue:"Y", FalseValue:"N", DefaultValue:"Y"},
                {Header:"<sht:txt mid='BLANK'       mdef='직무코드'     />",     Type:"Text"    , Hidden:1, Width:50 ,  Align:"Left"  , ColMerge:0, SaveName:"jobCd" ,    KeyField:1, CalcLogic:"", Format:""       ,  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:100 },
                {Header:"<sht:txt mid='BLANK'       mdef='코드타입'     />",     Type:"Text"    , Hidden:1, Width:50 ,  Align:"Left"  , ColMerge:0, SaveName:"workAssignType" ,    KeyField:1, CalcLogic:"", Format:""       ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:1 },
//                 {Header:"<sht:txt mid='BLANK'       mdef='사용여부'     />",     Type:"DummyCheck"    , Hidden:0, Width:50 ,  Align:"Left"  , ColMerge:0, SaveName:"useYn" ,    KeyField:1, CalcLogic:"", Format:""       ,  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:1 },
            ]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);
            
            var initdata3 = {};
            initdata3.Cfg = {FrozenCol:22,SearchMode:smLazyLoad,Page:22,MergeSheet:msAll};
            initdata3.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
            initdata3.Cols = [
            	{Header:"<sht:txt mid='sNo'         mdef='No'           />",     Type:"${sNoTy}" , Hidden:Number("${sNoHdn}") , Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
                {Header:"<sht:txt mid='sDelete V5'  mdef='삭제'         />",     Type:"${sDelTy}", Hidden:Number("${sDelHdn}"),  Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete", Sort:0 },
                {Header:"<sht:txt mid='sStatus'     mdef='상태'         />",     Type:"${sSttTy}", Hidden:Number("${sSttHdn}"),  Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0 },
                {Header:"<sht:txt mid='BLANK'       mdef='코드'     />",     Type:"Text"     , Hidden:0, Width:50 ,  Align:"Center", ColMerge:0, SaveName:"workAssignCd"    ,    KeyField:1, CalcLogic:"", Format:"Integer",  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:20 },
                {Header:"<sht:txt mid='BLANK'       mdef='상위코드'     />",     Type:"Text"     , Hidden:1, Width:50 ,  Align:"Center", ColMerge:0, SaveName:"priorWorkAssignCd"    ,    KeyField:0, CalcLogic:"", Format:"Integer",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:20 },
                {Header:"<sht:txt mid='BLANK'       mdef='코드명'     />",     Type:"Text"    , Hidden:0, Width:60 ,  Align:"Left"  , ColMerge:0, SaveName:"workAssignNm" ,    KeyField:1, CalcLogic:"", Format:""       ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:100 },
                {Header:"<sht:txt mid='BLANK'       mdef='직무코드'     />",     Type:"Text"    , Hidden:1, Width:50 ,  Align:"Left"  , ColMerge:0, SaveName:"jobCd" ,    KeyField:1, CalcLogic:"", Format:""       ,  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:100 },
                {Header:"<sht:txt mid='workAssignType'       mdef='코드타입'     />",     Type:"Text"    , Hidden:1, Width:50 ,  Align:"Left"  , ColMerge:0, SaveName:"workAssignType" ,    KeyField:1, CalcLogic:"", Format:""       ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:1 },
                {Header:"<sht:txt mid='useYn'       mdef='사용여부'     />",     Type:"CheckBox"    , Hidden:0, Width:30 ,  Align:"Left"  , ColMerge:0, SaveName:"useYn" ,    KeyField:0,		UpdateEdit:1,	InsertEdit:1,	TrueValue:"Y", FalseValue:"N"},
                {Header:"<sht:txt mid='jobPopDetail'      mdef='직무'    />",	Type:"Popup"     , Hidden:0, Width:40 ,  Align:"Center", ColMerge:0, SaveName:"jobNm", KeyField:0, CalcLogic:"", Format:""   ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:100 }
            ]; IBS_InitSheet(sheet3, initdata3);sheet3.SetEditable("${editable}");sheet3.SetVisible(true);sheet3.SetCountPosition(4);sheet3.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
			
            sheet3.SetDataLinkMouse("detail"  , 1);

//             $("#searchActiveYyyy").bind("keyup",function(event){
//                 if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
//             });

            $(window).smartresize(sheetResize); sheetInit();

//             fnSetCode()

            doAction1("Search");
        });

//         function fnSetCode() {

//             var halfGubunTypeCd     = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","D00005"), "");
//             sheet1.SetColProperty("halfGubunType", 	{ComboText:halfGubunTypeCd[0], ComboCode:halfGubunTypeCd[1]} );

//         }


        /**
         * Sheet 각종 처리
         */
        function doAction1(sAction) {
            switch (sAction) {
                case "Search": //조회
                	$("#searchWorkAssignType").val("G"); //단위업무분류 - G:대, M:중, S:소
                	$("#searchPriorWorkAssignCd").val("");
                    sheet1.DoSearch("${ctx}/WorkAssignMgr.do?cmd=getWorkAssignMgrList", $("#srchFrm").serialize());
                    break;
                case "Save": //저장
                    if(!dupChk(sheet1,"workAssignCd", true, true)){break;}
                    IBS_SaveName(document.srchFrm, sheet1);
                    sheet1.DoSave("${ctx}/WorkAssignMgr.do?cmd=saveWorkAssignMgrList", $("#srchFrm").serialize());
                    break;

                case "Insert": //입력

                    var Row = sheet1.DataInsert(0);
                	sheet1.SetCellValue(Row,"workAssignType","G");
                    break;
                    
    			case "Copy":
    				var row = sheet1.DataCopy();
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
                doAction2("Search");
                sheetResize();
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
        
        // 셀 변경시 발생
    	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
    		try {
    			sheet1.SetAllowCheck(false);
    			if(sheet1.GetSelectRow() > 0) {
    				if(OldRow != NewRow && sheet1.GetCellValue(NewRow,"sStatus") != "I") {
    					doAction2("Search");
    					
    				}
    			}
    		} catch (ex) {
    			alert("OnSelectCell Event Error " + ex);
    		}
    	}
        
    	function sheet1_OnChange(Row, Col, Value) {
    		 try{
    			 if(sheet1.ColSaveName(Col) == "sDelete" && Value == "1") {
     		        if(sheet2.RowCount() > 0) {
     		            alert("<msg:txt mid='alertAppDelChk' mdef='해당 대분류에 등록된 중분류 코드가 있어 삭제할 수 없습니다.'/>");
     		            sheet1.SetCellValue(Row,"sDelete",0);
     		            return;
     		        }else{
     		        }
     		    }
    		}catch(ex){alert("OnChange Event Error : " + ex);}
    	}
        
    	// 체크 되기 직전 발생.
//     	function sheet1_OnBeforeCheck(Row, Col) {
//     		try{
//     		    if(sheet1.ColSaveName(Col) == "sDelete") {
//     		        if(sheet2.RowCount() > 0) {
//     		            alert("<msg:txt mid='alertAppDelChk' mdef='해당 대분류에 등록된 중분류 코드가 있어 삭제할 수 없습니다.'/>");
//     		            sheet1.SetAllowCheck(false);
//     		            return;
//     		        }else{
//     		        	sheet1.SetAllowCheck(true);
//     		        }
//     		    }
//     		}catch(ex){
//     			alert("OnBeforeCheck Event Error : " + ex);
//     		}
//     	}
    	
     /**
      * sheet2 각종 처리
      */
     function doAction2(sAction) {
         switch (sAction) {
             case "Search": //조회
				 $("#searchWorkAssignType").val("M"); //단위업무분류 - G:대, M:중, S:소
				 $("#searchPriorWorkAssignCd").val(sheet1.GetCellValue(sheet1.GetSelectRow(),"workAssignCd"));
                 sheet2.DoSearch("${ctx}/WorkAssignMgr.do?cmd=getWorkAssignMgrList", $("#srchFrm").serialize());
                 break;
             case "Save": //저장
                 if(!dupChk(sheet2,"workAssignCd", true, true)){break;}
                 IBS_SaveName(document.srchFrm, sheet2);
                 sheet2.DoSave("${ctx}/WorkAssignMgr.do?cmd=saveWorkAssignMgrList", $("#srchFrm").serialize());
                 break;

             case "Insert": //입력

                 var Row = sheet2.DataInsert(0);
                 sheet2.SetCellValue(Row,"workAssignType","M");
                 sheet2.SetCellValue(Row,"priorWorkAssignCd",sheet1.GetCellValue(sheet1.GetSelectRow(),"workAssignCd"));
                 break;
                 
 			case "Copy":
 				var row = sheet2.DataCopy();
 				break;

             case "Down2Excel": //엑셀내려받기

                 sheet2.Down2Excel({ DownCols : makeHiddenSkipCol(sheet2), SheetDesign : 1, Merge : 1 });
                 break;

             case "LoadExcel": //엑셀업로드

                 var params = { Mode : "HeaderMatch", WorkSheetNo : 1 };
                 sheet2.LoadExcel(params);
                 break;

         }
     }

     function sheet2_OnSearchEnd(Code, ErrMsg, StCode, StMsg) {
         try {
             if (ErrMsg != "") {
                 alert(ErrMsg);
             }
             doAction3("Search");
             sheetResize();
             //setSheetSize(this);
         } catch (ex) {
             alert("OnSearchEnd Event Error : " + ex);
         }
     }

     function sheet2_OnSaveEnd(Code, ErrMsg, StCode, StMsg) {
         try {
             if (ErrMsg != "") {
                 alert(ErrMsg);
             }

             if (Code > 0) {
                 doAction2("Search");
             }

         } catch (ex) {
             alert("OnSaveEnd Event Error : " + ex);
         }
     }
     
    // 셀 변경시 발생
 	function sheet2_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
 		try {
 			sheet2.SetAllowCheck(false);
 			if(sheet2.GetSelectRow() > 0) {
 				if(OldRow != NewRow && sheet2.GetCellValue(NewRow,"sStatus") != "I") {
 					doAction3("Search");
 				}
 			}
 		} catch (ex) {
 			alert("OnSelectCell Event Error " + ex);
 		}
 	}
    
 	function sheet2_OnChange(Row, Col, Value) {
		 try{
			 if(sheet2.ColSaveName(Col) == "sDelete" && Value == "1") {
		        if(sheet3.RowCount() > 0) {
		            alert("<msg:txt mid='alertAppDelChk' mdef='해당 중분류에 등록된 소분류 코드가 있어 삭제할 수 없습니다.'/>");
		            sheet2.SetCellValue(Row,"sDelete",0);
		            return;
		        }else{
		        }
		    }
		}catch(ex){alert("OnChange Event Error : " + ex);}
	}
    
 	// 체크 되기 직전 발생.
// 	function sheet2_OnBeforeCheck(Row, Col) {
// 		try{
// 			sheet2.SetAllowCheck(true);
// 		    if(sheet2.ColSaveName(Col) == "sDelete") {
// 		        if(sheet3.RowCount() > 0) {
// 		            alert("<msg:txt mid='alertAppDelChk' mdef='해당 중분류에 등록된 소분류 코드가 있어 삭제할 수 없습니다.'/>");
// 		            sheet2.SetAllowCheck(false);
// 		            return;
// 		        }
// 		    }
// 		}catch(ex){
// 			alert("OnBeforeCheck Event Error : " + ex);
// 		}
// 	}
 
     /**
      * sheet3 각종 처리
      */
     function doAction3(sAction) {
         switch (sAction) {
             case "Search": //조회
            	 $("#searchWorkAssignType").val("S"); //단위업무분류 - G:대, M:중, S:소
            	 $("#searchPriorWorkAssignCd").val(sheet2.GetCellValue(sheet2.GetSelectRow(),"workAssignCd"));
                 sheet3.DoSearch("${ctx}/WorkAssignMgr.do?cmd=getWorkAssignMgrList", $("#srchFrm").serialize());
                 break;
             case "Save": //저장
                 if(!dupChk(sheet3,"workAssignCd", true, true)){break;}
                 IBS_SaveName(document.srchFrm, sheet3);
                 sheet3.DoSave("${ctx}/WorkAssignMgr.do?cmd=saveWorkAssignMgrList", $("#srchFrm").serialize());
                 break;

             case "Insert": //입력

                 var Row = sheet3.DataInsert(0);
                 sheet3.SetCellValue(Row,"priorWorkAssignCd",sheet2.GetCellValue(sheet2.GetSelectRow(),"workAssignCd"));
                 sheet3.SetCellValue(Row,"workAssignType","S");
                 break;
                 
 			case "Copy":
 				var row = sheet3.DataCopy();
 				break;

             case "Down2Excel": //엑셀내려받기

                 sheet3.Down2Excel({ DownCols : makeHiddenSkipCol(sheet3), SheetDesign : 1, Merge : 1 });
                 break;

             case "LoadExcel": //엑셀업로드

                 var params = { Mode : "HeaderMatch", WorkSheetNo : 1 };
                 sheet3.LoadExcel(params);
                 break;

         }
     }

     function sheet3_OnSearchEnd(Code, ErrMsg, StCode, StMsg) {
         try {
             if (ErrMsg != "") {
                 alert(ErrMsg);
             }
             sheetResize();
             //setSheetSize(this);
         } catch (ex) {
             alert("OnSearchEnd Event Error : " + ex);
         }
     }

     function sheet3_OnSaveEnd(Code, ErrMsg, StCode, StMsg) {
         try {
             if (ErrMsg != "") {
                 alert(ErrMsg);
             }

             if (Code > 0) {
                 doAction3("Search");
             }

         } catch (ex) {
             alert("OnSaveEnd Event Error : " + ex);
         }
     }
     
     function sheet3_OnClick(Row, Col, Value) {
         try {
             if (Row > 0 && sheet3.ColSaveName(Col) == "jobNm") {
            	 if (!isPopup()) {
                     return;
                 }

                 var w = 600;
                 var h = 620;
                 var url = "${ctx}/WorkAssignMgr.do?cmd=viewWorkAssignMgrPopup&authPg=${authPg}";
                 var args = new Array();

                 gPRow = Row;
                 pGubun = "workAssignMgrPopup";

                 openPopup(url, args, w, h);
             }

         } catch (ex) {
             alert("OnClick Event Error : " + ex);
         }
     }
     
   //팝업 콜백 함수.
 	function getReturnValue(returnValue) {
 		var rv = $.parseJSON('{' + returnValue+ '}');

         if(pGubun == "workAssignMgrPopup"){
         	sheet3.SetCellValue(gPRow, "jobCd", rv["jobCd"]);
         	sheet3.SetCellValue(gPRow, "jobNm", rv["jobNm"]);
         } 
 	}
        

    </script>
</head>
<body class="hidden">
<div class="wrapper">
    <form id="srchFrm" name="srchFrm" >
    	<input type="hidden" id="searchWorkAssignType" name="searchWorkAssignType"/>
    	<input type="hidden" id="searchPriorWorkAssignCd" name="searchPriorWorkAssignCd"/>
<!--         <div class="sheet_search outer"> -->
<!--             <div> -->
<!--                 <table> -->
<!--                     <tr> -->
<!--                         <td> <span>활동년도</span> <input id="searchActiveYyyy" name ="searchActiveYyyy" type="text" class="text w100" /> </td> -->
<%--                         <td><btn:a href="javascript:doAction1('Search')" id="btnSearch" css="button" mid='110697' mdef="조회"/> </td> --%>
<!--                     </tr> -->
<!--                 </table> -->
<!--             </div> -->
<!--         </div> -->
    </form>
    <table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
        <tr>
            <td class="sheet_right">
                <div class="inner">
                    <div class="sheet_title">
                        <ul>
                            <li id="txt" class="txt"><tit:txt mid='BLANK' mdef='대분류'/></li>
                            <li class="btn">
                            	<btn:a href="javascript:doAction1('Search')" css="basic authA" mid='110700' mdef="조회"/>
                                <btn:a href="javascript:doAction1('Insert')" css="basic authA" mid='110700' mdef="입력"/>
								<btn:a href="javascript:doAction1('Copy')" 	css="basic authA" mid='110696' mdef="복사"/>
                                <btn:a href="javascript:doAction1('Save')" 	css="basic authA" mid='110708' mdef="저장"/>
                                <btn:a href="javascript:doAction1('Down2Excel')" 	css="basic authR" mid='110698' mdef="다운로드"/>
                            </li>
                        </ul>
                    </div>
                </div>
                <script type="text/javascript">createIBSheet("sheet1", "30%", "100%", "${ssnLocaleCd}"); </script>
            </td>
        	<td class="sheet_right">
                <div class="inner">
                    <div class="sheet_title">
                        <ul>
                            <li id="txt" class="txt"><tit:txt mid='BLANK' mdef='중분류'/></li>
                            <li class="btn">
                            	<btn:a href="javascript:doAction2('Search')" css="basic authA" mid='110700' mdef="조회"/>
                                <btn:a href="javascript:doAction2('Insert')" css="basic authA" mid='110700' mdef="입력"/>
								<btn:a href="javascript:doAction2('Copy')" 	css="basic authA" mid='110696' mdef="복사"/>
                                <btn:a href="javascript:doAction2('Save')" 	css="basic authA" mid='110708' mdef="저장"/>
                                <btn:a href="javascript:doAction2('Down2Excel')" 	css="basic authR" mid='110698' mdef="다운로드"/>
                            </li>
                        </ul>
                    </div>
                </div>
                <script type="text/javascript">createIBSheet("sheet2", "30%", "100%", "${ssnLocaleCd}"); </script>
            </td>
        	<td class="sheet_right">
                <div class="inner">
                    <div class="sheet_title">
                        <ul>
                            <li id="txt" class="txt"><tit:txt mid='BLANK' mdef='소분류'/></li>
                            <li class="btn">
                            	<btn:a href="javascript:doAction3('Search')" css="basic authA" mid='110700' mdef="조회"/>
                                <btn:a href="javascript:doAction3('Insert')" css="basic authA" mid='110700' mdef="입력"/>
								<btn:a href="javascript:doAction3('Copy')" 	css="basic authA" mid='110696' mdef="복사"/>
                                <btn:a href="javascript:doAction3('Save')" 	css="basic authA" mid='110708' mdef="저장"/>
                                <btn:a href="javascript:doAction3('Down2Excel')" 	css="basic authR" mid='110698' mdef="다운로드"/>
                            </li>
                        </ul>
                    </div>
                </div>
                <script type="text/javascript">createIBSheet("sheet3", "30%", "100%", "${ssnLocaleCd}"); </script>
            </td>
        </tr>
    </table>
</div>
</body>
</html>
