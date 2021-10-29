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