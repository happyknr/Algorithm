package test;

import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;
import java.util.TreeSet;

public class Mijin {
	
	public static void main(String[] args) {
		// �Ǹ� Ȱ�� ����
		new CartForSongsMijin();
	}
}

/**
 * ������ �뷡�� �� ������ ����� �� 
 * 1. ������ ������ �뷡 ����� ������
 * 2. ����� �뷡 ��ȣ�� �Է¹���
 * 3. �Է¹��� �뷡���� �������� �� �� ������ �������
 */
class CartForSongsMijin{
	
	/*
	 * ���ڿ����� ���ڸ� �����ϱ� ���� �뵵�� �ۼ�
	 */
	static int getInputIntVal(String str){
		str = str.replaceAll("[^0-9]", "");
		return Integer.parseInt( str.equals("") ? "0" : str );
	}
	
	CartForSongsMijin(){
		// ������ �Ǹ��� �뷡���� �����ֱ� ���� �뷡������� ������
		List<SongDto> listSongs = new SongsMijin().getListSongs();
		int listSongsLen = listSongs.size();
		
		StringBuffer sb = new StringBuffer();
		int i = 1;
		// ���� ���� ���� ���·� �Ǹ� ���ڿ� �ۼ�
		for(SongDto song : listSongs){
			sb.append("["+ i++ +"��] "+ song.getTitle() +" - "+ song.getSinger() +" (���� : "+ song.getPrice() + "��)\n");
		}
		sb.append("\n���� "+ listSongsLen + "�� �߿� �����Ϸ��� ��ȣ�� �Է��ϼ���.\n");
		sb.append("�����Ϸ��� ��ȣ�� �����ôٸ� ���� �Ǵ� ���� 0���� �Է��ϼ���.\n");
		sb.append("* �����Ϸ��� ��ȣ�� ��� �Է��Ͻð� �����ø� ���� �Ǵ� 0���� �Է��ϼ���.\n\n");
		
		// �Ǹ� ���ڿ� ���
		System.out.println(sb.toString());
		// stringbuffer ������ ���� �ʱ�ȭ
		sb.setLength(0);
		
		// �ߺ������Ͽ� ������ �뷡��ȣ�� ������ ��ü
		TreeSet<Integer> ListSongNum = new TreeSet<Integer>();
		
		// ����ڿ��� ���Ź�ȣ �Է¹ޱ� ���� ��ü �� �ʱ�ȭ
		Scanner scan = new Scanner(System.in);
		// ����ڰ� �Է��� ���Ź�ȣ
		int number = getInputIntVal(scan.nextLine());
		
		// 0 �Է��� ������ ������ �뷡��ȣ ��� �Է� �ޱ� ���� �ݺ���
		while(number > 0){
			
			// ������ �ִ� �뷡 ��ȣ���� ����� ��� �� �Է� ����
			if(number > listSongsLen){
				System.out.println("�߸� �� �� ��ȣ �Դϴ�.\n�ٽ� �Է����ּ���.");
			
				number = getInputIntVal(scan.nextLine());
				
				continue;
			}
			// ���Ź�ȣ ������ �뷡 ��Ͽ� ���
			ListSongNum.add(number);
			
			number = getInputIntVal(scan.nextLine());
		}
		scan.close();
		
		SongDto song;
		int totalPrice = 0;
		// ���� �� �뷡�� ���� �� �հ� ���ϱ� 
		for(int num : ListSongNum){
			song = listSongs.get(--num);
			
			int price = new Double( Math.floor(song.getPrice() * (100 - song.getDiscountRate()) * 0.01) ).intValue();
			totalPrice += price;
			
			sb.append("\n\n����	: "+ song.getTitle());
			sb.append("\n����	: "+ price+" ��");
			sb.append("\n������	: "+ song.getDiscountRate() + "%");
		}
		
		sb.append("\n\nTotal	: "+ totalPrice +" ��");

		// ���� ���
		System.out.println(sb.toString());
	}
}


/**
 * �ȷ��� �뷡�� ����
 * list ��ü�� �Ǹ��� �뷡������ ���� 
 */
class SongsMijin{
	
	private List<SongDto> listSongs;
	
	// ������ �Ǹ��� �����Ͱ� ����� ���� ���� ������ ��ü ������ �뷡���� �����ϵ��� ��.
	SongsMijin(){
		listSongs = new ArrayList<SongDto>();
		
		String[][] songs = new SongsData().getSongs();
		SongDto songDto;
		for(String[] str : songs){
			songDto = new SongDto();
			songDto.setSinger(str[0]);
			songDto.setTitle(str[1]);
			songDto.setPrice(Integer.parseInt(str[2]));
			songDto.setDiscountRate(Integer.parseInt(str[3]));
			listSongs.add(songDto);
		}
	}
	
	List<SongDto> getListSongs(){
		return listSongs;
	}
}

/**
 * �뷡 ���� dto
 */
class SongDto{
	private String singer;
	private String title;
	private int price;
	private int discountRate;
	
	public String getSinger() {
		return singer;
	}
	public void setSinger(String singer) {
		this.singer = singer;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public int getPrice() {
		return price;
	}
	public void setPrice(int price) {
		this.price = price;
	}
	public int getDiscountRate() {
		return discountRate;
	}
	public void setDiscountRate(int discountRate) {
		this.discountRate = discountRate;
	}
}

/**
 * �뷡 ������ ���� Ŭ����
 */
class SongsData{
	// ������, ����, �Ǹűݾ�, ������������ ����
	private String[][] songs = {
			 {"AOA", "10 Seconds",			"100",	"31"}
			,{"AOA", "�ϲ� ����",				"200",	"30"}
			,{"AOA", "�ܵ���",				"300",	"29"}
			,{"AOA", "����",				"400",	"28"}
			,{"AOA", "AOA",					"500",	"27"}
			,{"AOA", "�ٸ���",				"600",	"26"}
			,{"AOA", "�ܹ߸Ӹ�(Short Hair)",	"700",	"25"}
			,{"AOA", "���ε� �� �Ʒ���",			"800",	"24"}
			,{"AOA", "����(Come To Me)",	"900",	"23"}
			,{"AOA", "Without You",			"1000",	"22"}
			,{"AOA", "���� �� ����",			"1100",	"21"}
			,{"AOA", "Time",				"1200",	"20"}
			,{"AOA", "�� ��(One Thing)",		"1300",	"19"}
			,{"AOA", "Still Falls The Rain","1400",	"18"}
			,{"AOA", "Cherry Pop",			"1500",	"17"}
			,{"AOA", "Chocolate",			"1600",	"16"}
			,{"AOA", "�� ����",				"1700",	"15"}
			,{"AOA", "��� ���",				"1800",	"14"}
			,{"AOA", "Crazy Boy",			"1900",	"13"}
			,{"AOA", "������(Heart Attack)",	"2000",	"12"}
			,{"AOA", "MOYA(���)",			"2100",	"11"}
			,{"AOA", "Luv me",				"2200",	"10"}
			,{"AOA", "ELVIS",				"2300",	"9"}
			,{"AOA", "���ڻ���",				"2400",	"7"}
			,{"AOA", "joa Yo!",				"2500",	"6"}
			,{"AOA", "Fantasy",				"2600",	"5"}
			,{"AOA", "Good Luck",			"2700",	"4"}
			,{"AOA", "GET OUT",				"2800",	"3"}
			,{"AOA", "ª�� ġ��(Miniskirt)",	"2900",	"2"}
			,{"AOA", "��¥(Really Really)",	"3000",	"1"}
	};
	
	String[][] getSongs(){
		return this.songs;
	}
}