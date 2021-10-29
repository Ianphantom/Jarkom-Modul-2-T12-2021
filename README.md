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
Dalam melakukan testing, kami sudah menambahkan alamat EniesLobby sebagai nameserver pada `/etc/resolv.conf` di node Loguetown dan Alabasta


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
Untuk membuat reverse domain, kami melakukan konfigurasi tambahan pada `/etc/bind/named.conf.local` sehingga menjadi seperti berikut ini :
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

### Nomor 5
Supaya tetap bisa menghubungi Franky jika server EniesLobby rusak, maka buat Water7 sebagai DNS Slave untuk domain utama

### Jawaban Nomor 5
##### Pada EniesLobby
Untuk menjadikan water 7 sebagai DNS Slave, kami melakukan konfigurasi pada `/etc/bind/named.conf.local` menjadi sebagai berikut
```
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
```
Kami menambahkan `notify yes`, `also-notify { 192.217.2.3; }` serta `allow-transfer { 192.217.2.3; };` untuk menjadikan Water 7 sebagai DNS Slave. 

##### Pada Water7
Pada water 7 pertama sekali menambahkan zone pada file `/etc/bind/named.conf.local` sebagai berikut
```
zone \"franky.t12.com\" {
    type slave;
    masters { 192.217.2.2; }; // Masukan IP EniesLobby tanpa tanda petik
    file \"/var/lib/bind/franky.t12.com\";
};
```
pada water7 dapat dilihat bahwa type nya adalah slave dan master nya adalah EniesLobby.

##### Testing
Dalam melakukan testing, kami mematikan service bind9 pada EnniesLobby dan menjalankan service bind9 pada water7. Tidak lupa juga kami memasukkan alamat water7 sebagai nameserver pada Loguetown dan Alabasta pada file `/etc/resolv.conf`

![image](https://user-images.githubusercontent.com/50267676/139436853-6336ca7c-6db8-4513-b5d9-a29d9fabbfba.png)

### Nomor 6
Setelah itu terdapat subdomain mecha.franky.yyy.com dengan alias www.mecha.franky.yyy.com yang didelegasikan dari EniesLobby ke Water7 dengan IP menuju ke Skypie dalam folder sunnygo

### Jawaban Nomor 6
##### Pada EniesLobby
Pada EnisLobby kami melakukan konfigurasi pada `/etc/bind/kaizoku/franky.t12.com` sebagai berikut
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
@               IN      NS      franky.t12.com.
@               IN      A       192.217.2.4
www             IN      CNAME   franky.t12.com.
super           IN      A       192.217.2.4
www.super       IN      CNAME   super.franky.t12.com.
ns1             IN      A       192.217.2.3
mecha           IN      NS      ns1
```
dapat dilihat bahwa kami mendelegasikan NS1 dan subdomain mecha ke alamat Water7. Pada EniesLobby kami hanya menambahkan konfigurasi tersebut, dan tidak merubah konfigurasi pada zone. Selain itu kami juga menambahkan konfigurasi pada `/etc/bind/named.conf.options`
```
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
```
pada konfigurasi diatas, kami menambahkan `allow-query{any;};`
##### Pada Water7
Pada water 7 pertama sekali menambahkan zone pada file `/etc/bind/named.conf.local` sehingga file tersebut terlihat sebagai berikut
```
zone \"franky.t12.com\" {
    type slave;
    masters { 192.217.2.2; }; // Masukan IP EniesLobby tanpa tanda petik
    file \"/var/lib/bind/franky.t12.com\";
};

