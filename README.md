# Azure ↔ Meraki Hybrid VPN Lab

## 📘 Overview
This lab sets up a site-to-site VPN tunnel between an on-prem Meraki MX and an Azure Virtual Network Gateway using Terraform. The goal is to simulate a hybrid network environment for secure communication between local infrastructure and Azure cloud resources.

---

## 🧱 Architecture

```plaintext
+------------------------+      Site-to-Site VPN     +---------------------------+
| On-Prem Network        | <-----------------------> | Azure Virtual Network     |
| - Meraki MX          |                           | - VNet with VPN Gateway   |
| - Local Subnet         |                           | - GatewaySubnet           |
+------------------------+                           +---------------------------+
```

---

## ⚙️ Prerequisites
- Azure subscription with permissions to create networking resources
- Meraki MX with Dashboard access
- Shared secret for VPN tunnel
- Terraform installed locally

---

## 🚀 Setup Steps (Simplified)

### 1. Clone the repo
```bash
git clone https://github.com/your-repo/azure-meraki-vpn-lab.git
cd azure-meraki-vpn-lab
```

### 2. Fill in `terraform.tfvars`
Edit the file to include:
- Your Azure region, Azure VNET, Azure Subnet, and Azure Gateway Subnet Prefix
- Your Meraki public IP and local subnet
- A shared key for the VPN tunnel

### 3. Deploy with Terraform
```bash or powershell
terraform init
terraform plan -var-file="terraform.tfvars"
terraform apply -var-file="terraform.tfvars"
```

---

## 🧑‍💻 Meraki Configuration

In the Meraki Dashboard:
1. Go to **Security & SD-WAN > Site-to-site VPN**
2. Set to **Hub**
3. Add Azure subnet (e.g., 10.1.0.0/16) as remote
4. Add a **Non-Meraki VPN Peer**:
   - Name: Azure
   - Public IP: output from Terraform
   - Subnets: (Your Azure Subnet)
   - PSK: match your `shared_key`
   - Use Azure defaults with IKEv2

---

## ✅ Validation Checklist

- Azure VPN Gateway shows “Connected”
- Meraki Dashboard shows tunnel “Active” or "green"
- Azure VM can ping on prem LAN devices

---

## 🧠 Skills Demonstrated

- Terraform provisioning of Azure networking
- Site-to-site IPsec VPN setup
- Hybrid networking design
- Real-world VPN peer config (Meraki ↔ Azure)