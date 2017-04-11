package test;

import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;
import java.util.TreeSet;

public class Mijin {
	
	public static void main(String[] args) {
		// 판매 활동 시작
		new CartForSongsMijin();
	}
}

/**
 * 구매한 노래의 총 가격을 계산해 줌 
 * 1. 고객에서 보유한 노래 목록을 보여줌
 * 2. 사려는 노래 번호를 입력받음
 * 3. 입력받은 노래들의 가격정보 및 총 가격을 출력해줌
 */
class CartForSongsMijin{
	
	/*
	 * 문자열에서 숫자만 추출하기 위한 용도로 작성
	 */
	static int getInputIntVal(String str){
		str = str.replaceAll("[^0-9]", "");
		return Integer.parseInt( str.equals("") ? "0" : str );
	}
	
	CartForSongsMijin(){
		// 고객에서 판매할 노래들을 보여주기 위해 노래정보목록 가져옴
		List<SongDto> listSongs = new SongsMijin().getListSongs();
		int listSongsLen = listSongs.size();
		
		StringBuffer sb = new StringBuffer();
		int i = 1;
		// 고객이 보기 편한 형태로 판매 문자열 작성
		for(SongDto song : listSongs){
			sb.append("["+ i++ +"번] "+ song.getTitle() +" - "+ song.getSinger() +" (가격 : "+ song.getPrice() + "원)\n");
		}
		sb.append("\n위의 "+ listSongsLen + "곡 중에 구매하려는 번호를 입력하세요.\n");
		sb.append("구매하려는 번호가 없으시다면 엔터 또는 숫자 0번을 입력하세요.\n");
		sb.append("* 구매하려는 번호를 계속 입력하시고 없으시면 엔터 또는 0번을 입력하세요.\n\n");
		
		// 판매 문자열 출력
		System.out.println(sb.toString());
		// stringbuffer 재사용을 위해 초기화
		sb.setLength(0);
		
		// 중복제거하여 구매할 노래번호를 취합할 객체
		TreeSet<Integer> ListSongNum = new TreeSet<Integer>();
		
		// 사용자에게 구매번호 입력받기 위한 객체 및 초기화
		Scanner scan = new Scanner(System.in);
		// 사용자가 입력한 구매번호
		int number = getInputIntVal(scan.nextLine());
		
		// 0 입력할 때까지 구매할 노래번호 계속 입력 받기 위한 반복문
		while(number > 0){
			
			// 가지고 있는 노래 번호에서 벗어났을 경우 재 입력 받음
			if(number > listSongsLen){
				System.out.println("잘못 된 곡 번호 입니다.\n다시 입력해주세요.");
			
				number = getInputIntVal(scan.nextLine());
				
				continue;
			}
			// 구매번호 구매할 노래 목록에 담기
			ListSongNum.add(number);
			
			number = getInputIntVal(scan.nextLine());
		}
		scan.close();
		
		SongDto song;
		int totalPrice = 0;
		// 구매 할 노래들 정리 및 합계 구하기 
		for(int num : ListSongNum){
			song = listSongs.get(--num);
			
			int price = new Double( Math.floor(song.getPrice() * (100 - song.getDiscountRate()) * 0.01) ).intValue();
			totalPrice += price;
			
			sb.append("\n\n제목	: "+ song.getTitle());
			sb.append("\n가격	: "+ price+" 원");
			sb.append("\n할인율	: "+ song.getDiscountRate() + "%");
		}
		
		sb.append("\n\nTotal	: "+ totalPrice +" 원");

		// 내용 출력
		System.out.println(sb.toString());
	}
}


/**
 * 팔려는 노래들 취합
 * list 객체에 판매할 노래정보를 담음 
 */
class SongsMijin{
	
	private List<SongDto> listSongs;
	
	// 어차피 판매할 데이터가 변경될 일이 없기 때문에 객체 생성시 노래정보 취합하도록 함.
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
 * 노래 정보 dto
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
 * 노래 정보를 담은 클래스
 */
class SongsData{
	// 가수명, 제목, 판매금액, 할인율순으로 정의
	private String[][] songs = {
			 {"AOA", "10 Seconds",			"100",	"31"}
			,{"AOA", "니꺼 내꺼",				"200",	"30"}
			,{"AOA", "단둘이",				"300",	"29"}
			,{"AOA", "흔들려",				"400",	"28"}
			,{"AOA", "AOA",					"500",	"27"}
			,{"AOA", "휠릴리",				"600",	"26"}
			,{"AOA", "단발머리(Short Hair)",	"700",	"25"}
			,{"AOA", "가로등 불 아래서",			"800",	"24"}
			,{"AOA", "들어와(Come To Me)",	"900",	"23"}
			,{"AOA", "Without You",			"1000",	"22"}
			,{"AOA", "말이 안 통해",			"1100",	"21"}
			,{"AOA", "Time",				"1200",	"20"}
			,{"AOA", "한 개(One Thing)",		"1300",	"19"}
			,{"AOA", "Still Falls The Rain","1400",	"18"}
			,{"AOA", "Cherry Pop",			"1500",	"17"}
			,{"AOA", "Chocolate",			"1600",	"16"}
			,{"AOA", "내 반쪽",				"1700",	"15"}
			,{"AOA", "사뿐 사뿐",				"1800",	"14"}
			,{"AOA", "Crazy Boy",			"1900",	"13"}
			,{"AOA", "심쿵해(Heart Attack)",	"2000",	"12"}
			,{"AOA", "MOYA(모야)",			"2100",	"11"}
			,{"AOA", "Luv me",				"2200",	"10"}
			,{"AOA", "ELVIS",				"2300",	"9"}
			,{"AOA", "여자사용법",				"2400",	"7"}
			,{"AOA", "joa Yo!",				"2500",	"6"}
			,{"AOA", "Fantasy",				"2600",	"5"}
			,{"AOA", "Good Luck",			"2700",	"4"}
			,{"AOA", "GET OUT",				"2800",	"3"}
			,{"AOA", "짧은 치마(Miniskirt)",	"2900",	"2"}
			,{"AOA", "진짜(Really Really)",	"3000",	"1"}
	};
	
	String[][] getSongs(){
		return this.songs;
	}
}