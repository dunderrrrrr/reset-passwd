SYNTAX
    .\reset-passwd.ps1 -identity <username>
        Will reset password for AD user (8 random numbers).
		
    .\reset-passwd.ps1 -filePath list.txt
        Will reset password for every user in list.txt. One
        username per row (8 random numbers). 