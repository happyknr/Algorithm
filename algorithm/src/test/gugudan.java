package test;

public class gugudan {
	public static void main(String[] args) {
		
		for(int i = 1; i <= 9; i=i+3) 
		{
			for(int j = 1; j <= 9; j++) {
				for(int z = i; z < i+3; z++) {
					System.out.print(z + "*" + j +"=" + j*z +"\t");
					if(z % 3 == 0) System.out.println();
				}
			}
			System.out.println();
		}
	}
}
