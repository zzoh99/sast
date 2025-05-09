// Sheet 중복체크[jquery 형태로 변경해야함]
/*
function comCheckPrimaryKey(obj, keyvalue, delchk, firchk) {
	var duprows1 = obj.ColValueDupRows(keyvalue, delchk, firchk) + " ";
	if (duprows1 != "") {
		var t = [];
		var a = duprows1.split("|");
		if (a[1] != "") {
			t = a[1].split(",");
			for (j = 0; j < t.length; j++) {
				obj.SetRowBackColor(t[j], "#FF7F50");
			}
		} else {
			var j = 0;
		}
		if (j > 0) {
			alert("중복된 값이 존재 합니다.");
			return false;
		}
	} else {
		return true;
	}
}
*/
/*=======================================================================*
 * 시트 가로 사이즈 구하기
 * 2011.07.21 KSJ
 *======================================================================*/
function getWidth(obj) {
	var _w = 0;
	for( var i = 0 ; i <= obj.LastCol() ; i++ ) {
		if( !obj.GetColHidden(i) ) _w += obj.GetColWidth(i);
	}
	return _w;
}


/*=======================================================================*
 * 시트의 고정 사이즈 카운트 구하기
 * 2011.07.21 KSJ
 *======================================================================*/
function getCount(obj) {
	var _cnt = 0;
	var _w = 0;
	var _option = true;
	for( var i = 0 ; i <= obj.LastCol() ; i++ ) {
		if( obj.GetColHidden(i) == 0 ) {
		  //alert("===width : "+obj.GetColWidth(i)+", i : "+i);
			_w += obj.GetColWidth(i);
			if( _option && obj.GetColWidth(i) == 45) _cnt++;
			else _option = false;
		}
	}
	return [_cnt, _w];
}
/*=======================================================================*
 * 시트가 화면에 100% 맞도록 리사이징
 * 2011.07.21 KSJ
 * 2020.05.26 고정컬럼 수정 
 *======================================================================*/
//function fitWidth(obj, count) {
function fitWidth(obj) {
	try{
		var scrollWidth = 0;
		var content_height = 0;
		$("#DIV_"+obj.id).find(".GMBodyMid table").each(function() {
			content_height += $(this).height();
		});
		
		if( $("#DIV_"+obj.id).find(".GMBodyMid").height() + 1 < content_height ) scrollWidth = 18;
		
		//var cnt = count;
		var objID = document.getElementById("DIV_"+obj.id);
		//alert( "w : " + $("#DIV_"+obj.id).parent().width() );
		var space = 0;
		//if( $(".popup_main").length > 0 ) space = 40;
		var width1 = ($("#DIV_"+obj.id).parent().width() - scrollWidth) - space;  // sheet 사이즈
		//var width1 = (document.body.clientWidth - scrollWidth) / $("#DIV_"+obj.id).attr("sheetcount") - space;  // sheet 사이즈
		//var width1 = ($("#DIV_"+obj.id).parent().width() - scrollWidth) / $("#DIV_"+obj.id).attr("sheetcount");  // sheet 사이즈
		
		var width2 = width1 - sheetFixWidth[obj.id];     // sheet 사이즈 에서 고정 td를 뺀 길이,  sheetFixWidth = FIX컬럼 총 넓이 2020.05.26
		var width3 = getWidth( obj );       // 실제 sheet 내부 테이블 길이
		width3 -= sheetFixWidth[obj.id];
		
		//var str = "";  //사용안함.
		var value = 0;
		var gap = 0;
		
		var _final = 0; //마지막 컬럼
		for( var i = 0 ; i <= obj.LastCol() ; i++ ) {	
			if( !obj.GetColHidden(i) ) {
				_final = i;
			}
		}
		
		// 화면 사이즈에 맞게 늘린다.
		var _columnWidth = 0;
		for( var i = 0 ; i <= obj.LastCol() ; i++ ) {
			if( !obj.GetColHidden(i) ) {
				_columnWidth = sheetColumnWidth[obj.id][i];
				if( i == _final ) {
					gap = width1 - value - 1;
					obj.SetColWidth(i,gap);	
				}
				else if( _columnWidth == 45  ||  _columnWidth == 55) {  // 2020.05.26
					//str += _columnWidth + "\n";
					value += _columnWidth;
					obj.SetColWidth(i, _columnWidth);
				}
				else {
					//str += Math.floor( (obj.GetColWidth(i) * width2) / width3 ) + "\n";
					value += Math.floor( (obj.GetColWidth(i) * width2) / width3 );
					obj.SetColWidth(i,Math.floor( (obj.GetColWidth(i) * width2) / width3 ));					
				}
			}
		}
	}catch (e) {
		//alert(e);
	}
}

