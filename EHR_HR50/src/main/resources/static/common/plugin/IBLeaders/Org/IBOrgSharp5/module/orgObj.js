/**
 * orgObj : 화상조직도 관련 내용
 */
var orgObj = {
	valiable : {
    	/** 
    	 * 클릭 카운트, 이전 노드
    	 */
		clkCnt : 0,
		prvNode : null,
		baseUrl : "${baseURL}"
	},
	config : {

	},
	init : function() {
		this.create("myOrg", "100%", "100%");
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
	        	level: 1,
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
	            	
	            	//myOrg.nodes().alignment("busr");
	            	
	            	//isTreeLevel = $("#treeLevel").is(":checked");						// 레벨 정렬 체크
	            	var flag;
	    			if(isNaN(Number($("#treeAlign").val()))) {
	    				flag = Boolean($("#treeAlign").val());
	    			}else {
	    				flag = Number($("#treeAlign").val());
	    			}
	    			//orgObj.UseLevelAlign(flag);
	            	//orgObj.UseLevelAlign(4);
					orgObj.UseLevelAlign(1);

	            	loadObj.hideBlockUI();												// 조회가 완료되면 Block영역을 숨김

	        		myOrg.nodes().root().select(true).center(100);						// 조회 완료시 루트노드를 선택하게 한다.
	        		
	        		myOrg.nodes().link().style("borderColor","#DCDCDC");
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
		            	    delay = 500, // 더블클릭 이벤트에 대한 delay 
		            	    timer = null // setTimeout timer 변수
		            	;
		            	
		            	// 변수 clear 이벤트
		            	var clearEvent = function() {
		            		this.orgObj.valiable.clkCnt = 0;
		            		this.orgObj.valiable.prvNode = null;
		            	};
		            	
		            	var rdPopup = function(pEnterCd, pSabun) {
		            		if(pSabun == "" || pSabun == null) {
		            			alert("조회할 수 있는 대상자가 없습니다.");
		            			return;
		            		}

							var rv = "enterCd="+pEnterCd
											+"&sabun="+pSabun;
							var data = ajaxCall("/OrgSchemeIBOrgSrch.do?cmd=getEmpCardPrtRk", rv, false);
							if ( data != null && data.DATA != null ){
								const rdData = {
									rk : data.DATA.rk
								};
								window.top.showRdLayer('/OrgSchemeIBOrgSrch.do?cmd=getEmpCardEncryptRd', rdData, null, "인사카드");
							}
		            	};
		            	
		            	var showUserPopup = function(pDeptcd, pSdate) {
	            			if(!isPopup()) {return;}
	            			gPRow = "";
	            			pGubun = "viewSrchResultPopup";

	            			var args    = new Array();
	            			args["frm"] = "searchOrgType=Y&searchOrgCd=" + pDeptcd + "&searchSdate=" + pSdate + "&searchStatusCd=RA";

							let srchResultLayer = new window.top.document.LayerModal({
								id : 'srchResultLayer',
								url : '/SpecificEmpSrch.do?cmd=viewSrchResultLayer&authPg=R',
								parameters: args,
								width : 1300,
								height : 700,
								title : "맞춤인재검색 결과",
								trigger :[
									{
										name : 'srchResultLayerTrigger'
										, callback : function(result){
										}
									}
								]
							});
							srchResultLayer.show();

		            	};
		            	
	            		var
                        	node = evt.member || evt.node,
                        	pkey = node.pkey(),
                        	isTreeShow = false
                        ;
	            		
	            		if(currKey != null && pkey == currKey) {
	            			
	            			/* 더블클릭 시 이벤트 발생 */
			            	if(this.orgObj.valiable.clkCnt == 0) {
			            		this.orgObj.valiable.clkCnt = 1;
			            		this.orgObj.valiable.prvNode = pkey;
			            		timer = setTimeout(function() {
			            			clearEvent();
			            		}, delay);
			            	} else if(this.orgObj.valiable.clkCnt == 1) {
			            		if(timer != null || this.orgObj.valiable.prvNode != pkey) {
			            			clearTimeout(timer);
			            			clearEvent();
			            		} else {
				            		// 더블클릭에 대한 이벤트 발생.
			            			if($("#treeType").val() == "HeadPhotoBox") {
			            				// 조직+헤드사진 인 경우 더블클릭 시 임직원 리스트를 보여주도록 한다.
			            				var 
			            				    pDeptcd = orgObj.GetNodeDBData(pkey, "deptcd"),
			            				    pSdate = $("#searchSdate").val()
			            				;
			            				showUserPopup(pDeptcd, pSdate);
			            			} else {
			            				// 그 외의 경우 더블클릭 시 인사기록카드를 보여준다.
				            			var 
				            			    pEnterCd = orgObj.GetNodeDBData(pkey, "entercd"), 
				            			    pSabun = orgObj.GetNodeDBData(pkey, "empcd")
				            			;
				            			rdPopup(pEnterCd, pSabun);
			            			}
			            		}
			            	}
			            	
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
		            	         //alert("비교대상 등록이 완료 되었습니다.");
		            	     }
	            			currKey = null;
	            		} else {
			            	if(this.orgObj.valiable.clkCnt == 0) {
			            		this.orgObj.valiable.clkCnt = 1;
			            		this.orgObj.valiable.prvNode = pkey;
			            		timer = setTimeout(function() {
			            			clearEvent();
			            		}, delay);
			            	} else if(this.orgObj.valiable.clkCnt == 1) {
			            		if(timer != null || this.orgObj.valiable.prvNode != pkey) {
			            			clearTimeout(timer);
			            			clearEvent();
			            		} else {
				            		// 더블클릭에 대한 이벤트 발생.
			            			if($("#treeType").val() == "HeadPhotoBox") {
			            				// 조직+헤드사진 인 경우 더블클릭 시 임직원 리스트를 보여주도록 한다.
			            				var 
			            				    pDeptcd = orgObj.GetNodeDBData(pkey, "deptcd"),
			            				    pSdate = $("#searchSdate").val()
			            				;
			            				showUserPopup(pDeptcd, pSdate);
			            			} else {
			            				// 그 외의 경우 더블클릭 시 인사기록카드를 보여준다.
				            			var 
				            			    pEnterCd = orgObj.GetNodeDBData(pkey, "entercd"), 
				            			    pSabun = orgObj.GetNodeDBData(pkey, "empcd")
				            			;
				            			rdPopup(pEnterCd, pSabun);
			            			}
			            		}
			            	}
	            			
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
		orgObj.sheetToOrg(1);
	},
	/**
	 * JSON 데이터를 직접 조회한다.
	 */
	loadJson : function(jsonData) {
		myOrg && myOrg.loadJson({data: jsonData});
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
		myOrg && myOrg.clear();
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
	sheetToOrg : function(Row) {
		var cnt = sheetObj.RowCount()
			,orgData = []
			,designName = $("#treeType").val();
		
		// 데이터(조직명)의 레벨별 최대길이
		var deptnmLeng = {
		};
		
		var startDeptLevel = 0;
		var dataObj = null;
		var upDeptCd = "";

		/**
		 * orgJson에 데이터 매핑 메소드
		 */
		var setData = function(obj) {
			var orgJson = {};
			if(typeof obj == "undefined") {
				return;
			}
			
			var design = "";
			var enterCd = obj.entercd;			// 회사코드
			var deptCd = obj.deptcd;			// 부서코드
			var deptNm = obj.deptnm;			// 부서명
			var deptUseCnt = obj.deptUseCnt;	// 부서인원수
			var updeptCd = obj.updeptcd;		// 상위부서코드
			var empCd = obj.empcd;				// 사번
			var empNm = obj.empnm;				// 성명
			var position = obj.position;		// 직위
			var title = obj.title;				// 직책
			var nodedesign = obj.nodedesign;	// 노드디자인
			nodedesign = (nodedesign) ? nodedesign : "";	// 데이터가 없는 경우 빈칸으로 설정
			var enterCd = obj.entercd;			// 회사코드
			var photo = baseURL + "/EmpPhotoOut.do?enterCd=" + enterCd + "&searchKeyword=" + empCd;
			var inline = obj.inline;
			var hp = obj.hp;
			var email = obj.email;
			var deptLevel = obj.deptlevel;
			var seq = obj.seq;
			var supporter = obj.supportslot;
			var linkcolor = obj.linkcolor;
			var listpid = obj.listpid;							// 테이블 표현에 사용될 상위 연결 아이디
			var nodeid = obj.nodeid;							// 테이블 표현에 사용될 대체 노드 아이디
			var isDual = (obj.dualemp == "Y") ? true : false;	// 공동조직장 유무
			const subOrgVerticalOrderYn = (obj.vrtclOrderYn === "Y"); // 하위조직 세로정렬 여부
			
			
			var workYear = obj.workYear;						// 근속년수
			//var orgYmd = obj.orgYmd;							// 현 부서배치일
			var orgWorkYear = obj.orgWorkYear;							// 현 부서근속기간
			
			// 디자인 요소 정보를 받아옴
			// nodedesign 이 숫자이면 일반 디자인으로 사용하고, 문자형이면 지정된 디자인명으로 사용
			design = isNaN(Number(nodedesign)) ? nodedesign : designName + nodedesign;

            // 세로형인데 직속조직인 경우 가로형태의 박스로 표시한 jylee
			if(designName == "OrgV" && ( deptLevel < "2" || supporter )){
				design = "Org"+ nodedesign;
			}
			
            // HeadPhotoBox 인 경우, 3레벨까지는 PhotoBox로 표시되도록.
			if(designName == "HeadPhotoBox") {
				if(deptLevel < "4" || supporter) {
					design = "PhotoBox"+ nodedesign;
				} else {
					design = "PhotoBoxVTwoV_"+ nodedesign;
				}
			}
			
			// 디자인 설정 (공동조직장)
			orgJson.template = (designName.indexOf("Org") < 0 && isDual && design.indexOf("VTwoV_") < 0) ? "Dual" + design : design;
			
			if(deptnmLeng[orgJson.template] == null || deptnmLeng[orgJson.template] < deptNm.length) {
				deptnmLeng[orgJson.template] = deptNm.length;
			}

			// 레이아웃(레벨 값, 보조자 값) 설정
			orgJson.layout = {};

			// 노드 레벨값
			orgJson.layout.level = Number(deptLevel);
			if (subOrgVerticalOrderYn) {
				orgJson.layout.alignment = "busr";
			}

			// 보조자 설정
			if (supporter) {
				orgJson.layout.supporter = Number(supporter);
			}

			// 링크 연결선
			orgJson.link = {};
			orgJson.link.style = {};
			orgJson.link.style.borderColor = linkcolor;

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
				orgJson.fields['listcount'] = (design.indexOf("Grid") > -1) ? obj.listcount : 0;

				if(orgJson.fields['listcount'] > 0 ) {
					if($("#localeCd").val() == "en_US") {
						orgJson.fields['listcount'] += " Members";
					} else {
						orgJson.fields['listcount'] += " 명";
					}
				}
			}

			orgJson.fields['entercd'] = enterCd;
			orgJson.fields['deptcd'] = deptCd;
			orgJson.fields['deptnm'] = deptNm;
			orgJson.fields['deptnmcnt'] = deptNm+" ("+deptUseCnt+")";
			orgJson.fields['cnt'] = "("+deptUseCnt+")";
			orgJson.fields['updeptcd'] = updeptCd;
			orgJson.fields['position'] = position;
			orgJson.fields['empnmpos'] = empNm + " " + position;
			orgJson.fields['title'] = title;
			orgJson.fields['empcd'] = empCd;
			orgJson.fields['empnm'] = empNm;
			orgJson.fields['photo'] = photo;
			orgJson.fields['seq'] = seq;
			orgJson.fields['email'] = email;
			orgJson.fields['hp'] = hp;
			
			/*
			if(orgYmd != undefined){
				orgJson.fields['orgYmd'] = formatDate(orgYmd,"-");
			}
			*/
			if(orgWorkYear != undefined){
				orgJson.fields['orgWorkYear'] = orgWorkYear;
			}
			
			if(workYear != undefined){
				orgJson.fields['workYear'] = workYear;
			}

			// 공동조직장일 경우, 추가 데이터를 넣는다.
			if (isDual) {
				//orgJson.fields['entercd'] = obj.enterCd2;
				orgJson.fields['deptnm2'] = obj.deptnm2;
				orgJson.fields['deptcd2'] = obj.deptcd2;
				orgJson.fields['empnm2'] = obj.empnm2;
				orgJson.fields['position2'] = obj.position2;
				orgJson.fields['empcd2'] = obj.empcd2;
				orgJson.fields['title2'] = obj.title2;
				orgJson.fields['inline2'] = obj.inline2;
				orgJson.fields['hp2'] = obj.hp2;
				orgJson.fields['email2'] = obj.email2;
				orgJson.fields['empnmpos2'] = obj.empnm2 + " " + obj.position2;
				
				enterCd = obj.entercd;
				empCd2 = obj.empcd2;
				orgJson.fields['photo2'] = baseURL + "/EmpPhotoOut.do?enterCd=" + enterCd + "&searchKeyword=" + empCd2;
			}
			
			orgData.push(orgJson);
		};

		/**
		 * 데이터에 따라 템플릿 수정 메소드.
		 */
		var setOrgTemp = function() {
			// 조직레벨에 따른 백그라운드 색상

			var backgroundColor = {
				"1":"#41a9f1,#41a9f1", //65DBB4
				"2":"#41a9f1,#41a9f1", //59C125
				"3":"#41a9f1,#41a9f1", //0082BC
				"4":"#a5b3cd,#a5b3cd", //F07F3F
				"5":"#a5b3cd,#a5b3cd", //765C7F
				"6":"#a5b3cd,#a5b3cd", //64B9F0
				"7":"#a5b3cd,#a5b3cd", //D63636
				"8":"#a5b3cd,#a5b3cd", //F0DA3E
				"9":"#a5b3cd,#a5b3cd", //AB7F5b
				"10":"#a5b3cd,#a5b3cd" //5D5D5D
			};/*
			var backgroundColor = {
				"1":"#4EA98B,#4EA98B", //65DBB4
				"2":"#45951D,#45951D", //59C125
				"3":"#006491,#006491", //0082BC
				"4":"#D46231,#D46231", //F07F3F
				"5":"#5B4762,#5B4762", //765C7F
				"6":"#4D8FBB,#4D8FBB", //64B9F0
				"7":"#A52A2A,#A52A2A", //D63636
				"8":"#F0A830,#F0A830", //F0DA3E
				"9":"#846246,#846246", //AB7F5b
				"10":"#B1B1B1,#B1B1B1" //5D5D5D
			};
			var backgroundColor = {
				"1":"#65DBB4,#4EA98B",
				"2":"#59C125,#45951D",
				"3":"#0082BC,#006491",
				"4":"#F07F3F,#D46231",
				"5":"#765C7F,#5B4762",
				"6":"#64B9F0,#4D8FBB",
				"7":"#D63636,#A52A2A",
				"8":"#F0DA3E,#F0A830",
				"9":"#AB7F5b,#846246",
				"10":"#5D5D5D,#B1B1B1"
			};*/
			
			// 조직레벨별 조직명의 최대 길이에 따라 템플릿 width, height 세팅.
			$.each(deptnmLeng, function(key, val) {
				var type = key.replace(/[0-9]/g, "");	// 화상조직도 타입
				var num = key.replace(/[^0-9]/g, "");	// 화상조직도 레벨
				if(type == "PhotoBoxPhoto" || type == "GridPhoto") return false;	// PhotoBoxPhoto와 GridPhoto는 조직 레벨에 상관없이 템플릿이 고정이기 때문에 패스.
				
				var orgTemp = $.extend(true, {}, ibconfig.template.nodes[type]);	// 객체 깊은 복사 ( jQuery 사용 )
				
				if(type == "OrgV") {
					// 조직(세로) 일 경우
					if ( num > 1 ){
						var iheight = ( val * 18 ) + 20;
						if( iheight < 100 ) iheight = 100;
						
						orgTemp.style.height = iheight;
						
						orgTemp.units[0].style.backgroundColor = backgroundColor[num];
						orgTemp.units[0].style.height = iheight - 20 ;
						orgTemp.units[0].forceWrap = true;
						orgTemp.units[0].binding = "deptnm";
						if( num != "" ){
							var bgClr = backgroundColor[num].split(",");
							if(bgClr != null)
								orgTemp.units[1].style.backgroundColor = bgClr[1];
							orgTemp.units[1].style.position = "0 " + (iheight - 20);
						}
					}else{
						orgTemp.units[0].style.backgroundColor = backgroundColor[num];
					}
					
				} else if(type == "Org" ) {
					var iwidth = ( val * 13 ) + 30;
					if( iwidth < 100 ) iwidth = 100;
					
					// 조직일 경우
					orgTemp.style.width = iwidth;
					
					orgTemp.units[0].style.backgroundColor = backgroundColor[num];
					orgTemp.units[0].style.width = iwidth;
				} else if(type == "OrgLdr") {
					let unitWidth = ( val * 13 ) + 30;
					let styleWidth = unitWidth+1;
					if( styleWidth < 120 ) styleWidth = 120;
					if( unitWidth < 119 ) unitWidth = 119;

					// 조직일 경우
					orgTemp.style.width = styleWidth;

					orgTemp.units[0].style.backgroundColor = backgroundColor[num];
					orgTemp.units[0].style.width = unitWidth;
					orgTemp.units[1].style.width = unitWidth;
				} else if(type == "PhotoBox") {
					// 조직 + 사진 일 경우
					var iwidth = ( val * 14 ) + 10;
					if( iwidth < 100 ) iwidth = 100;
					orgTemp.style.width = iwidth;

					if( num != "" ){
						orgTemp.units[0].style.backgroundColor = backgroundColor[num];
					}
					orgTemp.units[0].style.width = iwidth - 1;
					orgTemp.units[1].style.position = ((iwidth - 67)/2) + " 35";
					orgTemp.units[2].style.width = iwidth - 1;
					//orgTemp.units[3].style.width = iwidth- 1;
				} else if(type == "PhotoBoxVTwoV_") {
					// 조직(세로) 일 경우
					if ( num > 1 ){
						var iheight = ( val * 18 ) + 20;
						if( iheight < 80 ) iheight = 80;
						
						orgTemp.style.height = iheight;
						
						orgTemp.units[0].style.backgroundColor = backgroundColor[num];
						orgTemp.units[0].style.height = iheight - 20 ;
						orgTemp.units[0].forceWrap = true;
						orgTemp.units[0].binding = "deptnm";
						if( num != "" ){
							var bgClr = backgroundColor[num].split(",");
							if(bgClr != null)
								orgTemp.units[1].style.backgroundColor = bgClr[1];
							orgTemp.units[1].style.position = "0 " + (iheight - 20);
						}
					}else{
						orgTemp.units[0].style.backgroundColor = backgroundColor[num];
					}
					
				} else if(type == "DualPhotoBox") {
					// 조직 + 사진 ( 공동조직장 ) 일 경우
					orgTemp.units[0].style.backgroundColor = backgroundColor[num];
				} else if(type == "OrgChif") {
					// 조직 + 조직장 일 경우
					orgTemp.style.width = val * 20;

					orgTemp.units[0].style.backgroundColor = backgroundColor[num];
					orgTemp.units[0].style.width = (val * 20) - 1;
					orgTemp.units[1].style.width = (val * 20) - 1;
					orgTemp.units[2].style.width = (val * 20) - 1;
				} else if(type == "DualOrgChif") {
					// 조직 + 조직장 ( 공동조직장 ) 일 경우
					orgTemp.units[0].style.backgroundColor = backgroundColor[num];
				}
				
				ibconfig.template.nodes[key] = orgTemp;	// ibconfig 에 계산된 템플릿 저장
			});
		};
		
		for(var i = Row - 1 ; i <= cnt-1 ; i++) {
			if(i == Row-1) {
				startDeptLevel = sheetObj.orgList[i].deptlevel;
				upDeptCd = sheetObj.orgList[i].updeptcd;
			} else {
				if(startDeptLevel >= sheetObj.orgList[i].deptlevel) {
					break;
				}

				// 화상조직도에서 같은 레벨의 조직이 하위조직이 없을 경우 같이 나오는 에러 수정. by kwook.
				if(upDeptCd == sheetObj.orgList[i].updeptcd) break;
			}

			setData(sheetObj.orgList[i]);

			for(var j = 0; j < sheetObj.memberList.length; j++) {

				if(sheetObj.orgList[i].deptcd == sheetObj.memberList[j].deptcd) {
					setData(sheetObj.memberList[j]);
				}
			}
		}

		// 폰트명
		var fontName = $("#fontName").val();

		var jsonData = {};
		
		$("#spanblockMsg").html("Please Wait... ...");
		

		setTimeout(function(){
			setOrgTemp();
			
			// 모델, 디자인 정보를 가져오면서 폰트명 변경(임시)
			// 폰트명, 폰트사이즈를 변경하기 위한 고도화 작업이 필요함.
			jsonData = (JSON.stringify(ibconfig)).replace(/Dotum/gi, fontName);
			jsonData = JSON.parse(jsonData);

			// 데이터 반영
			jsonData.orgData = orgData;
			
			// 화상조직도 데이터를 조회
			orgObj.loadJson(jsonData);
			
		},100);
		
	}
};