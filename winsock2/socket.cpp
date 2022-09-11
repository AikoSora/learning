#include "socket.h"


Socket::Socket(string Hostname, string Port) {
	hostname = Hostname;
	port = Port;
}


int Socket::sconnect() {
	if (!this->isSocketInitialize()) {
		return -1;
	}

	if (!this->getAddrInfo()) {
		return -2;
	}

	if (!this->createSocket()) {
		return -3;
	}

	if (!this->connectToSocket()) {
		return -4;
	}

	return 1;
}


bool Socket::isSocketInitialize() {
	if (WSAStartup(MAKEWORD(2, 2), &wsaData) != 0) {
		return false;
	}
	ZeroMemory(&hints, sizeof(hints));
	hints.ai_family = AF_UNSPEC;
	hints.ai_socktype = SOCK_STREAM;
	hints.ai_protocol = IPPROTO_TCP;
	return true;
}

bool Socket::getAddrInfo() {
	if (getaddrinfo(hostname.c_str(), port.c_str(), &hints, &result) != 0) {
		return false;
	}
	return true;
}


bool Socket::createSocket() {
	ptr = result;
	ConnectSocket = socket(ptr->ai_family, ptr->ai_socktype, ptr->ai_protocol);
	if (ConnectSocket == INVALID_SOCKET) {
		return false;
	}
	return true;
}

bool Socket::connectToSocket() {
	if (connect(ConnectSocket, ptr->ai_addr, (int)ptr->ai_addrlen) == SOCKET_ERROR) {
		closesocket(ConnectSocket);
		ConnectSocket = INVALID_SOCKET;
		return false;
	}
	return true;
}


bool Socket::closeSendingSocket() {
	if (shutdown(ConnectSocket, SD_SEND) == SOCKET_ERROR) {
		closesocket(ConnectSocket);
		return false;
	}
	return true;
}


bool Socket::srecv() {
	memset(&recvbuf[0], 0, sizeof(recvbuf));
	int iResult = recv(ConnectSocket, recvbuf, recvbuflen, 0);
	if (iResult <= 0) {
		return false;
	}
	return true;
}


bool Socket::ssend(string text) {
	if (send(ConnectSocket, text.c_str(), (int)strlen(text.c_str()), 0) == SOCKET_ERROR) {
		closesocket(ConnectSocket);
		return false;
	}
	return true;
}


Socket::~Socket() {
	freeaddrinfo(result);

	if (ConnectSocket != INVALID_SOCKET) {
		closesocket(ConnectSocket);
	}

	WSACleanup();
}