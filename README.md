# AzureNetwork_VNet_Hub

![Azure Function App](https://github.com/Ludovic44/Azure_VNet_Hub)

## Sommaire
1. [Public](https://github.com/Ludovic44/AzureFunctionApp/tree/main#public)
2. [Description du contexte]()
3. [Point d'attention]()
4. [Contenu du repository](https://github.com/Ludovic44/AzureFunctionApp/tree/main#contenu-du-repository)
5. [Sources](https://github.com/Ludovic44/AzureFunctionApp/tree/main#sources)



## Public

- [x] Niveau 100 - Débutant
- [x] Niveau 200 - Junior
- [ ] Niveau 300 - Confirmé
- [ ] Niveau 400 - Expert



## Description du contexte
Dans le cadre du déploiement d'une topologogie réseau [Hub and Spoke](https://learn.microsoft.com/en-us/azure/architecture/reference-architectures/hybrid-networking/hub-spoke?tabs=cli), vous serez amenez  créer tout d'abord le Hub.
Ce VNet central est le coeur de votre réseau et contient les éléments d'infrastrucure réseau mutualisé.

A ce titre, les 
De manière classique on



## Point d'attention

A compter du 30 septembre 2025, les VM n'auront plus un accès à Internet par défaut et devront utiliser par exemple une [NAT Gateway](https://learn.microsoft.com/en-us/azure/nat-gateway/nat-overview).
C'est l'occasion de se pencher sur le sujet.
Source Microsoft : [Default outbound access for VMs in Azure will be retired— transition to a new method of internet access](https://azure.microsoft.com/en-gb/updates/default-outbound-access-for-vms-in-azure-will-be-retired-transition-to-a-new-method-of-internet-access/)



## Contenu du repository
Ce repository contient les scripts IaC Terraform vous permettant de créer votre Hub dans lequel les éléments suivants seront présents :

* VNet Hub
* Subnet pour la VPN Gatreway,
* Subnet pour le firewall
* Subnet pour le bastion
* Subnet pour l'APIM
* Subnet pour la NAT gateway
* La VPN Gateway
 * La gateway local
* Un Azure Firewall
* Un bastion
* Une NAT gateway



## Sources
En complément, vous trouverez ci-dessous des informations sur Azure network en lien avec la notion d'Hub and Spoke :
- [Hub-spoke network topology in Azure](https://learn.microsoft.com/en-us/azure/architecture/reference-architectures/hybrid-networking/hub-spoke?tabs=cli)