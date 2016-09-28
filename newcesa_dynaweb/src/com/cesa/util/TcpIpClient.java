package com.cesa.util;

import java.io.DataOutputStream;
import java.io.OutputStream;
import java.net.Socket;
import java.text.SimpleDateFormat;
import java.util.Date;

import sun.nio.cs.SingleByte.Encoder;

public class TcpIpClient {
	public TcpIpClient(byte num){
		try{
            String serverIp = "192.168.0.1";
            //System.out.println("체크된 값 : "+(byte)(0x00)+num);
            // 소켓을 생성하여 연결을 요청한다.
            System.out.println(getTime()+"서버에 연결중입니다. 서버IP : " + serverIp);
            Socket socket = new Socket(serverIp, 40100);
             
            OutputStream out = socket.getOutputStream();
            DataOutputStream dos = new DataOutputStream(out);
            byte[] data = new byte[14];
            data[0] = (byte)0x00;
            data[1] = (byte)0x0E;
            data[2] = (byte)0x00;
            data[3] = (byte)0x00;
            data[4] = (byte)0x00;
            data[5] = (byte)0x00;
            data[6] = (byte)0xFE;
            data[7] = (byte)0x02;
            data[8] = (byte)0xB0;
            data[9] = (byte)0xC0;
            data[10] = (byte)0x00;
            data[11] = (byte)((byte)(0x00)+num); // Nubmer to hexa
            data[12] = (byte)0xFA;
            data[13] = (byte)0x0D;
            System.out.printf("프로토콜 값 : 0x%02X", data[11]);
            dos.write(data);
            System.out.println(getTime()+" 프로토콜을 전송하였습니다.");
            
            out.close();
            dos.close();
            socket.close();
            
            System.out.println(getTime()+"연결이 종료되었습니다.");
        }catch (Exception e) {
            e.printStackTrace();
        }
	}

	static String getTime() {
        SimpleDateFormat f = new SimpleDateFormat("[hh:mm:ss]");
        return f.format(new Date()) ;
    }
}
