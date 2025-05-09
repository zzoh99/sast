var _app = navigator.appName;
//var serverURL         = "http://61.111.129.108:8081/DataServer";
var serverURL         = "http://192.168.4.212/DataServer";
if (_app == "Microsoft Internet Explorer") {
				document.write('<object id=rdViewer');
				document.write('  classid="clsid:04931AA4-5D13-442f-AEE8-0F1184002BDD"');
				document.write('  codebase="'+serverURL+'/cab/cxviewer60u.cab#version=6,2,1,59"');
				document.write('  name=rdViewer width=100% height=100% >');				
				document.write('</object>');

				document.write('<OBJECT id="chartdir" classid="5EBD5CA4-BDD9-4CA0-8103-773F365CDCB2"');
				document.write('  codebase="'+serverURL+'/cab/rdchartdir.cab#version=6,1,0,49"');
				document.write('  name="chartdir" width=0% height=0%>  ');
				document.write('</OBJECT>');
}

else{
				navigator.plugins.refresh(false);
				
				if(navigator.mimeTypes["application/x-cxviewer60u"]) {

					var _rdPlugin = navigator.mimeTypes["application/x-cxviewer60u"];
					var installedRdPluginVersion = _rdPlugin.description.substr(_rdPlugin.description.indexOf("version=")+8, 9);

					var rdPluginSetupVersion = "6,2,0,7";
					
					if(installedRdPluginVersion >= rdPluginSetupVersion) {
						
						document.write('<OBJECT id="rdViewer" type="application/x-cxviewer60u" width=100% height=100%></OBJECT>');
					} else {

						//window.location = serverURL +"/plugin/pluginInstall_u.html";
						window.showModalDialog(serverURL +"/plugin/pluginInstall_u.html",'','dialogWidth=640px; dialogHeight=360px; scroll=no; status=no; help=no; center=yes');

					}
				} else {
					//window.location = serverURL+ "/plugin/pluginInstall_u.html";
					window.showModalDialog(serverURL +"/plugin/pluginInstall_u.html",'','dialogWidth=640px; dialogHeight=360px; scroll=no; status=no; help=no; center=yes');
				}
}


		function checkPluginVersion(versionInstalled, versionSetup) {

			var arr_versionInstalled = versionInstalled.split(",");
			var arr_versionSetup = versionSetup.split(",");
			
			for(i=0; i<=3; i++) {

				if(Number(arr_versionInstalled[i]) > Number(arr_versionSetup[i])) {  // do not install
					return 1;
					break;
				} else if(Number(arr_versionInstalled[i]) < Number(arr_versionSetup[i])) { // install
					return 0;
					break;
				}
			}
			return 1;
		}