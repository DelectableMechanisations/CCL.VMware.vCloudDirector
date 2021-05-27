# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [1.0.1] - 2021-05-27

### Changed

- Wait-vCloudDirectorTask - Change error type to stop pipeline execution failing.
- Wait-vCloudDirectorTask - Added logic to take different actions based on the vCloud Director task status. Updated loop to allow early exit if failure detected.
- psakeFile.ps1, requirements.psd1, CCL.VMware.vCloudDirector.psm1 - Update scaffolding scripts to Stucco version 0.4.0

## [1.0.0] - 2021-04-06

### Added

- Add new helper function Test-StringIsUri
- Add new helper function Wait-vCloudDirectorTask

### Changed

- Update Set-CIVMComputePolicy to use Wait-vCloudDirectorTask helper function to manage task progress.
