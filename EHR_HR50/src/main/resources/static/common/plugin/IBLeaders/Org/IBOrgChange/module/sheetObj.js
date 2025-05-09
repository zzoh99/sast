/**
 * sheetObj : 트리형 시트 관련 내용
 */
var sheetObj = {
	config : {

	},
	/**
	 * IBSheet 초기화
	 */
	init : function() {

		var initdata = {};

		this.create();

		initdata.Cfg = {SearchMode:smLazyLoad, Page:30, DragMode:0};
	    initdata.HeaderMode = {Sort:0, ColMove:0, ColResize:1, HeaderCheck:0};

	    initdata.Cols = [
	    	 {Header:"상태",				Type:"Status",	SaveName:"sStatus"},
             {Header:"부서코드", 			Type:"Text",	SaveName:"orgCd"			},
             {Header:"조직트리", 			Type:"Text",	SaveName:"orgNm"			},
             {Header:"상위부서코드", 		Type:"Text",	SaveName:"priorOrgCd"		},
             {Header:"부서레벨",			Type:"Text",	SaveName:"orgLevel"			},
             {Header:"노드디자인",			Type:"Text",	SaveName:"nodedesign"		},
             {Header:"보조자",			Type:"Text",	SaveName:"supportslot"		},
             {Header:"링크색",			Type:"Text",	SaveName:"linkcolor" 		},
             {Header:"순차",				Type:"Text",	SaveName:"num" 				},
             {Header:"정렬",				Type:"Text",	SaveName:"seq"				},
             {Header:"변경구분",			Type:"Text",	SaveName:"changeGubun"		},
             {Header:"조직명(변경전)",		Type:"Text",	SaveName:"orgNmPre"			},
             {Header:"조직명(변경후)",		Type:"Text",	SaveName:"orgNmAfter"		},
             {Header:"영문조직명(변경전)",	Type:"Text",	SaveName:"orgEngNmPre"		},
             {Header:"영문조직명(변경후)",	Type:"Text",	SaveName:"orgEngNmAfter"	},
             {Header:"상위부서코드(변경전)",	Type:"Text",	SaveName:"priorOrgCdPre"	},
             {Header:"상위부서명(변경전)",	Type:"Text",	SaveName:"priorOrgNmPre"	},
             {Header:"상위부서코드(변경후)",	Type:"Text",	SaveName:"priorOrgCdAfter"	},
             {Header:"상위부서명(변경후)",	Type:"Text",	SaveName:"priorOrgNmAfter"	},
             {Header:"조직구분",			Type:"Text",	SaveName:"objectType"		},
             {Header:"내외구분",			Type:"Text",	SaveName:"inoutType"		},
             {Header:"조직유형",			Type:"Text",	SaveName:"orgType"			},
             {Header:"LOCAITON",		Type:"Text",	SaveName:"locationCd"		},
             {Header:"직속여부",			Type:"Text",	SaveName:"directYn"			},
             {Header:"세로표시",			Type:"Text",	SaveName:"vertYn"			},
             {Header:"조직장포함",			Type:"Text",	SaveName:"leaderYn"			},
             {Header:"비고",				Type:"Text",	SaveName:"memo"				},
             {Header:"직위성명",			Type:"Text",	SaveName:"positionName"		},
             {Header:"개편일자",			Type:"Text",	SaveName:"sdate"			},
             {Header:"버젼명",			Type:"Text",	SaveName:"versionNm"		}
        ];

	    IBS_InitSheet(mySheet, initdata);		// mySheet는 IBSheet의 createIBSheet2에서 생성된 전역객체

	    mySheet.FitColWidth();
	    mySheet.SetFocusAfterProcess(0);
	    mySheet.SetWaitImageVisible(0);			// 대기 이미지 생성하지 않도록 설정

	    this.bindEvent();

	    $("#sheetDiv").hide();

//	    doAction("Org");
	},
	/**
	 * IBSheet 생성
	 */
	create : function() {
		/**
		 * IBSheet를 생성
		 * @param 	{object}				IBSheet가 생성될 대상 컨테이너
		 * @param	{object}				IBSheet의 ID
		 * @param	{String}	"100%"		너비
		 * @param	{String}	"100%"		높이
		 */
		createIBSheet2(document.getElementById("sheetDiv"), "mySheet", "190px", "91%", "kr");
	},
	/**
	 * 시트 데이터 로드
	 * @param data : JSON형태의 데이터
	 */
	loadData : function(data) {
		mySheet.RemoveAll();
		mySheet.LoadSearchData(data);
	},
	/**
	 * 관련 이벤트
	 */
	bindEvent : function() {
		function addEvents(mySheet, callbacks) {
			for (var prop in callbacks) {
				window[mySheet + "_" + prop] = callbacks[prop];
			}
		}

		addEvents(mySheet.id, {
			/**
			 * 조회 후 처리이벤트
			 */
			OnSearchEnd : function(Code, Msg, StCode, StMsg) {
				// 처리가 실패하는 경우 로그를 표시한다.

					// 시트 컬럼 너비 정렬
//					mySheet.ShowTreeLevel(1,1);

					// 시트 조회후, 조직도를 생성하도록 한다.

				orgObj.sheetToOrg();

			},
			OnSaveEnd : function(Code, Msg, StCode, StMsg) {

			},
			OnResize : function(Width, Height) {
			    mySheet.FitColWidth();
			},
			/**
			 * 클릭 이벤트
			 */
			OnClick : function(Row, Col, Value, CellX, CellY, CellW, CellH) {

			},
			/**
			 * 돋보기 모양의 버튼 클릭 이벤트로 하위노드 보기를 지원한다.
			 */
			OnPopupClick : function(Row, Col) {

			},
			OnSelectCell : function(OldRow, OldCol, NewRow, NewCol) {

			}
		});
	},
	/**
	 * 특정 컬럼 Index에 해당하는 InitColumns 함수에서 설정한 SaveName을 확인한다.
	 * @param DataRow
	 * @param Col
	 * @returns
	 */
	ColSaveName : function(DataRow, Col) {
		return mySheet.ColSaveName(DataRow, Col);
	},
	/**
	 * 해당 값이 있는 곳의 행을 찾는다.
	 * @param code : 검색하려는 문자열
	 * @returns
	 */
	FindText : function(colName, searchText) {
		return mySheet.FindText(colName, searchText, 0);
	},
	/**
	 * 행과 열의 위치에 따른 값을 가져온다.
	 * @param row
	 * @param colName
	 * @returns
	 */
	GetCellValue : function(Row, colName) {
		return mySheet.GetCellValue(Row, colName);
	},
	/**
	 * 트리구조에서 특정 행의 자식행들의 Index를 "|"로 조합하여 반환한다
	 * @param Row
	 * @param MaxLevel
	 * @returns
	 */
	GetChildRows : function(Row, MaxLevel) {
		return mySheet.GetChildRows(Row, MaxLevel);
	},
	/**
	 * 마지막 컬럼의 index를 반환한다.
	 * @returns
	 */
	LastCol : function() {
		return mySheet.LastCol();
	},
	/**
	 * 시트 전체의 행의 갯수
	 */
	RowCount : function() {
		return mySheet.RowCount();
	},
	/**
	 * 행 숨김
	 */
	SetRowHidden : function(Row) {
		mySheet.SetRowHidden(Row, 1);
	},
	/**
	 * 행과 열 위치에 값을 입력한다.
	 * @param row
	 * @param colName
	 * @param val
	 */
	SetCellValue : function(Row, colName, val) {
		mySheet.SetCellValue(Row, colName, val);
	},
	/**
	 * 행의 레벨값을 가져온다.
	 * @param row
	 * @return level
	 */
	GetRowLevel : function(Row) {
		return mySheet.GetRowLevel(Row);
	},
	/**
	 * 지정된 행을 선택
	 */
	SetSelectRow : function(Row) {
		mySheet.SetSelectRow(Row, 0);
	},
	/**
	 * 트리 형태 일 때 행의 Child Level이 펼쳐져 있는 상태인지 여부를 확인하거나 펼침 여부를 설정한다.
	 */
	SetRowExpanded : function(Row, Expand) {
		mySheet.SetRowExpanded(Row, Expand, 0);
	},

	/**
	 * 이름 검색
	 */
	findName : function() {
		var
			row,
			nodeID,
			iType = $("#selFindType").val(),
			iName = $("#inputFindName").val()
		;

		// 선택 타입이 없으면
		if (iType.length < 1) {
			return;
		}

		// 검색하고자 하는 명칭이 없는 경우
		if (iName.length < 1) {
			return;
		}

		// 이전 명칭과 비교해서 같지 않으면 처음부터 검색
		if (tmpName != iName) {
			startRow = 1;
		}

		// 검색된 명칭과 동일한 행을 찾는다.
		row = mySheet.FindText(iType, iName, startRow, 2, 0);

		if (row > 0) {
			tmpName = iName;
			startRow = Number(row + 1);

			mySheet.SetSelectRow(row, 0);

			nodeID = mySheet.GetCellValue( row , "deptcd" );
			if (nodeID) {
				orgObj.SetSelectNode(nodeID);
			}

		} else {
			// 검색된 결과가 없으면
			startRow = 1;
			if ( confirm( "다시 검색하시겠습니까?" ) ) {
				sheetObj.findName();
			}
		}
	},
	/**
	 * Test
	 */
	Test : function() {

	}
	,
	/*
	 * 상위부서 정보 갱신
	 * **/
	updateParent : function( targetOrgCd , parentOrgCd ){

		for(var i = mySheet.HeaderRows(); i <= mySheet.LastRow(); i++){

			var deptcd = mySheet.GetCellValue( i  , "orgCd" );

			if ( deptcd == targetOrgCd ){

				mySheet.SetCellValue( i , "priorOrgCdAfter" , parentOrgCd );
				mySheet.SetCellValue( i , "priorOrgCd" 		, parentOrgCd );
				mySheet.SetCellValue( i , "changeGubun" 	, "3"  );		// 상부조직변동
			}
		}
	}
	,
	/*
	 * 상세정보 설정
	 * **/
	setDetailInfo : function( targetOrgCd ){

		for(var i = mySheet.HeaderRows(); i <= mySheet.LastRow(); i++){

			var deptcd = mySheet.GetCellValue( i  , "orgCd" );

			if ( deptcd == targetOrgCd ){

				var orgCd2 = deptcd;
				var changeGubun 	= mySheet.GetCellValue( i  , "changeGubun" );
				var orgNmPre 		= mySheet.GetCellValue( i  , "orgNmPre" );
				var orgNmAfter 		= mySheet.GetCellValue( i  , "orgNmAfter" );
				var orgEngNmPre 	= mySheet.GetCellValue( i  , "orgEngNmPre" );
				var orgEngNmAfter 	= mySheet.GetCellValue( i  , "orgEngNmAfter" );
				var priorOrgCdPre 	= mySheet.GetCellValue( i  , "priorOrgCdPre" );
				var priorOrgNmPre 	= mySheet.GetCellValue( i  , "priorOrgNmPre" );
				var priorOrgCdAfter = mySheet.GetCellValue( i  , "priorOrgCdAfter" );
				var priorOrgNmAfter = mySheet.GetCellValue( i  , "priorOrgNmAfter" );

				$("#orgCd2").val( orgCd2 ) ;
				$("#changeGubun").val( changeGubun ) ;
				$("#orgNmPre").val( orgNmPre ) ;
				$("#orgNmAfter").val( orgNmAfter ) ;
				$("#orgEngNmPre").val( orgEngNmPre ) ;
				$("#orgEngNmAfter").val( orgEngNmAfter ) ;
				$("#priorOrgCdPre").val( priorOrgCdPre ) ;
				$("#priorOrgNmPre").val( priorOrgNmPre ) ;
				$("#priorOrgCdAfter").val( priorOrgCdAfter ) ;
				$("#priorOrgNmAfter").val( priorOrgNmAfter ) ;
			}
		}
	}
};

var tmpName;			// 이름 검색시 비교를 위한 임시이름
var startRow = 1;		// 검색 시작행