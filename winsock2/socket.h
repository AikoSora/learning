#pragma once

#include <winsock2.h>
#include <ws2tcpip.h>
#include <string>

#pragma comment(lib, "Ws2_32.lib")
#define DEFAULT_BUFLEN 1024

using std::string;

class Socket {

public:
	WSADATA wsaData;

	string port;
	string hostname;

	struct addrinfo *result = NULL, *ptr = NULL, hints;
	SOCKET ConnectSocket = INVALID_SOCKET;

	int recvbuflen = DEFAULT_BUFLEN;
	char recvbuf[DEFAULT_BUFLEN];
	char* data;

public:
	Socket(string Hostname, string Port);
	~Socket();

public:
	int sconnect();
	bool isSocketInitialize();
	bool getAddrInfo();
	bool createSocket();
	bool connectToSocket();
	bool closeSendingSocket();
	bool srecv();
	bool ssend(string text);
};
