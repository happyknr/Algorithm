package test;

public class FindKim {
	public String findKim(String[] seoul){
		int x = 0;
		//x에 김서방의 위치를 저장하세요.
		/*
		for(int i = 0; i < seoul.length; i++)
		{
			if(seoul[i].equals("Kim"))
					x = i;
		}
*/
		while(x < seoul.length)
		{
			if(seoul[x].equals("Kim"))
				break;
			else
				x++;
		}
		
		return "김서방은 "+ x + "에 있다";
	}
	
	// 실행을 위한 테스트코드입니다.
	public static void main(String[] args) {
		FindKim kim = new FindKim();
		String[] names = {"Queen", "Tod","Kim"};
		System.out.println(kim.findKim(names));
	}
}
