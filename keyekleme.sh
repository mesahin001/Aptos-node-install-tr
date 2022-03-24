#Aptos FullNode Kurmuş Fakat Private Key Oluşturmamışlar İçin Devam Kodları Identity Klasörü Oluşturma (private-key için)

mkdir $HOME/aptos/identity

#private-key.txt oluşturma

docker run --rm --name aptos_tools -d -i aptoslab/tools:devnet
docker exec -it aptos_tools aptos-operational-tool generate-key --encoding hex --key-type x25519 --key-file $HOME/private-key.txt
docker exec -it aptos_tools cat $HOME/private-key.txt > $HOME/aptos/identity/private-key.txt
docker exec -it aptos_tools aptos-operational-tool extract-peer-from-file --encoding hex --key-file $HOME/private-key.txt --output-file $HOME/peer-info.yaml > $HOME/aptos/identity/id.json
PEER_ID=$(cat $HOME/aptos/identity/id.json | jq -r '.Result | keys[]')
PRIVATE_KEY=$(cat $HOME/aptos/identity/private-key.txt)
docker stop aptos_tools


#Aptos klasörüne girip private_key ve peer id leri node dosyasina yazdiriyoruz

cd $HOME/aptos
sed -i '/      discovery_method: "onchain"$/a\
      identity:\
          type: "from_config"\
          key: "'$PRIVATE_KEY'"\
          peer_id: "'$PEER_ID'"' public_full_node.yaml


#Private Key'i Görüntüleme

cat $HOME/aptos/identity/private-key.txt

#Genel Tanımlayıcı Verilerini Görüntüleme

cat $HOME/aptos/identity/id.json


#FullNode Çalışmıyorsa Bu Kodu Girin (çalışıyorsa girmenize gerek yok)

docker compose up -d


#FullNode Çalışıyorsa Bu Kodu Girin

docker compose restart



#Senkronizasyon Durumunu Kontrol Etme

curl 127.0.0.1:9101/metrics 2> /dev/null | grep aptos_state_sync_version | grep type


#Logları Görüntüleme

docker logs -f aptos-fullnode-1 --tail 5000


#AptosFullNode FirstTransaction Klavuzu Fullnode'u çalıştırıyorsanız, bu adıma hazırsınız : python3'ü bu kodla kurun

apt install python3-pip


#First_transaction.py'yi İndirin

wget https://raw.githubusercontent.com/aptos-labs/aptos-core/main/developer-docs-site/static/examples/python/first_transaction.py
python3 first_transaction.py

#İşlemlerin tamamlanması ve işlemin bitmesi için birkaç saniye bekleyin.
