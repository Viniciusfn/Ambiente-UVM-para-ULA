#include <stdio.h>

extern "C" int my_ULA(int A, int B, int instru){
	switch (instru){
		case 0:
			return A+B;
		case 1:
			if(A > B)
				return A-B;
			return B-A;
		case 2:
			return A+1;
		case 3:
			return B+1;
		default:
			return -1;
	}
}