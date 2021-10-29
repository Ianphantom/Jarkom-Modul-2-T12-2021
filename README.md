# Jarkom-Modul-2-T12-2021

Nama Kelompok :  
- Ian Felix Jonathan Simanjuntak
- Muhammad Zakky Ghufron
- Muhammad Naufal Imantyasto

### Gambar Topologi
![contoh](https://user-images.githubusercontent.com/50267676/139427863-6588171e-a2d9-4256-8586-6169f8512589.png)

### Nomor 1
EniesLobby akan dijadikan sebagai DNS Master, Water7 akan dijadikan DNS Slave, dan Skypie akan digunakan sebagai Web Server. Terdapat 2 Client yaitu Loguetown, dan Alabasta. Semua node terhubung pada router Foosha, sehingga dapat mengakses internet

### Jawaban Nomor 1
Kami membuat topologi sesuai dengan soal lalu melakukan konfigurasi untuk setiap node sebagai berikut  

##### Konfigurasi Foosha
```
auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet static
	address 192.217.1.1
	netmask 255.255.255.0

auto eth2
iface eth2 inet static
	address 192.217.2.1
	netmask 255.255.255.0
```

##### Konfigurasi Loguetown
```
auto eth0
iface eth0 inet static
	address 192.217.1.2
	netmask 255.255.255.0
	gateway 192.217.1.1
```

##### Konfigurasi Alabasta
```
auto eth0
iface eth0 inet static
	address 192.217.1.3
	netmask 255.255.255.0
	gateway 192.217.1.1
```

##### Konfigurasi EniesLobby
```
auto eth0
iface eth0 inet static
	address 192.217.2.2
	netmask 255.255.255.0
	gateway 192.217.2.1
```

##### Konfigurasi Water7
```
auto eth0
iface eth0 inet static
	address 192.217.2.3
	netmask 255.255.255.0
	gateway 192.217.2.1
```

##### Konfigurasi Skypie
```
auto eth0
iface eth0 inet static
	address 192.217.2.4
	netmask 255.255.255.0
	gateway 192.217.2.1
```

pada Foosha kami juga memasukkan command 
```bash
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 192.217.0.0/16
```
lalu pada setiap node selain foosha kami memasukkan perintah
```
echo "nameserver 192.168.122.1" > /etc/resolv.conf
```

##### Testing
![image](https://user-images.githubusercontent.com/50267676/139430567-0f7fbb1c-0044-4ea5-82ff-c5827b12110e.png)

### Nomor 2
Luffy ingin menghubungi Franky yang berada di EniesLobby dengan denden mushi. Kalian diminta Luffy untuk membuat website utama dengan mengakses franky.yyy.com dengan alias www.franky.yyy.com pada folder kaizoku 

### Jawaban Nomor 2 
 
Dalam mengerjakan soal ini, pertama kami melakukan konfigurasi terhadap file `/etc/bind/named.conf.local` dengan menambahkan kode berikut ini
```
zone "franky.t12.com" {
        type master;
        file "/etc/bind/kaizoku/franky.t12.com";
};
```
setelah membuat konfigurasi zone untuk franky.t12.com kami membuat direktori baru yaitu `/etc/bind/kaizoku` lalu menambahkan konfigurasi berikut ini pada `/etc/bind/kaizoku/franky.t12.com`
```
;
; BIND data file for local loopback interface
;
$TTL    604800
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
```
Pada file konfigurasi diatas kami mengatur domain menjadi franky.t12.com yang mengarah ke skypie lalu membuat CNAME www untuk franky.t12.com

##### Testing
![image](https://user-images.githubusercontent.com/50267676/139431601-61e49542-e07f-4a35-ae25-67b239efeb9e.png)

### Nomor 3
Setelah itu buat subdomain super.franky.yyy.com dengan alias www.super.franky.yyy.com yang diatur DNS nya di EniesLobby dan mengarah ke Skypie

### Jawaban Nomor 3
Kami menambahkan beberapa konfigurasi pada `/etc/bind/kaizoku/franky.t12.com` sebagai berikut
```
;
; BIND data file for local loopback interface
;
$TTL    604800
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
```
Pada kode tersebut dapat dilihat bahwa kami menambahakan subdomain super yang juga mengarah kepada skypie lalu membuat cname www.super sebagai alias dari super.franky.t12.com

##### Testing
![image](https://user-images.githubusercontent.com/50267676/139432717-c146556e-73fa-4f7e-a9f1-ba24362af2da.png)

### Nomor 4
Buat juga reverse domain untuk domain utama

### Jawaban Nomor 4
Untuk membuat reverse domain, kami melakukan konfigurasi tambahan pada `/etc/bind/kaizoku/franky.t12.com` sehingga menjadi seperti berikut ini :
```
zone "franky.t12.com" {
        type master;
        file "/etc/bind/kaizoku/franky.t12.com";
};

zone "2.217.192.in-addr.arpa"{
        type master;
        file "/etc/bind/kaizoku/2.217.192.in-addr.arpa";
};
```
dapat dilihat pada konfigurasi di atas, kami membuat sebuah zone untuk reverse domain franky.t12.com yang konfigurasi nya disimpan di `/etc/bind/kaizoku/2.217.192.in-addr.arpa`. Isi dari file tersebut adalah sebagai berikut
```
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
```
Pertama kami memasukkan domain franky.t12.com setelah itu pada NS kami mengganti menjadi `2.217.192.in-addr.arpa.` dan pada PTR kami memasukkan `2` sebagai alamat dari `EniesLobby`

##### Testing
![image](https://user-images.githubusercontent.com/50267676/139433642-06755002-9248-4f9f-afa9-94d3d9d2aba5.png)