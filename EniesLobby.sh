echo "nameserver 192.168.122.1" > /etc/resolv.conf 
apt-get update -y  
apt-get install dnsutils -y
apt-get install bind9 -y
apt-get install nano -y

echo "
//
// Do any local configuration here
//

// Consider adding the 1918 zones here, if they are not used in your
// organization
//include "/etc/bind/zones.rfc1918";

zone \"franky.t12.com\" {
        type master;
        notify yes;
        also-notify { 192.217.2.3; }; // Masukan IP Water7 tanpa tanda petik
        allow-transfer { 192.217.2.3; };
        file \"/etc/bind/kaizoku/franky.t12.com\";
};

zone \"2.217.192.in-addr.arpa\"{
        type master;
        file \"/etc/bind/kaizoku/2.217.192.in-addr.arpa\";
};

"> /etc/bind/named.conf.local

mkdir -p  /etc/bind/kaizoku

echo "
;
; BIND data file for local loopback interface
;
\$TTL    604800
@       IN      SOA     franky.t12.com. root.franky.t12.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@               IN      NS      franky.t12.com.
@               IN      A       192.217.2.4
www             IN      CNAME   franky.t12.com.
super           IN      A       192.217.2.4
www.super       IN      CNAME   super.franky.t12.com.
ns1             IN      A       192.217.2.3
mecha           IN      NS      ns1

" > /etc/bind/kaizoku/franky.t12.com

echo "
options {
        directory \"/var/cache/bind\";

        // If there is a firewall between you and nameservers you want
        // to talk to, you may need to fix the firewall to allow multiple
        // ports to talk.  See http://www.kb.cert.org/vuls/id/800113

        // If your ISP provided one or more IP addresses for stable 
        // nameservers, you probably want to use them as forwarders.  
        // Uncomment the following block, and insert the addresses replacing 
        // the all-0's placeholder.

        // forwarders {
        //      0.0.0.0;
        // };

        //========================================================================
        // If BIND logs error messages about the root key being expired,
        // you will need to update your keys.  See https://www.isc.org/bind-keys
        //========================================================================
        //dnssec-validation auto;
        allow-query{any;};
        auth-nxdomain no;    # conform to RFC1035
        listen-on-v6 { any; };
};


" > /etc/bind/named.conf.options

echo "
;
; BIND data file for local loopback interface
;
\$TTL    604800
@       IN      SOA     franky.t12.com. root.franky.t12.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
2.217.192.in-addr.arpa. IN      NS      franky.t12.com.
2                       IN      PTR     franky.t12.com.
" > /etc/bind/kaizoku/2.217.192.in-addr.arpa

service bind9 start
service bind9 restart