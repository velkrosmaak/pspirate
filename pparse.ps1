add-type @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
    public class TrustAllCertsPolicy : ICertificatePolicy {
        public bool CheckValidationResult(
            ServicePoint srvPoint, X509Certificate certificate,
            WebRequest request, int certificateProblem) {
            return true;
        }
    }
"@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy

##echo "<html><body>" | Out-File links.html


$FilePath = "artists.csv"
$Stuff = Import-CSV $FilePath 
ForEach ($artistv in $Stuff) {
Write-Host Searching for $artistv.Artist `n
$srch = $artistv.Artist

$results = (Invoke-WebRequest -Uri https://www.oldpiratebay.org/search.php?q="$srch").Links | where href -match "magnet*" | Select @{Name="Magnet";Expression={$_.href}} | format-table
##echo "<a>" $results "</a>"| Out-File -Append links.html
echo "<a>" $results "</a>"| Out-File -Append links.txt
} 


##echo "</body> </html>" | Out-File -Append links.html