/**
 * orgObj : 화상조직도 관련 내용
 */
var orgObj = {
	config : {
		/**
		 * 확정 여부
		 */
		isConfirmed : "N"
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
          , that
    	;

		that = this;

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
	        defaultImage: "/common/plugin/IBLeaders/Org/IBOrgChange/img/default.png",
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
	    		nodeSpacing: 5
	        },
	        event: {
	        	/**
	        	 * 조회 완료후 이벤트
	        	 * @param  {Object} evt
	        	 */
	            onDiagramLoadEnd : function(evt) {
	            	var isTreeLevel;

	            	isTreeLevel = true;
	            	orgObj.UseLevelAlign(isTreeLevel);

	            	loadObj.hideBlockUI();												// 조회가 완료되면 Block영역을 숨김

	        		myOrg.nodes().root().select(true).center(100);						// 조회 완료시 루트노드를 선택하게 한다.

	        		myOrg.nodes().link().style("borderColor","#DCDCDC");

	        		//orgObj.showLegend();
	            },
	            /**
	        	 * 노드 클릭 이벤트
	        	 * @param  {Object} evt
	        	 */
	            onClick : function(evt) {

	            },
	            onMouseDown: function(evt) {
	            	// evt 이벤트 객체
	            	// evt.node, evt.member 노드 객체나 리스트노드 객체
	            	if (evt.node || evt.member) {
	            		// 조직도 확정이 되어 있는 경우에는 이동 불가
		            	if(orgObj.config.isConfirmed == "Y")
		            		return;

	            		if (evt.ctrlKey) {
	            			evt.org.dragging({
	            				isDragging: true,
	            				data: (evt.isMember) ? evt.member : evt.node
	            			});
	            		}
	            	}
	            },
	            onMouseUp: function(evt) {
	            	if(evt.ctrlKey && orgObj.config.isConfirmed == "Y") {
	            		alert("조직도 확정이 되어 있는 상황에서 조직도 변경이 불가능합니다.");
	            		return;
	            	}

	            	// 마우스 우클릭(3)
	            	if (evt.which === 3) {

	            		contextMenu.proc(evt);
	            	}
	            },
	            onDragStart: function(evt) {
	            	var node = evt.org.dragging().data,
	            		img = node.makeImage();

	            	img.id = "dragimg";
	            	img.style.zIndex = 9999;

	            	$("body").append(img);

	            	$("#dragimg").css({
	            		"position": "absolute",
	            		"left": (evt.pageX + 10),
	            		"top": (evt.pageY + 10),
	            		"opacity": 0.5
	            	});

	            	// 시트 객체에서 조직도로 넘긴 데이터를 받을 수 있는 이벤트가 없기 때문에,
					// 생성된 시트위에 마우스업 이벤트 발생시 데이터를 전달하도록 한다.
					$(".GridMain2").on("mouseup", function(evt) {
						var sheet,
							rowData = {};

						sheet = moveSheet;

						// 조직도에서 제공되는 foreach를 통해서 배열에 데이터를 담음.
						node.fields().foreach(function() {
							rowData[this.name()] = this.value();
						});

						// 시트에 신규행 추가
						newRow = sheet.DataInsert();

						for (name in rowData) {
							val = rowData[name];
							sheet.SetCellValue(newRow, name, val);
						}

						// newRow는 데이터 활용을 위해 넣음.
						// 데이터 활용이 필요 없는 경우, 아래와 같이 직접 입력해도 됨.
						/*
						node.fields().foreach(function() {
							name = this.name();
							val = this.value();

							sheet.SetCellValue(newRow, name, val);
						});
						 */

						node.remove();
					});
	            },
	            onDrag: function(evt) {
	            	$("#dragimg").css({
	            		"position": "absolute",
	            		"left": (evt.pageX + 10),
	            		"top": (evt.pageY + 10),
	            		"opacity": 0.5
	            	});
	            },
	            onDragEnd: function(evt) {
	            	$("#dragimg").off().remove();
	            	$(".GridMain2").off();
	            	evt.org.etcData.set("draggingData", {});
	            },
	            onDrop: function(evt) {

	            	var node = evt.org.dragging().data,			// 변경 조직
            		targetNode = evt.node;					// 변경 대상

	            	var org = evt.org;

	            	draggingData = org.etcData.get("draggingData");

            		// 조직도에서 드래그된 데이터
	            	if ( targetNode != undefined ){

	            		if ( !$.isEmptyObject(draggingData) ){

	            			/**
	    					 * evt.node : 시트에서 조직도로 드래그 하여 놓을때, 타겟이 되는 노드의 정보
	    					 * 타겟이 되는 노드가 있으면 부모 노드가 되고, 없으면 상위 노드가 없는 상태로 생성된다.
	    					 */
	    					rkey = (evt.node) ? evt.node.pkey() : "";

	    					/**
	    					 * 조직 데이터 생성
	    					 *
	    					 * pkey는 노드의 유니크한 키
	    					 * rkey는 상위 연결 노드키
	    					 */
	    					nodedata = [{
	    						"template": "photo",
	    						"fields": {
	    							"pkey": {
	    								"value": draggingData.dept_cd
	    							},
	    							"rkey": {
	    								"value": rkey
	    							},
	    							"dept_nm": {
	    								"value": draggingData.dept_nm
	    							},
	    							"position": {
	    								"value": draggingData.position
	    							},
	    							"emp_cd": {
	    								"value": draggingData.emp_cd
	    							},
	    							"emp_nm": {
	    								"value": draggingData.emp_nm
	    							},
	    							"extension": {
	    								"value": draggingData.extension
	    							},
	    							"phone": {
	    								"value": draggingData.phone
	    							},
	    							"email": {
	    								"value": draggingData.email
	    							},
	    							"photo": {
	    								"value": draggingData.photo
	    							}
	    						}
	    					}];

	    					// org object에 새로운 orgData 추가
	    					org.nodes.add(nodedata);

	            		}else{

			            	// 변경대상 하위 노드로 이동(부서 이동)
			            	pkey = targetNode.pkey();			// 변경 대상의 key를 가져온다.
			            	node.rkey(pkey);

			            	var template1 = node.template();

			            	if ( template1.indexOf("_Move") == -1 ){

			            		template1 = template1 + "_Move";

			            		node.template(template1);
			            	}

			            	sheetObj.updateParent( node.pkey() , pkey );
	            		}
	            	}
	            }
	        }
	    }

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
		myOrg.saveAsJson();
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
		myOrg.saveAsImage( { filename : "orgChart", backgroundColor : "white" } );
	},
	Down2Excel : function() {
		myOrg.saveAsExcel({});
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

		var i , j
			, cnt = sheetObj.RowCount()
			, orgData = []
			, orgJson
			, designName = $("#treeType").val();


		for ( i = 1 ; i <= cnt ; i++ ) {
			orgJson = {};

			design 				= "";
			deptCd 				= sheetObj.GetCellValue( i , "orgCd" );						// 부서코드
			deptNm 				= sheetObj.GetCellValue( i , "orgNm" );						// 부서명
			updeptCd 			= sheetObj.GetCellValue( i , "priorOrgCd" );					// 상위부서코드
			nodedesign 			= sheetObj.GetCellValue( i , "nodedesign" );
			deptLevel 			= sheetObj.GetCellValue( i , "orgLevel" );
			position_name 		= sheetObj.GetCellValue( i , "positionName" );
			seq 				= sheetObj.GetCellValue( i , "seq" );
			supporter 			= sheetObj.GetCellValue( i , "directYn" );

			// 디자인 설정
			orgJson.template = nodedesign;
			//orgJson.template = 'Org';

			// 레이아웃(레벨 값, 보조자 값) 설정
			orgJson.layout = {};

			// 노드 레벨값
			orgJson.layout['level'] = Number(deptLevel);

			// 보조자 설정
			if ( supporter  == "Y" ) {
				orgJson.layout['supporter'] = Number(deptLevel);
			}

			// 링크 연결선
			orgJson.link = {};
			orgJson.link.style = {};
			orgJson.link.style['borderColor'] = "red";

			orgJson.fields = {};

			// 테이블 리스트형 인 경우
			orgJson.fields['pkey'] = deptCd;				// pkey : 자신의 ID
			orgJson.fields['rkey'] = updeptCd;				// mkey : 테이블 구조에서 부모 ID

			orgJson.fields['deptcd'] = deptCd;
			orgJson.fields['deptnm'] = deptNm;
			orgJson.fields['updeptcd'] = updeptCd;
			orgJson.fields['seq'] = seq;
			orgJson.fields['position_name'] = position_name;

			//console.log('orgJson : ' + JSON.stringify(orgJson) );
			orgData.push(orgJson);
		}

		// 폰트명
		var fontName = 'NanumGothic';

		var jsonData = {};

		// 모델, 디자인 정보를 가져오면서 폰트명 변경(임시)
		// 폰트명, 폰트사이즈를 변경하기 위한 고도화 작업이 필요함.
		jsonData = (JSON.stringify(ibconfig)).replace(/Dotum/gi, fontName);
		jsonData = JSON.parse(jsonData);


		// 데이터 반영
		jsonData.orgData = orgData;

		// 화상조직도 데이터를 조회
		orgObj.loadJson(jsonData);
	},
};