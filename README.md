# Azure Hub-and-Spoke hálózati architektúra Terraformmal

Ez a repository egy tiszta, újrafelhasználható Terraform konfigurációt tartalmaz, amellyel egy biztonságos **Hub-and-Spoke (Központi és Küllő) hálózati topológia** építhető ki a Microsoft Azure-ban.

## 🏗️ Architektúra áttekintése

Az architektúra a felhős hálózatépítés legjobb gyakorlatait követve elválasztja a központi megosztott szolgáltatásokat (Hub) a munkaterhelésektől (Spoke) kétirányú VNet Peering használatával.

* **Hub VNet (`minta-vnet-hub`)**: Központi szolgáltatásokhoz (pl. tűzfalak, VPN átjárók, Bastion).
  * Címtartomány: `10.100.0.0/16`
  * Alhálózat: `10.100.1.0/24` (`minta-subnet-hub`)
* **Spoke 1 VNet (`minta-spoke-1`)**: Alkalmazások és munkaterhelések futtatására.
  * Címtartomány: `10.200.0.0/16`
  * Alhálózat: `10.200.1.0/24` (`minta-subnet-spoke-1`)
* **Kapcsolat (Peering)**: Kétirányú VNet Peering (`minta-peer-hub-to-spoke-1` & `minta-peer-spoke-1-to-hub`) engedélyezett továbbított forgalommal.

---

## 🛠️ Előfeltételek

* **Terraform** (v1.0+)
* **Azure CLI** (hitelesítve a cél-előfizetéssel)

---

## 🚀 Telepítési lépések

1. **A repository klónozása:**
   ```bash
   git clone https://github.com/sitkeitamas-debug/azure-terraform-hub-spoke111.git
   cd azure-terraform-hub-spoke111
