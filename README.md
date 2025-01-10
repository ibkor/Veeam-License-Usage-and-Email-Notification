## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

# License-Usage-and-Email-Notification-Scripts

Overview

  This repository contains two PowerShell scripts designed to enhance the management of Veeam licenses and facilitate the sending of usage reports via email.

Setup Script

  This script collects and encrypts email credentials and SMTP server details, saving them to a JSON file. This allows for secure storage of sensitive information used for sending email notifications.

EM License Script 

  This script retrieves the current license usage from Veeam, creates a summary of the license consumption for Virtual Machines (VMs), servers, and applications, and then sends this summary via email to designated recipients.

Problem Statement

  When managing multiple Veeam Backup & Replication (VBR) Servers, there can be a significant challenge regarding accurate license consumption reporting. If the same VMs are backed up by more than one VBR Server over time, each individual VBR       Server will register license consumption for these VMs. This results in an incorrect summary of license consumption across VBR Servers, as Veeam licenses each unique VM only once. Although the Enterprise Manager provides accurate license          consumption data, it currently lacks the functionality to send notification emails regarding this information.

These scripts have been created to address this shortcoming by:
  - Retrieving the license consumption information directly from the Enterprise Manager.
  - Sending email notifications with the summarized consumption data to designated contacts, ensuring all stakeholders are informed of the actual license usage without duplications.

Features
  - Securely encrypts and stores sender email credentials and SMTP server details.
  - Retrieves detailed license usage for Veeam applications.
  - Automatically generates an HTML summary report of license usage.
  - Sends email notifications to multiple recipients.

Prerequisites
  - PowerShell: Ensure you have PowerShell installed on your machine.
  - Veeam Enterprise Manager: The script interacts with Veeam Enterprise Manager via WMI. Ensure you have the Veeam Enterprise Manager installed and you have the necessary permissions to access the required WMI classes.
  - SMTP Server: Access to a configured SMTP server for sending emails.

Script Breakdown
  - Setup Script
    This script will:

  - Generate a secure encryption key and store it as an environment variable.
  - Prompt the user for:
    - Sender email address
    - Sender email password
    - SMTP server address
    - SMTP port number
    - Receiver email addresses (comma-separated)
    - Encrypt the provided information and save it in a JSON file at a user-defined location.

  - License Consumption Retrieval and Email Script
    This script will:

    - Retrieve the license usage data from Veeam Enterprise Manager.
    - Parse the data to summarize the number of licenses used for VMs, servers, and applications.
    - Generate an HTML email body displaying the summary.
    - Read the encrypted email credentials and SMTP settings from the JSON file.
    - Send the license summary report via email to the listed recipients using the SMTP server.

How to Use
  - Step 1: Setup Script
    - Open PowerShell as an administrator.
    - Navigate to the directory containing the setup script.
    - Run the script: powershell `.\SetupEmailEM.ps1`
    - Follow the prompts to enter your email details and save the configuration.

  - Step 2: License Consumption and Email Script
    - Ensure that the setup script has been executed and the JSON file is created with the necessary credentials.
    - Open PowerShell. Navigate to the directory containing the license consumption script. 
    - Run the script: powershell `.\EMlicense.ps1`
      
Notes
  - Ensure that you have the correct permissions to run these scripts, especially in environments with security restrictions.
  - Regularly check for any updates in the scripts to improve functionality and ensure compatibility with the latest Veeam versions.
  - Depending on your SMTP server settings, you may need to modify the email sending method in the script for successful delivery.

Security Considerations
  - This script deals with sensitive information, including email credentials. Ensure that the combined usage of the encryption key and secure strings is handled with utmost care.
    Avoid hardcoding sensitive credentials directly in the script for better security practices.

Disclaimer: The scripts in this repository are provided "as is" without any warranties, express or implied. The author is not liable for any damages resulting from the use or inability to use these scripts, including but not limited to direct, indirect, incidental, or consequential damages. Users accept full responsibility for any risks associated with using these scripts, including compliance with laws and regulations. By using these scripts, you agree to indemnify the author against any claims arising from your use.
