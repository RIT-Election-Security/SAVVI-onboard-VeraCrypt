@ECHO OFF 
:: This section reveals OS, hardware, and 
::networking configuration for the Windows VM.

::preconditions: 
:: 1) windows VM w/ veracrypt installed; 
:: 2) windows has certutil enabled (it should be there by default); 
:: 3) ballot is saved on the c:\ drive as ballot.dat; 
:: 4) there's some biometric or other authentication signature saved as signature.dat
:: 5) voter knows the ballot ID
::postconditions: 
:: 1) produces / displays the hash of the unencrypted ballot (HASH1)
:: 2) encrypts the ballot with a randomly selected cipher/cipher cascade
:: 3) produces / displays the hash of the encrypted ballot (HASH2)


TITLE My System Info

:: Section 1: Hashing the ballot before it's 
::encrypted
ECHO ==========================
ECHO VERIFYING THE INTEGRITY OF YOUR BALLOT
ECHO ==========================
set HASH1= certutil -hashfile c:\ballot.dat SHA512
ECHO %HASH1 > log.txt

:: Section 2: Creating the encrypted container 
::that will store the ballot
ECHO ==========================
ECHO MAKING YOUR BALLOT CONFIDENTIAL
ECHO ==========================
ECHO Enter the identification number of the 
ECHO ballot you received today
ECHO %PIN2%
/create VOTE 
/size 1M

/k c:\signature.dat /k %PIN2%
::Specifies the key as a data file + pin

SET /A RAND=%RANDOM% %% 15
if %RAND%==0 SET ENCR = AES
if %RAND%==1 SET ENCR = Serpent
if %RAND%==2 SET ENCR = Twofish
if %RAND%==3 SET ENCR =Camellia
if %RAND%==4 SET ENCR =Kuznyechik
if %RAND%==5 SET ENCR =AES(Twofish)
if %RAND%==6 SET ENCR =AES(Twofish(Serpent))
if %RAND%==7 SET ENCR =Serpent(AES)
if %RAND%==8 SET ENCR =Serpent(Twofish(AES))
if %RAND%==9 SET ENCR =Twofish(Serpent)
if %RAND%==10 SET ENCR =Camellia(Kuznyechik)
if %RAND%==11 SET ENCR =Kuznyechik(Twofish)
if %RAND%==12 SET ENCR =Camellia(Serpent)
if %RAND%==13 SET ENCR =Kuznyechik(AES)
if %RAND%==14 SET ENCR =Kuznyechik(Serpent
(Camellia)) 

/encryption %ENCR
::CHOSEN RANDOMLY

:: Section 6: Hashing the encrypted ballot
ECHO ==========================
ECHO MAKING YOUR VOTE PRIVATE
ECHO ==========================
set HASH2= certutil -hashfile BALLOT.vote SHA512
ECHO %HASH2 >> log.txt

exit
