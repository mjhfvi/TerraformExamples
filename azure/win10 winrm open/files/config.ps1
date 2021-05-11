## This Script Will Run in VM

# Install Chocolatey, a software management automation for Windows
Set-ExecutionPolicy Bypass -Scope Process -Force; Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Install Tools For Build Process
#PowerShell.exe choco install -y git.install
#PowerShell.exe choco install -y notepadplusplus.install
PowerShell.exe choco install microsoft-build-tools
PowerShell.exe choco install jdk8 -y

# Setup Jenkins Node to Remote Server
# cmd.exe /c java -jar c:\\terraform\\agent.jar -jnlpUrl http://192.168.50.101:8080/computer/windows-test/jenkins-agent.jnlp -secret 7844f49430418c571210f932b439ff74ab60047b9eddef20aa7ece5ca44b048b -workDir "c:\"