/*=======================================================================*
 * 시트 원래 사이즈로 복귀
 * 2013.03.28 KSJ
 *======================================================================*/
function sheetSizeRestore(obj) {
	for( var i = 0 ; i <= obj.LastCol() ; i++ ) {
		if( !obj.GetColHidden(i) ) {
			obj.SetColWidth(i,sheetColumnWidth[obj.id][i]);
		}
	}
}

/*=======================================================================*
 * 시트 통합 리사이즈 함수
 * 2011.07.21 KSJ
 *======================================================================*/
var sheetWidth = {};
var sheetColumnWidth = {};
var sheetCount = {};
var sheetFixWidth = {}; //2020.05.26 고정컬럼넓이
//function setSheetSize( obj, count, init) { 
function setSheetSize( obj ) { // count, init 사용안함  2020.05.26
	try{
		if( obj.GetVisible() == 0 ) return;
		var objID = document.getElementById("DIV_"+obj.id);
		if( objID.clientWidth == 0 ) return;

		if( sheetWidth[obj.id] == undefined || sheetWidth[obj.id] == 0 ) {
			//var ary = getCount( obj );   //2020.05.26  getCount 사용안함.
			//sheetFixColumn[obj.id] = ary[0];
			//sheetWidth[obj.id]     = ary[1];
			
			
			sheetColumnWidth[obj.id] = [];
			var _w = 0,  _fw = 0;
			for( var i = 0 ; i <= obj.LastCol() ; i++ ) {
				sheetColumnWidth[obj.id][i] = obj.GetColWidth(i);
				if( obj.GetColHidden(i) == 0 ) {
					_w += obj.GetColWidth(i);
					if( obj.GetColWidth(i) == 45 || obj.GetColWidth(i) == 55 ){
						_fw += obj.GetColWidth(i);
					}
				}
			}
			sheetWidth[obj.id]    = _w;
			sheetFixWidth[obj.id] = _fw;
		}
		
		// $(".sheet_left .GMMainTable").css("marginRight","10px");
		
		//alert("A : " + $(".ibsheet").width() + " : " + $(".GMMainTable").width() );
		//objID.clientWidth < sheetWidth[obj.id] ? obj.FitSize(false, false) : fitWidth(obj, sheetCount[obj.id]);
		objID.clientWidth < sheetWidth[obj.id] ? sheetSizeRestore(obj) : fitWidth(obj);
	}catch (e) {
		alert(e);
	}
}

function clearSheetSize( obj ) {
	sheetCount[obj.id] = null;
	sheetWidth[obj.id] = null;
	sheetFixWidth[obj.id] = null; //2020.05.26 고정컬럼넓이
}


/************************************************************************************

 getColMaxValue(mySheet, Col)			: 컬럼중 값이 가장 큰 값을 구함

*************************************************************************************/

function getColMaxValue(mySheet, Col) {
	var maxValue = 0;

	for( i=mySheet.HeaderRows() ; i <= mySheet.LastRow(); i++) {
		if( mySheet.GetCellValue(i, Col) != "" && maxValue < parseInt(mySheet.GetCellValue(i, Col)) ) {
			maxValue = parseInt(mySheet.GetCellValue(i, Col));
		}
	}

	maxValue = maxValue + 1;
	return maxValue;
}


//SkipCol 
function makeSkipCol(sobj,cols){
	var lc = sobj.LastCol();
	var colsArr = cols.split("|");

	var rtnStr = "";
	for(var i=0;i<=lc;i++){

		if($.inArray( i +"",colsArr)== -1){
			rtnStr += "|"+ i;
		}
	}
	return rtnStr.substring(1);
}

