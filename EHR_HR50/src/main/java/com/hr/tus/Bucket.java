package com.hr.tus;

import com.hr.common.util.StringUtil;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.BadRequestException;
import java.io.*;
import java.util.*;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;
import java.util.zip.ZipOutputStream;

@Component("UploadBucket")
public class Bucket {

    @Value("${tus.server.data.directory:/Users/loves/Desktop/example/tus/bucket}")
    private  String rootPath;

    private String fullPath (String path){
        return (this.rootPath +"/"+(StringUtil.isEmpty(path)?"": path)).replaceAll("//","/");
    }


    public void upload (InputStream is, String path,String fileName )throws IOException {
        String _path = this.fullPath(path);
        new File(_path).mkdirs();
        File file = new File(_path, fileName);
        FileUtils.copyInputStreamToFile(is, file);
    }
    public void uploadAndUnzip (InputStream zipInputStream, String path )throws IOException {

        try (ZipInputStream zis = new ZipInputStream(zipInputStream)) {
            ZipEntry zipEntry;
            while ((zipEntry = zis.getNextEntry()) != null) {
                if (zipEntry.isDirectory()) {
                    this.mkDir(path+"/"+zipEntry.getName());
                } else {
                    ByteArrayOutputStream baos = new ByteArrayOutputStream();
                    byte[] buffer = new byte[1024];
                    int len;
                    while ((len = zis.read(buffer)) > -1) {
                        baos.write(buffer, 0, len);
                    }
                    baos.flush();
                    InputStream is = new ByteArrayInputStream(baos.toByteArray());

                    String zipEntryName = zipEntry.getName();

                    this.upload(is, path + "/", zipEntryName);
                }
            }
        } catch (IOException e) {
            throw new RuntimeException("ZIP 파일 압축 해제 중 오류 발생", e);
        }
    }
    public void mkDir (String path){
        String _path = this.fullPath(path);
        new File(_path).mkdirs();
    }

    public List<Map<String, Object>> listFilesAndFolders(String path) throws IOException {
        List<Map<String, Object>> result = new ArrayList<>();
        File directory = new File(this.rootPath,path );
        if (directory.exists() && directory.isDirectory()) {
            File[] filesList = directory.listFiles();
            if (filesList != null) {
                for (File file : filesList) {
                    Map<String, Object> fileInfo = new HashMap<>();
                    fileInfo.put("name", file.getName());
                    fileInfo.put("isDirectory", file.isDirectory());
                    fileInfo.put("size", file.length());
                    fileInfo.put("key", file.getPath().replace(this.rootPath,""));
                    result.add(fileInfo);
                }
            }
        }

        return result;
    }

    public void downloadFile(HttpServletResponse res, String path) throws IOException {
        String _path = this.fullPath(path);
        File file = new File(_path);

        if (!file.exists() || file.isDirectory()) {
            // 파일이 없거나 디렉토리인 경우 에러 처리
            res.setStatus(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        try (FileInputStream fis = new FileInputStream(file);
             OutputStream os = res.getOutputStream()) {

            byte[] buffer = new byte[1024];
            int bytesRead;

            res.setContentType("application/octet-stream");
            res.setHeader("Content-Disposition", "attachment; filename=\"" + file.getName() + "\"");

            while ((bytesRead = fis.read(buffer)) != -1) {
                os.write(buffer, 0, bytesRead);
            }
        }
    }

    private void addFilesToZip(File source, ZipOutputStream zipOut, String parentDirectoryName) throws IOException {
        String zipEntryName = source.getName();
        if (parentDirectoryName != null && !parentDirectoryName.isEmpty()) {
            zipEntryName = parentDirectoryName + "/" + source.getName();
        }

        if (source.isDirectory()) {
            for (File file : Objects.requireNonNull(source.listFiles())) {
                addFilesToZip(file, zipOut, zipEntryName);
            }
        } else {
            try (FileInputStream fis = new FileInputStream(source)) {
                ZipEntry zipEntry = new ZipEntry(zipEntryName);
                zipOut.putNextEntry(zipEntry);
                IOUtils.copy(fis, zipOut);
                zipOut.closeEntry();
            }
        }
    }

    // 특정 경로의 파일들

    public void downloadZip(HttpServletResponse res, String path) throws IOException {
        String _path = this.fullPath(path);
        File directory = new File(_path);

        if (!directory.exists() || !directory.isDirectory()) {
            throw new BadRequestException("잘못된 경로 입니다.");
        }

        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
        try (ZipOutputStream zipOut = new ZipOutputStream(byteArrayOutputStream)) {
            addFilesToZip(directory, zipOut, null);
        }

        byte[] zipBytes = byteArrayOutputStream.toByteArray();
        try (OutputStream os = res.getOutputStream()) {
            res.setContentType("application/zip");
            res.setHeader("Content-Disposition", "attachment; filename=\"files.zip\"");
            os.write(zipBytes);
        }
    }
    // 여러 파일 들
    public void downloadZip(HttpServletResponse res, List<String> paths) throws IOException {
        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
        try (ZipOutputStream zipOut = new ZipOutputStream(byteArrayOutputStream)) {
            for (String path : paths) {
                //String _path = this.fullPath(path);
                File file = new File(path);
                if (file.exists()) {
                    addFilesToZip(file, zipOut, null);
                }
            }
        }

        byte[] zipBytes = byteArrayOutputStream.toByteArray();
        try (OutputStream os = res.getOutputStream()) {
            res.setContentType("application/zip");
            res.setHeader("Content-Disposition", "attachment; filename=\"files.zip\"");
            os.write(zipBytes);
        }
    }
    public void delete(String path) {
        String _path = path.replaceAll("//", "/");
        //String _path = (this.rootPath + "/" + (StringUtil.isEmpty(path) ? "" : path)).replaceAll("//", "/");
        File fileOrDir = new File(_path);
        if (fileOrDir.exists()) {
            recursiveDelete(fileOrDir);
        }
    }
    private void recursiveDelete(File fileOrDir) {
        if (fileOrDir.isDirectory()) {
            File[] files = fileOrDir.listFiles();
            if (files != null) {
                for (File file : files) {
                    recursiveDelete(file);
                }
            }
        }
        fileOrDir.delete();
    }
}
