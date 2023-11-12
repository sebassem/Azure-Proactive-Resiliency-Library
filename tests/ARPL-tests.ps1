
$rootFolder = "./docs/content/services"
$serviceCategories = Get-ChildItem -Path $rootFolder -Directory | Select-Object -First 2

foreach ($serviceCategory in $serviceCategories) {
  $serviceCategoryName = $serviceCategory.Name
  $services = Get-ChildItem -Path $serviceCategories.FullName -Directory
  Describe "$serviceCategoryName Tests" {
    write-host $serviceCategoryName
    foreach ($service in $services) {
      $serviceName = $service.Name
      Context "$serviceName Tests" {
        $serviceCodes = Get-ChildItem -Path $service.FullName -Directory -Depth 2 | Where-Object { $_.Name -ne "code" }
        foreach ($serviceCode in $serviceCodes) {
          $serviceCodeName = $serviceCode.Name
          $scriptFiles = Get-ChildItem -Path $serviceCode.FullName -Include *.ps1, *.kql -Recurse
          if ($scriptFiles -ne $null) {
            foreach ($script in $scriptFiles) {
              $query = Get-Content -Path $script.FullName -Raw
              if ($query -notmatch "under-development" -and $query -notmatch "under development") {
                if ($script.Extension -eq ".kql") {
                  It -name "$serviceCodeName - test" {
                    $kqlQuery = Search-AzGraph -Query $query
                    $kqlQuery.Count | Should -BeExactly 0
                  }
                }
                elseif ($script.Extension -eq ".ps1") {
                  It "$serviceCodeName - test" {
                    $pwshScript = $script.FullName
                    $pwshQuery = & $pwshScript
                    $pwshQuery.Count | Should -BeExactly 0
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