zone \"mecha.franky.t12.com\" {
        type master;
        file \"/etc/bind/sunnygo/mecha.franky.t12.com\";
};
```
Kami menambahkan zone untuk alamat mecha.franky.t12.com dengan type master dan folder konfigurasi nya terdapat pada folder sunnygo. Selain itu kami juga menambahkan konfigurasi seperti berikut ini pada file `/etc/bind/named.conf.options`
```
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
```
pada konfigurasi diatas, kami menambahkan `allow-query{any;};`. Setelah melakukan konfigurasi diatas, kami membuat sebuah folder sunnygo pada `/etc/bind`. Di dalam folder tersebut kami menambahkan file `/etc/bind/sunnygo/mecha.franky.t12.com`
```
\$TTL    604800
@       IN      SOA     mecha.franky.t12.com. root.mecha.franky.t12.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@               IN      NS      mecha.franky.t12.com.
@               IN      A       192.217.2.4
www             IN      CNAME   mecha.franky.t12.com.
```
Dapat dilihat bahwa domain mecha.franky.t12.com akan mengarah ke alamat Skypie pada `192.217.2.4` dan mempunyai alias www.mecha.franky.t12.com

##### Testing
![image](https://user-images.githubusercontent.com/50267676/139439967-43c80a95-6452-46dd-acf5-cb5f681dba6c.png)

### Nomor 7
Untuk memperlancar komunikasi Luffy dan rekannya, dibuatkan subdomain melalui Water7 dengan nama general.mecha.franky.yyy.com dengan alias www.general.mecha.franky.yyy.com yang mengarah ke Skypie

### Jawaban Nomor 7
dalam mengerjakan soal ini, kami hanya menambahkan konfigurasi pada `/etc/bind/sunnygo/mecha.franky.t12.com` menjadi sebagai berikut
```
\$TTL    604800
@       IN      SOA     mecha.franky.t12.com. root.mecha.franky.t12.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@               IN      NS      mecha.franky.t12.com.
@               IN      A       192.217.2.4
www             IN      CNAME   mecha.franky.t12.com.
general         IN      A       192.217.2.4
www.general     IN      CNAME   general.mecha.franky.t12.com.
```
Dapat dilihat bahwa kami membuat sebuah domain general dan alias www untuk general.mecha.franky.t12.com yang mengarah pada Skypie.

##### Testing
![image](https://user-images.githubusercontent.com/50267676/139441057-752b6b47-1ede-453e-b743-828d7add1b4a.png)

### Nomor 8
### Jawaban Nomor 8
##### Testing

### Nomor 9
### Jawaban Nomor 9
##### Testing

### Nomor 10
### Jawaban Nomor 10
##### Testing

### Nomor 11
### Jawaban Nomor 11
##### Testing

### Nomor 12
Tidak hanya itu, Luffy juga menyiapkan error file 404.html pada folder /error untuk mengganti error kode pada apache
### Jawaban Nomor 12

##### Skypie
Pada Skypie kami edit konfigurasi file pada `/etc/apache2/sites-available/super.franky.t12.com.conf` sebagai berikut
```
ErrorDocument 404 /error/404.html
<Files "/var/www/super.franky.t12.com/error/404.html">
	<If "-z %{ENV:REDIRECT_STATUS}">
		RedirectMatch 404 ^/error/404.html$
	</If>
</Files>
```
Dalam file tersebut kami menambahkan `ErrorDocument` dan `Files` sehingga apabila muncul error code 404 pada web akan meredirect menuju file 404 yang sudah disiapkan yaitu `/error/404.html` 
##### Testing
Untuk melakukan pengujian kami menggunakan perintah `lynx` didalam loguetown pada link directory yang tidak ada sehingga nantinya akan mengeluarkan error 404 yaitu
```
lynx super.franky.t12.com/asdasd
```
Sehingga hasilnya akan sebagai berikut


### Nomor 13
Luffy juga meminta Nami untuk dibuatkan konfigurasi virtual host. Virtual host ini bertujuan untuk dapat mengakses file asset www.super.franky.yyy.com/public/js menjadi www.super.franky.yyy.com/js

### Jawaban Nomor 13

##### Skypie
Pada skypie sekali lagi kami edit konfigurasi pada `/etc/apache2/sites-available/super.franky.t12.com.conf` sebagai berikut
```
Alias "/js" "/var/www/super.franky.t12.com/public/js"
```
Maksudnya adalah bahwa `Alias` disini akan mentranslate direktori web `/js` menjadi `/public/js`

##### Testing
Untuk memastikan kami mencoba untuk membuka link www.super.franky.yyy.com/js menggunakan perintah
```
lynx super.franky.t12.com/js
```
Lalu hasilnya adalah sebagai berikut

### Nomor 14
Dan Luffy meminta untuk web www.general.mecha.franky.yyy.com hanya bisa diakses dengan port 15000 dan port 15500

### Jawaban Nomor 14

##### Skypie
Kami memasukkan port 15000 dan port 15500 pada file `etc/apache2/sites-available/general.mecha.franky.t12.com.conf` sebagai berikut
```
<VirtualHost *:15000 *:15500>
	...
	...
