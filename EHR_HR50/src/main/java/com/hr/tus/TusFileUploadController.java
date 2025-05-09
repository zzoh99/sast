package com.hr.tus;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

/**
 * 샘플 Controller
 *
 * @author isuSystem
 *
 */
@RestController
@RequestMapping(value="/tus/api", method=RequestMethod.POST )
public class TusFileUploadController {
	
	/**
	 * 사용할 서비스 선언
	 */
	@Autowired
	private FileUploadService service;

	@Autowired
	private Bucket bucketManager;


	@RequestMapping(value = {"/file/upload","/file/upload/{fileKey}"},method = {RequestMethod.POST,RequestMethod.PATCH,RequestMethod.HEAD})
	public ResponseEntity<?> uploadWithTusFilePathHttpHeader(
			HttpServletRequest request, HttpServletResponse response
	) throws Exception{
		String path = request.getHeader("bucket-path");
		service.upload(request, response,path);
		return ResponseEntity.ok("");
	}

	@GetMapping("/read")
	public ResponseEntity<List<Map<String,Object>>> readDir(
			@RequestParam String path
	)throws Exception{
		return ResponseEntity.ok(bucketManager.listFilesAndFolders(path));
	}

	@PostMapping("/downloadZip/all")
	public void downloadZip(@RequestBody Map<String,Object> body, HttpServletResponse response) throws Exception{
		String path= body.get("path").toString();
		bucketManager.downloadZip(response,path);
	}

	@PostMapping("/downloadZip")
	public void downloadZipT(@RequestBody List<String> paths, HttpServletResponse response) throws Exception{
		bucketManager.downloadZip(response,paths);
	}

	@DeleteMapping("/delete")
	public void deleteObject(@RequestBody List<String> paths) throws Exception{
		paths.forEach(bucketManager::delete);
	}


}