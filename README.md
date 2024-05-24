
# De l'API Pappers au CSV : Extraction de Données

## Introduction
Ce projet basé sur PowerShell automatise l'extraction de données d'entreprise à partir de l'API Pappers et leur transformation en fichiers CSV structurés. Les scripts gèrent divers aspects des données tels que les bénéficiaires effectifs, les dirigeants d'entreprise, les données financières et plus encore.

## Prise en Main

### Prérequis
- PowerShell 5.1 ou supérieur
- Accès à Internet pour la connectivité API

### Composants du Projet
DownloadData.ps1 : Télécharge les fichiers JSON depuis l'API Pappers.
ExtractData.ps1 : Convertit les fichiers JSON en format CSV.
siren.csv : Contient les numéros SIREN des entreprises à extraire.
Utilisation
Télécharger les Données
Exécutez le script de téléchargement pour récupérer les données des SIRENs listés dans siren.csv :

```powershell
# Exécutez le script de téléchargement pour récupérer les données des SIRENs listés dans siren.csv :
.\DownloadData.ps1

###Convertir en CSV
Traitez les fichiers JSON téléchargés en fichiers CSV :

```powershell
.\ExtractData.ps1
Définir la Politique d'Exécution (si nécessaire)
powershell
Copier le code
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Fichiers de Sortie
Chacun des fichiers CSV suivants contient des données spécifiques extraites de l'API :

Beneficiaires_Effectifs.csv : Détails sur les bénéficiaires effectifs comme requis par les cadres réglementaires.
Dirigeants.csv : Informations sur les dirigeants d'entreprise, y compris les noms, rôles et mandats.
Etablissements.csv : Données sur les établissements de l'entreprise, adresses et statut opérationnel.
Finances.csv : Indicateurs financiers tels que les revenus, les bénéfices et les états financiers.
Representants.csv : Informations sur les représentants légaux et leur autorité au sein de l'entreprise.
Successeurs.csv : Enregistrements des événements de succession d'entreprise et des changements d'entité pertinents.
Applications
Les données peuvent être utilisées pour :

Surveillance de la conformité.
Analyse de marché et compétitive.
Évaluations financières et planification d'investissement.
Conclusion
Ce projet simplifie le processus d'extraction et de transformation des informations détaillées sur les entreprises de l'API Pappers en fichiers CSV, améliorant l'accessibilité et l'utilisabilité pour diverses fins analytiques.

Licence
Ce projet est sous licence MIT - voir le fichier LICENSE.md pour plus de détails.
