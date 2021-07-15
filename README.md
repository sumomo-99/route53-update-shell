/etc/systemd/system/route53Updater.service
/var/scripts/route53Updater.sh

```
sudo chmod 755 /var/scripts/route53Updater.sh
sudo systemctl daemon-reload
sudo systemctl enable route53Updater.service
```