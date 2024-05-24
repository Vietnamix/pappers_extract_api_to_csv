# Chemin du fichier d'entrée contenant les SIRENs et le dossier de sortie pour les fichiers JSON
$inputFile = "C:\Users\Eric\Documents\_Societes\Sirens.csv"
$outputDir = "C:\Users\Eric\Documents\_Societes\Outputs\RawData"

# Vérification de l'existence du fichier d'entrée
if (-Not (Test-Path $inputFile)) {
    Write-Error "Le fichier d'entrée $inputFile n'a pas été trouvé."
    exit
}

# Création du répertoire de sortie si nécessaire
if (-Not (Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir
}

# Votre jeton API
$api_token = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" 

# URL de base de l'API
$baseUrl = "https://api.pappers.fr/v1"

# Point de terminaison pour obtenir les informations de l'entreprise
$endpoint = "/entreprise"

# Lire les SIREN depuis le fichier CSV
$sirens = Import-Csv -Path $inputFile -Encoding UTF8

# Fonction pour construire l'URL avec les paramètres de requête
function Build-Url {
    param (
        [string]$baseUrl,
        [string]$endpoint,
        [hashtable]$queryParams
    )
    $url = $baseUrl + $endpoint
    $params = $queryParams.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" }
    $url += "?" + ($params -join "&")
    return $url
}

# Parcourir chaque SIREN et faire la requête API
foreach ($siren in $sirens) {
    $queryParams = @{
        api_token = $api_token
        siren = $siren.SIREN
    }
    $url = Build-Url -baseUrl $baseUrl -endpoint $endpoint -queryParams $queryParams
    Write-Output "Envoi de la requête pour le SIREN $($siren.SIREN)"

    try {
        # Envoyer la requête à l'API et obtenir la réponse
        $response = Invoke-RestMethod -Uri $url -Method Get -ContentType "application/json"

        # Construire le chemin du fichier de sortie
        $outputFilePath = Join-Path -Path $outputDir -ChildPath "$($siren.SIREN).json"

        # Convertir la réponse en JSON et la sauvegarder dans un fichier
        $response | ConvertTo-Json -Depth 100 | Out-File -FilePath $outputFilePath -Encoding UTF8
        Write-Output "Fichier JSON pour le SIREN $($siren.SIREN) enregistré à : $outputFilePath"
    }
    catch {
        Write-Error "Erreur lors de la récupération des données pour le SIREN $($siren.SIREN): $_"
    }
}

Write-Output "Téléchargement des données JSON terminé pour tous les SIRENs spécifiés."
