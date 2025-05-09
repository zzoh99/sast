/**
 * orgObj : 화상조직도 관련 내용
 */
var orgObj = {
	config : {

	},
	init : function() {
		this.create("myOrg", "100%", "96%");
	},
	/**
	 * IBOrg를 생성
	 * @param 	{object}	orgID			IBOrg#이 생성되는 객체
	 * @param	{String}	div_width		너비
	 * @param	{String}	div_height		높이
	 */
	create : function(orgID, div_width, div_height) {
		$('<div/>', {
		    id: orgID,
		    width: div_width,
		    height: div_height,
		}).appendTo('#orgDiv');

		this.initIBOrg();
	},
	/**
	 * 조직도 설정
	 */
	initIBOrg : function() {
		var
    		_opt,
    		currKey //현재 정보에 보이는 사번
    	;

		// diagramPadding : 다이어그램 영역에 간격
		// expandButtonVisible : 노드 아래 하위노드 확장버튼을 숨김
		// contentAlign : 화상조직도 정렬 시작점
		// defaultImage : 기본 이미지(이미지가 없을때 대체하는 이미지)

		// layout.level : 레벨 정렬 사용 유무
		// layout.supporter : 보조자(direct) 사용 유무
		// layerSpacing : 노드 세로 간격
		// nodeSpacing : 노드 가로 간격

		// IBOrgJS 객체 생성시 사용할 option을 생성
	    _opt = {
	        diagramPadding: 30,
	        expandButtonVisible: false,
	        contentAlign: "TopCenter",
	        defaultImage: "/common/plugin/IBLeaders/Org/IBOrgSharp5/img/default.png",
	        defaultTemplate: {
	            link: {
	                style: {
	                    borderWidth: 2,
	                    borderColor: "#CCC",
	                    borderStyle: "solid"
	                }
	            }
	        },
	        layout: {
	        	level: true,
	        	supporter: true,
	        	layerSpacing: 0,
	    		nodeSpacng: 10
	        },
	        event: {
	        	/**
	        	 * 조회 완료후 이벤트
	        	 * @param  {Object} evt
	        	 */
	            onDiagramLoadEnd : function(evt) {
//	            	isTreeLevel = $("#treeLevel").is(":checked");						// 레벨 정렬 체크
//	            	orgObj.UseLevelAlign($("#treeAlign").val());						// 조직도 정렬 세팅

	            	// 노드들 기본 bus정렬로 세팅
	            	myOrg.nodes().alignment("busr");
	            	
	    			var flag;
	    			if(isNaN(Number($("#treeAlign").val()))) {
	    				flag = Boolean($("#treeAlign").val());
	    			}else {
	    				flag = Number($("#treeAlign").val());
	    			}
	    			orgObj.UseLevelAlign(flag);											// 조직도 정렬 세팅 
	    			
	            	loadObj.hideBlockUI();												// 조회가 완료되면 Block영역을 숨김

	        		myOrg.nodes().root().select(true).center(100);						// 조회 완료시 루트노드를 선택하게 한다.
	        		
	            },
	            /**
	        	 * 노드 클릭 이벤트
	        	 * @param  {Object} evt
	        	 */
	            onClick : function(evt) {
	            	var
	            		nodeID,
	            		row
	            	;
	            	
	            	// 노드 또는 노드의 필드 또는 리스트형태의 노드인 경우
	            	if (evt.isNode || evt.isField || evt.isMember) {
	            		var
                        	node = evt.member || evt.node,
                        	pkey = node.pkey(),
                        	isTreeShow = false
                        ;
	            		
	            		
	            		if(currKey !=  null  && pkey == currKey) {
	            			nodeID = pkey;
	            			
	            			if($('#name1').val() == ""){
		            	         $('#name1').val(orgObj.GetNodeDBData(nodeID, "empnm"));
		            	         $('#sabun1').val(orgObj.GetNodeDBData(nodeID, "empcd"));
		            	     }else if($('#name2').val() == ""){
		            	         $('#name2').val(orgObj.GetNodeDBData(nodeID, "empnm"));
		            	         $('#sabun2').val(orgObj.GetNodeDBData(nodeID, "empcd"));
		            	     }else if($('#name3').val() == ""){
		            	         $('#name3').val(orgObj.GetNodeDBData(nodeID, "empnm"));
		            	         $('#sabun3').val(orgObj.GetNodeDBData(nodeID, "empcd"));
		            	     }else{
		            	         alert("비교대상 등록이 완료 되었습니다.");
		            	     }

	            			currKey = null;
	            		} else {
	            			
	            			currKey = pkey;
	            			isTreeShow = $("#treeShow").is(":checked");						// 트리 체크
		            		if (!isTreeShow) {
		            			$("#treeShow").trigger("click");
		            			orgObj.showTreeInfo(pkey);
		            		} else {
		            			orgObj.showTreeInfo(pkey);
		            		}
	            		}
	            	}
	            }
	        }
	    };

    	// 조직도 생성
	    createIBOrg("myOrg", _opt);
	},
	/**
	 * 조직도 기본 조회
	 */
	load : function() {
		orgObj.sheetToOrg();
	},
	/**
	 * JSON 데이터를 직접 조회한다.
	 */
	loadJson : function(jsonData) {
		myOrg.loadJson({data: jsonData});
	},
	/**
	 * 파일 불러오기 기능
	 */
	loadFile : function() {
		myOrg.loadFromFile();
	},
	/**
	 * 파일 저장 기능
	 */
	saveFile : function() {
//		myOrg.saveAsJson();
		myOrg.saveAsExcel();
	},
	showTreeInfo : function(pkey) {
		$("ul.tabs li:eq(1)").click();

		// 노드의 각 필드 값들을 정보 탭에 보여줌.
		nodeEditObj.setEditData(pkey);
	},
	/**
	 * Zoom 기능
	 * @param {float} val : Zoom 값
	 */
	Zoom : function(val) {
		myOrg.scale(val);
	},
	/**
	 * 조직도 데이터를 지운다.
	 */
	ClearData : function() {
		myOrg.clear();
	},
	/**
	 * 확대
	 */
	ZoomIn : function() {
		myOrg.zoomIn();
	},
	/**
	 * 축소
	 */
	ZoomOut : function() {
		myOrg.zoomOut();
	},
	/**
	 * 화면에 맞게 크기 조절
	 */
	FitScale : function() {
		myOrg.scale("fit");
	},
	/**
	 * 조직도를 이미지로 저장
	 */
	Down2Image : function() {
		myOrg.saveAsImage( { filename : "org", backgroundColor : "white" } );
	},
	/**
	 * 레벨정렬 설정
	 * @param {bool} flag true/false
	 */
	UseLevelAlign : function(flag) {
		myOrg.layout.level(flag);
	},
	/**
	 * 전체 노드 보기
	 */
	ShowAllNode : function() {
		myOrg.nodes.viewAll();
		myOrg.nodes().root().select(true).center(100);
	},
	/**
	 * 자식 노드 보기
	 * @param {string} NodeID 노드 ID
	 */
	ShowChildNode : function(NodeID) {
		myOrg.nodes.viewSubTree(NodeID);
		myOrg.nodes(NodeID).select(true).center(100);
	},
	/**
	 * 노드를 선택한다.
	 * @param NodeID
	 */
	SetSelectNode : function(NodeID) {
		myOrg.nodes(NodeID).select(true).center();
	},
	/**
	 * 선택된 노드 정보를 받는다.
	 * @returns
	 */
	SelectNodeID : function() {
		return myOrg.nodes.selected();
	},
	/**
	 * 기준노드의 DBKey에 대응하는 해당 필드값을 반환한다.
	 * @param {string} NodeID
	 * @param {string} DBKey
	 * @returns {string}
	 */
	GetNodeDBData : function(NodeID, DBKey) {
		if (!NodeID) return "[Error] NodeID를 입력해주세요.";
		if (!DBKey) return "[Error] Key를 입력해주세요.";

		return myOrg.nodes(NodeID).fields(DBKey).value();
	},
	/**
	 * 노드 정보를 갱신한다.
	 * @param NodeID
	 * @param DBKey
	 * @param DBValue
	 * @returns {String}
	 */
	SetNodeDBData : function(NodeID, DBKey, DBValue) {
		if (!NodeID) return "[Error] NodeID를 입력해주세요.";
		if (!DBKey) return "[Error] Key를 입력해주세요.";

		myOrg.nodes(NodeID).fields(DBKey).value(DBValue);
	},
	/**
	 * 조직 갯수 카운트
	 */
	GetNodeCount : function() {
		return myOrg.nodes().length;
	},
	/**
	 * 디자인명
	 */
	GetNodeTemplate : function(NodeID) {
		return myOrg.nodes(NodeID).template();
	},
	/**
	 * 시트 데이터를 조직도 데이터로 변경
	 */
	sheetToOrg : function() {
		var
			i
			,j
			,cnt = sheetObj.RowCount()
			,orgData = []
			,orgJson
			,designName = $("#treeType").val();


		for (i = 1; i <= cnt; i++) {
			orgJson = {};

			design = "";
			deptCd = sheetObj.GetCellValue(i, "deptcd");						// 부서코드
			deptNm = sheetObj.GetCellValue(i, "deptnm");						// 부서명
			updeptCd = sheetObj.GetCellValue(i, "updeptcd");					// 상위부서코드
			empCd = sheetObj.GetCellValue(i, "empcd");
			/*
			if(sheetObj.GetCellValue(i, "doubleYn") != "" && sheetObj.GetCellValue(i, "doubleYn") != ""){
				if(sheetObj.GetCellValue(i, "doubleYn") == "Y" && sheetObj.GetCellValue(i, "oriEnterCd") != ""){
					empNm = "(겸)"+sheetObj.GetCellValue(i, "empnm")+"("+sheetObj.GetCellValue(i, "oriEnterCd")+")";
				}else if(sheetObj.GetCellValue(i, "doubleYn") == "Y" && sheetObj.GetCellValue(i, "oriEnterCd") == ""){
					empNm = "(겸)"+sheetObj.GetCellValue(i, "empnm");
				}else if(sheetObj.GetCellValue(i, "doubleYn") == "N" && sheetObj.GetCellValue(i, "oriEnterCd") != ""){
					empNm = sheetObj.GetCellValue(i, "empnm")+"("+sheetObj.GetCellValue(i, "oriEnterCd")+")";
				}else if(sheetObj.GetCellValue(i, "doubleYn") == "N" && sheetObj.GetCellValue(i, "oriEnterCd") == ""){
					empNm = sheetObj.GetCellValue(i, "empnm");
				}
			}else{
				empNm = sheetObj.GetCellValue(i, "empnm");
			}
			*/
			
			if(sheetObj.GetCellValue(i, "oriEnterCd") != ""){
				empNm = sheetObj.GetCellValue(i, "empnm")+"("+sheetObj.GetCellValue(i, "oriEnterCd")+")";
			}else{
				empNm = sheetObj.GetCellValue(i, "empnm");
			}
			
			position = sheetObj.GetCellValue(i, "position");
//			title = sheetObj.GetCellValue(i, "title");
			nodedesign = sheetObj.GetCellValue(i, "nodedesign");
			nodedesign = (nodedesign) ? nodedesign : 10;	// 데이터가 없는 경우 10으로 설정
//			inline = sheetObj.GetCellValue(i, "inline");
//			hp = sheetObj.GetCellValue(i, "hp");
//			email = sheetObj.GetCellValue(i, "email");
			enterCd = sheetObj.GetCellValue(i, "entercd");
			if( deptCd == "10000" ) {
				//'한국카카오주식회사'의 경우 사원사진이 아닌 회사마크 표시
				photo = baseURL + "/OrgPhotoOut.do?enterCd=" + enterCd + "&logoCd=11"; //법인이미지관리:회사로고_화상조직도
			}else {
				photo = baseURL + "/EmpPhotoOut.do?enterCd=" + enterCd + "&searchKeyword=" + empCd;
			}
			deptLevel = sheetObj.GetCellValue(i, "deptlevel");
			seq = sheetObj.GetCellValue(i, "seq");
			supporter = sheetObj.GetCellValue(i, "supportslot");
			linkcolor = sheetObj.GetCellValue(i, "linkcolor");
			listpid = sheetObj.GetCellValue(i, "listpid");						// 테이블 표현에 사용될 상위 연결 아이디
			nodeid = sheetObj.GetCellValue(i, "nodeid");						// 테이블 표현에 사용될 대체 노드 아이디
			isDual = (sheetObj.GetCellValue(i, "dualemp") == "Y") ? true : false;						// 공동조직장 유무

			listcount = 0;														// 직원 표현시 사용될 직원들의 인원수
			empcnt = 0;

			// 디자인 요소 정보를 받아옴;
			// nodedesign 이 숫자이면 일반 디자인으로 사용하고, 문자형이면 지정된 디자인명으로 사용
			design = isNaN(Number(nodedesign)) ? nodedesign : designName + nodedesign;
			// 공동조직장인 경우, 조직코드가 같으므로 하나를 숨김 처리한다.
			if (isDual) {
				sheetObj.SetRowHidden(i);
			}

			// 디자인 설정
			orgJson.template = design;

			// 디자인 설정 (공동조직장)

			orgJson.template = (isDual) ? "Dual" + design : design;

			// 레이아웃(레벨 값, 보조자 값) 설정
			orgJson.layout = {};

			// 노드 레벨값
			orgJson.layout['level'] = Number(deptLevel);

			// 보조자 설정
			if (supporter) {
				orgJson.layout['supporter'] = Number(supporter);
			}

			// 링크 연결선
			orgJson.link = {};
			orgJson.link.style = {};
			orgJson.link.style['borderColor'] = linkcolor;

			orgJson.fields = {};

			if (listpid) {
				// 테이블 리스트형 인 경우
				orgJson.fields['pkey'] = nodeid;				// pkey : 자신의 ID
				orgJson.fields['mkey'] = listpid;				// mkey : 테이블 구조에서 부모 ID
			} else {
				// 일반 노드인 경우
				orgJson.fields['pkey'] = deptCd;				// pkey : 자신의 ID
				orgJson.fields['rkey'] = updeptCd;				// rkey : 부모 ID

				// Grid 데이터인 경우, 리스트 인원 갯수를 받아오게 설정
				//orgJson.fields['listcount'] = (design.indexOf("Grid") > -1) ? sheetObj.GetSubSumCount("listpid", deptCd) : 0;
				//orgJson.fields['listcount'] = (design.indexOf("Grid") > -1) ? sheetObj.GetCellValue(i, "empcnt") : 0;
				orgJson.fields['listcount'] = sheetObj.GetCellValue(i, "empcnt");
			}

			orgJson.fields['deptcd'] = deptCd;
			orgJson.fields['deptnm'] = deptNm;
			orgJson.fields['updeptcd'] = updeptCd;
			orgJson.fields['position'] = position;
//			orgJson.fields['title'] = title;
			orgJson.fields['empcd'] = empCd;
			orgJson.fields['empnm'] = empNm;
//			orgJson.fields['inline'] = inline;
//			orgJson.fields['hp'] = hp;
//			orgJson.fields['email'] = email;
			orgJson.fields['photo'] = photo;
			orgJson.fields['seq'] = seq;

			// 공동조직장일 경우, 추가 데이터를 넣는다.
			if (isDual) {
				i++;
				orgJson.fields['deptcd2'] = sheetObj.GetCellValue(i, "deptcd");
				orgJson.fields['empnm2'] = sheetObj.GetCellValue(i, "empnm");
				orgJson.fields['position2'] = sheetObj.GetCellValue(i, "position");
				orgJson.fields['empcd2'] = sheetObj.GetCellValue(i, "empcd");
				orgJson.fields['empnm2'] = sheetObj.GetCellValue(i, "empnm");

				enterCd = sheetObj.GetCellValue(i, "entercd");
				empCd = sheetObj.GetCellValue(i, "empcd");
				orgJson.fields['photo2'] = baseURL + "/EmpPhotoOut.do?enterCd=" + enterCd + "&searchKeyword=" + empCd;
			}

			orgData.push(orgJson);
		}

		// 폰트명
		var fontName = $("#fontName").val();

		var jsonData = {};

		// 모델, 디자인 정보를 가져오면서 폰트명 변경(임시)
		// 폰트명, 폰트사이즈를 변경하기 위한 고도화 작업이 필요함.
		jsonData = (JSON.stringify(ibconfig)).replace(/Dotum/gi, fontName);
		jsonData = JSON.parse(jsonData);

		// 데이터 반영
		jsonData.orgData = orgData;

		// 화상조직도 데이터를 조회
		orgObj.loadJson(jsonData);
	}
};