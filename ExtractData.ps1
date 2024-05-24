
<#
    Extraction et Transformation des Données JSON en CSV

    Ce script lit les fichiers JSON téléchargés depuis l'API Pappers et extrait les informations pertinentes.
    Il convertit les données JSON en fichiers CSV structurés pour une utilisation facile.

    @package PappersToCSV
    @file ExtractData.ps1
    @version 1.0
    @update 2024-05-22
    @autor Eric Guiffault
#>

# Chemin du dossier contenant les fichiers JSON et du dossier de sortie
$inputDir = "C:\Users\Eric\Documents\_Societes\Outputs\RawData"
$outputDir = "C:\Users\Eric\Documents\_Societes\Outputs\CSVs"

# Vérification de l'existence du dossier contenant les fichiers JSON
if (-Not (Test-Path $inputDir)) {
    Write-Error "Le dossier contenant les fichiers JSON $inputDir n'a pas été trouvé."
    exit
}

# Création du répertoire de sortie si nécessaire
if (-Not (Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir
}

# Initialiser les listes pour collecter les données de chaque type
$all_beneficiaires_effectifs = @()
$all_etablissements = @()
$all_dirigeants = @()
$all_finances = @()
$all_representants = @()
$all_successeurs = @()

# Lire chaque fichier JSON dans le dossier
Get-ChildItem -Path $inputDir -Filter *.json | ForEach-Object {
    $jsonContent = Get-Content -Path $_.FullName -Raw | ConvertFrom-Json

    # Affichage du SIREN en cours de traitement
    Write-Host "Traitement du SIREN: $($jsonContent.siren)"

    # Collecter les bénéficiaires effectifs
    if ($jsonContent.beneficiaires_effectifs -ne $null) {
        foreach ($beneficiaire in $jsonContent.beneficiaires_effectifs) {
            $beneficiaire | Add-Member -NotePropertyName "siren" -NotePropertyValue $jsonContent.siren -Force
            $all_beneficiaires_effectifs += $beneficiaire
        }
    }

    # Collecter les informations des établissements
    if ($jsonContent.etablissements -ne $null) {
        foreach ($etablissement in $jsonContent.etablissements) {
            $etablissement | Add-Member -NotePropertyName "siren" -NotePropertyValue $jsonContent.siren -Force
            $all_etablissements += $etablissement
            # Collecter les successeurs s'ils existent
            if ($etablissement.successeurs -ne $null) {
                foreach ($successeur in $etablissement.successeurs) {
                    $successeur | Add-Member -NotePropertyName "siren" -NotePropertyValue $jsonContent.siren -Force
                    $successeur | Add-Member -NotePropertyName "siret" -NotePropertyValue $etablissement.siret -Force
                    $all_successeurs += $successeur
                }
            }
        }
    }

    # Collecter les informations des dirigeants
    if ($jsonContent.dirigeants -ne $null) {
        foreach ($dirigeant in $jsonContent.dirigeants) {
            $dirigeant | Add-Member -NotePropertyName "siren" -NotePropertyValue $jsonContent.siren -Force
            $all_dirigeants += $dirigeant
        }
    }

    # Collecter les données financières
    if ($jsonContent.finances -ne $null) {
        foreach ($finance in $jsonContent.finances) {
            $finance | Add-Member -NotePropertyName "siren" -NotePropertyValue $jsonContent.siren -Force
            $all_finances += $finance
        }
    }

    # Collecter les informations des représentants
    if ($jsonContent.representants -ne $null) {
        foreach ($representant in $jsonContent.representants) {
            $representant | Add-Member -NotePropertyName "siren" -NotePropertyValue $jsonContent.siren -Force
            $all_representants += $representant
        }
    }
}

# Exporter les listes dans des fichiers CSV
$all_beneficiaires_effectifs | Export-Csv -Path "$outputDir\beneficiaires_effectifs.csv" -NoTypeInformation -Encoding UTF8
$all_etablissements | Export-Csv -Path "$outputDir\etablissements.csv" -NoTypeInformation -Encoding UTF8
$all_dirigeants | Export-Csv -Path "$outputDir\dirigeants.csv" -NoTypeInformation -Encoding UTF8
$all_finances | Export-Csv -Path "$outputDir\finances.csv" -NoTypeInformation -Encoding UTF8
$all_representants | Export-Csv -Path "$outputDir\representants.csv" -NoTypeInformation -Encoding UTF8
$all_successeurs | Export-Csv -Path "$outputDir\successeurs.csv" -NoTypeInformation -Encoding UTF8

Write-Output "Les fichiers CSV ont été créés dans le dossier : $outputDir"
