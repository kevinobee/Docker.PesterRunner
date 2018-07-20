Set-StrictMode -Version Latest

# Feature: Pester Test Runner
# 	As a user of the runner
# 	I want to execute Pester tests without installing Pester

# Scenario: Docker Image Runs Tests
# 	Given a `adminb/pester-runner` image
# 	When image is run with `/test` volume mapped
# 	Then tests contained in the mapped volume will be executed

$pesterRunnerImage = "adminb/pester-runner"

Describe "Tests for '$pesterRunnerImage' image" -Tags 'pester-runner' , 'Pester' {

    Context "Can access '$pesterRunnerImage' image" {

        It "$pesterRunnerImage can be pulled by Docker" {

            { docker pull $pesterRunnerImage } | Should -Not -Throw
        }
    }

    Context "Use Docker Image to Run Pester Tests" {

        It "$pesterRunnerImage runs without throwing errors" {

            { docker run -v ${pwd}:/test $pesterRunnerImage } | Should -Not -Throw
        }

        $result = docker run -v ${pwd}:/test $pesterRunnerImage | Out-String

        It "Verify No Failed Tests" {

            $result | Should -Match "Failed: 0"
        }

        It "Verify No Skipped Tests" {

            $result | Should -Match "Skipped: 0"
        }

        It "Verify No Pending Tests" {

            $result | Should -Match "Pending: 0"
        }

        It "Verify No Inconclusive Tests" {

            $result | Should -Match "Inconclusive: 0"
        }
    }
}