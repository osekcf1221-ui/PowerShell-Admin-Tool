\# PowerShell Admin Tool



\## Project Goal



A simple PowerShell script designed to process data from a CSV file and simulate adding users to groups.  

The project was created as a practical exercise in administrative automation, input validation, logging, reporting and safe script execution.



\## Features



\- Reads input data from a CSV file

\- Validates required CSV columns

\- Validates missing or empty values

\- Supports `WhatIfMode` for safe simulation

\- Writes execution logs to a log file

\- Generates a CSV report

\- Provides a summary of processed records



\## Project Structure



```text

PowerShell-Admin-Tool

├── Add-UsersToGroups.ps1

├── input.csv

├── logs

│   └── tool.log

├── reports

│   └── report.csv

└── README.md



\# CSV Input Format



The input CSV file should contain the following columns:



UserPrincipalName,GroupName,TicketNumber

jan.kowalski@company.com,VPN\_Users,INC12345

anna.nowak@company.com,VPN\_Users,INC12346

piotr.test@company.com,Finance\_ReadOnly,INC12347



\# Usage



\# Run the script in simulation mode:

.\\Add-UsersToGroups.ps1 -WhatIfMode



\# Run the script with a custom CSV path:

.\\Add-UsersToGroups.ps1 -InputCsv ".\\input.csv" -WhatIfMode



\# Run the script with custom log and report paths:

.\\Add-UsersToGroups.ps1 -InputCsv ".\\input.csv" -LogPath ".\\logs\\tool.log" -ReportPath ".\\reports\\report.csv" -WhatIfMode



\# Output

\# The script creates:



a log file in the logs folder

a CSV report in the reports folder



Example report output:

UserPrincipalName,GroupName,TicketNumber,Status,Message

jan.kowalski@company.com,VPN\_Users,INC12345,WhatIf,Simulated successfully

anna.nowak@company.com,VPN\_Users,INC12346,WhatIf,Simulated successfully



\## How It Works

The script reads data from the CSV file.

It checks whether the required columns exist.

It validates that required values are not empty.

In WhatIfMode, it simulates the action without making real changes.

Each processed record is written to a report.

Execution details are written to a log file.

A summary is displayed and saved in the log.



\## What I Learned

How to use parameters in PowerShell scripts

How to work with Import-Csv and Export-Csv

How to create a simple logging function

How to validate input data

How to handle missing values

How to generate structured reports

How to design a safer administrative script using simulation mode

How to extend an existing script with an additional field such as TicketNumber



\## Possible Improvements

Add separate Validate, Simulate and Execute modes

Integrate with Add-ADGroupMember for real Active Directory changes

Add support for multiple groups per user

Improve error reporting

Add a configuration file

Add transcript logging

Add unit-like test cases for CSV validation



\## Notes

This project is a learning exercise and currently works in simulation mode.

The real Active Directory command is intentionally not enabled to avoid accidental changes in a production environment.