</VirtualHost>
```
Maka dengan begitu web www.general.mecha.franky.yyy.com hanya akan bisa diakses dengan port 15000 dan port 15500

##### Testing
Kita akan cek dengan memasukkan perintah pada loguetown
```
lynx general.mecha.franky.t12.com:15000
```
dan 
```
lynx general.mecha.franky.t12.com:15500
```
Sehingga hasilnya sebagai berikut

Disini kita harus memasukkan username dan password untuk autentikasi yang akan dijelaskan pada nomor selanjutnya

### Nomor 15
Dengan autentikasi username luffy dan password onepiece dan file di /var/www/general.mecha.franky.yyy

### Jawaban Nomor 15

##### Skypie
Pada skypie pertama-tama kami memasukkan command
```
htpasswd -b -c /var/www/general.mecha.franky.t12 luffy onepiece
```
Perintah tersebut berfungsi untuk mengatur basic authentication yang disimpan pada file `/var/www/general.mecha.franky.t12` dengan username `luffy` dan password `onepiece`

##### Testing
Selanjutnya untuk testing akan dimasukkan perintah berikut pada loguetown
```
lynx general.mecha.franky.t12.com:15000
```
Selanjutnya kita akan diminta untuk mengetikkan username dan password, ketika benar maka akan menampilkan seperti berikut


### Nomor 16
Dan setiap kali mengakses IP Skypie akan dialihkan secara otomatis ke www.franky.yyy.com

### Jawaban Nomor 16

##### Skypie
Pada file `/etc/apache2/sites-available/000-default.conf` kami menambahkan
```
redirect permanent / http://franky.t12.com
```
Sehingga akan langsung meredirect ke www.franky.t12.com ketika membuka IP Skypie

##### Testing
Kita masukkan perintah `lynx` diikuti dengan IP Address Skypie untuk mengeceknya
```
lynx 192.217.2.4
```
Maka akan langsung terbuka web www.franky.t12.com sebagai berikut

### Nomor 17
Dikarenakan Franky juga ingin mengajak temannya untuk dapat menghubunginya melalui website www.super.franky.yyy.com, dan dikarenakan pengunjung web server pasti akan bingung dengan randomnya images yang ada, maka Franky juga meminta untuk mengganti request gambar yang memiliki substring “franky” akan diarahkan menuju franky.png

### Jawaban Nomor 17

##### Skypie
Disini kami membuat file `/var/www/super.franky.t12.com/.htaccess` yang isinya sebagai berikut
```
RewriteEngine On
RewriteCond %{REQUEST_URI} !^/public/images/franky.png$
RewriteCond %{REQUEST_FILENAME} !-d 
RewriteRule ^(.*)franky(.*)$ /public/images/franky.png [R=301,L]
```
Dimana ketika apapun yang memiliki kata franky akan diarahkan menuju `/public/images/franky.png`

Kemudian pada file `/etc/apache2/sites-available/super.franky.t12.com.conf` kami tambahkan directory nya
```
<Directory /var/www/super.franky.t12.com>
        Options +FollowSymLinks -Multiviews
	AllowOverride All
</Directory>
```

##### Testing
Lalu hasil testing dengan perintah 
```
lynx super.franky.t12.com/frankyblablabla.jpeg
```
adalah sebagai berikut

