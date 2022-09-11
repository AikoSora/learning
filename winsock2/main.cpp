#include "socket.h"
#include <stdio.h>


int main() {
	Socket socket("127.0.0.1", "2077");

	if (socket.sconnect() > 0) {
		
		while (socket.srecv()) {
			printf("DATA: %s\n", socket.recvbuf);
		}
	}

	return 0;
}