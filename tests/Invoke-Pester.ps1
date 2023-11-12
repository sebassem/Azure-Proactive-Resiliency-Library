$configuration = [PesterConfiguration]@{
  Run    = @{
      Path = 'C:\Users\sebassem\Documents\Projects\Azure-Proactive-Resiliency-Library\tests\ARPL-tests.ps1'
  }
  Should = @{
      ErrorAction = 'SilentlyContinue'
  }
  Output = @{
      Verbosity = 'Detailed'
      StackTraceVerbosity = 'None'
  }
}
Invoke-Pester -Configuration $configuration