//HiddenSkipCol 
function makeHiddenSkipCol(sobj, arrSkipType){
	var lc = sobj.LastCol();
	var colsArr = new Array();
	for(var i=0;i<=lc;i++){
		if(1==sobj.GetColHidden(i) || sobj.GetCellProperty(0, i, "Type")== "Status" || sobj.GetCellProperty(0, i, "Type")== "DelCheck"){
			colsArr.push(i);
		}
		// arrSkipType : 추가적으로 제외할 컬럼들의 배열
		if (arrSkipType != null && arrSkipType != undefined && arrSkipType != "" && Array.isArray(arrSkipType) && arrSkipType.length > 0) {
			for (var j = 0; j < arrSkipType.length; j++) {
				if (sobj.GetCellProperty(0, i, "Type") == arrSkipType[j]) {
					colsArr.push(i);
				}
			}
		}
	}

	var rtnStr = "";
	for(var i=0;i<=lc;i++){
		//alert(i +"==>>>>"+ colsArr +"==>>"+$.inArray(i, colsArr));
		if($.inArray(i,colsArr)== -1){
			rtnStr += "|"+ i;
		}
	}
	return rtnStr.substring(1);
}

/**
 * makeHiddenSkipCol 함수를 이용하여 Hidden컬럼 및 Type이 Image인 컬럼을 제외한 컬럼을 취득
 * 
 * @param sobj : 컬럼을 취득할 sheet 객체
 * @returns : Hidden컬럼 및 Type이 Image인 컬럼을 제외한 컬럼
 */
function makeHiddenImgSkipCol(sobj) {
	return makeHiddenSkipCol(sobj, ["Image"]);
}

/************************************************************************************
 checkDateCtl2(message, message2, sCtl, eCtl)
	:  TextField에 시작일자와 종료일자 크기를 체크
	message : 시작일자와 종료일자 앞에 붙일 메시지
	sCtl    : 시작일 칼럼명
	eCtl    : 종료일 칼럼명
*************************************************************************************/
function checkDateCtl2( message, message2, sCtl, eCtl){
	if( sCtl.value != "" && eCtl.value != "" ) {
		if( sCtl.value  > eCtl.value ) {
			alert(message+"일자가 "+message2+"일자보다 큽니다.");
			eCtl.value = "";
			eCtl.focus();
			return false;
		}
	}
	return true;
}

/************************************************************************************

checkNMDate(mySheet, row, col, message, sColNm, eColNm)
		    :  컬럼에 시작일자와 종료일자 크기를 체크
	mySheet : 시트 Object
	row     : 선택된 행
	col     : 선택된 칼럼
	message : 시작일자와 종료일자 앞에 붙일 메시지
	sColNm  : 시작일 칼럼명
	eColNm  : 종료일 칼럼명
*************************************************************************************/
function checkNMDate(mySheet, row, col, message, sColNm, eColNm){

	if( (mySheet.ColSaveName(col) == sColNm  || mySheet.ColSaveName(col) == eColNm ) && mySheet.GetCellValue(row, eColNm ) != "" ) {
		if( mySheet.GetCellValue(row, sColNm)  > mySheet.GetCellValue(row, eColNm) ) {			
			alert(message+"시작일자가 "+message+"종료일자보다 큽니다.");
			mySheet.SetCellValue(row, eColNm, "");
			mySheet.SelectCell(row, eColNm);			
			return;
		}
	}
}

/************************************************************************************
checkNMDate2(mySheet, row, col, message, sColNm, eColNm)
		    :  컬럼에 시작일자와 종료일자 크기를 체크
	mySheet : 시트 Object
	row     : 선택된 행
	col     : 선택된 칼럼
	message : 시작일자와 종료일자 앞에 붙일 메시지
	sColNm  : 시작일 칼럼명
	eColNm  : 종료일 칼럼명
*************************************************************************************/
function checkNMDate2(mySheet, row, col, message1, message2, sColNm, eColNm){
	if( (mySheet.ColSaveName(col) == sColNm  || mySheet.ColSaveName(col) == eColNm ) && mySheet.GetCellValue(row, eColNm ) != "" ) {
		if( mySheet.GetCellValue(row, sColNm)  > mySheet.GetCellValue(row, eColNm) ) {
			alert(message1+"일자가 "+message2+"일자보다 큽니다.");
			mySheet.SetCellValue(row, eColNm, "");
			mySheet.SelectCell(row, eColNm);
			return;
		}
	}
}
