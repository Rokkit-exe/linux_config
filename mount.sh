#!/bin/bash

echo "UUID=1aa44f69-7eed-4464-9b6f-8a847f9b8366 /mnt/storage   ext4    defaults,nofail  0   2" >> /etc/fstab

sudo mount -a

sudo systemctl daemon-reload
