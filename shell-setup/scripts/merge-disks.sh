# Install mdadm
sudo apt-get update && sudo apt-get install -y mdadm

# Create RAID 0 array from all 16 NVMe disks
sudo mdadm --create /dev/md0 --level=0 --raid-devices=16 \
  /dev/nvme0n1 /dev/nvme0n2 /dev/nvme0n3 /dev/nvme0n4 \
  /dev/nvme0n5 /dev/nvme0n6 /dev/nvme0n7 /dev/nvme0n8 \
  /dev/nvme0n9 /dev/nvme0n10 /dev/nvme0n11 /dev/nvme0n12 \
  /dev/nvme0n13 /dev/nvme0n14 /dev/nvme0n15 /dev/nvme0n16

# Format as ext4
sudo mkfs.ext4 -F /dev/md0

# Create mount point
sudo mkdir -p /mnt/disks/local-ssd

# Mount
sudo mount /dev/md0 /mnt/disks/local-ssd

# Set permissions
sudo chmod a+w /mnt/disks/local-ssd

# Make persistent across reboots
echo '/dev/md0 /mnt/disks/local-ssd ext4 defaults,nofail 0 0' | sudo tee -a /etc/fstab

# Save RAID config
sudo mdadm --detail --scan | sudo tee -a /etc/mdadm/mdadm.conf
sudo update-initramfs -u

# Verify
df -h /mnt/disks/local-ssd

