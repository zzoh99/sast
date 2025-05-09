package com;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.common.hash.Hashing;
import com.hr.common.logger.Log;
import com.hr.common.util.CryptoUtil;
import com.hr.common.util.RSA;
import org.apache.commons.io.Charsets;

import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import javax.xml.bind.DatatypeConverter;
import java.io.*;
import java.math.BigInteger;
import java.nio.charset.StandardCharsets;
import java.security.AlgorithmParameters;
import java.security.KeyFactory;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.RSAPublicKeySpec;
import java.util.*;

import static com.hr.common.util.CryptoUtil.byteArrayToHex;
import static com.hr.common.util.CryptoUtil.hexToByteArray;

public class test {

    public static void main(String[] args) throws Exception {

        ObjectMapper mapper = new ObjectMapper();

        String configJson = "{\"actionType\":1,\"actionLink\":\"\",\"filters\":[],\"useSmChart\":false,\"useMdSummary\":false,\"useAction\":false,\"options\":{\"legend\":{\"orient\":\"horizontal\",\"left\":\"auto\",\"right\":\"0%\",\"bottom\":\"0%\",\"itemGap\":8,\"data\":null,\"itemWidth\":6,\"itemHeight\":6,\"icon\":\"circle\",\"textStyle\":{\"color\":\"#4A4E57\",\"fontSize\":10,\"fontWeight\":400}},\"xAxis\":{\"type\":\"category\",\"data\":null,\"axisLabel\":{\"color\":\"#8D929B\",\"fontSize\":10},\"axisLine\":{\"lineStyle\":{\"color\":\"#EEE\"}}},\"yAxis\":{\"type\":\"value\",\"axisLabel\":{\"color\":\"#8D929B\",\"fontSize\":10}},\"grid\":{\"left\":\"0%\",\"right\":\"4%\",\"top\":\"10%\",\"bottom\":\"15%\",\"containLabel\":true},\"series\":[{\"name\":\"입사\",\"type\":\"bar\",\"barWidth\":\"6px\",\"itemStyle\":{\"borderRadius\":[4,4,0,0],\"opacity\":0.7,\"color\":\"#1D56E7\"},\"data\":null},{\"name\":\"퇴사\",\"type\":\"bar\",\"barWidth\":\"6px\",\"itemStyle\":{\"borderRadius\":[4,4,0,0],\"opacity\":0.7,\"color\":\"#1D56E7\"},\"data\":null}]},\"summary\":{\"dataLabel1\":\"입사\",\"label1\":\"\",\"value1\":10,\"unit1\":\"명\",\"descDataLabel1\":\"2024년\",\"descLabel1\":\"기준\",\"descBoldLabel1\":\"\",\"descData1\":\"\",\"descUnit1\":\"\",\"dataLabel2\":\"퇴사\",\"label2\":\"\",\"value2\":5,\"unit2\":\"명\",\"descDataLabel2\":\"2024년\",\"descLabel2\":\"기준\",\"descBoldLabel2\":\"\",\"descData2\":\"\",\"descUnit2\":\"\",\"value\":null,\"descData\":null}}";

        Map<String, Object> config = mapper.readValue(configJson, new TypeReference<Map<String, Object>>() {});
        System.out.println(config.get("actionType")); // 1 출력됨

        /*Log.Debug(CryptoUtil.decryptCbc(resourceConfig.getAkey(), resourceConfig.getl().get("u")));
        Log.Debug(CryptoUtil.decryptCbc(resourceConfig.getAkey(), resourceConfig.getl().get("c")));
        Log.Debug(CryptoUtil.decryptCbc(resourceConfig.getAkey(), resourceConfig.getl().get("d")));
        Log.Debug(CryptoUtil.decryptCbc(resourceConfig.getAkey(), resourceConfig.getl().get("i")));
        Log.Debug(CryptoUtil.decryptCbc(resourceConfig.getAkey(), resourceConfig.getl().get("e")));
        Log.Debug(CryptoUtil.decryptCbc(resourceConfig.getAkey(), resourceConfig.getl().get("m")));
        */

//        System.out.println("------------------------------");
//        RSA rsa = RSA.getEncKey();
//        String privateStr = "308204bf020100300d06092a864886f70d0101010500048204a9308204a50201000282010100b7903a3602987dafc6bcee3689cf25c02b2cbd875560636a69328c77ef440fcb5aeb7f44e6b619cac085c04cf4f617ea027c4417d6911b4f283aae3ef2d69539e2a6ac33b2b4fea1f42a33a7e92a6eb6104f9d79fa6d56dacf934cd2118276ab2adcfcc68b2f174b6b949a4de4099ada78abb7c9b4b7889661e0d5834a2d3904b715f602e57cadc8d8a75bcf68defb629dfc5f65376451012b49908e0a5cf4c682fad77cdd38d400965ada8dc1b4ba468685a3bb2d5646f72ff4307fdf26ad4c65cbe6a853fe1d1409cd43068b88174ae29edb247daf35560f3bb01000a53b979575c04c952ce0c295419db374557de463a66488cb3c681df8baa6030e73e39b020301000102820101008dd9726252572ca92cd6caee724815500f0d1fd8f8ece7664facb447ea299a5af7038cf1dda752ff0f0f4caf2b8d10a5d10dde40dd9a7c940aee6dc04f3feb493410c079a2dba2f9dc08d0aa2cd0918537cd8e4fb869cdf880f7bf21864e5f0d9eadeed82eae513e03006ecd4a2ef1ef69d8a8c9c25121c7b4135e6b7a62bfefc59400ed11eaf21b6bd0a0b17a8d9aeaa7af0100c39b140d8ea8a6bf0f3c274583ed52fe1499c4bc2805912fddc85ea4b2d0a57dc9a401a4726d2851e7d93239cc439ace5ca48fb990504d481443a432224a9cd07586c858851662f1cfc91ca5918fc3f41abadf957476e995a82e107b6df7f0842f1bdd74b095846f0994e02102818100fe237dd36c8ffb6ff3d823f3ea00f2831533992abdcb9479879587d0adee55280a25358421445152d81b2a13c023347c14cef9477571c727dfdc3a28907c8dc670f039540117593a0034b32f1c061c5a82ce40077285f2cec82a700ff8c11e8bf783b765545c1c82a0959ea9082717dc4da4e4a4d64ea14e713bdb6dcb05945702818100b8e8685e49590da06bc12ee8e27e68ac1523e15812c7e912022d9b797e818e7c0ff6218a3750c3ff9691bbf96a341b25ba6a93f9cc778f50e129321838ab9186bb822118c27fa9e10883cefc3f62f6096f18daded61bdd744ded6689a1a5690eb30c45a9ef12abb39c886b6f598a4b0d1688e5c18b80f3b72cb2c02071db005d02818100820f9fe187f9d7f05f970a2f565ecdbe1027ac0797c28c65f5e1acf43b4f71fd5fd3d3239ff2dabbcf2577cf4bd1b89697ffa4cbd16b3d4546e7ea4bc0463e3884ac2c6ab5744191d1712712c100cf99f2bfa33d2c7b28dc72cc653587552e50eb8759605e6015a7348fddf71bd905f91533826069dd2be87d42e8f5b3a55359028180714cceeebf28d705ae21103a58d63613035d19ee1a8bee0f3fd06c4cd4ac53ff46d47d16b0f04738ac2d1e2e24da4aac227ebdaf398f24fcdd0a9e0c63651565a62d855423919029384b739ff2c31399123efb95c1420fbefd24f3487008e7c7bf044d07645b5f644e0cf52fa480ed9dd66a09c63f51c38440da42895eda5f6d02818100ec044781d0860a48aff1f977a344af80d79ff656d789ea118ac0a3b7b93660782a51baf8c91f842a05c4f53a302d68a248658ffaef531f7cdc55cad479a9ae72f5daaa2bba01bcceeb9026cc4d973afb3bb7bfaee8cc100e022032145da604ef14a64953d1e515675f27d769b38906a7ee7dd836f959e2a7bcdca488c78cb381";
//        // new String(byteArrayToHex(rsa.getPrivateKey().getEncoded()));
//        System.out.println("privateStr :: " + new String(byteArrayToHex(rsa.getPrivateKey().getEncoded())));
//        //
//
//        String pubExp = "10001";
//        System.out.println("rsa.getPublicKeyExponent() : " + rsa.getPublicKeyExponent());
//        String pubMod = "b7903a3602987dafc6bcee3689cf25c02b2cbd875560636a69328c77ef440fcb5aeb7f44e6b619cac085c04cf4f617ea027c4417d6911b4f283aae3ef2d69539e2a6ac33b2b4fea1f42a33a7e92a6eb6104f9d79fa6d56dacf934cd2118276ab2adcfcc68b2f174b6b949a4de4099ada78abb7c9b4b7889661e0d5834a2d3904b715f602e57cadc8d8a75bcf68defb629dfc5f65376451012b49908e0a5cf4c682fad77cdd38d400965ada8dc1b4ba468685a3bb2d5646f72ff4307fdf26ad4c65cbe6a853fe1d1409cd43068b88174ae29edb247daf35560f3bb01000a53b979575c04c952ce0c295419db374557de463a66488cb3c681df8baa6030e73e39b";
//        System.out.println("rsa.getPublicKeyModulus() : " + rsa.getPublicKeyModulus());
//        PKCS8EncodedKeySpec rkeySpec = new PKCS8EncodedKeySpec(hexToByteArray(privateStr));
//        KeyFactory rkeyFactory = KeyFactory.getInstance("RSA");
//        PrivateKey privateKey = null;
//        privateKey = rkeyFactory.generatePrivate(rkeySpec);
//
//
//        Cipher encryptCipher = Cipher.getInstance("RSA");
//
//        KeyFactory keyFactory = KeyFactory.getInstance("RSA");
//
//
//
//        RSAPublicKeySpec publicSpec = new RSAPublicKeySpec(new BigInteger("17424247634180933654838709716661310885008466546698514157616369401301627357018823153821856764025614028549208609833905118544530498905562099657744545363447072472185686754396717047071256837367470503880908254006785500711401026754669666510709902096230360877079947975911880385191427601224425928117245081118491185557658134952333032349803286747066655345012331363344908652344292663328980911879932013494183834090033807069000302620809204338562296441284914943711783350046167674742210514087758701084936345933209006150384183681266730478469363885435057711447170007132218249188369919709031269438936500428850886987277545986841330254303",16)
//                , new BigInteger("65537"));
//        PublicKey publicKey = keyFactory.generatePublic(publicSpec);
//
//
//        encryptCipher.init(Cipher.ENCRYPT_MODE, publicKey);
//
//        byte[] secretMessageBytes = "10".getBytes(StandardCharsets.UTF_8);
//        byte[] encryptedMessageBytes = encryptCipher.doFinal(secretMessageBytes);
//        String encodedMessage = Base64.getEncoder().encodeToString(encryptedMessageBytes);
//        System.out.println(encodedMessage);
//        System.out.println(RSA.dec(privateKey,encodedMessage));
//        System.out.println(RSA.dec(privateKey,"3c3892f6ae8b60cffc61a4eee8b44674dbeb1d0e7f7c9b9fa585a0191f4434ce2f7b2ebc06d3e9d53047280b062f1060144b17998477735859de2743c8199b5520582108ae01a9172eecb23cb0abcbca6c36b531ad46cd26437c383cec7cb22d9275cf84a2abed8da6757a545afa5918f2af82a323e25423e65c8f832270f6551158e570f17f4b3155e97bf292dee621b98291e899dc69453d8a9b33d315403ef26c737aff4521e103363d2ab87dfdc10e54261e96675f4718db26a3509eb1fbbddc710bcfa2adfdc14aa2c93fb096687f919a2e4a2c84e2d2098e0f1dc554adb00fc8f795ae47063a5cdfcabc6c72a8620706b0d54ade4914758ee9f19380c4"));
//
//
//        System.out.println("------------------------------");
//        String s = "<body>";
//        Calendar cal = Calendar.getInstance();
//        //cal.setTime(new Date());
//        cal.set(Calendar.YEAR, 9999);
//        cal.set(Calendar.MONTH, 11);
//        cal.set(Calendar.DATE, 31);
//        String skey = "1SusysT@mS0Lut10&D@v@l0pmenTT@AM";
//        System.out.println(cal.getTime());
//        System.out.println(cal.getTimeInMillis());
//        System.out.println(CryptoUtil.encryptCbc(skey, "/license/license.dat"));
//        System.out.println(CryptoUtil.decryptCbc(skey, CryptoUtil.encryptCbc(skey, "/license/license.dat").get("encryptMsg")+""));
//        System.out.println(CryptoUtil.encryptCbc(skey,"b6e4fa05c93ecb6a6faba1149df3d9840f587ced0743f19ca7e1c5fc2e10f006"));
//        System.out.println(CryptoUtil.encryptCbc(skey, cal.getTimeInMillis()+""));
//        System.out.println(CryptoUtil.encryptCbc(skey, "[\"02\",\"03\",\"05\",\"06\",\"16\",\"07\",\"08\",\"09\",\"10\",\"12\",\"11\",\"15\",\"20\"]"));
//        System.out.println(CryptoUtil.encryptCbc(skey,"b1492f0f3702056dcd4daf3ae3377386c2d829da7b331baaa9c4806ec8fdc50ea61921cbd28f6ccb2d56b2072fdc556ba27fb8a7cf6bc2ef01143c24644449f30f19ed60e0f50f8318e6d1344527b903"));
//        System.out.println(CryptoUtil.encryptCbc(skey, "This license has expired."));
//
//        System.out.println("1SusysT@mS0Lut10&D@v@l0pmenTT@AM".substring(0,16));
//
//        // 1. 파일 위치 설정
//        String path = "C:/Users/jsoh/Downloads/license.dat";
//        FileOutputStream fos = new FileOutputStream(path);
//        BufferedOutputStream bos = new BufferedOutputStream(fos);
//        DataOutputStream dos = new DataOutputStream(bos);
//
//        ObjectOutputStream oos = new ObjectOutputStream(dos);
//        // 3. 쓰기
//        // - Map으로
//        Map<String, String> map = new HashMap<>();
//        List<String> mList = new ArrayList<>();
//        mList.add( CryptoUtil.encrypt(skey,"02")); // 인사관리
//        mList.add( CryptoUtil.encrypt(skey,"03")); // 조직관리
//        mList.add( CryptoUtil.encrypt(skey,"05")); // 교육관리
//        mList.add( CryptoUtil.encrypt(skey,"06")); // 성과관리
//        mList.add( CryptoUtil.encrypt(skey,"16")); // 경력개발
//        mList.add( CryptoUtil.encrypt(skey,"07")); // 급여관리
//        mList.add( CryptoUtil.encrypt(skey,"08")); // 근태관리
//        mList.add( CryptoUtil.encrypt(skey,"09")); // 복리후생
//        mList.add( CryptoUtil.encrypt(skey,"10")); // 신청결재
//        mList.add( CryptoUtil.encrypt(skey,"12")); // 통계
//        mList.add( CryptoUtil.encrypt(skey,"11")); // 설정
//        mList.add( CryptoUtil.encrypt(skey,"15")); // 연말정산
//        mList.add( CryptoUtil.encrypt(skey,"20")); // 게시판
//
//
//        map.put("e", (String) CryptoUtil.encryptCbc(skey, cal.getTimeInMillis()+"").get("encryptMsg"));
//        map.put("d", (String) CryptoUtil.encryptCbc(skey, "*").get("encryptMsg"));
////        map.put("i", (String) CryptoUtil.encryptCbc(skey, "*.*.*.*").get("encryptMsg"));
//        map.put("i", (String) CryptoUtil.encryptCbc(skey, "10.30.30.21:80").get("encryptMsg"));
//        map.put("m", (String) CryptoUtil.encryptCbc(skey, "[\"02\",\"03\",\"05\",\"06\",\"16\",\"07\",\"08\",\"09\",\"14\",\"10\",\"12\",\"11\",\"15\",\"20\"]").get("encryptMsg"));
//        //map.put("m", mList.toString());
//
//        map.put("u", (String) CryptoUtil.encryptCbc(skey, "9999999").get("encryptMsg"));
//        map.put("c", (String) CryptoUtil.encryptCbc(skey, "9999999").get("encryptMsg"));
//        map.put("a", CryptoUtil.byteArrayToHex(skey.getBytes()));
//
//
//        oos.writeObject(map);
//        // - Array로
//        //oos.writeObject(new int[] {90, 95, 90, 100});
//        // - String으로
//        //oos.writeUTF("기본형도 가능");
//        // - Instance Object, 객체화하여 넣기
//        //oos.writeObject(new Sample());
//
//        oos.flush();
//        // 5. 자원 반납
//        oos.close();
//        dos.close();
//        fos.close();
//
//// 2. 스트림 생성
//
//        FileInputStream fis = new FileInputStream(path);
//        BufferedInputStream bis = new BufferedInputStream(fis);
//        ObjectInputStream ois = new ObjectInputStream(bis);
//
//        // 3. 읽기
//        Map<String, String> m = (Map<String, String>)ois.readObject();
//        //int [] scores = (int[])ois.readObject();
//        //String msg = (String)ois.readUTF();
//        //Sample sample = (Sample)ois.readObject();
//
//        // 4. 출력하기
//        Set<String> set = m.keySet();
//        for(String key : set) {
//            System.out.println(key + " : " + m.get(key));
//        }
//
//        // 4. 해제
//        ois.close();
//        bis.close();
//        fis.close();



    }

    public static String encryptAES(String data, String secretKey) {
        try {
            byte[] secretKeys = Arrays.copyOfRange(Hashing.sha1().hashString(secretKey, Charsets.UTF_8).asBytes(), 0, 16);
            SecretKey secret = new SecretKeySpec(secretKeys, "AES");

            Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
            cipher.init(Cipher.ENCRYPT_MODE, secret);

            AlgorithmParameters params = cipher.getParameters();

            byte[] iv = params.getParameterSpec(IvParameterSpec.class).getIV();
            byte[] cipherText = cipher.doFinal(data.getBytes(Charsets.UTF_8));

            return DatatypeConverter.printHexBinary(iv) + DatatypeConverter.printHexBinary(cipherText);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

}
