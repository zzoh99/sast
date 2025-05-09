var ibOrgItemStyle = {
	backgroundColor : {
		normal : "#4d8fbb",
		move   : "#f7d518",
		close  : "#808ea2",
		focus  : "#f18d00"
	},
	borderColor : {
		normal : "#4d8fbb",
		move   : "#f7d518",
		close  : "#808ea2",
		focus  : "#f18d00"
	},
	color : {
		normal : "#fff",
		move   : "#fff",
		close  : "#fff",
		focus  : "#fff"
	},
	selection : {
		width      : "6px",
		background : "#000",
		opacity    : "0.3"
	}
};
var ibconfig =
{
    "model": {
        "pkey": "pkey",
        "rkey": "rkey",
        "mkey": "mkey",
        "useKey": "deptcd",
		"usePKey": "updeptcd",
        "order": [
            "seq"
        ],
        "fields": [
            {
                "code": "deptcd",
                "type": "string",
                "name": "부서코드",
                "alias": {
					"hidden": false
				}
            },
            {
                "code": "updeptcd",
                "type": "string",
                "name": "상위부서코드",
                "alias": {
    				"hidden": true
    			}
            },
            {
                "code": "deptnm",
                "type": "string",
                "name": "부서명",
                "alias": {
    				"hidden": false
    			}
            },
            {
                "code": "seq",
                "type": "string",
                "name": "순서",
                "alias": {
    				"hidden": true
    			}
            }
            ,
            {
                "code": "chief_position_nm",
                "type": "string",
                "name": "조직장직급",
                "alias": {
    				"hidden": true
    			}
            }
            ,
            {
                "code": "chief_nm",
                "type": "string",
                "name": "조직장이름",
                "alias": {
    				"hidden": true
    			}
            }

        ]
    },
    "template": {
        "nodes": {
        	"Org": {
                "style": {
                    "backgroundColor": ibOrgItemStyle.backgroundColor.normal,
                    "borderWidth": "1",
                    "borderColor": ibOrgItemStyle.borderColor.normal,
                    "borderRadius": "6",
                    "selectionBorderWidth" : ibOrgItemStyle.selection.width,
                    "selectionBorderColor" : ibOrgItemStyle.selection.background,
                    "selectionBorderOpacity" : ibOrgItemStyle.selection.opacity,
                    "width": 120,
                    "height": 57
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnm",
                        "verticalAlign": "center",
                        "maxLines": 10,
                        "style": {
                        	"backgroundColor": ibOrgItemStyle.backgroundColor.normal,
                            "borderRadius": "4 4 0 0",
                            "width": 119,
                            "height": 30,
                            "fontColor": ibOrgItemStyle.color.normal,
                            "fontWeight": "bold",
                            "fontSize": "11px",
                            "cursor": "pointer",
                            "position": "1 0 0 0"
                        }
                    }
                    ,
                    {
                        "type": "text",
                        "binding": "chief_position_nm",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "#F2FAFD",
                            "borderRadius": "0 0 0 4",
                            "width": 50,
                            "height": 25,
                            "fontColor": "#676767",
                            "fontWeight": "bold",
                            "fontSize": "11px",
                            "cursor": "pointer",
                            "position": "1 32 0 0"
                        }
                    }
                    ,
                    {
                        "type": "text",
                        "binding": "chief_nm",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "#fff",
                            "borderRadius": "0 0 4 0",
                            "width": 69,
                            "height": 25,
                            "fontColor": "#000",
                            "fontWeight": "bold",
                            "fontSize": "11px",
                            "cursor": "pointer",
                            "position": "51 32 0 0"
                        }
                    }
                ]
            }
    		,
            "Org_Move": {
                "style": {
                    "backgroundColor": ibOrgItemStyle.backgroundColor.move,
                    "borderWidth": "1",
                    "borderColor": ibOrgItemStyle.borderColor.move,
                    "borderRadius": "6",
                    "selectionBorderWidth" : ibOrgItemStyle.selection.width,
                    "selectionBorderColor" : ibOrgItemStyle.selection.background,
                    "selectionBorderOpacity" : ibOrgItemStyle.selection.opacity,
                    "width": 120,
                    "height": 57
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnm",
                        "verticalAlign": "center",
                        "maxLines": 10,
                        "style": {
                        	"backgroundColor": ibOrgItemStyle.backgroundColor.move,
                            "borderRadius": "4 4 0 0",
                            "width": 119,
                            "height": 30,
                            "fontColor": ibOrgItemStyle.color.move,
                            "fontWeight": "bold",
                            "fontSize": "11px",
                            "cursor": "pointer",
                            "position": "1 0 0 0"
                        }
                    }
                    ,
                    {
                        "type": "text",
                        "binding": "chief_position_nm",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "#F2FAFD",
                            "borderRadius": "0 0 0 4",
                            "width": 50,
                            "height": 25,
                            "fontColor": "#676767",
                            "fontWeight": "bold",
                            "fontSize": "11px",
                            "cursor": "pointer",
                            "position": "1 32 0 0"
                        }
                    }
                    ,
                    {
                        "type": "text",
                        "binding": "chief_nm",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "#fff",
                            "borderRadius": "0 0 4 0",
                            "width": 69,
                            "height": 25,
                            "fontColor": "#000",
                            "fontWeight": "bold",
                            "fontSize": "11px",
                            "cursor": "pointer",
                            "position": "51 32 0 0"
                        }
                    }
                ]
            }
            ,
            "Org_Close": {
                "style": {
                    "backgroundColor": ibOrgItemStyle.backgroundColor.close,
                    "borderWidth": "1",
                    "borderColor": ibOrgItemStyle.borderColor.close,
                    "borderRadius": "6",
                    "selectionBorderWidth" : ibOrgItemStyle.selection.width,
                    "selectionBorderColor" : ibOrgItemStyle.selection.background,
                    "selectionBorderOpacity" : ibOrgItemStyle.selection.opacity,
                    "width": 120,
                    "height": 57
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnm",
                        "verticalAlign": "center",
                        "maxLines": 10,
                        "style": {
                        	"backgroundColor": ibOrgItemStyle.backgroundColor.close,
                            "borderRadius": "4 4 0 0",
                            "width": 119,
                            "height": 30,
                            "fontColor": ibOrgItemStyle.color.close,
                            "fontWeight": "bold",
                            "fontSize": "11px",
                            "cursor": "pointer",
                            "position": "1 0 0 0"
                        }
                    }
                    ,
                    {
                        "type": "text",
                        "binding": "chief_position_nm",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "#F2FAFD",
                            "borderRadius": "0 0 0 4",
                            "width": 50,
                            "height": 25,
                            "fontColor": "#676767",
                            "fontWeight": "bold",
                            "fontSize": "11px",
                            "cursor": "pointer",
                            "position": "1 32 0 0"
                        }
                    }
                    ,
                    {
                        "type": "text",
                        "binding": "chief_nm",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "#fff",
                            "borderRadius": "0 0 4 0",
                            "width": 69,
                            "height": 25,
                            "fontColor": "#000",
                            "fontWeight": "bold",
                            "fontSize": "11px",
                            "cursor": "pointer",
                            "position": "51 32 0 0"
                        }
                    }
                ]
            }
            ,
            "Org_Focus": {
                "style": {
                    "backgroundColor": ibOrgItemStyle.backgroundColor.focus,
                    "borderWidth": "1",
                    "borderColor": ibOrgItemStyle.borderColor.focus,
                    "borderRadius": "6",
                    "selectionBorderWidth" : ibOrgItemStyle.selection.width,
                    "selectionBorderColor" : ibOrgItemStyle.selection.background,
                    "selectionBorderOpacity" : ibOrgItemStyle.selection.opacity,
                    "width": 120,
                    "height": 57
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnm",
                        "verticalAlign": "center",
                        "maxLines": 10,
                        "style": {
                        	"backgroundColor": ibOrgItemStyle.backgroundColor.focus,
                            "borderRadius": "4 4 0 0",
                            "width": 119,
                            "height": 30,
                            "fontColor": ibOrgItemStyle.color.focus,
                            "fontWeight": "bold",
                            "fontSize": "11px",
                            "cursor": "pointer",
                            "position": "1 0 0 0"
                        }
                    }
                    ,
                    {
                        "type": "text",
                        "binding": "chief_position_nm",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "#F2FAFD",
                            "borderRadius": "0 0 0 4",
                            "width": 50,
                            "height": 25,
                            "fontColor": "#676767",
                            "fontWeight": "bold",
                            "fontSize": "11px",
                            "cursor": "pointer",
                            "position": "1 32 0 0"
                        }
                    }
                    ,
                    {
                        "type": "text",
                        "binding": "chief_nm",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "#fff",
                            "borderRadius": "0 0 4 0",
                            "width": 69,
                            "height": 25,
                            "fontColor": "#000",
                            "fontWeight": "bold",
                            "fontSize": "11px",
                            "cursor": "pointer",
                            "position": "51 32 0 0"
                        }
                    }
                ]
            }
            ,
            "Org_Move_Focus": {
                "style": {
                    "backgroundColor": ibOrgItemStyle.backgroundColor.focus,
                    "borderWidth": "1",
                    "borderColor": ibOrgItemStyle.borderColor.focus,
                    "borderRadius": "6",
                    "selectionBorderWidth" : ibOrgItemStyle.selection.width,
                    "selectionBorderColor" : ibOrgItemStyle.selection.background,
                    "selectionBorderOpacity" : ibOrgItemStyle.selection.opacity,
                    "width": 120,
                    "height": 57
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnm",
                        "verticalAlign": "center",
                        "maxLines": 10,
                        "style": {
                        	"backgroundColor": ibOrgItemStyle.backgroundColor.focus,
                            "borderRadius": "4 4 0 0",
                            "width": 119,
                            "height": 30,
                            "fontColor": ibOrgItemStyle.color.focus,
                            "fontWeight": "bold",
                            "fontSize": "11px",
                            "cursor": "pointer",
                            "position": "1 0 0 0"
                        }
                    }
                    ,
                    {
                        "type": "text",
                        "binding": "chief_position_nm",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "#F2FAFD",
                            "borderRadius": "0 0 0 4",
                            "width": 50,
                            "height": 25,
                            "fontColor": "#676767",
                            "fontWeight": "bold",
                            "fontSize": "11px",
                            "cursor": "pointer",
                            "position": "1 32 0 0"
                        }
                    }
                    ,
                    {
                        "type": "text",
                        "binding": "chief_nm",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "#fff",
                            "borderRadius": "0 0 4 0",
                            "width": 69,
                            "height": 25,
                            "fontColor": "#000",
                            "fontWeight": "bold",
                            "fontSize": "11px",
                            "cursor": "pointer",
                            "position": "51 32 0 0"
                        }
                    }
                ]
            }
            ,
            "Org_Close_Focus": {
                "style": {
                    "backgroundColor": ibOrgItemStyle.backgroundColor.focus,
                    "borderWidth": "1",
                    "borderColor": ibOrgItemStyle.borderColor.focus,
                    "borderRadius": "6",
                    "selectionBorderWidth" : ibOrgItemStyle.selection.width,
                    "selectionBorderColor" : ibOrgItemStyle.selection.background,
                    "selectionBorderOpacity" : ibOrgItemStyle.selection.opacity,
                    "width": 120,
                    "height": 57
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnm",
                        "verticalAlign": "center",
                        "maxLines": 10,
                        "style": {
                        	"backgroundColor": ibOrgItemStyle.backgroundColor.focus,
                            "borderRadius": "4 4 0 0",
                            "width": 119,
                            "height": 30,
                            "fontColor": ibOrgItemStyle.color.focus,
                            "fontWeight": "bold",
                            "fontSize": "11px",
                            "cursor": "pointer",
                            "position": "1 0 0 0"
                        }
                    }
                    ,
                    {
                        "type": "text",
                        "binding": "chief_position_nm",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "#F2FAFD",
                            "borderRadius": "0 0 0 4",
                            "width": 50,
                            "height": 25,
                            "fontColor": "#676767",
                            "fontWeight": "bold",
                            "fontSize": "11px",
                            "cursor": "pointer",
                            "position": "1 32 0 0"
                        }
                    }
                    ,
                    {
                        "type": "text",
                        "binding": "chief_nm",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "#fff",
                            "borderRadius": "0 0 4 0",
                            "width": 69,
                            "height": 25,
                            "fontColor": "#000",
                            "fontWeight": "bold",
                            "fontSize": "11px",
                            "cursor": "pointer",
                            "position": "51 32 0 0"
                        }
                    }
                ]
            }
            ,
            "Org2": {
                "style": {
                    "backgroundColor": ibOrgItemStyle.backgroundColor.normal,
                    "borderWidth": "0",
                    "borderColor": ibOrgItemStyle.borderColor.normal,
                    "borderRadius": "6",
                    "selectionBorderWidth" : ibOrgItemStyle.selection.width,
                    "selectionBorderColor" : ibOrgItemStyle.selection.background,
                    "selectionBorderOpacity" : ibOrgItemStyle.selection.opacity,
                    "width": 120,
                    "height": 32
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnm",
                        "verticalAlign": "center",
                        "maxLines": 10,
                        "style": {
                        	"backgroundColor": ibOrgItemStyle.backgroundColor.normal,
                            "borderRadius": "4",
                            "width": 119,
                            "height": 30,
                            "fontColor": ibOrgItemStyle.color.normal,
                            "fontWeight": "bold",
                            "fontSize": "11px",
                            "cursor": "pointer",
                            "position": "1 0 0 0"
                        }
                    }
                ]
            }
            ,
            "Org2_Move": {
                "style": {
                    "backgroundColor": ibOrgItemStyle.backgroundColor.move,
                    "borderWidth": "1",
                    "borderColor": ibOrgItemStyle.borderColor.move,
                    "borderRadius": "6",
                    "selectionBorderWidth" : ibOrgItemStyle.selection.width,
                    "selectionBorderColor" : ibOrgItemStyle.selection.background,
                    "selectionBorderOpacity" : ibOrgItemStyle.selection.opacity,
                    "width": 120,
                    "height": 32
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnm",
                        "verticalAlign": "center",
                        "maxLines": 10,
                        "style": {
                        	"backgroundColor": ibOrgItemStyle.backgroundColor.move,
                            "borderRadius": "4",
                            "width": 119,
                            "height": 30,
                            "fontColor": ibOrgItemStyle.color.move,
                            "fontWeight": "bold",
                            "fontSize": "11px",
                            "cursor": "pointer",
                            "position": "1 0 0 0"
                        }
                    }
                ]
            }
            ,
            "Org2_Close": {
                "style": {
                    "backgroundColor": ibOrgItemStyle.backgroundColor.close,
                    "borderWidth": "1",
                    "borderColor": ibOrgItemStyle.borderColor.close,
                    "borderRadius": "6",
                    "selectionBorderWidth" : ibOrgItemStyle.selection.width,
                    "selectionBorderColor" : ibOrgItemStyle.selection.background,
                    "selectionBorderOpacity" : ibOrgItemStyle.selection.opacity,
                    "width": 120,
                    "height": 32
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnm",
                        "verticalAlign": "center",
                        "maxLines": 10,
                        "style": {
                        	"backgroundColor": ibOrgItemStyle.backgroundColor.close,
                            "borderRadius": "4",
                            "width": 119,
                            "height": 30,
                            "fontColor": ibOrgItemStyle.color.close,
                            "fontWeight": "bold",
                            "fontSize": "11px",
                            "cursor": "pointer",
                            "position": "1 0 0 0"
                        }
                    }
                ]
            }
            ,
            "Org2_Focus": {
                "style": {
                    "backgroundColor": ibOrgItemStyle.backgroundColor.focus,
                    "borderWidth": "0",
                    "borderColor": ibOrgItemStyle.borderColor.focus,
                    "borderRadius": "6",
                    "selectionBorderWidth" : ibOrgItemStyle.selection.width,
                    "selectionBorderColor" : ibOrgItemStyle.selection.background,
                    "selectionBorderOpacity" : ibOrgItemStyle.selection.opacity,
                    "width": 120,
                    "height": 32
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnm",
                        "verticalAlign": "center",
                        "maxLines": 10,
                        "style": {
                        	"backgroundColor": ibOrgItemStyle.backgroundColor.focus,
                            "borderRadius": "4",
                            "width": 119,
                            "height": 30,
                            "fontColor": ibOrgItemStyle.color.focus,
                            "fontWeight": "bold",
                            "fontSize": "11px",
                            "cursor": "pointer",
                            "position": "1 0 0 0"
                        }
                    }
                ]
            }
            ,
            "Org2_Move_Focus": {
                "style": {
                    "backgroundColor": ibOrgItemStyle.backgroundColor.focus,
                    "borderWidth": "0",
                    "borderColor": ibOrgItemStyle.borderColor.focus,
                    "borderRadius": "6",
                    "selectionBorderWidth" : ibOrgItemStyle.selection.width,
                    "selectionBorderColor" : ibOrgItemStyle.selection.background,
                    "selectionBorderOpacity" : ibOrgItemStyle.selection.opacity,
                    "width": 120,
                    "height": 32
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnm",
                        "verticalAlign": "center",
                        "maxLines": 10,
                        "style": {
                        	"backgroundColor": ibOrgItemStyle.backgroundColor.focus,
                            "borderRadius": "4",
                            "width": 119,
                            "height": 30,
                            "fontColor": ibOrgItemStyle.color.focus,
                            "fontWeight": "bold",
                            "fontSize": "11px",
                            "cursor": "pointer",
                            "position": "1 0 0 0"
                        }
                    }
                ]
            }
            ,
            "Org2_Close_Focus": {
                "style": {
                    "backgroundColor": ibOrgItemStyle.backgroundColor.focus,
                    "borderWidth": "0",
                    "borderColor": ibOrgItemStyle.borderColor.focus,
                    "borderRadius": "6",
                    "selectionBorderWidth" : ibOrgItemStyle.selection.width,
                    "selectionBorderColor" : ibOrgItemStyle.selection.background,
                    "selectionBorderOpacity" : ibOrgItemStyle.selection.opacity,
                    "width": 120,
                    "height": 32
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnm",
                        "verticalAlign": "center",
                        "maxLines": 10,
                        "style": {
                        	"backgroundColor": ibOrgItemStyle.backgroundColor.focus,
                            "borderRadius": "4",
                            "width": 119,
                            "height": 30,
                            "fontColor": ibOrgItemStyle.color.focus,
                            "fontWeight": "bold",
                            "fontSize": "11px",
                            "cursor": "pointer",
                            "position": "1 0 0 0"
                        }
                    }
                ]
            }
            ,
            "VertLeader": {
                "style": {
                    "backgroundColor": ibOrgItemStyle.backgroundColor.normal,
                    "borderWidth": "1",
                    "borderColor": ibOrgItemStyle.borderColor.normal,
                    "borderRadius": "6",
                    "selectionBorderWidth" : ibOrgItemStyle.selection.width,
                    "selectionBorderColor" : ibOrgItemStyle.selection.background,
                    "selectionBorderOpacity" : ibOrgItemStyle.selection.opacity,
                    "height": 150,
                    "width": 60
                },
                "units": [
                    {
                    	"type": "text",
                        "binding": "deptnm",
                        "verticalAlign": "center",
                        "forceWrap": "true",
                        "maxLines": 10,
                        "style": {
                            "backgroundColor": ibOrgItemStyle.backgroundColor.normal,
                            "borderRadius": "4 4 0 0",
                            "width": 29,
                            "height": 150,
                            "fontColor": ibOrgItemStyle.color.normal,
                            "fontWeight": "bold",
                            "fontSize": "11px",
                            "cursor": "pointer",
                            "position": "1 0 0 0"
                        }
                    },
                    {
                    	"type": "text",
                        "binding": "chief_position_nm",
                        "forceWrap": "true",
                        "style": {
                              "backgroundColor": "#F2FAFD",
                              "borderRadius": "0 4 0 0",
                              "width": 29,
                              "height": 70,
                              "fontColor": "#676767",
                              "fontWeight": "bold",
                              "fontSize": "11px",
                              "cursor": "pointer",
                              "position": "31 1 0 0"
                        }
                    },
                    {
                    	"type": "text",
                        "binding": "chief_nm",
                        "forceWrap": "true",
                        "style": {
                              "backgroundColor": "#fff",
                              "borderRadius": "0 0 4 0",
                              "width": 29,
                              "height": 80,
                              "fontColor": "#000",
                              "fontWeight": "bold",
                              "fontSize": "11px",
                              "cursor": "pointer",
                              "position": "31 70 0 0"
                        }
                    }
                ]
            }
            ,
            "VertLeader_Move": {
                "style": {
                    "backgroundColor": ibOrgItemStyle.backgroundColor.move,
                    "borderColor": ibOrgItemStyle.borderColor.move,
                    "borderRadius": "6",
                    "borderWidth": "1",
                    "selectionBorderWidth" : ibOrgItemStyle.selection.width,
                    "selectionBorderColor" : ibOrgItemStyle.selection.background,
                    "selectionBorderOpacity" : ibOrgItemStyle.selection.opacity,
                    "height": 150,
                    "width": 60
                },
                "units": [
                    {
                    	"type": "text",
                        "binding": "deptnm",
                        "verticalAlign": "center",
                        "forceWrap": "true",
                        "maxLines": 10,
                        "style": {
                            "backgroundColor": ibOrgItemStyle.backgroundColor.move,
                            "borderRadius": "4 4 0 0",
                            "width": 29,
                            "height": 150,
                            "fontColor": ibOrgItemStyle.color.move,
                            "fontWeight": "bold",
                            "fontSize": "11px",
                            "cursor": "pointer",
                            "position": "1 0 0 0"
                        }
                    },
                    {
                    	"type": "text",
                        "binding": "chief_position_nm",
                        "forceWrap": "true",
                        "style": {
                              "backgroundColor": "#F2FAFD",
                              "borderRadius": "0 4 0 0",
                              "width": 29,
                              "height": 70,
                              "fontColor": "#676767",
                              "fontWeight": "bold",
                              "fontSize": "11px",
                              "cursor": "pointer",
                              "position": "31 1 0 0"
                        }
                    },
                    {
                    	"type": "text",
                        "binding": "chief_nm",
                        "forceWrap": "true",
                        "style": {
                              "backgroundColor": "#fff",
                              "borderRadius": "0 0 4 0",
                              "width": 29,
                              "height": 80,
                              "fontColor": "#000",
                              "fontWeight": "bold",
                              "fontSize": "11px",
                              "cursor": "pointer",
                              "position": "31 70 0 0"
                        }
                    }
                ]
              }
              ,
              "VertLeader_Close": {
                  "style": {
                      "backgroundColor": ibOrgItemStyle.backgroundColor.close,
                      "borderColor": ibOrgItemStyle.borderColor.close,
                      "borderRadius": "6",
                      "borderWidth": "1",
                      "selectionBorderWidth" : ibOrgItemStyle.selection.width,
                      "selectionBorderColor" : ibOrgItemStyle.selection.background,
                      "selectionBorderOpacity" : ibOrgItemStyle.selection.opacity,
                      "height": 150,
                      "width": 60
                  },
                  "units": [
                      {
                      	"type": "text",
                          "binding": "deptnm",
                          "verticalAlign": "center",
                          "forceWrap": "true",
                          "maxLines": 10,
                          "style": {
                              "backgroundColor": ibOrgItemStyle.backgroundColor.close,
                              "borderRadius": "4 4 0 0",
                              "width": 29,
                              "height": 150,
                              "fontColor": ibOrgItemStyle.color.close,
                              "fontWeight": "bold",
                              "fontSize": "11px",
                              "cursor": "pointer",
                              "position": "1 0 0 0"
                          }
                      },
                      {
                      	"type": "text",
                          "binding": "chief_position_nm",
                          "forceWrap": "true",
                          "style": {
                                "backgroundColor": "#F2FAFD",
                                "borderRadius": "0 4 0 0",
                                "width": 29,
                                "height": 70,
                                "fontColor": "#676767",
                                "fontWeight": "bold",
                                "fontSize": "11px",
                                "cursor": "pointer",
                                "position": "31 1 0 0"
                          }
                      },
                      {
                      	"type": "text",
                          "binding": "chief_nm",
                          "forceWrap": "true",
                          "style": {
                                "backgroundColor": "#fff",
                                "borderRadius": "0 0 4 0",
                                "width": 29,
                                "height": 80,
                                "fontColor": "#000",
                                "fontWeight": "bold",
                                "fontSize": "11px",
                                "cursor": "pointer",
                                "position": "31 70 0 0"
                          }
                      }
                  ]
              }
              ,
              "VertLeader_Focus": {
                  "style": {
                      "backgroundColor": ibOrgItemStyle.backgroundColor.focus,
                      "borderColor": ibOrgItemStyle.borderColor.focus,
                      "borderRadius": "6",
                      "borderWidth": "1",
                      "selectionBorderWidth" : ibOrgItemStyle.selection.width,
                      "selectionBorderColor" : ibOrgItemStyle.selection.background,
                      "selectionBorderOpacity" : ibOrgItemStyle.selection.opacity,
                      "height": 150,
                      "width": 60
                  },
                  "units": [
                      {
                      	"type": "text",
                          "binding": "deptnm",
                          "verticalAlign": "center",
                          "forceWrap": "true",
                          "maxLines": 10,
                          "style": {
                              "backgroundColor": ibOrgItemStyle.backgroundColor.focus,
                              "borderRadius": "4 4 0 0",
                              "width": 29,
                              "height": 150,
                              "fontColor": ibOrgItemStyle.color.focus,
                              "fontWeight": "bold",
                              "fontSize": "11px",
                              "cursor": "pointer",
                              "position": "1 0 0 0"
                          }
                      },
                      {
                      	"type": "text",
                          "binding": "chief_position_nm",
                          "forceWrap": "true",
                          "style": {
                                "backgroundColor": "#F2FAFD",
                                "borderRadius": "0 4 0 0",
                                "width": 29,
                                "height": 70,
                                "fontColor": "#676767",
                                "fontWeight": "bold",
                                "fontSize": "11px",
                                "cursor": "pointer",
                                "position": "31 1 0 0"
                          }
                      },
                      {
                      	"type": "text",
                          "binding": "chief_nm",
                          "forceWrap": "true",
                          "style": {
                                "backgroundColor": "#fff",
                                "borderRadius": "0 0 4 0",
                                "width": 29,
                                "height": 80,
                                "fontColor": "#000",
                                "fontWeight": "bold",
                                "fontSize": "11px",
                                "cursor": "pointer",
                                "position": "31 70 0 0"
                          }
                      }
                  ]
              }
              ,
              "VertLeader_Move_Focus": {
                  "style": {
                      "backgroundColor": ibOrgItemStyle.backgroundColor.focus,
                      "borderColor": ibOrgItemStyle.borderColor.focus,
                      "borderRadius": "6",
                      "borderWidth": "1",
                      "selectionBorderWidth" : ibOrgItemStyle.selection.width,
                      "selectionBorderColor" : ibOrgItemStyle.selection.background,
                      "selectionBorderOpacity" : ibOrgItemStyle.selection.opacity,
                      "height": 150,
                      "width": 60
                  },
                  "units": [
                      {
                      	"type": "text",
                          "binding": "deptnm",
                          "verticalAlign": "center",
                          "forceWrap": "true",
                          "maxLines": 10,
                          "style": {
                              "backgroundColor": ibOrgItemStyle.backgroundColor.focus,
                              "borderRadius": "4 4 0 0",
                              "width": 29,
                              "height": 150,
                              "fontColor": ibOrgItemStyle.color.focus,
                              "fontWeight": "bold",
                              "fontSize": "11px",
                              "cursor": "pointer",
                              "position": "1 0 0 0"
                          }
                      },
                      {
                      	"type": "text",
                          "binding": "chief_position_nm",
                          "forceWrap": "true",
                          "style": {
                                "backgroundColor": "#F2FAFD",
                                "borderRadius": "0 4 0 0",
                                "width": 29,
                                "height": 70,
                                "fontColor": "#676767",
                                "fontWeight": "bold",
                                "fontSize": "11px",
                                "cursor": "pointer",
                                "position": "31 1 0 0"
                          }
                      },
                      {
                      	"type": "text",
                          "binding": "chief_nm",
                          "forceWrap": "true",
                          "style": {
                                "backgroundColor": "#fff",
                                "borderRadius": "0 0 4 0",
                                "width": 29,
                                "height": 80,
                                "fontColor": "#000",
                                "fontWeight": "bold",
                                "fontSize": "11px",
                                "cursor": "pointer",
                                "position": "31 70 0 0"
                          }
                      }
                  ]
              }
              ,
              "VertLeader_Close_Focus": {
                  "style": {
                      "backgroundColor": ibOrgItemStyle.backgroundColor.focus,
                      "borderColor": ibOrgItemStyle.borderColor.focus,
                      "borderRadius": "6",
                      "borderWidth": "1",
                      "selectionBorderWidth" : ibOrgItemStyle.selection.width,
                      "selectionBorderColor" : ibOrgItemStyle.selection.background,
                      "selectionBorderOpacity" : ibOrgItemStyle.selection.opacity,
                      "height": 250,
                      "width": 60
                  },
                  "units": [
                      {
                      	"type": "text",
                          "binding": "deptnm",
                          "verticalAlign": "center",
                          "forceWrap": "true",
                          "maxLines": 10,
                          "style": {
                              "backgroundColor": ibOrgItemStyle.backgroundColor.focus,
                              "borderRadius": "4 4 0 0",
                              "width": 29,
                              "height": 150,
                              "fontColor": ibOrgItemStyle.color.focus,
                              "fontWeight": "bold",
                              "fontSize": "11px",
                              "cursor": "pointer",
                              "position": "1 0 0 0"
                          }
                      },
                      {
                      	"type": "text",
                          "binding": "chief_position_nm",
                          "forceWrap": "true",
                          "style": {
                                "backgroundColor": "#F2FAFD",
                                "borderRadius": "0 4 0 0",
                                "width": 29,
                                "height": 70,
                                "fontColor": "#676767",
                                "fontWeight": "bold",
                                "fontSize": "11px",
                                "cursor": "pointer",
                                "position": "31 1 0 0"
                          }
                      },
                      {
                      	"type": "text",
                          "binding": "chief_nm",
                          "forceWrap": "true",
                          "style": {
                                "backgroundColor": "#fff",
                                "borderRadius": "0 0 4 0",
                                "width": 29,
                                "height": 80,
                                "fontColor": "#000",
                                "fontWeight": "bold",
                                "fontSize": "11px",
                                "cursor": "pointer",
                                "position": "31 70 0 0"
                          }
                      }
                  ]
              }
              ,
              "VertOrg": {
                  "style": {
                      "backgroundColor": ibOrgItemStyle.backgroundColor.normal,
                      "borderWidth": "1",
                      "borderColor": ibOrgItemStyle.borderColor.normal,
                      "borderRadius": "6",
                      "selectionBorderWidth" : ibOrgItemStyle.selection.width,
                      "selectionBorderColor" : ibOrgItemStyle.selection.background,
                      "selectionBorderOpacity" : ibOrgItemStyle.selection.opacity,
                      "width": 30,
                      "height": 150
                  },
                  "units": [
                      {
                          "type": "text",
                          "binding": "deptnm",
                          "verticalAlign": "center",
                          "forceWrap": "true",
                          "maxLines": 10,
                          "style": {
                              "backgroundColor": ibOrgItemStyle.backgroundColor.normal,
                              "borderRadius": "4",
                              "width": 29,
                              "height": 148,
                              "fontWeight": "bold",
                              "fontColor": ibOrgItemStyle.color.normal,
                              "fontSize": "11px",
                              "cursor": "pointer",
                              "position": "1 1 0 0"
                          }
                      }
                  ]
              }
              ,
              "VertOrg_Move": {
                  "style": {
                      "backgroundColor": ibOrgItemStyle.backgroundColor.move,
                      "borderWidth": "1",
                      "borderColor": ibOrgItemStyle.borderColor.move,
                      "borderRadius": "6",
                      "selectionBorderWidth" : ibOrgItemStyle.selection.width,
                      "selectionBorderColor" : ibOrgItemStyle.selection.background,
                      "selectionBorderOpacity" : ibOrgItemStyle.selection.opacity,
                      "width": 30,
                      "height": 150
                  },
                  "units": [
                      {
                          "type": "text",
                          "binding": "deptnm",
                          "verticalAlign": "center",
                          "forceWrap": "true",
                          "maxLines": 10,
                          "style": {
                              "backgroundColor": ibOrgItemStyle.backgroundColor.move,
                              "borderRadius": "4",
                              "width": 29,
                              "height": 148,
                              "fontWeight": "bold",
                              "fontColor": ibOrgItemStyle.color.move,
                              "fontSize": "11px",
                              "cursor": "pointer",
                              "position": "1 1 0 0"
                          }
                      }
                  ]
              }
              ,
              "VertOrg_Close": {
                  "style": {
                      "backgroundColor": ibOrgItemStyle.backgroundColor.close,
                      "borderWidth": "1",
                      "borderColor": ibOrgItemStyle.borderColor.close,
                      "borderRadius": "6",
                      "selectionBorderWidth" : ibOrgItemStyle.selection.width,
                      "selectionBorderColor" : ibOrgItemStyle.selection.background,
                      "selectionBorderOpacity" : ibOrgItemStyle.selection.opacity,
                      "width": 30,
                      "height": 150
                  },
                  "units": [
                      {
                          "type": "text",
                          "binding": "deptnm",
                          "verticalAlign": "center",
                          "forceWrap": "true",
                          "maxLines": 10,
                          "style": {
                              "backgroundColor": ibOrgItemStyle.backgroundColor.close,
                              "borderRadius": "4",
                              "width": 29,
                              "height": 148,
                              "fontWeight": "bold",
                              "fontColor": ibOrgItemStyle.color.close,
                              "fontSize": "11px",
                              "cursor": "pointer",
                              "position": "1 1 0 0"
                          }
                      }
                  ]
              }
              ,
              "VertOrg_Focus": {
                  "style": {
                      "backgroundColor": ibOrgItemStyle.backgroundColor.focus,
                      "borderWidth": "1",
                      "borderColor": ibOrgItemStyle.borderColor.focus,
                      "borderRadius": "6",
                      "selectionBorderWidth" : ibOrgItemStyle.selection.width,
                      "selectionBorderColor" : ibOrgItemStyle.selection.background,
                      "selectionBorderOpacity" : ibOrgItemStyle.selection.opacity,
                      "width": 30,
                      "height": 150
                  },
                  "units": [
                      {
                          "type": "text",
                          "binding": "deptnm",
                          "verticalAlign": "center",
                          "forceWrap": "true",
                          "maxLines": 10,
                          "style": {
                              "backgroundColor": ibOrgItemStyle.backgroundColor.focus,
                              "borderRadius": "4",
                              "width": 29,
                              "height": 148,
                              "fontWeight": "bold",
                              "fontColor": ibOrgItemStyle.color.focus,
                              "fontSize": "11px",
                              "cursor": "pointer",
                              "position": "1 1 0 0"
                          }
                      }
                  ]
              }
              ,
              "VertOrg_Move_Focus": {
                  "style": {
                      "backgroundColor": ibOrgItemStyle.backgroundColor.focus,
                      "borderWidth": "1",
                      "borderColor": ibOrgItemStyle.borderColor.focus,
                      "borderRadius": "6",
                      "selectionBorderWidth" : ibOrgItemStyle.selection.width,
                      "selectionBorderColor" : ibOrgItemStyle.selection.background,
                      "selectionBorderOpacity" : ibOrgItemStyle.selection.opacity,
                      "width": 30,
                      "height": 150
                  },
                  "units": [
                      {
                          "type": "text",
                          "binding": "deptnm",
                          "verticalAlign": "center",
                          "forceWrap": "true",
                          "maxLines": 10,
                          "style": {
                              "backgroundColor": ibOrgItemStyle.backgroundColor.focus,
                              "borderRadius": "4",
                              "width": 29,
                              "height": 148,
                              "fontWeight": "bold",
                              "fontColor": ibOrgItemStyle.color.focus,
                              "fontSize": "11px",
                              "cursor": "pointer",
                              "position": "1 1 0 0"
                          }
                      }
                  ]
              }
              ,
              "VertOrg_Close_Focus": {
                  "style": {
                      "backgroundColor": ibOrgItemStyle.backgroundColor.focus,
                      "borderWidth": "1",
                      "borderColor": ibOrgItemStyle.borderColor.focus,
                      "borderRadius": "6",
                      "selectionBorderWidth" : ibOrgItemStyle.selection.width,
                      "selectionBorderColor" : ibOrgItemStyle.selection.background,
                      "selectionBorderOpacity" : ibOrgItemStyle.selection.opacity,
                      "width": 30,
                      "height": 150
                  },
                  "units": [
                      {
                          "type": "text",
                          "binding": "deptnm",
                          "verticalAlign": "center",
                          "forceWrap": "true",
                          "maxLines": 10,
                          "style": {
                              "backgroundColor": ibOrgItemStyle.backgroundColor.focus,
                              "borderRadius": "4",
                              "width": 29,
                              "height": 148,
                              "fontWeight": "bold",
                              "fontColor": ibOrgItemStyle.color.focus,
                              "fontSize": "11px",
                              "cursor": "pointer",
                              "position": "1 1 0 0"
                          }
                      }
                  ]
              }
        }
    },
    "orgData": []
}