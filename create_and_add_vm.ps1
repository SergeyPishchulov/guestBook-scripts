$machine = yc compute instance create --name $args[0] --preemptible --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-2004-lts --zone ru-central1-a --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 --service-account-id=ajelusbrohp8t5nrig12 --ssh-key=id_rsa.pub --format json
$machine = $machine | ConvertFrom-Json
$vmaddress = $machine.network_interfaces[0].primary_v4_address.address
$vmexternaladdress = $machine.network_interfaces[0].primary_v4_address.one_to_one_nat.address
yc load-balancer target-group add-targets --name guest-vm-tg --target address=$vmaddress,subnet-name=default-ru-central1-a

Start-Sleep -Seconds 20
ssh yc-user@$vmexternaladdress "sudo apt-get update;sudo apt install git -y;git clone https://github.com/SergeyPishchulov/guestBook-backend;cd guestBook-backend;sudo apt-get install uvicorn -y;sudo apt install python3-pip -y;sudo pip install fastapi;sudo pip install -r requirements.txt;sudo ufw allow 80; sudo uvicorn main:app --host 0.0.0.0 --port 80"



