## Extension

延伸比對細項，項目有：
- -p
- -m

### TCP

--dport Start:End or --destination-port Start:End

--mss Start:End
Maximum Segment Size, MTU = MSS + IP heard

--sport Start:End or --source-port Start:End

--syn (SYN, FUN, ACK SYN)

--tcp-flags (SYN, ACK, FIN, RST, URG, PSH and ALL, NONE)

--tcp-option

### UDP

-p udp or --pootocol udp

--dport Start:End or --destination-port Start:End

--sport Start:End or --source-port Start:End

### ICMP

-p icmp or -- protocol icmp

--icmp-type

    iptables -p icmp --help

### mac

-m mac

--mac-source mac

### limit

--limit-burst number

--limit number(/second, minute, hours, day)

### multiport

--destination-port number, number1...

--ports number, number1... (destination == source)

--source-port number, number1...

### mark

--mark (4294967296)

### owner

--cmd-owner programe_name

--gid-owner GID

--pid-owner PID

--uid-owner uid

--sid-owner sid (session)

### state

--state (INVALID, ESTABLISHED, NEW, RELATED)

編號無法識別或不正確
屬於已建立之連線的封包
新增一連線，重設連線或重新導向
屬於已建立之連線所新增連線的封包

### conntrack

--ctexpire time

--ctorigdst IP  

--ctproto protocol

--ctrepldst IP

--ctreplsrc IP

--ctatate (INVALID, ESTABLISHED, NEW, RELATED)

--ctstatus (NONE, EXPECTED, SEEN_REPLY, ASSURED)

### dscp

--dscp 0~32

--dscp-class DiffServ Class(BE, EF, AFxx, CSx Class)

### pkttype

--pkt-type (unicast, broadcast, multicast)

### tos

--tos  number

### ah

--ahspi spi number(IPSec AH SPI)

### esp

--espspi spi number(IPSec ESP SPI)

### length

--length number

### ttl

-TTL number
