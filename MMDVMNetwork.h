/*
 *   Copyright (C) 2015,2016,2017,2018,2020 by Jonathan Naylor G4KLX
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 2 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, write to the Free Software
 *   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

#if !defined(MMDVMNetwork_H)
#define	MMDVMNetwork_H

#include "UDPSocket.h"
#include "Timer.h"
#include "RingBuffer.h"
#include "DMRData.h"

#include <string>
#include <cstdint>

class CMMDVMNetwork
{
public:
	CMMDVMNetwork(const std::string& rptAddress, unsigned short rptPort, const std::string& localAddress, unsigned short localPort, unsigned short startNet, bool debug);
	~CMMDVMNetwork();

	unsigned int getShortConfig(unsigned char* config) const;

	unsigned int getId() const;

	bool open();

	bool read(CDMRData& data);

	bool write(const CDMRData& data);

	bool readRadioPosition(unsigned char* data, unsigned int& length);

	bool readTalkerAlias(unsigned char* data, unsigned int& length);

	bool writeBeacon();

	void clock(unsigned int ms);

	void close();

private: 
	sockaddr_storage           m_rptAddr;
	unsigned int               m_rptAddrLen;
	unsigned int               m_id;
	unsigned char*             m_netId;
	bool                       m_debug;
	CUDPSocket                 m_socket;
	unsigned char*             m_buffer;
	CRingBuffer<unsigned char> m_rxData;
	unsigned char*             m_configData;
	unsigned int               m_configLen;
	unsigned char*             m_radioPositionData;
	unsigned int               m_radioPositionLen;
	unsigned char*             m_talkerAliasData;
	unsigned int               m_talkerAliasLen;
};

#endif
