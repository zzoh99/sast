
function ShowCalendar(opt1, opt2) {
	var option = false;
	if( opt1["TimeFormat"] == "yyyy-MM" ) option = true;

	sheetPopCalendar(opt1["Grid"],0,0,option);
	setSheetCalendarPosition(opt1["Grid"], opt2);
	
	return false;
}

function getOption() {
	return sheetCalendarOption;
}

var sheetCalendarOption;
var _SheetObj;

function sheetPopCalendarSetCellValue(d){
	_SheetObj.SetCellValue(_SheetObj.GetSelectRow(), _SheetObj.GetSelectCol(),d);
}

function sheetPopCalendar(dateSheet,xplus,yplus,option) {
	_SheetObj = dateSheet;

	let selectedRow = _SheetObj.GetSelectRow();
	let selectedCol = _SheetObj.GetSelectCol();

	let startDateColName = _SheetObj.GetCellProperty(_SheetObj.GetSelectRow(), _SheetObj.GetSelectCol(), 'StartDateCol');
	let endDateColName   = _SheetObj.GetCellProperty(_SheetObj.GetSelectRow(), _SheetObj.GetSelectCol(), 'EndDateCol');

	if( $("#hiddenCalendarInput").length == 0 ) {
		$('<span></span>',{ id:'hiddenCalendarLink'}).appendTo('body');
		$('<input></input>',{ id:'hiddenCalendarInput',type:'hidden'}).appendTo('body');
		$("#hiddenCalendarInput").addClass("calendarInput");

		$("#hiddenCalendarInput").sheetDatePicker({
			picker: "#hiddenCalendarLink",
			ymonly:option,
			applyrule: getOption,
			onReturn:function(d) {
				sheetPopCalendarSetCellValue(d);
			}
		});
	}
	sheetCalendarOption = option;
	var value;
	var year;
	var month;
	var day;
	var selectValue = dateSheet.GetCellValue(selectedRow,selectedCol);
	if( selectValue.length == 8 && !option ) {
		year = selectValue.substr(0,4);
		month = selectValue.substr(4,2);
		day = selectValue.substr(6,2);
		value = year + "-" + month + "-" + day;
	}
	else if( selectValue.length == 8 && option ) {
		year = selectValue.substr(0,4);
		month = selectValue.substr(4,2);
		value = year + "-" + month;
	}
	else value = "";
	$("#hiddenCalendarInput").val(value);

	$(".ibsheet").mouseup(function() {calendarClose2();});
	$(".GMVScroll>div").scroll(function () {calendarClose2();});
	$(".GMHScrollMid>div").scroll(function () {calendarClose2();});
}

//시트에서 달력 닫기
function calendarClose2(dateText) {
	$(".ibsheet").unbind("mouseup");
	$(".GMVScroll>div").unbind("scroll");
	$(".GMHScrollMid>div").unbind("scroll");
	$("#hiddenCalendarLink").attr("isshow","0");
	$("#BBIT_DP_CONTAINER").css("visibility", "hidden");
}

/**
 * IBSheet 내 Calendar의 left, top 지정
 * @param dateSheet
 * @param opt2 선택된 위치의 정보
 */
function setSheetCalendarPosition(dateSheet, opt2) {
	const CALENDAR_WIDTH = 240;
	const CALENDAR_HEIGHT = 301;

	let posX = opt2.X;
	let posY = opt2.Y + opt2.Height;

	let windowWidth = $(window).width();
	let windowHeight = $(window).height();

	if (windowWidth < posX + CALENDAR_WIDTH + 20)
		posX = windowWidth - CALENDAR_WIDTH - 20;
	if (windowHeight < posY + CALENDAR_HEIGHT)
		posY = windowHeight - CALENDAR_HEIGHT;
	if (posY < 0)
		posY = 0;

	$("#hiddenCalendarLink").click();
	$("#BBIT_DP_CONTAINER").css("left", posX+"px");
	$("#BBIT_DP_CONTAINER").css("top", posY+"px");
}