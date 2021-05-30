#!/bin/bash
if [ $(whoami) != "root" ];then
	echo "----------请使用root权限执行本脚本！----------"
	exit 1;
fi

if [ `grep -c "Ubuntu" /etc/issue` -ne '0' ];then
    if [ `grep -c "Debian" /etc/issue` -ne '0' ];then
    echo "----------此脚本不支持此系统！----------"
	exit 1;
    fi
fi

touch /etc/iptables.test.rules && echo -e "*filter\n:INPUT ACCEPT [0:0]\n:OUTPUT ACCEPT [0:0]\n:FORWARD DROP [0:0]\n-A INPUT -p tcp --tcp-flags ALL FIN,URG,PSH -j REJECT\n-A INPUT -p tcp --tcp-flags SYN,RST SYN,RST -j REJECT\n-A INPUT -p tcp --tcp-flags SYN,FIN SYN,FIN -j REJECT\n-A INPUT -i lo -j ACCEPT\n-A OUTPUT -o lo -j ACCEPT\nCOMMIT">/etc/iptables.test.rules && iptables-restore < /etc/iptables.test.rules && touch /etc/network/if-pre-up.d/iptables && echo -e "#!/bin/bash\n/sbin/iptables-restore < /etc/iptables.test.rules">/etc/network/if-pre-up.d/iptables && chmod +x /etc/network/if-pre-up.d/iptables && echo -e "----------脚本执行完毕----------"
