# GCP-Architecture

---

## Rango IPs

| VPC        | CIDR VPC    | Subred   | CIDR Subred | IPs disponibles | Uso                            | VMs en la subred   |
| ---------- | ----------- | -------- | ----------- | --------------- | ------------------------------ | ------------------ |
| VPC 1. PRO | 10.0.0.0/16 | Subnet-1 | 10.0.1.0/24 | 256 IPs         | VM de Producción 1 (privada)   | VM sin IP pública  |
|            |             | Subnet-2 | 10.0.2.0/24 | 256 IPs         | VM de Producción 2 (privada)   | VM sin IP pública  |
|            |             | Subnet-3 | 10.0.3.0/24 | 256 IPs         | Reservada (futuro crecimiento) | Vacía              |
| VPC 2. DEV | 10.1.0.0/16 | Subnet-1 | 10.1.1.0/24 | 256 IPs         | VM de Desarrollo 1 (privada)   | VM sin IP pública  |
|            |             | Subnet-2 | 10.1.2.0/24 | 256 IPs         | VM de Desarrollo 2 (privada)   | VM sin IP pública  |
|            |             | Subnet-3 | 10.1.3.0/24 | 256 IPs         | Reservada (futuro crecimiento) | Vacía              |

---

## Configuración Cloud NAT

| VPC        | Cloud NAT     | Cloud Router | Región      | Subredes afectadas           |
| ---------- | ------------- | ------------ | ----------- | ---------------------------- |
| VPC 1. PRO | cloud-nat-pro | router-pro   | us-central1 | Subnet-1, Subnet-2, Subnet-3 |
| VPC 2. DEV | cloud-nat-dev | router-dev   | us-central1 | Subnet-1, Subnet-2, Subnet-3 |
---

## VPC Firewall Rules

| VPC        | Regla                 | Origen                | Destino                | Puerto            | Acción | Descripción             |
| ---------- | --------------------- | --------------------- | ---------------------- | ----------------- | ------ | ----------------------- |
| VPC 1. PRO | allow-iap-ssh-pro     | 35.235.240.0/20 (IAP) | VMs con tag: allow-iap | 22                | ALLOW  | Acceso SSH vía IAP      |
| VPC 1. PRO | allow-icmp-pro        | 10.0.0.0/16           | Todas                  | ICMP              | ALLOW  | Ping interno VPC PRO    |
| VPC 1. PRO | allow-internal-pro    | 10.0.0.0/16           | Todas                  | Todos             | ALLOW  | Tráfico interno VPC PRO |
| VPC 1. PRO | allow-from-dev-to-pro | 10.1.0.0/16 (VPC DEV) | Todas                  | 22, 80, 443, ICMP | ALLOW  | Tráfico desde VPC DEV   |
| VPC 2. DEV | allow-iap-ssh-dev     | 35.235.240.0/20 (IAP) | VMs con tag: allow-iap | 22                | ALLOW  | Acceso SSH vía IAP      |
| VPC 2. DEV | allow-icmp-dev        | 10.1.0.0/16           | Todas                  | ICMP              | ALLOW  | Ping interno VPC DEV    |
| VPC 2. DEV | allow-internal-dev    | 10.1.0.0/16           | Todas                  | Todos             | ALLOW  | Tráfico interno VPC DEV |
| VPC 2. DEV | allow-from-pro-to-dev | 10.0.0.0/16 (VPC PRO) | Todas                  | 22, 80, 443, ICMP | ALLOW  | Tráfico desde VPC PRO   |

---

## Configuración Cloud KMS (Cifrado de Discos)

| Recurso    | Nombre                 | Región      | Rotación automática | Usado por                                  | Coste estimado |
| ---------- | ---------------------- | ----------- | ------------------- | ------------------------------------------ | -------------- |
| Key Ring   | vm-encryption-keyring  | us-central1 | -                   | Contenedor de claves de cifrado            | $0             |
| Crypto Key | vm-disk-encryption-key | us-central1 | ✅ Cada 90 días      | Cifrar discos de todas las VMs (PRO y DEV) | ~$0.06/mes     |                                                          

---

## Configuración IAM (Permisos de Usuarios y Service Accounts)

| Usuario/Service Account        | Rol IAM                                    | Descripción                                                |
| ------------------------------ | ------------------------------------------ | ---------------------------------------------------------- |
| jcorrochano@stemdo.io          | roles/compute.osAdminLogin                 | Permite usar OS Login CON sudo en VMs                      |
| jcorrochano@stemdo.io          | roles/iap.tunnelResourceAccessor           | Permite usar túneles IAP para conectarse                   |
| jcorrochano@stemdo.io          | roles/compute.viewer                       | Permite ver recursos de Compute Engine                     |
| jcorrochano@stemdo.io          | roles/compute.instanceAdmin.v1             | Permite gestionar VMs (crear, modificar, borrar)           |
| jcorrochano@stemdo.io          | roles/cloudkms.admin                       | Administrador de claves KMS (crear, rotar, revocar)        |
| jcorrochano@stemdo.io          | roles/cloudkms.cryptoKeyEncrypterDecrypter | Puede cifrar/descifrar con las claves KMS                  |
| github-actions-sa              | roles/compute.osLogin                      | Permite usar OS Login SIN sudo en VMs                      |
| github-actions-sa              | roles/iam.serviceAccountUser               | Permite actuar como Service Account                        |
| github-actions-sa              | roles/iap.tunnelResourceAccessor           | Permite usar túneles IAP                                   |
| Compute Engine Service Account | roles/cloudkms.cryptoKeyEncrypterDecrypter | Permite a VMs usar las claves para cifrar/descifrar discos |

## Configuración VPC Peering (Conectividad entre entornos)

| Peering            | VPC Origen               | VPC Destino              |
| ------------------ | ------------------------ | ------------------------ |
| peering-pro-to-dev | VPC 1. PRO (10.0.0.0/16) | VPC 2. DEV (10.1.0.0/16) |
| peering-dev-to-pro | VPC 2. DEV (10.1.0.0/16) | VPC 1. PRO (10.0.0.0/16) |

---

```bash
gcloud auth login
```

```bash
gcloud auth list
```

```bash
gcloud config set project balmy-mile-452912-p6
```

```bash
gcloud config set compute/zone us-central1-a
```

```bash
gcloud config list
```

```bash
terraform init
```

```bash
terraform plan
```

```bash
terraform apply
```

```bash
gcloud compute ssh vm-pro-2 --tunnel-through-iap
```

```bash
ping -c 3 8.8.8.8
```

```bash
ping -c 3 10.0.1.2
```

```bash
ping -c 3 10.1.1.2
```

```bash
terraform destroy
```

