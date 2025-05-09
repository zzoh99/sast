package com.hr.api.common.util;


import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.security.Key;
import java.security.NoSuchAlgorithmException;
import java.util.Base64;

public class AES256 {
    private String iv;
    private Key keySpec;

    public AES256(String key) throws UnsupportedEncodingException {
        this.iv = key.substring(0, 16);
//        byte[] keyBytes = new byte[16];
//        byte[] b = key.getBytes("UTF-8");
//        int len = b.length;
//        if (len > keyBytes.length) {
//            len = keyBytes.length;
//        }모
//
//        System.arraycopy(b, 0, keyBytes, 0, len);
//        SecretKeySpec keySpec = new SecretKeySpec(keyBytes, "AES");
        this.keySpec = new SecretKeySpec(key.getBytes("UTF-8"), "AES");
    }

    public AES256(String key, int keyByte) throws UnsupportedEncodingException {
        this.iv = key.substring(0, 16);
        byte[] keyBytes = new byte[keyByte];
        byte[] b = key.getBytes("UTF-8");
        int len = b.length;
        if (len > keyBytes.length) {
            len = keyBytes.length;
        }

        System.arraycopy(b, 0, keyBytes, 0, len);
        SecretKeySpec keySpec = new SecretKeySpec(keyBytes, "AES");
        this.keySpec = keySpec;
    }

    public String encrypt(String str) throws NoSuchAlgorithmException, GeneralSecurityException, UnsupportedEncodingException {
        Cipher c = Cipher.getInstance("AES/CBC/PKCS5Padding");
        c.init(1, this.keySpec, new IvParameterSpec(this.iv.getBytes()));
        byte[] encrypted = c.doFinal(str.getBytes("UTF-8"));
        String enStr = new String(Base64.getEncoder().encode(encrypted));
        return enStr;
    }

    public String decrypt(String str) throws NoSuchAlgorithmException, GeneralSecurityException, UnsupportedEncodingException {
        Cipher c = Cipher.getInstance("AES/CBC/PKCS5Padding");
        c.init(2, this.keySpec, new IvParameterSpec(this.iv.getBytes()));
        byte[] byteStr = Base64.getDecoder().decode(str.getBytes());
        return new String(c.doFinal(byteStr), "UTF-8");
    }
}
