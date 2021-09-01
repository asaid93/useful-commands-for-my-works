# Sadece belirtilmiş pattern'e uyan dosyaların
# size'ını bul ve totalini göster.
du -csh *202108*

------------------------------

# Her dosya için aktif pasif sayıları. 
# uniq'in çıktısını satır satır basmak yerine
# paste komutu ile yan yana basıyoruz.
# Bu sayede listelenen bütün dosyaların
# aktif pasif sayılarını alt alta görebiliyoruz.
ls isletme*.txt | while read file; do echo -n "$file "; cat $file | awk -F'\\|;\\|' '{print $4}' | sort | uniq -c | paste -sd ''; done

------------------------------

# Mevcut dizin altındaki bütün işletme dizinlerine
# teker teker git. Gidilen dizinler altında en son
# oluşan log dosyasını aç. Bu son log dosyasından da
# son log satırını getir. bu işlemle bütün işletmeler
# için ekrana son log kaydını bastırmış oluyoruz.
for isletme in *; do son_log_kayit=`ls -1t $isletme/directory/*Log* | head -1 | xargs tail -1`; echo -e "$isletme" '\t' "$son_log_kayit"; done | column -t

------------------------------

# Bir user-id bilgi çifti için start ve stop
# kayıtlarının tarih bilgisi kaydedilir.
# Sonra start tarihi stop tarihinden
# büyük mü diye kontrol edilir.
awk '{if($3=="start") arrstart[$1,$4]=$2; else if($3=="stop") arrstop[$1,$4]=$2 fi; next} END{for(i in arrstop) if(arrstart[i]>arrstop[i]) print i}' SUBSEP=':' log
# Örnek veri: "log" dosyası
user1	2020	start	id1
user2	2005	stop	id2
user3	2006	start	id3
user4	2014	stop	id1
user1	2010	stop	id1
# Çıktı
user1:ID1

------------------------------

# türkçe karakterleri sort etme sorunu varsa
# komut satırına şu yazılsa kafi NOT: istenmeyen
# durumlarla karşılaşma ihtimaline karşı değişkenin
# önceki değerini kaydetmenizi tavsiye ederim.
export LC_ALL=C

------------------------------

# windows türkçe oluşturulan dosyadan
# -encoding conversion- NOT: BU İŞLEM Xshell 4
# üzerinden yapılırken encoding UTF-8 iken yapılır,
# dosyayı okumak için Xshell 4 encoding'i Turkish(iso) ya tekrardan çevrilmeli.
iconv -f CP1254 -t ISO8859-9//TRANSLIT dosya > yenidosya

------------------------------

# Check if command is succesfully executed in bash 
echo $?
# returns  0 if successful

------------------------------

# lokal makineden remote'a dosya yükleme
sftp user@192.168.xx.xx:/path/to/file <<< $'put /path/to/file/DENEMEDOSYA.abn.gz'

------------------------------

# sunucuya trafik geliyor mu gelmiyor mu
# (ftp yapmaya izin verilen sunucu ipsi)
tcpdump -i any host 172.17.xx.xx

------------------------------

# satır satır ; sayısını veriyor.
grep -o ";" dosya | wc -l

------------------------------

# N. Satırı getirme
sed -n 'Np' dosya 

# N. Satırdan itibaren M satır getirme
sed -n 'N,+Mp' dosya

# alttaki de n-m aralığını getirme
sed -n 'N,Mp' dosya

------------------------------

# belirli size'da dosya oluşturmak için
truncate -s 1G dosya

------------------------------

# who am i'dan çekilen ip'nin etrafındaki parantezleri kaldırıp print etme.
who am i | awk 'NF~5{ gsub(/[(]|[)]/,""); print $5}')

------------------------------

# baştan ve sondan 20şer satır
cat dosya | (head -20; tail -20)

------------------------------

# 55. alanda EYLÜL geçenlerin satırını bul
cat dosya | awk -F "[|];[|]" '$55 ~ /EYLÜL/ {print NR}' | sort | uniq -c

------------------------------

# \ işaretinin ascii kodu 2f.
# 44. alanda bu karakterin kaç kere geçtiğini bul.
# Ascii kodu olduğu gibi yazılmadan önce önüne \x alır.
cat dosya* | awk -F"[|][;][|]" '{if($44~/\x2f/)  print NR}'| wc -l

------------------------------

# i. Kolondan k kolon kadar sed ile belirtilen satır aralıklarını yazdır.
cat dosya* | awk -v i=14 -v k=5 -F"[|][;][|]" '{printf (NR); for(j=0; j<=k; j++) printf ("\t*%s* %s ",i+j,$(i+j));printf ("\n")}' | sed -n '1,10p'

------------------------------

# Satır başındaki boşlukları sil ve dosyanın ikinci
# yarısını ilk yarısı ile yan yana yaz.
lastline=$(wc -l < log) ; awk -F'"' -v line=$lastline '{ if(NR<=line/2) arr[NR]=$0; gsub(/^ +/,"",$0); if(NR>line/2) print arr[NR-line/2] $0}' log
# Örnek veri: "log" dosyası
<ma x="1">ab</ma>
<ma x="2">af</ma>
<ma x="3">ji</ma>
        <r x="1">0</r>
        <r x="2">0</r>
        <r x="3">0</r>
# Çıktı
<ma x="1">ab</ma><r x="1">0</r>
<ma x="2">af</ma><r x="2">0</r>
<ma x="3">ji</ma><r x="3">0</r>

------------------------------

# Duplicate paragrafları silme
awk -v RS='[*][*]\n[*][*]' '{gsub(/[*]|\n$/,""); if(!visited[$0]++) print $0}' file
# Örnek veri: "file" dosyası
**startkeyword**
  apple
**endKeyword**
**startkeyword**
  banana
**endKeyword**
**startkeyword**
  apple
**endKeyword**
# Çıktı
startkeyword
  apple
endKeyword
startkeyword
  banana
endKeyword

------------------------------

# Mevcut dizin ve bulunduğun dizinin altındaki
# child directorylerde kaç tane dosya ve
# dizin var hepsini gösteriyor.
find . -type d -print0 | while read -d '' -r dir; do
    files=("$dir"/*)
    printf "%5d files in directory %s\n" "${#files[@]}" "$dir"
done

------------------------------

# Disk usage belli bir oranın altındaysa gör.
for i in $(df -h |awk 'NR!=1 && $5<="10%" {print $6}')
do 
     echo $i
done

------------------------------

# ilk kolonu kaldırıp ikinci colonu transpose ediyoruz.
awk '{$1=FS="";ORS=""}1;END{print "\n"}' rowcol.txt
# Örnek veri: "rowcol.txt" dosyası
A 1
B 2
C 3
# Çıktı
 1   2   3

------------------------------

# bir dosyada matching pattern bulduk.
# Diyelim ki bu satırı ve kendinden önceki
# üç satırı ve de sonrasındaki bir satırı silmek istedik.
sed -n "1N;2N;3N;/pattern/{N;d};P;N;D" file.txt > file_new.txt

------------------------------

traceroute -I 192.168.x.x

tcpdump -i ens192 -c 4 -v

#network-scripts ten username ile ftp yapacak kaynak sunucuyu tanımlıyoruz. 

route -n

etc/sysconfig/network-scripts

route-eth1

etc/hosts.allow

service network restart

------------------------------
