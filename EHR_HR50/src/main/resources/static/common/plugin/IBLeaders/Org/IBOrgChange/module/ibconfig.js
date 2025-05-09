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
                "code": "position_name",
                "type": "string",
                "name": "직급",
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
                    "backgroundColor": "#B5BECC",
                    "borderWidth": "1",
                    "borderColor": "#8998A4",
                    "borderRadius": "5",
                    "width": 120,
                    "height": 63
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnm",
                        "verticalAlign": "center",
                        "maxLines": 10,
                        "style": {
                        	"backgroundColor": "#64b9F0, #4d8fbb",
                            "borderRadius": "5 5 0 0",
                            "width": 119,
                            "height": 30,
                            "fontColor": "#fff",
                            "fontWeight": "bold",
                            "fontSize": 13,
                            "cursor": "pointer",
                            "position": "0 0"
                        }
                    }
                    ,
                    {
                        "type": "text",
                        "binding": "position_name",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "white",
                            "borderRadius": "0 0 5 5",
                            "width": 119,
                            "height": 30,
                            "fontColor": "#000",
                            "fontWeight": "bold",
                            "fontSize": 13,
                            "cursor": "pointer",
                            "position": "0 31"
                        }
                    }
                ]
            }
    		,
            "Org_Move": {
                "style": {
                    "backgroundColor": "#B5BECC",
                    "borderWidth": "1",
                    "borderColor": "#8998A4",
                    "borderRadius": "5",
                    "width": 120,
                    "height": 63
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnm",
                        "verticalAlign": "center",
                        "maxLines": 10,
                        "style": {
                        	"backgroundColor": "yellow",
                            "borderRadius": "5 5 0 0",
                            "width": 119,
                            "height": 30,
                            "fontColor": "#000",
                            "fontWeight": "bold",
                            "fontSize": 13,
                            "cursor": "pointer",
                            "position": "0 0"
                        }
                    }
                    ,
                    {
                        "type": "text",
                        "binding": "position_name",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "white",
                            "borderRadius": "0 0 5 5",
                            "width": 119,
                            "height": 30,
                            "fontColor": "#000",
                            "fontWeight": "bold",
                            "fontSize": 13,
                            "cursor": "pointer",
                            "position": "0 31"
                        }
                    }
                ]
            }
            ,
            "Org_Close": {
                "style": {
                    "backgroundColor": "#B5BECC",
                    "borderWidth": "1",
                    "borderColor": "#8998A4",
                    "borderRadius": "5",
                    "width": 120,
                    "height": 63
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnm",
                        "verticalAlign": "center",
                        "maxLines": 10,
                        "style": {
                        	"backgroundColor": "red",
                            "borderRadius": "5 5 0 0",
                            "width": 119,
                            "height": 30,
                            "fontColor": "#fff",
                            "fontWeight": "bold",
                            "fontSize": 13,
                            "cursor": "pointer",
                            "position": "0 0"
                        }
                    }
                    ,
                    {
                        "type": "text",
                        "binding": "position_name",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "white",
                            "borderRadius": "0 0 5 5",
                            "width": 119,
                            "height": 30,
                            "fontColor": "#000",
                            "fontWeight": "bold",
                            "fontSize": 13,
                            "cursor": "pointer",
                            "position": "0 31"
                        }
                    }
                ]
            }
            ,
            "Org2": {
                "style": {
                    "backgroundColor": "#B5BECC",
                    "borderWidth": "1",
                    "borderColor": "#8998A4",
                    "borderRadius": "5",
                    "width": 120,
                    "height": 36
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnm",
                        "verticalAlign": "center",
                        "maxLines": 10,
                        "style": {
                        	"backgroundColor": "#64b9F0, #4d8fbb",
                            "borderRadius": "5",
                            "width": 119,
                            "height": 35,
                            "fontColor": "#fff",
                            "fontWeight": "bold",
                            "fontSize": 13,
                            "cursor": "pointer",
                            "position": "0 0"
                        }
                    }
                ]
            }
            ,
            "Org2_Move": {
                "style": {
                    "backgroundColor": "#B5BECC",
                    "borderWidth": "1",
                    "borderColor": "#8998A4",
                    "borderRadius": "5",
                    "width": 120,
                    "height": 36
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnm",
                        "verticalAlign": "center",
                        "maxLines": 10,
                        "style": {
                        	"backgroundColor": "yellow",
                            "borderRadius": "5",
                            "width": 119,
                            "height": 35,
                            "fontColor": "#000",
                            "fontWeight": "bold",
                            "fontSize": 13,
                            "cursor": "pointer",
                            "position": "0 0"
                        }
                    }
                ]
            }
            ,
            "Org2_Close": {
                "style": {
                    "backgroundColor": "#B5BECC",
                    "borderWidth": "1",
                    "borderColor": "#8998A4",
                    "borderRadius": "5",
                    "width": 120,
                    "height": 36
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnm",
                        "verticalAlign": "center",
                        "maxLines": 10,
                        "style": {
                        	"backgroundColor": "red",
                            "borderRadius": "5",
                            "width": 119,
                            "height": 35,
                            "fontColor": "#fff",
                            "fontWeight": "bold",
                            "fontSize": 13,
                            "cursor": "pointer",
                            "position": "0 0"
                        }
                    }
                ]
            }
            ,
            "VertLeader": {
              "units": [
                {
                  "binding": "deptnm",
                  "forceWrap": "true",
                  "maxLines": 10,
                  "style": {
                	"backgroundColor": "#64b9F0, #4d8fbb",
                    "borderColor": "transparent",
                    "borderRadius": "6 6 0 0",
                    "borderWidth": "1",
                    "fontColor": "#FFFFFF",
                    "fontWeight": "bold",
                    "fontSize": 13,
                    "height": 149,
                    "position": "1 1",
                    "width": 28
                  },
                  "type": "text",
                  "verticalAlign": "center"
                },
                {
                  "binding": "position_name",
                  "forceWrap": "true",
                  "style": {
                    "backgroundColor": "transparent",
                    "borderColor": "#3A3A3A",
                    "fontWeight": "bold",
                    "borderRadius": "0",
                    "borderWidth": "0",
                    "fontSize": 13,
                    "height": 149,
                    "position": "1 149",
                    "width": 28
                  },
                  "type": "text"
                }
              ],
              "style": {
                "backgroundColor": "white",
                "borderColor": "#b1b1b1",
                "borderRadius": 8,
                "borderWidth": 1,
                "height": 300,
                "width": 30
              }
            }
            ,
            "VertLeader_Move": {
                "units": [
                  {
                    "binding": "deptnm",
                    "forceWrap": "true",
                    "maxLines": 10,
                    "style": {
                  	"backgroundColor": "yellow",
                      "borderColor": "transparent",
                      "borderRadius": "6 6 0 0",
                      "borderWidth": "1",
                      "fontColor": "#000",
                      "fontWeight": "bold",
                      "fontSize": 13,
                      "height": 149,
                      "position": "1 1",
                      "width": 28
                    },
                    "type": "text",
                    "verticalAlign": "center"
                  },
                  {
                    "binding": "position_name",
                    "forceWrap": "true",
                    "style": {
                      "backgroundColor": "transparent",
                      "borderColor": "#3A3A3A",
                      "fontWeight": "bold",
                      "borderRadius": "0",
                      "borderWidth": "0",
                      "fontSize": 13,
                      "height": 149,
                      "position": "1 149",
                      "width": 28
                    },
                    "type": "text"
                  }
                ],
                "style": {
                  "backgroundColor": "white",
                  "borderColor": "#b1b1b1",
                  "borderRadius": 8,
                  "borderWidth": 1,
                  "height": 300,
                  "width": 30
                }
              }
              ,
              "VertLeader_Close": {
                  "units": [
                    {
                      "binding": "deptnm",
                      "forceWrap": "true",
                      "maxLines": 10,
                      "style": {
                    	"backgroundColor": "red",
                        "borderColor": "transparent",
                        "borderRadius": "6 6 0 0",
                        "borderWidth": "1",
                        "fontColor": "#fff",
                        "fontWeight": "bold",
                        "fontSize": 13,
                        "height": 149,
                        "position": "1 1",
                        "width": 28
                      },
                      "type": "text",
                      "verticalAlign": "center"
                    },
                    {
                      "binding": "position_name",
                      "forceWrap": "true",
                      "style": {
                        "backgroundColor": "transparent",
                        "borderColor": "#3A3A3A",
                        "fontWeight": "bold",
                        "borderRadius": "0",
                        "borderWidth": "0",
                        "fontSize": 13,
                        "height": 149,
                        "position": "1 149",
                        "width": 28
                      },
                      "type": "text"
                    }
                  ],
                  "style": {
                    "backgroundColor": "white",
                    "borderColor": "#b1b1b1",
                    "borderRadius": 8,
                    "borderWidth": 1,
                    "height": 300,
                    "width": 30
                  }
                }
              ,
            "VertOrg": {
                "style": {
                    "backgroundColor": "#B5BECC , #F0F0F0",
                    "borderWidth": "1",
                    "borderColor": "#8998A4",
                    "borderRadius": "5",
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
                        	"backgroundColor": "#64b9F0, #4d8fbb",
                            "borderRadius": "5",
                            "width": 28,
                            "height": 148,
                            "fontWeight": "bold",
                            "fontColor": "#fff",
                            "fontSize": 13,
                            "cursor": "pointer",
                            "position": "1 1"
                        }
                    }
                ]
            }
            ,
            "VertOrg_Move": {
                "style": {
                    "backgroundColor": "#B5BECC , #F0F0F0",
                    "borderWidth": "1",
                    "borderColor": "#8998A4",
                    "borderRadius": "5",
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
                        	"backgroundColor": "yellow",
                            "borderRadius": "5",
                            "width": 28,
                            "height": 148,
                            "fontWeight": "bold",
                            "fontColor": "#000",
                            "fontSize": 13,
                            "cursor": "pointer",
                            "position": "1 1"
                        }
                    }
                ]
            }
            ,
            "VertOrg_Close": {
                "style": {
                    "backgroundColor": "#B5BECC , #F0F0F0",
                    "borderWidth": "1",
                    "borderColor": "#8998A4",
                    "borderRadius": "5",
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
                        	"backgroundColor": "red",
                            "borderRadius": "5",
                            "width": 28,
                            "height": 148,
                            "fontWeight": "bold",
                            "fontColor": "#fff",
                            "fontSize": 13,
                            "cursor": "pointer",
                            "position": "1 1"
                        }
                    }
                ]
            }
            ,
            "PhotoBox": {
                "style": {
                    "backgroundColor": "#E0E0E0, #F0F0F0",
                    "borderWidth": "1",
                    "borderColor": "#b1b1b1",
                    "borderRadius": "5",
                    "width": 90,
                    "height": 150
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnm",
                        "verticalAlign": "center",
                        "style": {
                        	"backgroundColor": "#64b9F0, #4d8fbb",
                            "borderRadius": "4 4 0 0",
                            "width": 89,
                            "height": 26,
                            "fontFamily": "Dotum",
                            "fontColor": "#ffffff",
                            "fontSize": 13,
                            "cursor": "pointer",
                            "position": "1 1"
                        }
                    },
                    {
                        "type": "picture",
                        "binding": "photo",
                        "style": {
                            "backgroundColor": "transparent",
                            "borderWidth": "0",
                            "borderColor": "Gray",
                            "borderRadius": "0",
                            "width": 67,
                            "height": 100,
                            "position": "11 26"
                        }
                    },
                    {
                        "type": "text",
                        "binding": "position",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "transparent",
                            "borderWidth": "0",
                            "width": 45,
                            "height": 25,
                            "fontFamily": "Dotum",
                            "fontColor": "#3A3A3A",
                            "fontSize": 13,
                            "position": "1 123"
                        }
                    },
                    {
                        "type": "text",
                        "binding": "empnm",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "transparent",
                            "borderWidth": "0",
                            "width": 45,
                            "height": 25,
                            "fontFamily": "Dotum",
                            "fontColor": "#3A3A3A",
                            "fontSize": 13,
                            "cursor": "pointer",
                            "position": "46 123"
                        }
                    }
                ]
            },
            "OrgBox": {
                "style": {
                    "backgroundColor": "#E0E0E0, #F0F0F0",
                    "borderWidth": 1,
                    "borderColor": "#b1b1b1",
                    "borderRadius": 5,
                    "width": 140,
                    "height": 50
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnm",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "#e6e6e6, #b1b1b1",
                            "borderRadius": null,
                            "width": 138,
                            "height": 26,
                            "fontFamily": "Dotum",
                            "fontColor": "#ffffff",
                            "fontSize": 13,
                            "cursor": "pointer",
                            "position": "1 1"
                        }
                    },
                    {
                        "type": "text",
                        "binding": "position",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "transparent",
                            "borderWidth": 0,
                            "width": 65,
                            "height": 25,
                            "fontFamily": "Dotum",
                            "fontColor": "#3A3A3A",
                            "fontSize": 13,
                            "position": "8 25"
                        }
                    },
                    {
                        "type": "text",
                        "binding": "empnm",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "transparent",
                            "borderWidth": 0,
                            "width": 65,
                            "height": 25,
                            "fontFamily": "Dotum",
                            "fontColor": "#3A3A3A",
                            "fontSize": 13,
                            "cursor": "pointer",
                            "position": "70 25"
                        }
                    }
                ]
            },
            "GridPhoto": {
                "type": "table",
                "style": {
                    "backgroundColor": "white",
                    "borderWidth": "1",
                    "borderColor": "#b1b1b1",
                    "borderRadius": "5 5 0 0",
                    "selectionBorderWidth": 2,
                    "width": 100
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnm",
                        "horizontalAlign": "center",
                        "style": {
                            "backgroundColor": "#64b9F0, #4d8fbb",
                            "borderRadius": "5 5 0 0",
                            "width": 100,
                            "height": 25,
                            "fontColor": "#fff",
                            "fontSize": 13,
                            "cursor": "pointer",
                            "column": 0,
                            "row": 0
                        }
                    },
                    {
                        "type": "picture",
                        "binding": "photo",
                        "style": {
                            "backgroundColor": "transparent",
                            "borderWidth": "0.5",
                            "borderColor": "PowderBlue",
                            "width": 100,
                            "height": 100,
                            "column": 0,
                            "row": 1
                        }
                    },
                    {
                        "type": "table",
                        "style": {
                            "backgroundColor": "transparent",
                            "borderWidth": "0 0.5 0 0.5",
                            "borderColor": "Gray",
                            "width": 100,
                            "column": 0,
                            "row": 2
                        },
                        "units": [
                            {
                                "type": "text",
                                "binding": "position",
                                "horizontalAlign": "center",
                                "style": {
                                    "backgroundColor": "#ece5cd",
                                    "borderWidth": "0.5",
                                    "borderColor": "PowderBlue",
                                    "width": 50,
                                    "height": 25,
                                    "fontColor": "Black",
                                    "fontSize": 13,
                                    "column": 0,
                                    "row": 0
                                }
                            },
                            {
                                "type": "text",
                                "binding": "empnm",
                                "horizontalAlign": "center",
                                "style": {
                                    "backgroundColor": "#ece5cd",
                                    "borderWidth": "0.5",
                                    "borderColor": "PowderBlue",
                                    "width": 50,
                                    "height": 25,
                                    "fontColor": "Black",
                                    "fontSize": 13,
                                    "column": 1,
                                    "row": 0
                                }
                            }
                        ]
                    },
                    {
                        "type": "list",
                        "style": {
                            "backgroundColor": "transparent",
                            "borderWidth": "0",
                            "borderColor": "Red",
                            "width": 100,
                            "column": 0,
                            "row": 3
                        },
                        "units": [
                            {
                                "type": "table",
                                "style": {
                                    "backgroundColor": "transparent",
                                    "borderWidth": 1,
                                    "borderColor": "#999999",
                                    "width": 99
                                },
                                "units": [
                                    {
                                        "type": "picture",
                                        "binding": "photo",
                                        "style": {
                                            "backgroundColor": "transparent",
                                            "borderWidth": "0",
                                            "borderColor": "PowderBlue",
                                            "width": 50,
                                            "height": 38,
                                            "column": 0,
                                            "row": 0
                                        }
                                    },
                                    {
                                        "type": "table",
                                        "style": {
                                            "backgroundColor": "transparent",
                                            "borderWidth": "0",
                                            "borderColor": "Gray",
                                            "width": 50,
                                            "column": 1,
                                            "row": 0
                                        },
                                        "units": [
                                            {
                                                "type": "text",
                                                "binding": "position",
                                                "horizontalAlign": "center",
                                                "style": {
                                                    "backgroundColor": "WhiteSmoke",
                                                    "borderWidth": "0.5",
                                                    "borderColor": "PowderBlue",
                                                    "width": 50,
                                                    "height": 20,
                                                    "fontColor": "Black",
                                                    "fontSize": 13,
                                                    "column": 0,
                                                    "row": 0
                                                }
                                            },
                                            {
                                                "type": "text",
                                                "binding": "empnm",
                                                "horizontalAlign": "center",
                                                "style": {
                                                    "backgroundColor": "WhiteSmoke",
                                                    "borderWidth": "0.5",
                                                    "borderColor": "PowderBlue",
                                                    "width": 50,
                                                    "height": 20,
                                                    "fontColor": "Black",
                                                    "fontSize": 13,
                                                    "column": 0,
                                                    "row": 1
                                                }
                                            }
                                        ]
                                    }
                                ]
                            }
                        ]
                    },
                    {
                        "type": "table",
                        "style": {
                            "backgroundColor": "transparent",
                            "borderWidth": "0 0 0 0.5",
                            "borderColor": "Gray",
                            "width": 100,
                            "column": 0,
                            "row": 4
                        },
                        "units": [
                            {
                                "type": "text",
                                "binding": "listcount",
                                "horizontalAlign": "right",
                                "style": {
                                    "backgroundColor": "#c5e0dc",
                                    "borderWidth": "0",
                                    "borderColor": "#3C5A91",
                                    "width": 50,
                                    "height": 20,
                                    "fontColor": "#000",
                                    "fontSize": 13,
                                    "column": 0,
                                    "row": 0
                                }
                            },
                            {
                                "type": "text",
                                "value": "명",
                                "horizontalAlign": "left",
                                "style": {
                                    "backgroundColor": "#c5e0dc",
                                    "borderWidth": "0",
                                    "borderColor": "#3C5A91",
                                    "width": 50,
                                    "height": 20,
                                    "fontColor": "#000",
                                    "fontSize": 13,
                                    "column": 1,
                                    "row": 0
                                }
                            }
                        ]
                    }
                ]
            },
            "Member": {
                "style": {
                    "backgroundColor": "#B5BECC",
                    "borderWidth": "0",
                    "borderColor": "#8998A4",
                    "borderRadius": "10",
                    "width": 80,
                    "height": 40
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "empnm",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "#46649B",
                            "borderWidth": "0",
                            "borderRadius": "10",
                            "width": 79,
                            "height": 35,
                            "fontFamily": "Dotum",
                            "fontColor": "#3A3A3A",
                            "fontSize": 13,
                            "cursor": "pointer",
                            "position": "1 1"
                        }
                    }
                ]
            }
        }
    },
    "orgData": []
}